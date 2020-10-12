local List = require "list"
local VarSystem = require "variable"

local list = List.create()

local function first (VarSystem)
	local createVariable = VarSystem.createVariable

	list = list:cons(createVariable("x", "int", "field"))
	list = list:cons(createVariable("a", "Array", "static"))
	list = list:cons(createVariable("Ax", "int", "argument"))
end

local function second (VarSystem)
	local createVariable = VarSystem.createVariable

	list = list:cons(createVariable("y", "int", "field"))
	list = list:cons(createVariable("s", "String", "static"))
	list = list:cons(createVariable("Ay", "int", "argument"))
end

first(VarSystem)
second(VarSystem:reset("field", "static"))

print(list)

--print(list:find(function (x) return x.name == "s" end))
