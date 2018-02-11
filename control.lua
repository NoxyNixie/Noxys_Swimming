local floor = math.floor

local function is_clean_water_str(str)
	for _,r in pairs{"water", "deepwater"} do
		if str == r then return true end
	end
	return false
end

local function is_green_water_str(str)
	for _,r in pairs{"water-green", "deepwater-green"} do
		if str == r then return true end
	end
	return false
end

local function is_water_str(str)
	for _,r in pairs{"water", "deepwater", "water-green", "deepwater-green"} do
		if str == r then return true end
	end
	return false
end

local function initialize()
	global.corpses = {}
	global.rng     = game.create_random_generator()
end

script.on_configuration_changed(function()
	initialize()
end)

script.on_init(function()
	initialize()
end)

local function do_the_ripple(player)
	local r = 2.5
	local p = player.position
	local surface = player.surface
	if is_clean_water_str(surface.get_tile(p).name) then
		if surface.count_tiles_filtered{area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}, name = "water", limit = 25} +
			surface.count_tiles_filtered{area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}, name = "deepwater", limit = 25} >= 25
		then
			surface.create_entity{name = "water-ripple" .. global.rng(1, 4) .. "-smoke", position = p}
		end
	elseif is_green_water_str(surface.get_tile(p).name) then
		if surface.count_tiles_filtered{area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}, name = "water-green", limit = 25} +
			surface.count_tiles_filtered{area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}}, name = "deepwater-green", limit = 25} >= 25
		then
			surface.create_entity{name = "greenwater-ripple" .. global.rng(1, 4) .. "-smoke", position = p}
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	event.tick = event.tick + 1
	if event.tick % 30 == 0 then
		-- Clean up corpses in water
		local r = 1
		for _,v in pairs(global.corpses) do
			local corpses = game.surfaces[v[1]].find_entities_filtered{area = {{v[2] - r, v[3] - r}, {v[2] + r, v[3] + r}}, type = "corpse"}
			if corpses then
				for i=#corpses,1,-1 do
					--todo: maybe I can change the fade times to be short instead of just destroying them.
					corpses[i].destroy()
				end
			end
		end
		global.corpses = {}
	end
	if event.tick % 60 == 0 then
		-- Ripple for players in water
		for _,player in pairs(game.players) do
			if player.connected and player.character then
				do_the_ripple(player)
			end
		end
	end
end)

script.on_event(defines.events.on_player_changed_position, function(e)
	local player = game.players[e.player_index]
	if player.connected and player.character then
		do_the_ripple(player)
		--@todo: Vehicles should splash at the wheels
		if is_clean_water_str(player.surface.get_tile(player.position).name) then
			player.surface.create_entity{name = "water-splash-smoke", position = player.position}
		elseif is_green_water_str(player.surface.get_tile(player.position).name) then
			player.surface.create_entity{name = "greenwater-splash-smoke", position = player.position}
		end
	end
end)

-- Mark entities that die in water for cleaning up their corpses later
script.on_event(defines.events.on_entity_died, function(event)
	if event.entity and event.entity.position and event.entity.surface then
		local surface = event.entity.surface
		local p = event.entity.position
		if is_water_str(surface.get_tile(p).name) then
			global.corpses[surface.index .. "," .. floor(p.x) .. "," .. floor(p.y)] = {surface.index, floor(p.x), floor(p.y)}
		end
	end
end)
