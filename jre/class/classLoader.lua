--[[ Java Class Loader (Bootstrap)
	 Since: 0.1
	 Part of the JavOC project
]]
local moduleLoader = require("moduleLoader")

local debug = moduleLoader.require("debug/javaDebug")
-- BU stands for 'Binary Utilities'
local bu    = moduleLoader.require("utilities/binaryStream")
local cpHandler = moduleLoader.require("class/handlers/constantPool")

local classLoader = {}

---Loads a class from a file. Path is relative from classpath
---@param file string           @ Name of the class to load
---@param classpath string      @ Absolute path to the classes to load
---@return table class          @ Loaded and parsed class file
function classLoader.loadClassFromFile(file, classpath)
	-- If name of the class have been given without extension, we
	-- should add it
	if not file:find(".class") then
		file = file .. ".class"
	end

	-- Declaring an absolute path to the file
	local filePath = "../" .. classpath .. file

	debug.print("Attempting to load class on path of " .. filePath)
	local stream = io.open(filePath, "rb")

	if not stream then
		debug.print("Failed to find the file or open it")
		error("Class File not found!")
	end

	debug.print("File stream created, loading class from it")
	return classLoader.loadClassFromStream(stream)
end

---Loads a class from the stream - usually file, but not always
---@param stream file_stream    @ Stream with class file
---@return table class          @ Load`ed and parsed class file
function classLoader.loadClassFromStream(stream)
	local class = {}

	-- Step 1 - loading 'magic value'
	if not classLoader.checkMagicValue(stream) then
		debug.print("Incorrect 'magic value'")
		error("Class loading aborted: incorrect 'magic value'")
	end

	debug.print("Correct 'magic value' is loaded")

	-- Step 2 - Loading versions (major and minor)
	class.version = classLoader.loadVersion(stream)

	-- Step 3 - Loading constant pool
	class.constantPool = classLoader.loadConstantPool(stream)

	-- Step 4 - Loading access flags
	class.accessFlags = classLoader.loadAccessFlags(stream)

	-- Step N - PROFIT!!!
	debug.print("Class loaded successfully") -- TODO: Name

	return class
end

---Loads a magic value and checks if it is valid or not
---@param stream file_stream    @ Stream with class file
---@return boolean valid        @ Determines if magic value is correct or not
function classLoader.checkMagicValue(stream)
	debug.print("Loading 'magic value' (0xCAFEBABE)")
	local magicValue = bu.readU4(stream)

	return (magicValue == 0xCAFEBABE)
end

---Loads major and minor versions and saves them to the table
---@param stream file_stream    @ Stream with class file
---@return table versions       @ Table with major and minor versions stored
---                               Structure:
---                               {
---                                 minor = <minor version>,
---                                 major = <major version>
---                               }
function classLoader.loadVersion(stream)
	debug.print("Loading versions (major and minor)")
	local version = {}

	version.minor = bu.readU2(stream)
	version.major = bu.readU2(stream)

	debug.print("Versions loaded successfully!")
	debug.print("Major - " .. version.major .. "; Minor - " .. version.minor)
	return version
end

---Loads constant pool
---@param stream file_stream    @ Stream with class file
---@return table constantPool   @ Table with constant pool values
function classLoader.loadConstantPool(stream)
	debug.print("Loading constant pool")

	local constantPool = {}
	constantPool.size = bu.readU2(stream)
	debug.print("Size of the constant pool - " .. constantPool.size)

	local currentIndex = 1

	debug.print("Constants in the pool:")
	while currentIndex < constantPool.size do
		local tag = bu.readU1(stream)
		-- Since Double and Long constants occuppy two indexes in the
		-- constant pool, they will return not one constant, but two:
		-- the actual one and the 'dummy'. "Normal" constants will
		-- set 'dummyConstant' field to nil
		--
		-- Also, this line utilizes handler for the constant pool
		-- Refer to 'doc/About JavOC/Strcture/Handlers' for more info
		debug.print("Constant #" .. currentIndex .. " with tag " .. tag)
		local constant, dummyConstant = cpHandler[tag](stream)

		if dummyConstant then
			-- If dummyConstant is NOT nil, it means that 
			-- the 'fat' constant was loaded.
			-- So, we should increment currentIndex on 2 and insert
			-- both constant and dummyConstant into table
			table.insert(constantPool, constant)
			table.insert(constantPool, dummyConstant)

			currentIndex = currentIndex + 2
		else
			-- If dummyConstant is nil, it means that
			-- the 'normal' constant was loaded.
			table.insert(constantPool, constant)

			currentIndex = currentIndex + 1
		end
	end

	return constantPool
end

---Loads access flags
---@param stream file_stream      @ Stream with class file
---@return table accessFlags      @ Access flags of the class
function classLoader.loadAccessFlags(stream)
	debug.print("Loading access flags")

	local accessFlags = {}
	accessFlags.mask = bu.readU2(stream)

	debug.print("Mask: " .. string.format("0x%x", accessFlags.mask))

	accessFlags["ACC_PUBLIC"]     = bu.mask(accessFlags.mask, 0x0001)
	debug.print("ACC_PUBLIC: " .. tostring(accessFlags["ACC_PUBLIC"]))

	accessFlags["ACC_FINAL"]      = bu.mask(accessFlags.mask, 0x0010)
	debug.print("ACC_FINAL: " .. tostring(accessFlags["ACC_FINAL"]))

	accessFlags["ACC_SUPER"]      = bu.mask(accessFlags.mask, 0x0020)
	debug.print("ACC_SUPER: " .. tostring(accessFlags["ACC_SUPER"]))

	accessFlags["ACC_INTERFACE"]  = bu.mask(accessFlags.mask, 0x0200)
	debug.print("ACC_INTERFACE: " .. tostring(accessFlags["ACC_INTERFACE"]))

	accessFlags["ACC_ABSTRACT"]   = bu.mask(accessFlags.mask, 0x0400)
	debug.print("ACC_ABSTRACT: " .. tostring(accessFlags["ACC_ABSTRACT"]))

	accessFlags["ACC_SYNTHETIC"]  = bu.mask(accessFlags.mask, 0x1000)
	debug.print("ACC_SYNTHETIC: " .. tostring(accessFlags["ACC_SYNTHETIC"]))

	accessFlags["ACC_ANNOTATION"] = bu.mask(accessFlags.mask, 0x2000)
	debug.print("ACC_ANNOTATION: " .. tostring(accessFlags["ACC_ANNOTATION"]))

	accessFlags["ACC_ENUM"]       = bu.mask(accessFlags.mask, 0x4000)
	debug.print("ACC_ENUM: " .. tostring(accessFlags["ACC_ENUM"]))

	return accessFlags
end

return classLoader