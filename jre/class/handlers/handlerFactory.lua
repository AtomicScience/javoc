local javoc, handlerFactory = require("umfal")("javoc")

local function tagNotFound(_, tag)
	error("Invalid tag for handler entry (" .. tag .. ")")
end

function handlerFactory.getEmptyHandler()
    local metatable = {__index = tagNotFound}

    return {setmetatable({}, metatable)}
end