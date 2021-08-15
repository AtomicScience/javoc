local javoc, classLoader = require("umfal")("javoc")

local debugPrint = javoc.jre.util.debug.print
local binaryStream = javoc.jre.util.binaryStream
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

	class.version = classLoader.loadVersion(stream)
	class.constantPool = javoc.jre.class.constantPoolLoader.load(stream)
	class.accessFlags = javoc.jre.class.accessFlagsLoader.load(stream)
	class.thisClass, class.superClass = classLoader.loadClassNames(stream, class.constantPool)

	debugPrint("Class " .. class.thisClass.name .. " loaded successfully")

	return class
end

function classLoader.checkMagicValue(stream)
	debugPrint("Loading 'magic value' (0xCAFEBABE)")
	local magicValue = binaryStream.readU4(stream)

	return (magicValue == 0xCAFEBABE)
end

function classLoader.loadVersion(stream)
	debugPrint("Loading versions (major and minor)")
	local version = {}

	version.minor = binaryStream.readU2(stream)
	version.major = binaryStream.readU2(stream)

	debugPrint("Versions loaded successfully!")
	debugPrint("Major - " .. version.major .. "; Minor - " .. version.minor)
	return version
end

function classLoader.loadClassNames(stream, constantPool)
	debugPrint("Loading this and super class names")
	local thisClass  = {}
	local superClass = {}

	thisClass.index  = binaryStream.readU2(stream)
	superClass.index = binaryStream.readU2(stream)

	-- Both 'thisClassIndex' and 'superClassIndex' point at
	-- the CONSTANT_Class, which points at the CONSTANT_Utf8,
	-- which contains the string we want
	local thisClassConstantClass  = constantPool[thisClass.index]
	local superClassConstantClass = constantPool[superClass.index]

	local thisClassUTF8  = constantPool[thisClassConstantClass.nameIndex]
	local superClassUTF8 = constantPool[superClassConstantClass.nameIndex]

	thisClass.name  = thisClassUTF8.value
	superClass.name = superClassUTF8.value

	debugPrint("This class:  #" .. thisClass.index .. " (" .. thisClass.name .. ")")
	debugPrint("Super class: #" .. superClass.index .. " (" .. superClass.name .. ")")
	return thisClass, superClass
end

return classLoader