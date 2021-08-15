local accessFlags = {}

---Compiles class access
---@param accessFlags table    @ Table of the access flags - output of the
---                              classLoader.loadAccessFlags() function
---@return string string       @ Access flags in human-readable form
---                              This form can't be unserialized
function accessFlags.toString(accessFlags)
	-- Extending the mask number to always have 4 digits
	-- For example, 0x20 will be extended to 0x0020
	local stringMask         = string.format("%x", accessFlags.mask)
	local stringMaskExtended = string.rep("0", 4 - string.len(stringMask)) .. stringMask

	local line = "(0x" .. stringMaskExtended .. ")  "

	if accessFlags["ACC_PUBLIC"] then
		line = line .. "ACC_PUBLIC, "
	end

	if accessFlags["ACC_FINAL"] then
		line = line .. "ACC_FINAL, "
	end

	if accessFlags["ACC_SUPER"] then
		line = line .. "ACC_SUPER, "
	end

	if accessFlags["ACC_INTERFACE"] then
		line = line .. "ACC_INTERFACE, "
	end

	if accessFlags["ACC_ABSTRACT"] then
		line = line .. "ACC_ABSTRACT, "
	end

	if accessFlags["ACC_SYNTHETIC"] then
		line = line .. "ACC_SYNTHETIC, "
	end

	if accessFlags["ACC_ANNOTATION"] then
		line = line .. "ACC_ANNOTATION, "
	end

	if accessFlags["ACC_ENUM"] then
		line = line .. "ACC_ENUM, "
	end

	-- Removing last two chars on the string (comma and whitespace)
	line = line:sub(1, -3)

	return line
end

return accessFlags