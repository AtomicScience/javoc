local javoc, accessFlagsLoader = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryStream = javoc.util.binaryStream

-- TODO: Move this table to the separate file
local accessFlagsMasks = {
    ["ACC_PUBLIC"]     = 0x0001,
    ["ACC_FINAL"]      = 0x0010,
    ["ACC_SUPER"]      = 0x0020,
    ["ACC_INTERFACE"]  = 0x0200,
    ["ACC_ABSTRACT"]   = 0x0400
}

local function debugPrintAccessFlag(name, value)
    debugPrint(name .. " - " .. tostring(value))
end

function accessFlagsLoader.load(stream)
	debugPrint("Loading access flags")

	local accessFlags = {}

    local allFlagsFromStream = binaryStream.readU2(stream)
    debugPrint("Access flags mask: " .. string.format("0x%x", allFlagsFromStream))

    for flagName, flagMask in pairs(accessFlagsMasks) do
        local flagValue = binaryStream.mask(allFlagsFromStream, flagMask)

        accessFlags[flagName] = flagValue

        debugPrintAccessFlag(flagName, flagValue)
    end

    accessFlags.mask = allFlagsFromStream
	return accessFlags
end