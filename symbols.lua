local List = require "list"

local function newClassVars ()
	local classvars = List.create()

	-- The field and static counts for the class-level trunk
	classvars.field = -1
	classvars.static = -1

	-- Make sure that fields and statics can't be added from within subroutine declarations, etc.
	-- Safeguard against reusing memory in a different subroutine declaration
	classvars.closed = {}

	-- augmented cons operation.
	function classvars:addVar (segment, datatype, name)
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
		return self:cons(variable)
	end


	function classvars:close (...)
		for i = 1, select("#", ...) do
			self.closed[select(i, ...)] = true
		end
	end

	return classvars
end


local function newLocalIndex (index)
	-- create and prepare a fork for each subroutine declaration
	local localIndex = index:fork()

	-- close static and field additions for this and all future local branches
	localIndex:close("static", "field")

	-- without the next line, 'closed' delegates back to the trunk, closing argument and var additions
	-- for this and all future local branches, where the latter trips a strange error for example
	-- when we reach the _second_ subroutine declaration with a nonempty argument list.
	localIndex.closed = {}

	localIndex.argument = -1
	localIndex.var = -1

	return localIndex
end

return {
	newClassVars = newClassVars,
	newLocalIndex = newLocalIndex
}
