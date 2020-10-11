local L = require "list"
local V = require "variable"

local list = L.create()
local createVariable = V.initVariableSystem()

local function first (createVariable)
	list = list:cons(createVariable("x", "int", "field"))
	list = list:cons(createVariable("a", "Array", "static"))
end

local function second (createVariable)
	list = list:cons(createVariable("y", "int", "field"))
	list = list:cons(createVariable("s", "String", "static"))
	list = list:cons(createVariable("Ax", "int", "argument"))
end

first(createVariable)
second(createVariable)

print(list)

--print(list:find(function (x) return x.name == "s" end))
