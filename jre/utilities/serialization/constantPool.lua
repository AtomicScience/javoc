--[[ Constant pool entries serialization
	Since: 0.2
	Part of the JavOC project

	More information: "doc/About JavOC/Structure/Serialization/Constant Pool"
]]
local jre = require("umfal").javoc.jre

local serialization = {}

---Serializes a constant from the constant pool
---@param constantPool table   @ Table of the constant pool - output of the
---                              classLoader.loadConstantPool() function
---@param index number         @ Index of the constant pool entry you want to
---                              serialize
---
---
---@return string value        @ Value of the constant
---                              Nil, if constant is dummy
---@return string commentary   @ A commentary to the constant
---                              Nil if not needed or dummy
function serialization.toString(constantPool, index)
	local constant = constantPool[index]
	local type = constant.type

	local value, comment = jre.utilities.serialization.handlers.constantPool[type](constantPool, index)

	return value, comment
end

return serialization