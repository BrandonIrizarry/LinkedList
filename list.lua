local function create ()
	local list = {}
	list.__index = list

	function list:__tostring ()
		local buffer = {}
		self:foreach(function (item) buffer[#buffer + 1] = tostring(item) end)
		return table.concat(buffer, ",\n")
	end

	function list:cons (item)
		local node = {car = item, cdr = self}
		node.__tostring = self.__tostring
		node.__index = node

		return setmetatable(node, self)
	end

	function list:foreach (fn)
		while self.cdr do
			if self.car then fn(self.car) end
			self = self.cdr
		end
	end

	function list:length ()
		local count = 0
		self:foreach(function () count = count + 1 end)
		return count
	end

	function list:fork ()
		-- being able to fork the empty list becomes important if a Jack class doesn't declare
		-- any class variables. We need separate branches for separate subroutine declarations,
		-- but there's no trunk - no common set of class variables.
		if not self.cdr then
			local empty = {}
			empty.__index = empty -- unique to this node
			empty.__tostring = list.__tostring
			empty.__root = empty -- unique to this node

			for name, value in pairs(self) do
				if name:sub(1,2) ~= "__" then
					empty[name] = value
				end
			end

			return setmetatable(empty, list)
		end

		local sibling = self.cdr:cons(self.car) -- 'car' is nil here

		-- share self's metadata with sibling
		for name, value in pairs(self) do
			if name:sub(1,2) ~= "__" then -- e.g. copying '__index' wrongly diverts metatable lookups to 'self'
				sibling[name] = value
			end
		end

		return sibling
	end

	function list:find (fn)
		while self.cdr do
			if fn(self.car) then return self.car end
			self = self.cdr
		end
	end

	function list:fold (fn, initial)
		local result = initial

		while self.cdr do
			result = fn(result, self.car)
			self = self.cdr
		end

		return result
	end

	-- Doesn't create new node
	function list:atop (alist)
		self.__root.cdr = alist
		setmetatable(self.__root, alist)
	end

	local empty = {}
	empty.__index = empty
	empty.__tostring = list.__tostring
	empty.__root = empty

	return setmetatable(empty, list)
end

return {create = create}
