-- creates a new inheritance chain...
local function create ()
	-- root of the current list
	local list = {}
	local list = setmetatable({}, {__tostring = function ()
		return "<empty>"
	end,

	-- the root node must still have a cdr field
	cdr = function (self)
		return nil
	end})

	list.__index = list
	list.root = list

	function list:__tostring ()
		local buffer = {}
		self:foreach(function (item) buffer[#buffer + 1] = item end)
		return table.concat(buffer, ",\n")
	end

	function list:cons (item)
		return setmetatable({car = item, __tostring = self.__tostring}, self)
	end

	function list:cdr ()
		return getmetatable(self)
	end

	function list:foreach (fn)
		repeat
			fn(self.car)
			local cdr = self:cdr()
			self = cdr
		until not cdr
	end

	return list
end

local list = create()
print(list)

list1 = list:cons(1)
print(list)
print(list1)
list2 = list:cons("w")
print(list)
print(list1)
print(list2)

	--[=[

	function list:foreach (fn)
		while self.cdr do
			fn(self.car)
			self = self.cdr
		end
	end

-- Print a branch
function list:__tostring ()
	local buffer = {}
	self:foreach(function (item) buffer[#buffer + 1] = item end)
	return table.concat(buffer, ",\n")
end

function list:fork ()
	local item = self.car
	return self.cdr:cons(item)
end

function list:fold (fn, initial)
	local result = initial

	while self.cdr do
		result = fn(result, self.car)
		self = self.cdr
	end

	return result
end

function list:length ()
	return self:fold(function (sum) return sum + 1 end, 0)
end

function list:find (fn)
	while self.cdr do
		if fn(self.car) then
			return self.car
		end
	end
end

-- Append 'alist' to the tip of the branch 'list' currently references
function list:append (alist)
	local root = alist:root()

	if list:root() == root then
		error("Cannot append one branch onto another", 2)
	end


end

local function create ()
	local empty = {}
	empty.__index = empty
	empty.__tostring = list.__tostring
	empty.root = empty

	-- Add a node to the current branch
	function empty:cons (item)
		return setmetatable({car = item, cdr = self}, empty)
	end

	return setmetatable(empty, list)
end

return {create = create}
--]=]
