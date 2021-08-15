local javoc, fileClassLoader = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print

---Loads a class from a file. Path is relative from classpath
---@param file string           @ Name of the class to load
---@param classpath string      @ Absolute path to the classes to load
---@return table class          @ Loaded and parsed class file
function fileClassLoader.load(file, classpath)
	if not file:find(".class") then
		file = file .. ".class"
	end

	local filePath = "" .. classpath .. file

	debugPrint("Attempting to load class on path of " .. filePath)
	local stream = io.open(filePath, "rb")

	if not stream then
		debugPrint("Failed to find the file or open it")
		error("Class File not found!")
	end

	debugPrint("File stream created, loading class from it")
	return javoc.class.streamClassLoader.load(stream)
end