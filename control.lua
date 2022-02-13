local rand = math.random

local waters = {
	clean = {["water"] = true , ["deepwater"] = true},
	green = {["water-green"] = true, ["deepwater-green"] = true},
	mud = {["water-mud"] = true, ["water-shallow"] = true}
}

script.on_configuration_changed(function()
	global.corpses = {}
end)

script.on_init(function()
	global.corpses = global.corpses or {}
end)

local function ripple_at_position(p, surface)
	local r = 2.5
	local area = {{p.x - r, p.y - r}, {p.x + r, p.y + r}} -- Do the math once
	local tilename = surface.get_tile(p).name
	if waters.clean[tilename] then
		if surface.count_tiles_filtered{area = area, name = "water", limit = 25} +
			surface.count_tiles_filtered{area = area, name = "deepwater", limit = 25} >= 25
		then
			surface.create_entity{name = "water-ripple" .. rand(1, 4) .. "-smoke", position = p}
      return true
		end
	elseif waters.green[tilename] then
		if surface.count_tiles_filtered{area = area, name = "water-green", limit = 25} +
			surface.count_tiles_filtered{area = area, name = "deepwater-green", limit = 25} >= 25
		then
			surface.create_entity{name = "greenwater-ripple" .. rand(1, 4) .. "-smoke", position = p}
      return true
		end
	elseif waters.mud[tilename] then
		if surface.count_tiles_filtered{area = area, name = "water-shallow", limit = 25} +
			surface.count_tiles_filtered{area = area, name = "water-mud", limit = 25} >= 25
		then
			surface.create_entity{name = "mudwater-ripple" .. rand(1, 4) .. "-smoke", position = p}
      return true
		end
	end
end

local function do_the_ripple(player)
	ripple_at_position(player.position, player.surface)
end

script.on_event(defines.events.on_tick, function(event)
	if event.tick % 60 == 0 then
		-- Ripple for players in water
		for _,player in pairs(game.connected_players) do
			if player.character and player.vehicle == nil then
				do_the_ripple(player)
			end
		end
	end
end)

script.on_event(defines.events.on_player_changed_position, function(e)
	local player = game.players[e.player_index]
	if player.character and player.vehicle == nil then
		do_the_ripple(player)
		if waters.clean[player.surface.get_tile(player.position).name] then
			player.surface.create_entity{name = "water-splash-smoke", position = player.position}
		elseif waters.green[player.surface.get_tile(player.position).name] then
			player.surface.create_entity{name = "greenwater-splash-smoke", position = player.position}
		end
	end
end)

script.on_event(defines.events.on_post_entity_died, function(event)
	for _,v in pairs(event.corpses) do
		if ripple_at_position(v.position, v.surface) then
      v.destroy()
    end
	end
end)
