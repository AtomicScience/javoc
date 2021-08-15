local javoc, classLoader = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils
-- TODO: Split file and stream loaders
---Loads a class from a file. Path is relative from classpath
---@param file string           @ Name of the class to load
---@param classpath string      @ Absolute path to the classes to load
---@return table class          @ Loaded and parsed class file
function classLoader.loadClassFromFile(file, classpath)
	if not file:find(".class") then
		file = file .. ".class"
	end

	local filePath = "" .. classpath .. file

	debugPrint("Attempting to load class on path of " .. filePath)
	local stream = io.open(filePath, "rb")

	if not stream then
		debugPrint("Failed to find the file or open it")
		error("Class File not found!")
	end

	debugPrint("File stream created, loading class from it")
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

	debugPrint("Correct 'magic value' is loaded")

	class.version      = javoc.class.subloaders.version.load(stream)
	class.constantPool = javoc.class.subloaders.constantPool.load(stream)
	class.accessFlags  = javoc.class.subloaders.accessFlags.load(stream)
	class.thisClass, class.superClass = javoc.class.subloaders.classNames.load(stream, class.constantPool)

	debugPrint("Class " .. class.thisClass.name .. " loaded successfully")

	return class
end

function classLoader.checkMagicValue(stream)
	debugPrint("Loading 'magic value' (0xCAFEBABE)")
	local magicValue = binaryUtils.readU4(stream)

	return (magicValue == 0xCAFEBABE)
end