--[[ Library for debug functions
	 Since: 0.1
	 Part of the JavOC project
]]

local javaDebug = {}

-- Flag for stating if JVM shold run in debug mode or not
-- Debug is disabled by default
javaDebug.debugEnabled = false

---Prints data to console if JVM is running in the debug mode
function javaDebug.print(...)
	if javaDebug.debugEnabled then
		print("[JavOC]: " .. ...)
	end
end

return javaDebug