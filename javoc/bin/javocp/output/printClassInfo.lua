local javoc         = require("umfal")("javoc")
local filesystem    = require("filesystem")

---Prints different information about class
---@param class table              @ Loaded class
---@param fullPathToClass string   @ Absolute path of the class file
local function printClassInfo(class, fullPathToClass)
    local fileEditTime = os.date("%b %d, %Y", filesystem.lastModified(fullPathToClass))
    local fileSize = filesystem.size(fullPathToClass)

    -- 'extends' signature is ommited when object is inherited directly from java/lang/Object
    local extends = ""
    if class.superClass.name ~= "java/lang/Object" then
	    extends = " extends " .. class.superClass.name
    end

    print("Classfile " .. fullPathToClass)
    print("  Last modified: " .. fileEditTime .. "; size " .. fileSize .. " bytes")
    print("class " .. class.thisClass.name .. extends)
    print("  minor version: " .. class.version.minor)
    print("  major version: " .. class.version.major)
    print("  flags: " .. javoc.bin.javocp.serialization.accessFlags.toString(class.accessFlags))
    print("  this_class: #" .. class.thisClass.index)
    print("  super_class: #" .. class.superClass.index)
end

return printClassInfo