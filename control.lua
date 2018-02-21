local floor = math.floor
local rand = math.random

local waters = {
	clean = {["water"] = true , ["deepwater"] = true},
	green = {["water-green"] = true, ["deepwater-green"] = true}
}

script.on_configuration_changed(function()
	global.corpses = {}
end)

script.on_init(function()
	global.corpses = global.corpses or {}
end)

local function do_the_ripple(player)
	local r = 2.5
	local p = player.position
	local surface = player.surface
	local area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}} -- Do the math once
	if waters.clean[surface.get_tile(p).name] then
		if surface.count_tiles_filtered{area = area, name = "water", limit = 25} +
			surface.count_tiles_filtered{area = area, name = "deepwater", limit = 25} >= 25
		then
			surface.create_entity{name = "water-ripple" .. rand(1, 4) .. "-smoke", position = p}
		end
	elseif waters.green[surface.get_tile(p).name] then
		if surface.count_tiles_filtered{area = area, name = "water-green", limit = 25} +
			surface.count_tiles_filtered{area = area, name = "deepwater-green", limit = 25} >= 25
		then
			surface.create_entity{name = "greenwater-ripple" .. rand(1, 4) .. "-smoke", position = p}
		end
	end
end

script.on_event(defines.events.on_tick, function(event)
	event.tick = event.tick + 1
	if event.tick % 30 == 0 then
		-- Clean up corpses in water
		local r = 1
		for _,v in pairs(global.corpses) do
			for _, corpse in pairs(game.surfaces[v[1]].find_entities_filtered{area = {{v[2] - r, v[3] - r}, {v[2] + r, v[3] + r}}, type = "corpse"}) do
				--todo: maybe I can change the fade times to be short instead of just destroying them.
				--Note to Nexela add corpse::time_to_live read/write
				corpse.destroy()
			end
		end
		global.corpses = {}
	end
	if event.tick % 60 == 0 then
		-- Ripple for players in water
		for _,player in pairs(game.connected_players) do
			if player.character then
				do_the_ripple(player)
			end
		end
	end
end)

script.on_event(defines.events.on_player_changed_position, function(e)
	local player = game.players[e.player_index]
	if player.character then
		do_the_ripple(player)
		--@todo: Vehicles should splash at the wheels
		if waters.clean[player.surface.get_tile(player.position).name] then
			player.surface.create_entity{name = "water-splash-smoke", position = player.position}
		elseif waters.green[player.surface.get_tile(player.position).name] then
			player.surface.create_entity{name = "greenwater-splash-smoke", position = player.position}
		end
	end
end)

-- Mark entities that die in water for cleaning up their corpses later
script.on_event(defines.events.on_entity_died, function(event)
	if event.entity and event.entity.position and event.entity.surface then
		local surface = event.entity.surface
		local p = event.entity.position
		local tile_name = surface.get_tile(p).name
		if waters.clean[tile_name] or waters.green[tile_name] then
			global.corpses[surface.index .. "," .. floor(p.x) .. "," .. floor(p.y)] = {surface.index, floor(p.x), floor(p.y)}
		end
	end
end)
