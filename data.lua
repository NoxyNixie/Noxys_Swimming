local speed = settings.startup["Noxys_Swimming-swimming-speed"].value
for _,water in pairs{"water", "deepwater", "water-green", "deepwater-green"} do
	local mask = data.raw.tile[water].collision_mask
	for i=#mask,1,-1 do
		if mask[i] == "player-layer" then
			table.remove(mask, i)
		end
	end
	data.raw.tile[water].vehicle_friction_modifier = 6 / speed
	data.raw.tile[water].walking_speed_modifier    = speed
end

table.insert(data.raw.explosion["water-splash"].flags, "placeable-off-grid")
