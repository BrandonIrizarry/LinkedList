local M = {}

local listCreator = require "list"
local list = listCreator.create()

list = list:cons("apple")
list = list:cons("orange")
list = list:cons("grape")

M.list = list

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

return M
