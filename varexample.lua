local function done ()
	error("File ends here", 2)
end

local List = require "list"
local list = List.create()

list.field = -1
list.static = -1
list.closed = {} -- set

-- augmented cons operation.
function list:addVar (segment, datatype, name)
	if not self[segment] then
		local msg = string.format("Segment '%s' is not defined yet", segment)
		error(msg, 2)
	end

	if self.closed[segment] then
		local msg = string.format("Segment '%s' is closed at this point", segment)
		error(msg, 2)
	end

	local variablePrint = {__tostring = function (v)
		local line = string.format("%s %s %s %d", v.segment, v.datatype, v.name, v.index)
		return line
	end}

	self[segment] = self[segment] + 1

	local variable = {segment = segment, datatype = datatype, name = name, index = self[segment]}
	setmetatable(variable, variablePrint)
	self = self:cons(variable)

	return self
end


function list:close (...)
	for i = 1, select("#", ...) do
		self.closed[select(i, ...)] = true
	end
end

-- should use tostring for a given object

local function prettyPrint (list)
	list:foreach(function (x)
		print(x)
	end)
end

list = list:addVar("field", "int", "x")
list = list:addVar("static", "Array", "map")
list = list:addVar("field", "String", "msg")
list = list:addVar("static", "Array", "powerups")

print(list:length())

local mainList = List.create()
print(mainList:length())
mainList.classname = "Main"

print(list.classname or "not yet")
list:atop(mainList)
print(list.classname or "something's broken")


localList = list:fork()

localList:close("static", "field")

localList.argument = -1
localList.var = -1
localList = localList:addVar("argument", "int", "Ax")

localList:close("argument")
localList = localList:addVar("var", "int", "i")
--localList = localList:addVar("field", "int", "x") -- error
prettyPrint(localList)
