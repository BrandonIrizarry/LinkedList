local function create ()
	local list = {}
	list.__index = list

	function list:__tostring ()
		local buffer = {}
		self:foreach(function (item) buffer[#buffer + 1] = item end)
		return table.concat(buffer, ",\n")
	end

	function list:cons (item)
		local node = {car = item, cdr = self}

		if self.root == self then
			self.forward = node
		else
			self.forward = false
		end

		node.__tostring = self.__tostring
		node.__index = node

		return setmetatable(node, self)
	end

	function list:foreach (fn)
		while self.cdr do
			fn(self.car)
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
			if fn(self.car) then return self end
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

	function list:append (alist)

	end

	local empty = {}
	empty.root = empty
	empty.__index = empty
	empty.__tostring = list.__tostring

	return setmetatable(empty, list)
end

local function p (x)
	print("---")
	print(x)
end

local list = create()
print(assert(not list.forward))
list2 = list:cons("a")
print(assert(list.forward))
list2:foreach(function (x) print(x) end)
p(list2:length())
list2 = list2:cons("petunia"):cons("rose")
p(list2)
assert(not list2.forward)


p(list2.root == list.root)
local flist2 = list2:fork()
--print(flist2 == list2)
p(flist2)

flist2 = flist2:cons("more"):cons("and more")
list2 = list2:cons("on this side"):cons("and then some")

p(flist2)
p(list2)

local a_node = flist2:find(function (x) return x == "a" end)
p(a_node.car)

local numbers = create()

for i = 1, 100 do
	numbers = numbers:cons(i)
end

p(numbers:fold(function (x, sum) return sum + x end, 0))

--[[
list1 = list:cons(1)
print(list)
print(list1)
list2 = list:cons("w")
print(list)
print(list1)
print(list2)
--]]
	--[=[

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
