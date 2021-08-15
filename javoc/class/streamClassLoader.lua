local javoc, streamClassLoader = require("umfal")("javoc")

local debugPrint = javoc.util.debug.print

---Loads a class from the stream - usually file, but not always
---@param stream file_stream    @ Stream with class file
---@return table class          @ Load`ed and parsed class file
function streamClassLoader.load(stream)
	local class = {}

	if not javoc.class.subloaders.magicValue.check(stream) then
		error("Class loading aborted: incorrect 'magic value'")
	end

	debugPrint("Correct 'magic value' is loaded")

	class.version      = javoc.class.subloaders.version.load(stream)
	class.constantPool = javoc.class.subloaders.constantPool.load(stream)
	class.accessFlags  = javoc.class.subloaders.accessFlags.load(stream)
	class.thisClass, class.superClass = javoc.class.subloaders.classNames.load(stream, class.constantPool)

	debugPrint("Class " .. class.thisClass.name .. " loaded successfully")

	return class
end