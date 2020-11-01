--[[ JVM module loader
	 Since: 0.1
	 Part of the JavOC project
]]

local moduleLoader = {}

-- Cache for loaded modules.
moduleLoader.loaded = {}

---Loads a module from "jre" directory
---@param path string              @ Path to the module to load
---                                  Paths should be relative to the 'jre'
---                                  library (e.g. "class/classLoader")
---@param reloadFromFile boolean   @ Set to true if module should be forced to
---                                  be reloaded from the file
---@return table module	           @ Loaded module
function moduleLoader.require(path, ignoreCache)
	-- If cache contains preloaded module and ignoreCache is false or nii,
	-- returing the cached module
	if moduleLoader.loaded[path] and not ignoreCache then
		return moduleLoader.loaded[path]
	end

	local loadedModule = dofile("jre/" .. path .. ".lua")

	if loadedModule then
		moduleLoader.loaded[path] = loadedModule
		return loadedModule
	else
		error("Failed to load module!")
	end
end

-- Clears the loaded modules cache
function moduleLoader.clearCache()
	moduleLoader.loaded = {}
end

return moduleLoader