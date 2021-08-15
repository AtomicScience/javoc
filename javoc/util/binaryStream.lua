local bit32 = require("bit32")

-- TODO: Rename to binaryUtils
local binaryStream = {}

---Loads a one-byte (8 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryStream.readU1(stream)
	return string.byte(stream:read(1))
end

---Loads a two-byte (16 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryStream.readU2(stream)
	-- u2() = (u1() << 8) + u1()
	return bit32.lshift(binaryStream.readU1(stream), 8) + binaryStream.readU1(stream)
end

---Loads a four-byte (32 bit) unsigned integer from the stream
---@param stream file_stream    @ Stream to load integer from
---@return number int           @ Integer loaded
function binaryStream.readU4(stream)
	-- u4() = (u2() << 16) + u2()
	return bit32.lshift(binaryStream.readU2(stream), 16) + binaryStream.readU2(stream)
end

---Checks if bit in maskedValue is 1 under mask
---@param maskedValue number   @ Value to apply mask to
---@param mask number          @ Mask to apply
---@return boolean isSet       @ If bit under mask or not
function binaryStream.mask(maskedValue, mask)
	return (bit32.band(maskedValue, mask) == mask)
end

return binaryStream