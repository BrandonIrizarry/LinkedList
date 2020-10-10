local M = {}

-- to enforce that clients can't use the raw-methods' table, we do _this_.
function M.create ()
	local list = {}
	list.__index = list

	-- non-destructive
	function list:cons (item)
		self.__index = self
		return setmetatable({car = item, cdr = self, __tostring = self.__tostring,
			__pairs = self.__pairs}, self)
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
			return result..","..tostring(item)
		end, "list:")
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
	function list:nconc (alist)
		local orig = self

		while self.cdr.cdr do
			self = self.cdr
		end

		self.cdr = alist

		return orig
	end

	-- Bootstrap __tostring for all future conses that occur off of
	-- this instance of 'list'
	return setmetatable({__tostring = list.__tostring, __pairs = list.__pairs}, list)
end

return M
