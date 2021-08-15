local javoc, clasNames = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

function clasNames.load(stream, constantPool)
	debugPrint("Loading this and super class names")
	local thisClass  = {}
	local superClass = {}

	thisClass.index  = binaryUtils.readU2(stream)
	superClass.index = binaryUtils.readU2(stream)

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
