--[[ Help message printer
	Since: 0.2
	Part of the JavOC project
]]
local helpMessagePrinter = {}

---Prints a help message for a javocp
---Why would I even make move it into separate file?
function helpMessagePrinter.printHelpMessage()
    print("javocp - Java class Disassembler (v 0.1) ")
	print("Usage: javocp [options] <class>          ")
	print("Possible options:                        ")
	print("  --help, -?         Print this reference")
	print("  --verbose, -v      Verbose information ")
	print("                     (constant pool)     ")
	print("  --debug, -d        Enables debug mode  ")
end

return helpMessagePrinter