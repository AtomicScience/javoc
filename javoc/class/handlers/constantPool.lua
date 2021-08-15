local javoc = require("umfal")("javoc")

local constantPoolHandler = javoc.util.handlerFactory.getEmptyHandler()
local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

local bit32 = require("bit32")

-- Constant CONSTANT_Utf8
-- Tag - 1
-- Syntax: {
--    u2 length;
--    u1 bytes[length];
-- }
constantPoolHandler[1] = function(stream)
	local constant = {}
	constant.type  = "Utf8"
	constant.value = ""

	local length = binaryUtils.readU2(stream)

	-- TODO: Implement proper UTF8 loading
	for i = 1, length do
		constant.value = constant.value .. string.char(binaryUtils.readU1(stream))
	end

	debugPrint("Utf8 constant.")
	debugPrint("Lenght - " .. length .. " bytes")
	debugPrint("Value  - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Integer
-- Tag - 3
-- Syntax: {
--    u4 bytes
-- }
constantPoolHandler[3] = function(stream)
	local constant = {}
	constant.type  = "Integer"
	constant.value = binaryUtils.readU4(stream)

	debugPrint("Integer constant.")
	debugPrint("Value - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Float
-- Tag - 4
-- Syntax: {
--    u4 bytes
-- }
constantPoolHandler[4] = function(stream)
	local constant = {}
	constant.type  = "Float"
	
	local bytes = stream:read(4)

	constant.value = string.unpack(">f", bytes)

	debugPrint("Float constant.")
	debugPrint("Value - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Long
-- Tag - 5
-- Syntax: {
--    u4 high_bytes;
--    u4 low_bytes;
-- }
constantPoolHandler[5] = function(stream)
	local constant = {}
	constant.type  = "Long"
	
	local highBytes = binaryUtils.readU4(stream)
	local lowBytes  = binaryUtils.readU4(stream)

	-- value = (highBytes << 32) + lowBytes
	constant.value = bit32.lshift(highBytes, 32) + lowBytes

	debugPrint("Long constant.")
	debugPrint("Value - " .. constant.value)

	-- Since Long and Double constants "occuppy" 2 indexes
	-- in the table, a dummy constant should be inserted
	return constant, {type = "Dummy"}
end

-- Constant CONSTANT_Double
-- Tag - 6
-- Syntax: {
--    u4 high_bytes;
--    u4 low_bytes;
-- }
constantPoolHandler[6] = function(stream)
	local constant = {}
	constant.type  = "Double"

	local highBytes = stream:read(4)
	local lowBytes  = stream:read(4)

	-- value = (highBytes << 32) + lowBytes
	constant.value = string.unpack(">d", highBytes .. lowBytes)

	debugPrint("Double constant.")
	debugPrint("Value - " .. constant.value)

	-- Since Long and Double constants "occuppy" 2 indexes
	-- in the table, a dummy constant should be inserted
	return constant, {type = "Dummy"}
end

-- Constant CONSTANT_Class
-- Tag - 7
-- Syntax: {
--    u2 name_index;
-- }
constantPoolHandler[7] = function(stream)
	local constant = {}
	constant.type  = "Class"

	constant.nameIndex = binaryUtils.readU2(stream)

	debugPrint("Class constant.")
	debugPrint("Name index - " .. constant.nameIndex)

	return constant
end

-- Constant CONSTANT_String
-- Tag - 8
-- Syntax: {
--    u2 string_index;
-- }
constantPoolHandler[8] = function(stream)
	local constant = {}
	constant.type  = "String"

	constant.stringIndex = binaryUtils.readU2(stream)

	debugPrint("String constant.")
	debugPrint("Utf8 index - " .. constant.stringIndex)

	return constant
end

-- Constant CONSTANT_Fieldref
-- Tag - 9
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPoolHandler[9] = function(stream)
	local constant = {}
	constant.type  = "Fieldref"

	constant.classIndex       = binaryUtils.readU2(stream)
	constant.nameAndTypeIndex = binaryUtils.readU2(stream)

	debugPrint("Fieldref constant")
	debugPrint("Class index         - " .. constant.classIndex)
	debugPrint("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_Methodref
-- Tag - 10
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPoolHandler[10] = function(stream)
	local constant = {}
	constant.type  = "Methodref"

	constant.classIndex       = binaryUtils.readU2(stream)
	constant.nameAndTypeIndex = binaryUtils.readU2(stream)

	debugPrint("Methodref constant")
	debugPrint("Class index         - " .. constant.classIndex)
	debugPrint("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_InterfaceMethodref
-- Tag - 11
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPoolHandler[11] = function(stream)
	local constant = {}
	constant.type  = "InterfaceMethodref"

	constant.classIndex       = binaryUtils.readU2(stream)
	constant.nameAndTypeIndex = binaryUtils.readU2(stream)

	debugPrint("InterfaceMethodref constant")
	debugPrint("Class index         - " .. constant.classIndex)
	debugPrint("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_NameAndType
-- Tag - 12
-- Syntax: {
--    u2 name_index;
--    u2 descriptor_index;
-- }
constantPoolHandler[12] = function(stream)
	local constant = {}
	constant.type  = "NameAndType"

	constant.nameIndex        = binaryUtils.readU2(stream)
	constant.descriptorIndex  = binaryUtils.readU2(stream)

	debugPrint("NameAndType constant")
	debugPrint("Name index       - " .. constant.nameIndex)
	debugPrint("Descriptor index - " .. constant.descriptorIndex)

	return constant
end

return constantPoolHandler