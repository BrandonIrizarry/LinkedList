local function create ()
	local printer = {}
	printer.__tostring = function (l)
		return ""
	end

	local list = setmetatable({}, printer)

	list.__index = list

	function list:__tostring ()
		local buffer = {}

		self:foreach(function (item)
			buffer[#buffer + 1] = tostring(item)
		end)

		return table.concat(buffer, ",\n")
	end

	function list:cdr ()
		local mt = getmetatable(self)
		if mt == printer then return nil end -- at 'list', no parent

		return mt
	end

	function list:foreach (fn)
		while true do
			local c = self:cdr()
			if not c then break end -- at parent
			if self.car then fn(self.car) end
			self = c
		end
	end

	function list:cons (item)
		local node = {car = item}
		node.__tostring = self.__tostring
		node.__index = node

		return setmetatable(node, self)
	end

	function list:fork ()
		local newCdr = self:cdr()

		if newCdr then
			return newCdr:cons(self.car)
		else
			print("in fork: no cdr")
			return self:cons(false)
		end
	end

	function list:find (fn)
		while selfcdr do
			if fn(self.car) then return self.car end
			self = self.cdr
		end
	end

	function list:fold (fn, initial)
		local result = initial

		while true do
			local c = self:cdr()
			if not c then break end -- at parent
			if self.car then result = fn(result, self.car) end
			self = c
		end

		return result
	end

	return list
end

return {create = create}

--[[
--tests
local list = create()
local menu = {"venison", "pork chops"}

list.food = menu[2]
local list2 = list:fork()
local list3 = list:fork()
assert(list2.food == menu[2])
assert(list3.food == menu[2])
list3 = list3:cons("venison")
print("list 3:")
print(list3)
print("list 2:")
print(list2)
list4 = list3:fork()
print("list 4:")

local list = create():cons(3):cons(4):cons(5):fork():cons(6)
print(list:fold(function (sum, x) return sum + x end, 0))

]]

