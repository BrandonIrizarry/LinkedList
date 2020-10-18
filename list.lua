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
		if not self.cdr then
			error("Empty list can't fork.", 2)
		end

		return self.cdr:cons(self.car)
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
		self.root.cdr = alist
		setmetatable(self.root, alist)
	end

	local empty = {}
	empty.__index = empty
	empty.__tostring = list.__tostring
	empty.root = empty

	return setmetatable(empty, list)
end

return {create = create}
