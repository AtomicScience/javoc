--[[ Java Class Loader (Bootstrap)
	 Version: 0.1
	 Part of the JavOC project
]]
local debug = require("debug")
local classLoader = {}

---Loads a class from the stream - usually file, but not always
---@param stream file-stream    @ Stream with class file
---@return table class          @ Loaded and parsed class file
function classLoader.loadClassFromStream(stream)
	
end

---Loads a class from a file. Path is relative from classpath
---@param file string           @ Name of the class to load
---@param classpath string      @ Absolute path to the classes to load
---@return table class          @ Loaded and parsed class file
---@return string error         @ Error message (nil if success)
function classLoader.loadClassFromFile(file, classpath)
	-- Finding an absolute path to the file
	local filePath = classpath .. file

	debug.print("Attempting to load class on path of " .. filePath)
	local stream = io.open(filePath, "rb")

	if not stream then
		debug.print("Failed to find the file or open it")
		error("Class File not found!")
	end

	debug.print("File stream created, loading class from it")
	return classLoader.loadClassFromStream(stream)
end

return classLoader