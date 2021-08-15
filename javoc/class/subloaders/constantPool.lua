local javoc, constantPool = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

function constantPool.load(stream)
	debugPrint("Loading constant pool")

	local constantPool = {}
	constantPool.size = binaryUtils.readU2(stream)
	debugPrint("Size of the constant pool - " .. constantPool.size)

	local currentIndex = 1

	debugPrint("Constants in the pool:")
	while currentIndex < constantPool.size do
		local tag = binaryUtils.readU1(stream)
		debugPrint("Constant #" .. currentIndex .. " with tag " .. tag)
		-- Since Double and Long constants occuppy two indexes in the
		-- constant pool, they will return not one constant, but two:
		-- the actual one and the 'dummy'. "Normal" constants will
		-- set 'dummyConstant' field to nil
		local constant, dummyConstant = javoc.class.handlers.constantPool[tag](stream)
		table.insert(constantPool, constant)

		if dummyConstant then
			-- If dummyConstant is NOT nil, it means that
			-- the 'fat' constant was loaded.
			-- So, we should increment currentIndex on 2 and insert
			-- a dummyConstant into table as well
			table.insert(constantPool, dummyConstant)

			currentIndex = currentIndex + 2
		else
			-- If dummyConstant is nil, it means that
			-- the 'normal' constant was loaded.
			currentIndex = currentIndex + 1
		end
	end

	return constantPool
end