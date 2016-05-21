--[[
	Room registration function.
	Takes in:
		* Room placing function
		* Desired neighbours in the form of a table:
			[x][y][z] = {"basic", "group1", "group2", ..., "groupN"}
--]]
function tunnels.register_room(neighbours, room_placing_function)

end

-- Adds neighbours to the neighbours table
--[[
	neighbours -- a table, containing all previous neighbours
	pos -- relative position of a desired neighbour
	groups -- groups of the desired neighbour
--]]
function tunnels.add_neighbour(neighbours, pos, groups)
	if not neighbours[pos.x] then
		neighbours[pos.x] = {}
	end

	if not neighbours[pos.x][pos.y] then
		neighbours[pos.x][pos.y] = {}
	end

	if neighbours[pos.x][pos.y][pos.z] then
		print("ERROR: Neighbour is already registered!")
		return
	end

	neighbours[pos.x][pos.y][pos.z] = groups
end


-- An example of room registration
local neighbours = {}

tunnels.add_neighbour(neighbours, {1, 0, 0}, {"basic"})
tunnels.add_neighbour(neighbours, {-1, 0, 0}, {"basic"})
tunnels.add_neighbour(neighbours, {0, 0, 1}, {"basic"})
tunnels.add_neighbour(neighbours, {1, 0, -1}, {"basic"})

tunnels.register_room(neighbours, room_placing_function)
