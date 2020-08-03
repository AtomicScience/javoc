--[[ Java Class Decompiler
	 Version: 0.1
	 Part of the JavOC project
]]

local shell = require("shell")
-- The flag to indicate if output should be verbose or not
local verbose = false

local function printHelpMessage()
	print("javocp - Java class Disassembler (v 0.1) ")
	print("Usage: javocp [options] <class>          ")
	print("Possible options:                        ")
	print("  --help, -?         Print this reference")
	print("  --verbose, -v      Verbose information ")
	print("                     (constant pool)     ")
end

-- Parsing arguments passed to the program via "shell" API
-- Refer to (https://ocdoc.cil.li/api:shell) for more information
local args, ops = shell.parse(...)

-- If special options are provided or no class is given,
-- we should print the help message
if ops["?"] or ops["help"] or (#args == 0) then
	printHelpMessage()
end

if ops["v"] or ops["verbose"] then
	verbose = true
end