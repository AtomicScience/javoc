local jre = require("umfal")("javoc").jre

local bit32 = require("bit32")

-- TODO: Move empty handler creation to a separate file
local function tagNotFound(_, tag)
	error("Invalid tag for constant pool entry (" .. tag .. ")")
end

local metatable = {__index = tagNotFound}

local constantPool = setmetatable({}, metatable)

-- Constant CONSTANT_Utf8
-- Tag - 1
-- Syntax: {
--    u2 length;
--    u1 bytes[length];
-- }
constantPool[1] = function(stream)
	local constant = {}
	constant.type  = "Utf8"
	constant.value = ""

	local length = jre.utilities.binaryStream.readU2(stream)

	for i = 1, length do
		constant.value = constant.value .. string.char(jre.utilities.binaryStream.readU1(stream))
	end

	jre.debug.print("Utf8 constant.")
	jre.debug.print("Lenght - " .. length .. " bytes")
	jre.debug.print("Value  - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Integer
-- Tag - 3
-- Syntax: {
--    u4 bytes
-- }
constantPool[3] = function(stream)
	local constant = {}
	constant.type  = "Integer"
	constant.value = jre.utilities.binaryStream.readU4(stream)

	jre.debug.print("Integer constant.")
	jre.debug.print("Value - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Float
-- Tag - 4
-- Syntax: {
--    u4 bytes
-- }
constantPool[4] = function(stream)
	local constant = {}
	constant.type  = "Float"
	
	local bytes = stream:read(4)

	constant.value = string.unpack(">f", bytes)

	jre.debug.print("Float constant.")
	jre.debug.print("Value - " .. constant.value)

	return constant
end

-- Constant CONSTANT_Long
-- Tag - 5
-- Syntax: {
--    u4 high_bytes;
--    u4 low_bytes;
-- }
constantPool[5] = function(stream)
	local constant = {}
	constant.type  = "Long"
	
	local highBytes = jre.utilities.binaryStream.readU4(stream)
	local lowBytes  = jre.utilities.binaryStream.readU4(stream)

	-- value = (highBytes << 32) + lowBytes
	constant.value = bit32.lshift(highBytes, 32) + lowBytes

	jre.debug.print("Long constant.")
	jre.debug.print("Value - " .. constant.value)

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
constantPool[6] = function(stream)
	local constant = {}
	constant.type  = "Double"

	local highBytes = stream:read(4)
	local lowBytes  = stream:read(4)

	-- value = (highBytes << 32) + lowBytes
	constant.value = string.unpack(">d", highBytes .. lowBytes)

	jre.debug.print("Double constant.")
	jre.debug.print("Value - " .. constant.value)

	-- Since Long and Double constants "occuppy" 2 indexes
	-- in the table, a dummy constant should be inserted
	return constant, {type = "Dummy"}
end

-- Constant CONSTANT_Class
-- Tag - 7
-- Syntax: {
--    u2 name_index;
-- }
constantPool[7] = function(stream)
	local constant = {}
	constant.type  = "Class"

	constant.nameIndex = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("Class constant.")
	jre.debug.print("Name index - " .. constant.nameIndex)

	return constant
end

-- Constant CONSTANT_String
-- Tag - 8
-- Syntax: {
--    u2 string_index;
-- }
constantPool[8] = function(stream)
	local constant = {}
	constant.type  = "String"

	constant.stringIndex = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("String constant.")
	jre.debug.print("Utf8 index - " .. constant.stringIndex)

	return constant
end

-- Constant CONSTANT_Fieldref
-- Tag - 9
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPool[9] = function(stream)
	local constant = {}
	constant.type  = "Fieldref"

	constant.classIndex       = jre.utilities.binaryStream.readU2(stream)
	constant.nameAndTypeIndex = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("Fieldref constant")
	jre.debug.print("Class index         - " .. constant.classIndex)
	jre.debug.print("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_Methodref
-- Tag - 10
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPool[10] = function(stream)
	local constant = {}
	constant.type  = "Methodref"

	constant.classIndex       = jre.utilities.binaryStream.readU2(stream)
	constant.nameAndTypeIndex = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("Methodref constant")
	jre.debug.print("Class index         - " .. constant.classIndex)
	jre.debug.print("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_InterfaceMethodref
-- Tag - 11
-- Syntax: {
--    u2 class_index;
--    u2 name_and_type_index;
-- }
constantPool[11] = function(stream)
	local constant = {}
	constant.type  = "InterfaceMethodref"

	constant.classIndex       = jre.utilities.binaryStream.readU2(stream)
	constant.nameAndTypeIndex = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("InterfaceMethodref constant")
	jre.debug.print("Class index         - " .. constant.classIndex)
	jre.debug.print("Name and type index - " .. constant.nameAndTypeIndex)

	return constant
end

-- Constant CONSTANT_NameAndType
-- Tag - 12
-- Syntax: {
--    u2 name_index;
--    u2 descriptor_index;
-- }
constantPool[12] = function(stream)
	local constant = {}
	constant.type  = "NameAndType"

	constant.nameIndex        = jre.utilities.binaryStream.readU2(stream)
	constant.descriptorIndex  = jre.utilities.binaryStream.readU2(stream)

	jre.debug.print("NameAndType constant")
	jre.debug.print("Name index       - " .. constant.nameIndex)
	jre.debug.print("Descriptor index - " .. constant.descriptorIndex)

	return constant
end

return constantPool