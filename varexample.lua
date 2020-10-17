local List = require "list"

local list = List.create()

list.field = -1
list.static = -1
list.closed = {} -- set

print(list)

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

	self[segment] = self[segment] + 1
	self = self:cons({segment = segment, datatype = datatype, name = name, index = self[segment]})

	return self
end

function list:close (...)
	for i = 1, select("#", ...) do
		self.closed[select(i, ...)] = true
	end
end

local function prettyPrint (list)
	list:foreach(function (x)
		local msg = string.format("%s %s %s %d", x.segment, x.datatype, x.name, x.index)
		print(msg)
	end)
end

list = list:addVar("field", "int", "x")
list = list:addVar("static", "Array", "map")
list = list:addVar("field", "String", "msg")
list = list:addVar("static", "Array", "powerups")

localList = list:fork()

localList:close("static", "field")

localList.argument = -1
localList.var = -1

localList = localList:addVar("argument", "int", "Ax")
localList:close("argument")
localList = localList:addVar("var", "boolean", "flag")
localList = localList:addVar("var", "int", "i")
--localList = localList:addVar("field", "int", "x") -- error
prettyPrint(localList)
