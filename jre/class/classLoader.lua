local javoc, classLoader = require("umfal")("javoc")

---Loads a class from a file. Path is relative from classpath
---@param file string           @ Name of the class to load
---@param classpath string      @ Absolute path to the classes to load
---@return table class          @ Loaded and parsed class file
function classLoader.loadClassFromFile(file, classpath)
	if not file:find(".class") then
		file = file .. ".class"
	end

	local filePath = "" .. classpath .. file

	javoc.jre.debug.print("Attempting to load class on path of " .. filePath)
	local stream = io.open(filePath, "rb")

	if not stream then
		javoc.jre.debug.print("Failed to find the file or open it")
		error("Class File not found!")
	end

	javoc.jre.debug.print("File stream created, loading class from it")
	return classLoader.loadClassFromStream(stream)
end

---Loads a class from the stream - usually file, but not always
---@param stream file_stream    @ Stream with class file
---@return table class          @ Load`ed and parsed class file
function classLoader.loadClassFromStream(stream)
	local class = {}

	if not classLoader.checkMagicValue(stream) then
		error("Class loading aborted: incorrect 'magic value'")
	end

	javoc.jre.debug.print("Correct 'magic value' is loaded")

	class.version = classLoader.loadVersion(stream)
	class.constantPool = classLoader.loadConstantPool(stream)
	class.accessFlags = classLoader.loadAccessFlags(stream)
	class.thisClass, class.superClass = classLoader.loadClassNames(stream, class.constantPool)

	javoc.jre.debug.print("Class " .. class.thisClass.name .. " loaded successfully")

	return class
end

function classLoader.checkMagicValue(stream)
	javoc.jre.debug.print("Loading 'magic value' (0xCAFEBABE)")
	local magicValue = javoc.jre.utilities.binaryStream.readU4(stream)

	return (magicValue == 0xCAFEBABE)
end

function classLoader.loadVersion(stream)
	javoc.jre.debug.print("Loading versions (major and minor)")
	local version = {}

	version.minor = javoc.jre.utilities.binaryStream.readU2(stream)
	version.major = javoc.jre.utilities.binaryStream.readU2(stream)

	javoc.jre.debug.print("Versions loaded successfully!")
	javoc.jre.debug.print("Major - " .. version.major .. "; Minor - " .. version.minor)
	return version
end

function classLoader.loadConstantPool(stream)
	javoc.jre.debug.print("Loading constant pool")

	local constantPool = {}
	constantPool.size = javoc.jre.utilities.binaryStream.readU2(stream)
	javoc.jre.debug.print("Size of the constant pool - " .. constantPool.size)

	local currentIndex = 1

	javoc.jre.debug.print("Constants in the pool:")
	while currentIndex < constantPool.size do
		local tag = javoc.jre.utilities.binaryStream.readU1(stream)
		javoc.jre.debug.print("Constant #" .. currentIndex .. " with tag " .. tag)
		-- Since Double and Long constants occuppy two indexes in the
		-- constant pool, they will return not one constant, but two:
		-- the actual one and the 'dummy'. "Normal" constants will
		-- set 'dummyConstant' field to nil
		local constant, dummyConstant = javoc.jre.class.handlers.constantPool[tag](stream)
		table.insert(constantPool, constant)

		if dummyConstant then
			-- If dummyConstant is NOT nil, it means that
			-- the 'fat' constant was loaded.
			-- So, we should increment currentIndex on 2 and insert
			-- a dummyConstant into table as well
			table.insert(constantPool, dummyConstant)

			currentIndex = currentIndex + 2
		else
			-- If dummyConstant is nil, it means that
			-- the 'normal' constant was loaded.
			currentIndex = currentIndex + 1
		end
	end

	return constantPool
end

-- TODO: REFACTOR THIS MESS ASAP!!!!
function classLoader.loadAccessFlags(stream)
	javoc.jre.debug.print("Loading access flags")

	local accessFlags = {}
	accessFlags.mask = javoc.jre.utilities.binaryStream.readU2(stream)

	javoc.jre.debug.print("Mask: " .. string.format("0x%x", accessFlags.mask))

	accessFlags["ACC_PUBLIC"]     = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x0001)
	javoc.jre.debug.print("ACC_PUBLIC: " .. tostring(accessFlags["ACC_PUBLIC"]))

	accessFlags["ACC_FINAL"]      = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x0010)
	javoc.jre.debug.print("ACC_FINAL: " .. tostring(accessFlags["ACC_FINAL"]))

	accessFlags["ACC_SUPER"]      = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x0020)
	javoc.jre.debug.print("ACC_SUPER: " .. tostring(accessFlags["ACC_SUPER"]))

	accessFlags["ACC_INTERFACE"]  = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x0200)
	javoc.jre.debug.print("ACC_INTERFACE: " .. tostring(accessFlags["ACC_INTERFACE"]))

	accessFlags["ACC_ABSTRACT"]   = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x0400)
	javoc.jre.debug.print("ACC_ABSTRACT: " .. tostring(accessFlags["ACC_ABSTRACT"]))

	accessFlags["ACC_SYNTHETIC"]  = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x1000)
	javoc.jre.debug.print("ACC_SYNTHETIC: " .. tostring(accessFlags["ACC_SYNTHETIC"]))

	accessFlags["ACC_ANNOTATION"] = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x2000)
	javoc.jre.debug.print("ACC_ANNOTATION: " .. tostring(accessFlags["ACC_ANNOTATION"]))

	accessFlags["ACC_ENUM"]       = javoc.jre.utilities.binaryStream.mask(accessFlags.mask, 0x4000)
	javoc.jre.debug.print("ACC_ENUM: " .. tostring(accessFlags["ACC_ENUM"]))

	return accessFlags
end

function classLoader.loadClassNames(stream, constantPool)
	javoc.jre.debug.print("Loading this and super class names")
	local thisClass  = {}
	local superClass = {}

	thisClass.index  = javoc.jre.utilities.binaryStream.readU2(stream)
	superClass.index = javoc.jre.utilities.binaryStream.readU2(stream)

	-- Both 'thisClassIndex' and 'superClassIndex' point at
	-- the CONSTANT_Class, which points at the CONSTANT_Utf8,
	-- which contains the string we want
	local thisClassConstantClass  = constantPool[thisClass.index]
	local superClassConstantClass = constantPool[superClass.index]

	local thisClassUTF8  = constantPool[thisClassConstantClass.nameIndex]
	local superClassUTF8 = constantPool[superClassConstantClass.nameIndex]

	thisClass.name  = thisClassUTF8.value
	superClass.name = superClassUTF8.value

	javoc.jre.debug.print("This class:  #" .. thisClass.index .. " (" .. thisClass.name .. ")")
	javoc.jre.debug.print("Super class: #" .. superClass.index .. " (" .. superClass.name .. ")")
	return thisClass, superClass
end

return classLoader