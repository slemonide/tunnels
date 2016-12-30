tunnels = {}

-- ----------------------------------------------------------------------------
-- Constants:

tunnels.PATH = minetest.get_modpath("tunnels")
local ROOMS_DISTANCE = 9
local BIRTHSTONE = "tunnels:stone"

-- Load room registration function and some basic rooms
dofile(tunnels.PATH .. "/register_room.lua")

-- ----------------------------------------------------------------------------
-- Data definitions:

--[[
    Pos is {x = Integer, y = Integer, z = Integer}
    interp. a unique position in the world
    
    local p1 = {x=1,y=2,z=3}
    local p2 = {x=-231,0,13241}

    local function fn-for-pos(pos)
        ... pos.x pos.y pos.z
    end

--]]

-- ----------------------------------------------------------------------------
-- Functions:

-- Pos -> Boolean
-- Checks if a given position is already occupied
local function is_pos_occupied(pos)
	local name = minetest.get_node(pos).name
	if name == BIRTHSTONE then
		return true
	else
		return false
	end
end

-- Pos Boolean -> Pos
-- Returns a random neighbour pos
local function get_neighbour(pos, prefer_horizontal)

	-- Generate three random integers from -1 to 1 that represent possible
	-- neighbour's coordinates projections
	local delta_x = math.random(3) - 2
	local delta_y
	local delta_z = math.random(3) - 2

	if prefer_horizontal then
		if math.random(4) == 1 then
			delta_y = math.random(3) - 2
		else
			delta_y = 0
		end
	else
		delta_y = math.random(3) - 2
	end

	-- Finally, calculate the position
	local neighbour = {
		x = pos.x + delta_x * ROOMS_DISTANCE,
		y = pos.y + delta_y * ROOMS_DISTANCE,
		z = pos.z + delta_z * ROOMS_DISTANCE}

	-- Return the result
	return neighbour
end

-- Pos -> Boolean
-- produce true if an entity is near given position
local function entity-near(pos)
    ...
end

-- ----------------------------------------------------------------------------
-- Registrations

minetest.register_node("tunnels:light", {
    description = "Light",
    drawtype = "airlike",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    climbable = false,
    paramtype = "light",
    light_source = 12,
    sunlight_propagates = true,
    groups = {not_in_creative_inventory=1},
})

minetest.register_node(BIRTHSTONE, {
	description = "Tunnels Stone",
	tiles = {"default_stone.png^[colorize:green:120"},
	is_ground_content = true,
	groups = {cracky=3, stone=1, vein=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_abm({
	nodenames = {"tunnels:stone"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
	    if not entity-near(pos) then
	        return
	    end
		local neighbour = get_neighbour(pos, true)
		if not is_pos_occupied(neighbour) then
			tunnels.registered_tunnels[math.random(#tunnels.registered_tunnels)].room_placing_function(neighbour)
		end
	end,
})
