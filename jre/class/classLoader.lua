local javoc, classLoader = require("umfal")("javoc")

local debugPrint = javoc.jre.debug.print
local binaryStream = javoc.jre.utilities.binaryStream
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
	class.accessFlags = classLoader.loadAccessFlags(stream)
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

-- TODO: REFACTOR THIS MESS ASAP!!!!
function classLoader.loadAccessFlags(stream)
	debugPrint("Loading access flags")

	local accessFlags = {}
	accessFlags.mask = binaryStream.readU2(stream)

	debugPrint("Mask: " .. string.format("0x%x", accessFlags.mask))

	accessFlags["ACC_PUBLIC"]     = binaryStream.mask(accessFlags.mask, 0x0001)
	debugPrint("ACC_PUBLIC: " .. tostring(accessFlags["ACC_PUBLIC"]))

	accessFlags["ACC_FINAL"]      = binaryStream.mask(accessFlags.mask, 0x0010)
	debugPrint("ACC_FINAL: " .. tostring(accessFlags["ACC_FINAL"]))

	accessFlags["ACC_SUPER"]      = binaryStream.mask(accessFlags.mask, 0x0020)
	debugPrint("ACC_SUPER: " .. tostring(accessFlags["ACC_SUPER"]))

	accessFlags["ACC_INTERFACE"]  = binaryStream.mask(accessFlags.mask, 0x0200)
	debugPrint("ACC_INTERFACE: " .. tostring(accessFlags["ACC_INTERFACE"]))

	accessFlags["ACC_ABSTRACT"]   = binaryStream.mask(accessFlags.mask, 0x0400)
	debugPrint("ACC_ABSTRACT: " .. tostring(accessFlags["ACC_ABSTRACT"]))

	accessFlags["ACC_SYNTHETIC"]  = binaryStream.mask(accessFlags.mask, 0x1000)
	debugPrint("ACC_SYNTHETIC: " .. tostring(accessFlags["ACC_SYNTHETIC"]))

	accessFlags["ACC_ANNOTATION"] = binaryStream.mask(accessFlags.mask, 0x2000)
	debugPrint("ACC_ANNOTATION: " .. tostring(accessFlags["ACC_ANNOTATION"]))

	accessFlags["ACC_ENUM"]       = binaryStream.mask(accessFlags.mask, 0x4000)
	debugPrint("ACC_ENUM: " .. tostring(accessFlags["ACC_ENUM"]))

	return accessFlags
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