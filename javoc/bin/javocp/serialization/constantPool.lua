--	More information: "doc/About JavOC/Structure/Serialization/Constant Pool"
local javoc = require("umfal")("javoc")

local serialization = {}

function serialization.toString(constantPool, index)
	local constant = constantPool[index]
	local type = constant.type

	local value, comment = javoc.bin.javocp.serialization.handlers.constantPool[type](constantPool, index)

	return value, comment
end

return serialization