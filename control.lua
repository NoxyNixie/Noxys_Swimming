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

function on_player_changed_position(e)
	local player = game.players[e.player_index]
	if player.connected and player.character then
		--@todo: Vehicles should splash at the wheels
		--@todo: Maybe add/make water circles or a "wake".
		if is_clean_water_str(player.surface.get_tile(player.position).name) then
			player.surface.create_entity{name = "water-splash", position = player.position}
		elseif is_green_water_str(player.surface.get_tile(player.position).name) then
			player.surface.create_entity{name = "greenwater-splash", position = player.position}
		end
	end
end

function setup()
	if global.noxys_swimming then global.noxys_swimming = nil end
	if settings.global["Noxys_Swimming-enable-water-particles"].value then 
		script.on_event(defines.events.on_player_changed_position, on_player_changed_position)
	else
		script.on_event(defines.events.on_player_changed_position, nil)
	end
end

script.on_configuration_changed(function()
	setup()
end)

script.on_init(function()
	setup()
end)

setup()