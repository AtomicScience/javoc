local javoc, accessFlags = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

local function debugPrintAccessFlag(name, value)
    debugPrint(name .. " - " .. tostring(value))
end

function accessFlags.load(stream)
	debugPrint("Loading access flags")

	local accessFlags = {}

    local allFlagsFromStream = binaryUtils.readU2(stream)
    debugPrint("Access flags mask: " .. string.format("0x%x", allFlagsFromStream))

    for flagName, flagMask in pairs(javoc.class.values.accessFlagsMasks) do
        local flagValue = binaryUtils.mask(allFlagsFromStream, flagMask)

        accessFlags[flagName] = flagValue

        debugPrintAccessFlag(flagName, flagValue)
    end

    accessFlags.mask = allFlagsFromStream
	return accessFlags
end