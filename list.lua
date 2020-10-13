local M = {}

-- to enforce that clients can't use the raw-methods' table, we wrap the object in
-- a 'create' method.
function M.create ()
	local list = {}
	list.__index = list

	-- non-destructive
	function list:cons (item)
		self.__index = self
		local node = {car = item, cdr = self, __tostring = self.__tostring, __pairs = self.__pairs}
		return setmetatable(node, self)
	end

	function list:copy ()
		return self.cdr:cons(self.car)
	end

	-- non-destructive
	function list:map (fn)
		if not self.cdr then return self end

		local newCdr = self.cdr:map(fn)
		return newCdr:cons(fn(self.car))
	end

	-- non-destructive ('fn' is called for its side effect)
	function list:foreach (fn)
		while self.cdr do
			fn(self.car)
			self = self.cdr
		end
	end

	-- non-destructive
	function list:fold (fn, initial)
		local result = initial

		while self.cdr do
			result = fn(result, self.car)
			self = self.cdr
		end

		return result
	end

	-- non-destructive
	function list:__tostring ()
		return self:fold(function (result, item)
			return result..","..tostring(item).."\n"
		end, "")
	end

	-- non-destructive
	-- the 'head' is the first car of the list to be iterated over
	-- see PIL 4, p. 176
	function list.getnext (head, node)
		if not node then
			return head
		else
			return node.cdr
		end
	end

	function list:__pairs ()
		return self.getnext, self, nil
	end

	-- non-destructive
	function list:filter (fn)
		if not self.cdr then return self end

		local newCdr = self.cdr:filter(fn)

		if fn(self.car) then
			return newCdr:cons(self.car)
		else
			return newCdr
		end
	end

	-- non-destructive append
	-- appends alist to the end of self
	function list:append (alist)
		if not self.cdr then
			return alist
		elseif not alist.cdr then
			return self
		else
			local newCdr = self.cdr:append(alist)
			return newCdr:cons(self.car)
		end
	end

	-- append alist to the end of self
	-- destructive
	--[[
	function list:nconc (alist)
		local orig = self

		while self.cdr.cdr do
			self = self.cdr
		end

		self.cdr = alist

		return orig
	end
	--]]

	-- Return the first element satisfying the predicate
	-- non-destructive
	function list:find (fn)
		for node in pairs(self) do
			if fn(node.car) then
				return node.car
			end
		end

		return nil
	end

	function list:length ()
		local count = 0

		for node in pairs(self) do
			count = count + 1
		end

		return count - 1 -- offset for the root
	end

	-- Bootstrap __tostring for all future conses that occur off of
	-- this instance of 'list'
	return setmetatable({__tostring = list.__tostring, __pairs = list.__pairs}, list)
end

return M
