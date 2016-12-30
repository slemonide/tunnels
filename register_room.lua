-- ----------------------------------------------------------------------------
-- Data definitions:
tunnels.registered_tunnels = {}
-- Tunnels is (tableof Tunnel)

-- ----------------------------------------------------------------------------
-- Functions:

--[[
	Room registration function.
	Takes in:
		* Desired neighbours in the form of a table:
			[x][y][z] = {"basic", "group1", "group2", ..., "groupN"}
	    * Walls/passages in the form of a table:
	        [x][y][z] = true represents a passage
	        [x][y][z] = false represents a wall
		* Room placing function
--]]
function tunnels.register_room(neighbours, walls, room_placing_function)
	-- Pack all the data into a box
	local box = {}
	box.neighbours = neighbours
	box.walls = walls
	box.room_placing_function = room_placing_function

	table.insert(tunnels.registered_tunnels, box)
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

-- Adds connections to the neighbours table
--[[
	connections -- a table, containing all previous connections
	pos -- relative position of a desired neighbour
	mode -- true means connect, false means don't connect
--]]
-- Just a temporary storage
function tunnels.add_wall(connections, pos, mode)

	if not connections[tostring(pos.x)] then
		connections[tostring(pos.x)] = {}
	end

	if not connections[tostring(pos.x)][tostring(pos.y)] then
		connections[tostring(pos.x)][tostring(pos.y)] = {}
	end

	connections[tostring(pos.x)][tostring(pos.y)][tostring(pos.z)] = mode
end

-- ----------------------------------------------------------------------------
-- Registrations:
--[[
-- An example of room registration
-- A room with 4 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y = 0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y = 0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y = 0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y = 0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls,room_placing_function)

-- A room with 4 horizontal exits and a downwards ladder
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y = -1, z =  0}, {"basic", "ladder"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X_down.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 4 horizontal exits and an upwards ladder
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  1, z =  0}, {"basic", "ladder"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_X_up.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 3 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_T_north.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 3 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_T_east.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 3 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_T_west.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 3 horizontal exits
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_T_south.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)


-- A room with 1 exit
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_end_south.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 1 exit
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_end_east.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 1 exit
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_end_north.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 1 exit
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_end_west.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)
--]]
-- A room with 2 exits, tunnel
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_I_north.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 2 exits, tunnel
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_I_west.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)
--[[
-- A room with 2 exits, L-sided
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_L_north_east.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 2 exits, L-sided
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, false)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_L_north_west.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 2 exits, L-sided
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_L_south_east.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)

-- A room with 2 exits, L-sided
tunnels.neighbours = {}
tunnels.add_neighbour(tunnels.neighbours, {x =  1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x = -1, y =  0, z =  0}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z =  1}, {"basic"})
tunnels.add_neighbour(tunnels.neighbours, {x =  0, y =  0, z = -1}, {"basic"})

tunnels.walls = {}
tunnels.add_wall(tunnels.walls, {x =  1, y =  0, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x = -1, y =  0, z =  0}, true)
tunnels.add_wall(tunnels.walls, {x =  0, y =  1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y = -1, z =  0}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z =  1}, false)
tunnels.add_wall(tunnels.walls, {x =  0, y =  0, z = -1}, true)

local room_placing_function = function(neighbour)
	local schematic = tunnels.PATH .. "/schems/basic_L_south_west.mts"
	local rotation = 0
	local replacements = {["air"] = "tunnels:light"}
	minetest.place_schematic(neighbour, schematic, rotation, replacements)
	minetest.set_node(neighbour, {name = "tunnels:stone"})
	local neighbour_meta = minetest.get_meta(neighbour)
	local mail = {neighbours = tunnels.neighbours, walls = tunnels.walls}
	neighbour_meta:set_string("infotext", minetest.serialize(mail))
end

tunnels.register_room(tunnels.neighbours, tunnels.walls, room_placing_function)
--]]
