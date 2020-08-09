--[[ Constant pool handler
	 Since: 0.2
	 Part of the JavOC project
	 More information - `doc/About JavOC/Structure/Handlers.md`
]]
local moduleLoader = require("moduleLoader")

local bit32 = require("bit32")

local debug = moduleLoader.require("debug/javaDebug")

local bu    = moduleLoader.require("utilities/binaryStream")

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
	constant.string = ""

	local length = bu.readU2(stream)

	for i = 1, length do
		constant.string = constant.string .. string.char(bu.readU1(stream))
	end

	debug.print("Utf8 constant.")
	debug.print("Lenght - " .. length .. " bytes")
	debug.print("Value  - " .. constant.string)

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
	constant.value = bu.readU4(stream)

	debug.print("Integer constant.")
	debug.print("Value - " .. constant.value)

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

	debug.print("Float constant.")
	debug.print("Value - " .. constant.value)

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
	
	local highBytes = bu.readU4(stream)
	local lowBytes  = bu.readU4(stream)

	-- value = (highBytes << 32) + lowBytes
	constant.value = bit32.lshift(highBytes, 32) + lowBytes

	debug.print("Long constant.")
	debug.print("Value - " .. constant.value)

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

	debug.print("Double constant.")
	debug.print("Value - " .. constant.value)

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

	constant.nameIndex = bu.readU2(stream)

	debug.print("Class constant.")
	debug.print("Name index - " .. constant.nameIndex)

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

	constant.stringIndex = bu.readU2(stream)

	debug.print("String constant.")
	debug.print("Utf8 index - " .. constant.stringIndex)

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

	constant.classIndex       = bu.readU2(stream)
	constant.nameAndTypeIndex = bu.readU2(stream)

	debug.print("Fieldref constant")
	debug.print("Class index         - " .. constant.classIndex)
	debug.print("Name and type index - " .. constant.nameAndTypeIndex)

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

	constant.classIndex       = bu.readU2(stream)
	constant.nameAndTypeIndex = bu.readU2(stream)

	debug.print("Methodref constant")
	debug.print("Class index         - " .. constant.classIndex)
	debug.print("Name and type index - " .. constant.nameAndTypeIndex)

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

	constant.classIndex       = bu.readU2(stream)
	constant.nameAndTypeIndex = bu.readU2(stream)

	debug.print("InterfaceMethodref constant")
	debug.print("Class index         - " .. constant.classIndex)
	debug.print("Name and type index - " .. constant.nameAndTypeIndex)

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

	constant.nameIndex        = bu.readU2(stream)
	constant.descriptorIndex  = bu.readU2(stream)

	debug.print("NameAndType constant")
	debug.print("Name index       - " .. constant.nameIndex)
	debug.print("Descriptor index - " .. constant.descriptorIndex)

	return constant
end

return constantPool