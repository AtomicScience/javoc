--[[ Binary stream utilities
	 Version: 0.1
	 Part of the JavOC project
]]
local bit32 = require("bit32")

local binaryUtils = {}

---Loads a one-byte (8 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryUtils.readU1(stream)
	return string.byte(stream:read(1))
end

---Loads a two-byte (16 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryUtils.readU2(stream)
	-- u2() = (u1() << 8) + u1()
	return bit32.lshift(binaryUtils.readU1(stream), 8) + binaryUtils.readU1(stream)
end

---Loads a four-byte (32 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryUtils.readU4(stream)
	-- u4() = (u2() << 16) + u2()
	return bit32.lshift(binaryUtils.readU2(stream), 16) + binaryUtils.readU2(stream)
end

return binaryUtils