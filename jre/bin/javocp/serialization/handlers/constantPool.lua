--    More information: "doc/About JavOC/Structure/Serialization/Constant Pool"
--                      "doc/About JavOC/Structure/Handlers.md"
local javoc = require("umfal")("javoc")
local handler = javoc.jre.util.handlerFactory.getEmptyHandler()

-- Constant DUMMY
-- Syntax: {
--    type  = "Dummy"
-- }
-- Final view:
--   NONE
handler["Dummy"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = nil
    local comment = nil

    return value, comment
end

-- Constant CONSTANT_Utf8
-- Syntax: {
--    type  = "Utf8"
--    value = <String>
-- }
handler["Utf8"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = constant.value
    local comment = nil
    
    return value, comment
end

-- Constant CONSTANT_Integer
-- Syntax: {
--    type  = "Integer"
--    value = <Number (32-bit)>
-- }
handler["Integer"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = tostring(constant.value)
    local comment = nil

    return value, comment
end

-- Constant CONSTANT_Float
-- Syntax: {
--    type  = "Float"
--    value = <Number (32-bit)>
-- }
handler["Float"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = tostring(constant.value) .. "f"
    local comment = nil

    return value, comment
end

-- Constant CONSTANT_Long
-- Syntax: {
--    type  = "Long"
--    value = <Number (64-bit)>
-- }
handler["Long"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = tostring(constant.value) .. "l"
    local comment = nil

    return value, comment
end

-- Constant CONSTANT_Double
-- Syntax: {
--    type  = "Double"
--    value = <Number (64-bit)>
-- }
handler["Double"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local value   = tostring(constant.value) .. "d"
    local comment = nil

    return value, comment
end

-- Constant CONSTANT_Class
-- Syntax: {
--    type       = "Class"
--    nameIndex = <Index of Utf8 constant>
-- }
handler["Class"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local nameIndex = constant.nameIndex

    local value   = "#" .. tostring(nameIndex)
    local comment = handler["Utf8"](constantPool, nameIndex)

    return value, comment
end

-- Constant CONSTANT_String
-- Syntax: {
--    type        = "String"
--    stringIndex = <Index of Utf8 constant>
-- }
handler["String"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local stringIndex = constant.stringIndex

    local value   = "#" .. tostring(stringIndex)
    local comment = handler["Utf8"](constantPool, stringIndex)

    return value, comment
end

-- Constant CONSTANT_Fieldref
-- Syntax: {
--    type              = "Fieldref"
--    classIndex        = <Index of Class constant>
--    nameAndTypeIndex  = <Index of NameAndType constant>
-- }
handler["Fieldref"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local classIndex = constant.classIndex
    local nameAndTypeIndex = constant.nameAndTypeIndex

    local value   = "#" .. classIndex .. ":" .. "#" .. nameAndTypeIndex

    local _, classComment       = handler["Class"](constantPool, classIndex)
    local _, nameAndTypeComment = handler["NameAndType"](constantPool, classIndex)

    local comment = classComment .. "." .. nameAndTypeComment

    return value, comment
end

-- Constant CONSTANT_Methodref
-- Syntax: {
--    type              = "Methodref"
--    classIndex        = <Index of Class constant>
--    nameAndTypeIndex  = <Index of NameAndType constant>
-- }
handler["Methodref"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local classIndex = constant.classIndex
    local nameAndTypeIndex = constant.nameAndTypeIndex

    local value   = "#" .. classIndex .. ":" .. "#" .. nameAndTypeIndex

    local _, classComment       = handler["Class"](constantPool, classIndex)
    local _, nameAndTypeComment = handler["NameAndType"](constantPool, nameAndTypeIndex)

    local comment = classComment .. "." .. nameAndTypeComment

    return value, comment
end

-- Constant CONSTANT_InterfaceMethodref
-- Syntax: {
--    type              = "InterfaceMethodref"
--    classIndex        = <Index of Class constant>
--    nameAndTypeIndex  = <Index of NameAndType constant>
-- }
handler["InterfaceMethodref"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local classIndex       = constant.classIndex
    local nameAndTypeIndex = constant.nameAndTypeIndex

    local value   = "#" .. classIndex .. ":" .. "#" .. nameAndTypeIndex

    local _, classComment       = handler["Class"](constantPool, classIndex)
    local _, nameAndTypeComment = handler["NameAndType"](constantPool, classIndex)

    local comment = classComment .. "." .. nameAndTypeComment

    return value, comment
end

-- Constant CONSTANT_NameAndType
-- Syntax: {
--    type              = "NameAndType"
--    nameIndex         = <Index of Utf8 constant>
--    descriptorIndex   = <Index of Utf8 constant>
-- }
handler["NameAndType"] = function(constantPool, constantIndex)
    local constant = constantPool[constantIndex]

    local nameIndex       = constant.nameIndex
    local descriptorIndex = constant.descriptorIndex

    local value = "#" .. nameIndex .. ":#" .. descriptorIndex

    local nameComment       = handler["Utf8"](constantPool, nameIndex)
    local descriptorComment = handler["Utf8"](constantPool, descriptorIndex)

    local comment = nameComment .. ":" .. descriptorComment

    return value, comment
end

return handler