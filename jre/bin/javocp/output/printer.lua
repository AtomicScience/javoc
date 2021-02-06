--[[ Message printer for javocp
	Since: 0.2
	Part of the JavOC project

	Collects different printers from `printers` directory into single file
	for the sake of usage simplicity
]]
local moduleLoader = require("moduleLoader")

local printer = {}

local classInfoPrinter      = moduleLoader.require("bin/javocp/output/printers/classInfoPrinter")
local helpMessagePrinter    = moduleLoader.require("bin/javocp/output/printers/helpMessagePrinter")
local constantPoolPrinter   = moduleLoader.require("bin/javocp/output/printers/constantPoolPrinter")

printer.printClassInfo      = classInfoPrinter.printClassInfo
printer.printHelpMessage    = helpMessagePrinter.printHelpMessage
printer.printConstantPool   = constantPoolPrinter.printConstantPool

return printer