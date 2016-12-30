tunnels = {}

-- ----------------------------------------------------------------------------
-- Constants:

tunnels.PATH = minetest.get_modpath("tunnels")
local ROOMS_DISTANCE = 9
local BIRTHSTONE = "tunnels:stone"

local GEN_RADIUS = ROOMS_DISTANCE * 3 / 4

-- Load room registration function and some basic rooms
dofile(tunnels.PATH .. "/register_room.lua")

-- ----------------------------------------------------------------------------
-- Data definitions:

--[[
    Pos is {x = Integer, y = Integer, z = Integer}
    interp. a unique position in the world
    
    local p1 = {x=1,y=2,z=3}
    local p2 = {x=-231,y=0,z=13241}

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
	if name == BIRTHSTONE or name == "ignore" then
		return true
	else
		return false
	end
end

-- Pos -> Pos
-- Returns a random neighbour pos
local function get_neighbour(pos)

	local delta_x = 0
	local delta_y = 0
	local delta_z = 0
    local delta_m

    local coord_choice = math.random(3)
    local dir_choice = math.random(2)
    
    if coord_choice == 1 then
        delta_x = 1
    elseif coord_choice == 2 then
        delta_y = 1
    elseif coord_choice == 3 then
        delta_z = 1
    end
    
    if dir_choice == 1 then
        delta_m =  1
    else
        delta_m = -1
    end
    
    

	-- Finally, calculate the position
	local neighbour = {
		x = pos.x + delta_x * delta_m * ROOMS_DISTANCE,
		y = pos.y + delta_y * delta_m * ROOMS_DISTANCE,
		z = pos.z + delta_z * delta_m * ROOMS_DISTANCE}

	-- Return the result
	return neighbour
end

-- Pos -> Boolean
-- produce true if an entity is near given position
local function entity_near(pos)
    local all_objects = minetest.get_objects_inside_radius(pos, GEN_RADIUS)
    if all_objects == nil or next(all_objects) == nil then
        return false
    else
        return true
    end
end

assert (type(entity_near({
            x=math.random(200),
            y=math.random(200),
            z=math.random(200)})) == "boolean",
        "should return boolean")

-- Pos Integer Integer Integer -> Groups or false
-- produce groups at the given displacement from position, if fail, produce false

local function get_groups_at(pos, dx, dy, dz)
    local real_pos = {x = pos.x + dx * ROOMS_DISTANCE,
                      y = pos.y + dy * ROOMS_DISTANCE,
                      z = pos.z + dz * ROOMS_DISTANCE}
    local real_node = minetest.get_node(real_pos)
	if real_node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(real_pos, real_pos)
		real_node = minetest.get_node(real_pos)
	end
	local real_metadata = minetest.get_meta(real_node)
	local real_string = real_metadata:get_string("infotext")
	local real_groups = minetest.deserialize(real_string)
	
	if not nil == real_groups then
	    return real_groups.neightbours
	else
	    return real_groups
	end
end

-- Groups Groups -> Boolean
-- produce true if all of the subfields match

local function groups_match(grps1, grps2)
    if grps1 == nil or grps2 == nil then
        return true
    end

    -- rsf: Boolean; result so far accumulator
    local rsf
    local _,g1,g2
    for _,g1 in ipairs(grps1) do
        rsf = false
            for _,g2 in ipairs(grps2) do
                if g1 == g2 then
                    rsf = true
                end
            end
        if false == rsf then
            return false
        end
    end
    
    return true
end

-- Pos Integer Integer Integer -> Groups or nil
-- produce groups at the given displacement from position, if fail, produce false

local function get_walls_at(pos, dx, dy, dz)
    local real_pos = {x = pos.x + dx * ROOMS_DISTANCE,
                      y = pos.y + dy * ROOMS_DISTANCE,
                      z = pos.z + dz * ROOMS_DISTANCE}
    local real_node = minetest.get_node(real_pos)
	if real_node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(real_pos, real_pos)
		real_node = minetest.get_node(real_pos)
	end
	if not real_node.name == BIRTHSTONE then
	    return nil
	end
	local real_metadata = minetest.get_meta(real_pos)
	local real_string = real_metadata:get_string("infotext")
	local real_groups = minetest.deserialize(real_string)
	
	if "" == real_string then
	    return real_groups
	else
	    return real_groups.walls
	end
end

-- Groups Groups -> Boolean
-- produce true if all of the subfields match

local function walls_match(walls1, walls2, dx, dy, dz)
    if walls1 == nil or walls2 == nil then
        --print("case A")
        return true
    end
--[[
    print(minetest.serialize(walls1))
    print(dx)
    print(dy)
    print(dz)
    print(minetest.serialize(walls2))
    print(minetest.serialize(walls2[tostring(-dx + 0)]))
    print(minetest.serialize(walls2[tostring(-dx + 0)][tostring(-dy + 0)]))
--]]
    if nil == walls2[tostring(-1 * dx + 0)] then
        return true
    end
    if nil == walls2[tostring(-1 * dx + 0)][tostring(-1 * dy + 0)] then
        return true
    end
    
    if walls1 == walls2[tostring(-1 * dx + 0)][tostring(-1 * dy + 0)][tostring(-1 * dz + 0)] then
        --print("case B")
        return  true
    else
        return false
    end
end

local function walls_ok(peers, pos)
    local dx, dy, dz, a, b, c
    for dx,a in pairs(peers) do
        for dy,b in pairs(a) do
            for dz,groups in pairs(b) do
                local real_walls = get_walls_at(pos, dx, dy, dz)
                if not walls_match(groups, real_walls, dx, dy, dz) then
                    return false
                end
            end
        end
    end
    
    return true
end

local function groups_ok(peers, pos)
    local dx, dy, dz, a, b, c
    for dx,a in pairs(peers) do
        for dy,b in pairs(a) do
            for dz,groups in pairs(b) do
                local real_groups = get_groups_at(pos, dx, dy, dz)
                if not groups_match(groups, real_groups) then
                    return false
                end
            end
        end
    end
    
    return true
end

-- Tunnel Pos -> Boolean
-- produce true if a given tunnel can be placed at a given position
local function can_place(tunnel, pos)
    -- template from Tunnel and Pos and a call to for
    if walls_ok(tunnel.walls, pos) then-- and groups_ok(tunnel.neighbours, pos) then
        return true
    else
        return false
    end
end

-- Tunnels Pos -> Tunnels
-- filter tunnels that cannot be placed
local function filter_invalid_tunnels(tunnels, pos)
    -- template as call to for
    local _,tunnel
    -- rsf: Tunnels; result so far accumulator
    local rsf = {}
    for _,tunnel in ipairs(tunnels) do
        if can_place(tunnel, pos) then
            table.insert(rsf, tunnel)
        end
    end
    
    return rsf
end

--assert (filter_invalid_tunnels({}, {x=0,y=0,z=0}) == {})
--assert (filter_invalid_tunnels({}, {x=-21,y=33,z=22}) == {})

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
	    if not entity_near(pos) then
	        return
	    end
		local neighbour = get_neighbour(pos)
		if not is_pos_occupied(neighbour) then
		    local valid_tunnels = filter_invalid_tunnels(tunnels.registered_tunnels, neighbour)
		    if #valid_tunnels == 0 then
		        return
		    end
			--valid_tunnels[math.random(#valid_tunnels)].room_placing_function(neighbour)
			valid_tunnels[1].room_placing_function(neighbour)
			print(#valid_tunnels)
		end
	end,
})

