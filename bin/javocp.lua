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
local moduleLoader  = require("moduleLoader")
moduleLoader.clearCache()

local classLoader   = moduleLoader.require("class/classLoader")
local debug         = moduleLoader.require("debug/javaDebug")

local classInfoPrinter     = moduleLoader.require("bin/javocp/output/classInfoPrinter")
local helpMessagePrinter   = moduleLoader.require("bin/javocp/output/helpMessagePrinter")

-- The flag to indicate if output should be verbose or not
local verbose = false

-- Parsing arguments passed to the program via "shell" API
-- Refer to (https://ocdoc.cil.li/api:shell) for more information
local args, ops = shell.parse(...)

-- If special options are provided or no class is given,
-- we should print the help message
if ops["?"] or ops["help"] or (#args == 0) then
	helpMessagePrinter.printHelpMessage()
	return
end

if ops["v"] or ops["verbose"] then
	verbose = true
end

if ops["d"] or ops["debug"] then
	debug.debugEnabled = true
end

-- Name of the class to load
local classToLoad = args[1]
local class = classLoader.loadClassFromFile(classToLoad, "")

local fullPathToClass = filesystem.canonical(shell.getWorkingDirectory() .. "/" .. classToLoad)

classInfoPrinter.printInfo(class, fullPathToClass)