local javoc, accessFlags = require("umfal")("javoc")

local function accessFlagMaskAsString(accessFlagMask)
	-- Extending the mask number to always have 4 digits
	-- For example, 0x20 will be extended to 0x0020
	local stringMask         = string.format("%x", accessFlagMask)
	local stringMaskExtended = string.rep("0", 4 - string.len(stringMask)) .. stringMask

	return "(0x" .. stringMaskExtended .. ")  "
end

function accessFlags.toString(accessFlagsTable)
	local line = accessFlagMaskAsString(accessFlagsTable.mask)

	for flagName, _ in pairs(javoc.class.values.accessFlagsMasks) do
		if accessFlagsTable[flagName] then
			line = line .. flagName .. ", "
		end
    end

	-- Removing last two chars on the string (comma and whitespace)
	line = line:sub(1, -3)

	return line
end