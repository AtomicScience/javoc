--[[ Java Class Loader (Bootstrap)
	 Since: 0.1
	 Part of the JavOC project
]]
local debug = require("moduleLoader").require("debug/javaDebug")
-- BU stands for 'Binary Utilities'
local bu    = require("moduleLoader").require("utilities/binaryStream")

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

	debug.print("Versions loaded successfully")

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
function classLoader.loadVersion(stream)
	debug.print("Loading versions (major and minor)")
	local version = {}

	version.minor = bu.readU2(stream)
	version.major = bu.readU2(stream)

	debug.print("Versions loaded successfully!")
	debug.print("Major - " .. version.major .. "; Minor - " .. version.minor)
	return version
end

return classLoader