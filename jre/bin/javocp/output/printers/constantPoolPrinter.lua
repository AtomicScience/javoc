--[[ Constant Pool Printer
	Since: 0.2
	Part of the JavOC project
]]
local moduleLoader = require("moduleLoader")
local constantSerialization = moduleLoader.require("utilities/serialization/constantPool")

local constantPoolPrinter = {}

---Prints a constant pool
---@param constantPool table   @ Table of the constant pool - output of the
---                              classLoader.loadConstantPool() function
function constantPoolPrinter.printConstantPool(constantPool)
	print("Constant pool:")

	for i = 1, constantPool.size - 1 do
		local constant = constantPool[i]

		if constant.type ~= "Dummy" then
			local index        = "#" .. i
			local indexSpacing = string.rep(" ", 5 - string.len(index))

			local equals = " = "

			local type        = constant.type
			local typeSpacing = string.rep(" ", 20 - string.len(type))
		
			local value, comment = constantSerialization.toString(constantPool, i)
			local valueSpacing   = string.rep(" ", 16 - string.len(value))

			-- Trying to concatenate nil value will result in error
			if comment == nil then
				comment = ""
			else
				comment = "// " .. comment
			end

			local result = indexSpacing .. index .. equals .. type .. typeSpacing .. value .. valueSpacing .. comment

			print(result)
		end
	end
end

return constantPoolPrinter