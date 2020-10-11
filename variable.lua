local M = {}

local system = {
	field = -1,
	static = -1,
	argument = -1,
	var = -1
}

function M.reset (...)
	for i = 1, select("#", ...) do
		local given = select(i, ...)
		system[given] = -1
	end
end

local methods = {}

function methods.__tostring (t)
	return string.format("name=%s,datatype=%s,segment=%s,index=%d",
		t.name, t.datatype, t.segment, t.index)
end

function M.createVariable (name, datatype, segment)
	system[segment] = system[segment] + 1

	return setmetatable({
		name = name,
		datatype = datatype,
		segment = segment,
		index = system[segment]
	}, methods)
end

--[[
print(M.createVariable("x", "int", "field"))
print(M.createVariable("y", "int", "field"))
print(M.createVariable("a", "Array", "static"))
print(M.createVariable("z", "String", "field"))
print(M.createVariable("i", "int", "var"))
print(M.createVariable("j", "int", "var"))
M.reset("argument", "var")
print(M.createVariable("i", "int", "var"))
print(M.createVariable("j", "int", "var"))
print(M.createVariable("b", "Sprite", "static"))
--]]

return M
