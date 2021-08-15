local javoc, version = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print
local binaryUtils = javoc.util.binaryUtils

function version.load(stream)
	debugPrint("Loading versions (major and minor)")
	local version = {}

	version.minor = binaryUtils.readU2(stream)
	version.major = binaryUtils.readU2(stream)

	debugPrint("Versions loaded successfully!")
	debugPrint("Major - " .. version.major .. "; Minor - " .. version.minor)
	return version
end