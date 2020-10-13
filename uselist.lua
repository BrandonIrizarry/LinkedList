local M = {}

local listCreator = require "list"
local list = listCreator.create()

list = list:cons("apple")
list = list:cons("orange")
list.signpost = "fruit stand"

list = list:cons("grape")
list = list:cons("papaya")

--print(list:length())

print(list.signpost)

-- make sure memory (lists) don't get shared across different function calls
local function pipe1 (alist)
	alist = alist:cons("raspberry")
	alist = alist:map(function (x) return x end)
end

local function pipe2 (alist)
	alist = alist:cons("lychee")
	alist =  alist:map(function (x) return x end)
end

--pipe1(list)
--pipe2(list)

local empty = listCreator.create()

local function pipe3 (alist)
	print(alist == empty)
end

local function pipe4 (alist)
	print(alist == empty)
	alist = alist:cons("more fruit")
	print(alist == empty)
end

pipe1(empty)
pipe2(empty)
print(empty)
print(pipe3(empty))
print(pipe4(empty))

print(list == list, list == list:copy())

local nicelist = list:copy()

print(nicelist.signpost)

print(nicelist)
print("after reversal:")
local backwards = nicelist:reverse()
print(backwards)
print(backwards:length() == nicelist:length())

-- need to make sure that an empty list doesn't become shared memory
--[[
local list2 = listCreator.create()

list2 = list2:cons("pineapple")
list2 = list2:cons("mango")
list2 = list2:cons("strawberry")

M.list2 = list2

function M.run ()
	local count = 0
	for node in pairs(list) do
		count = count + 1
		print(count)
		print(node)
	end

	print(list)
	print(list2)
	print(list:append(list2)
end
--]]
return M
