--[[ Java Class Decompiler
	 Version: 0.1
	 Part of the JavOC project
]]
-- Adding path to our JVM components to the package loader.
-- However, before doing so, we should check if we'd already added it
if not package.path:find("jre") then
	package.path = package.path .. ";../jre/?.lua"
end

local shell        = require("shell")
local moduleLoader = require("moduleLoader")
moduleLoader.clearCache()
local classLoader  = moduleLoader.require("class/classLoader")
local debug        = moduleLoader.require("debug/javaDebug")

-- The flag to indicate if output should be verbose or not
local verbose = false

local function printHelpMessage()
	print("javocp - Java class Disassembler (v 0.1) ")
	print("Usage: javocp [options] <class>          ")
	print("Possible options:                        ")
	print("  --help, -?         Print this reference")
	print("  --verbose, -v      Verbose information ")
	print("                     (constant pool)     ")
	print("  --debug, -d        Enables debug mode  ")
end

-- Parsing arguments passed to the program via "shell" API
-- Refer to (https://ocdoc.cil.li/api:shell) for more information
local args, ops = shell.parse(...)

-- If special options are provided or no class is given,
-- we should print the help message
if ops["?"] or ops["help"] or (#args == 0) then
	printHelpMessage()
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

local class = classLoader.loadClassFromFile(args[1], "")