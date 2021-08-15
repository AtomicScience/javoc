--	More information: "doc/About JavOC/Structure/Serialization/Constant Pool"
local javoc = require("umfal")("javoc")

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

	local value, comment = javoc.bin.javocp.serialization.handlers.constantPool[type](constantPool, index)

	return value, comment
end

return serialization