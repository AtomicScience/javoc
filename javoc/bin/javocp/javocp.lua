local shell         = require("shell")
local filesystem    = require("filesystem")
local javoc         = require("umfal").initAppFromRelative("javoc", 3)

-- The flag to indicate if output should be verbose or not
local verbose = false

local args, ops = shell.parse(...)

if ops["?"] or ops["help"] or (#args == 0) then
	javoc.bin.javocp.output.printHelpMessage()
	return
end

if ops["v"] or ops["verbose"] then
	verbose = true
end

if ops["d"] or ops["debug"] then
	javoc.util.debug.debugEnabled = true
end

local classToLoad = args[1]

local class = javoc.class.classLoader.loadClassFromFile(classToLoad, "")

local fullPathToClass = filesystem.canonical(shell.getWorkingDirectory() .. "/" .. classToLoad)

javoc.bin.javocp.output.printClassInfo(class, fullPathToClass)

if verbose then
	javoc.bin.javocp.output.printConstantPool(class.constantPool)
end