--[[ JVM module loader
	 Version: 0.1
	 Part of the JavOC project
]]

local moduleLoader = {}

---Loads a module from "jre" directory
---@param path string	  @ Path to the module to load
---							Paths should be relative to the 'jre'
---							library (e.g. "classLoader/classLoader")
---@return table module	  @ Loaded module
function moduleLoader.require(path)

end

return moduleLoader