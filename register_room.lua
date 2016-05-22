--[[
	Room registration function.
	Takes in:
		* Room placing function
		* Desired neighbours in the form of a table:
			[x][y][z] = {"basic", "group1", "group2", ..., "groupN"}
--]]
tunnels.registered_tunnels = {}
function tunnels.register_room(neighbours, room_placing_function)
	-- Pack all the data into a box
	local box = {}
	box.neighbours = neighbours
	box.room_placing_function = room_placing_function

	table.insert(tunnels.registered_tunnels, box)
	-- DEBUG
	--print(minetest.serialize(tunnels.registered_tunnels))
end

-- Adds neighbours to the neighbours table
--[[
	neighbours -- a table, containing all previous neighbours
	pos -- relative position of a desired neighbour
	groups -- groups of the desired neighbour
--]]
-- Just a temporary storage
function tunnels.add_neighbour(neighbours, pos, groups)

	if not neighbours[tostring(pos.x)] then
		neighbours[tostring(pos.x)] = {}
	end

	if not neighbours[tostring(pos.x)][tostring(pos.y)] then
		neighbours[tostring(pos.x)][tostring(pos.y)] = {}
	end

	neighbours[tostring(pos.x)][tostring(pos.y)][tostring(pos.z)] = groups
end


-- An example of room registration
-- A room with 4 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 0, y = 0, z = 1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = -1}, {"basic"})

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	neighbour_meta:set_string("infotext", minetest.serialize(tunnels.neighbours))
end

tunnels.register_room(tunnels.neighbours, room_placing_function)

-- A room with 4 horizontal exits and a downwards ladder
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 0, y = 0, z = 1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = -1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 0, y = -1, z = 0}, {"basic"})

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X_down.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	neighbour_meta:set_string("infotext", minetest.serialize(tunnels.neighbours))
end

tunnels.register_room(tunnels.neighbours, room_placing_function)

-- A room with 4 horizontal exits and an upwards ladder
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y = 0, z = 0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 0, y = 0, z = 1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 1, y = 0, z = -1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = 0, y = -1, z = 0}, {"basic", "ladder"})

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X_up.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	neighbour_meta:set_string("infotext", minetest.serialize(tunnels.neighbours))
end

tunnels.register_room(tunnels.neighbours, room_placing_function)

