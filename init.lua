local path = minetest.get_modpath("tunnels")
local ROOMS_DISTANCE = 9

-- I hate minetest's default lightning system
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

minetest.register_node("tunnels:stone", {
	description = "Tunnels Stone",
	tiles = {"default_stone.png^[colorize:green:120"},
	is_ground_content = true,
	groups = {cracky=3, stone=1, vein=1},
	drop = 'tunnels:stone',
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

-- Checks if a given position is already occupied
local function is_pos_occupied(pos)
	local name = minetest.get_node(pos).name
	if name == "tunnels:stone" then
		return true
	else
		return false
	end
end

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

minetest.register_abm({
	nodenames = {"tunnels:stone"},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local neighbour = get_neighbour(pos, true)
		if not is_pos_occupied(neighbour) then
			local schematic = path .. "/schems/basic.mts"
			local rotation = 0
			local replacements = {["air"] = "tunnels:light"}
			minetest.place_schematic(neighbour, schematic, rotation, replacements)
			local neighbour_meta = minetest.get_meta(neighbour)
			neighbour_meta:set_string("infotext", "pxnxpznz")
		end

		-- Inactivate the stem node (there is a 25% chance that it won't be inactivated)
--		if math.random(3) ~= 1 then
--			minetest.set_node(pos, {name = "tunnels:stone_inactivated"})
--			local meta = minetest.get_meta(pos)
--			meta:set_string("infotext", "Hello infotext!")
--		end
	end,
})
