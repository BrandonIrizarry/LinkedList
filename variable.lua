local M = {}

function M.initVariableSystem ()
	local system = {
		field = -1,
		static = -1,
		argument = -1,
		var = -1
	}

	local methods = {}

	function methods.__tostring (t)
		return string.format("name=%s,datatype=%s,segment=%s,index=%d",
			t.name, t.datatype, t.segment, t.index)
	end

	-- create an item for the linked list/other storage
	local function createVariable (name, datatype, segment)
		system[segment] = system[segment] + 1

		return setmetatable({
			name = name,
			datatype = datatype,
			segment = segment,
			index = system[segment]
		}, methods)
	end

	return createVariable
end

local createVariable = M.initVariableSystem()

print(createVariable("x", "int", "field"))
print(createVariable("y", "int", "field"))
print(createVariable("a", "Array", "static"))
print(createVariable("z", "String", "field"))

return M
