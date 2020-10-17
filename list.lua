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
			if fn(self) then return self end
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

	local empty = {}
	empty.__index = empty
	empty.__tostring = list.__tostring
	empty.root = empty

	function list:first ()
		return self:find(function (node) return node.cdr == empty end)
	end

	function list:append (alist)
		local first = alist:first()

		first.cdr = self
	end

	return setmetatable(empty, list)
end

local function p (...)
	print("---")
	print(...)
end

--[[
local list = create()
list2 = list:cons("a")
list2:foreach(function (x) print(x) end)
p(list2:length())
list2 = list2:cons("petunia"):cons("rose")
p(list2)


p(list2.root == list.root)
local flist2 = list2:fork()
--print(flist2 == list2)
p(flist2)

flist2 = flist2:cons("more"):cons("and more")
list2 = list2:cons("on this side"):cons("and then some")

p(flist2)
p(list2)

local a_node = flist2:find(function (x) return x.car == "a" end)
p(a_node.car)

local numbers = create()

for i = 1, 100 do
	numbers = numbers:cons(i)
end

p(numbers:fold(function (x, sum) return sum + x end, 0))

p(numbers:first().car)

local bigger = create()

for i = 101, 105 do
	bigger = bigger:cons(i)
end

p(bigger)
p(list2)

bigger:append(list2)

p(list2, list2:length())
--]]
return {create = create}
