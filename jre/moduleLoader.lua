--[[ JVM module loader
	 Version: 0.1
	 Part of the JavOC project
]]

local moduleLoader = {}

---Loads a module from "jre" directory
---@param path string     @ Path to the module to load
---                         Paths should be relative to the 'jre'
---                         library (e.g. "class/classLoader")
---@return table module	  @ Loaded module
function moduleLoader.require(path)
	local loadedModule = dofile("../jre/" .. path .. ".lua")

	if loadedModule then
		return loadedModule
	else
		error("Failed to load module!")
	end
end

return moduleLoader