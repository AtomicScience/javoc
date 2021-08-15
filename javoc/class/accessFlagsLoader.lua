local javoc, accessFlagsLoader = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryStream = javoc.util.binaryStream

local function debugPrintAccessFlag(name, value)
    debugPrint(name .. " - " .. tostring(value))
end

function accessFlagsLoader.load(stream)
	debugPrint("Loading access flags")

	local accessFlags = {}

    local allFlagsFromStream = binaryStream.readU2(stream)
    debugPrint("Access flags mask: " .. string.format("0x%x", allFlagsFromStream))

    for flagName, flagMask in pairs(javoc.class.values.accessFlagsMasks) do
        local flagValue = binaryStream.mask(allFlagsFromStream, flagMask)

        accessFlags[flagName] = flagValue

        debugPrintAccessFlag(flagName, flagValue)
    end

    accessFlags.mask = allFlagsFromStream
	return accessFlags
end