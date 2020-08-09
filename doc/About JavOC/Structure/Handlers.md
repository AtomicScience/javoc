# Handlers in JavOC
In Java classes, there are few types of fields, that use tags heavily.

For example, in constant pool, there are about 15 different types of constants, and each requires its own procedure to be carried out.

The most straightforward approach - simple 'switch-case' operator covering all the possible tags - will result in bulky construction, which will make it hard to read code files and understanding logic under it. 

So, in order to separate this logic and procedures, JavOC implements system of **handlers**

### What is a handler?

Handler is a library stored in a `class/handers` directory.  
After loading, it provides a table of functions, and each procedure is stored at the address, which eqals the tag of this type of entry.

> For example, procedure for loading the CONSTANT_Class_info field form the constant pool will be stored at the address of `7`

However, handler's not just a usual table - it also uses metatable values to throw a error when unknown tag is referenced:
```lua
local function tagNotFound (_, tag)
	error("Invalid tag for constant pool entry (" .. tag .. ")")
end

local metatable = {__index = tagNotFound}

local constantPool = setmetatable({}, metatable)
```

As you can see, `__index` value of the metatable is a function `tagNotFound` - and it will be called, when invalid tag will be passed