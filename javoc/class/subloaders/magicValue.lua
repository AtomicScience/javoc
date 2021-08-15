local javoc, magicValue = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

function magicValue.check(stream)
	debugPrint("Loading 'magic value' (0xCAFEBABE)")
	local magicValue = binaryUtils.readU4(stream)

	return (magicValue == 0xCAFEBABE)
end