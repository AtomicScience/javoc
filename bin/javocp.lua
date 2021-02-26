--[[ Java Class Decompiler
	 Since: 0.1
	 Part of the JavOC project
]]
-- Adding path to our JVM components to the package loader.
-- However, before doing so, we should check if we'd already added it
if not package.path:find("jre") then
	package.path = package.path .. ";jre/?.lua"
end

local shell         = require("shell")
local filesystem    = require("filesystem")
local jre         = require("umfal").javoc.jre

-- The flag to indicate if output should be verbose or not
local verbose = false

-- Parsing arguments passed to the program via "shell" API
-- Refer to (https://ocdoc.cil.li/api:shell) for more information
local args, ops = shell.parse(...)

-- If special options are provided or no class is given,
-- we should print the help message
if ops["?"] or ops["help"] or (#args == 0) then
	jre.bin.javocp.output.printHelpMessage()
	return
end

if ops["v"] or ops["verbose"] then
	verbose = true
end

if ops["d"] or ops["debug"] then
	jre.debug.debugEnabled = true
end

-- Name of the class to load
local classToLoad = args[1]
local class = jre.class.classLoader.loadClassFromFile(classToLoad, "")

local fullPathToClass = filesystem.canonical(shell.getWorkingDirectory() .. "/" .. classToLoad)

jre.bin.javocp.output.printClassInfo(class, fullPathToClass)

if verbose then
	jre.bin.javocp.output.printConstantPool(class.constantPool)
end