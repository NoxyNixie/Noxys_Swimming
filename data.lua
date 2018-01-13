local speed = settings.startup["Noxys_Swimming-swimming-speed"].value
for _,water in pairs{"water", "deepwater", "water-green", "deepwater-green"} do
	-- Collision mask
	local mask = data.raw.tile[water].collision_mask
	for i=#mask,1,-1 do
		if mask[i] == "player-layer" then
			table.remove(mask, i)
		end
	end
	-- Speed
	data.raw.tile[water].vehicle_friction_modifier = 6 / speed
	data.raw.tile[water].walking_speed_modifier    = speed
	-- Sound
	data.raw.tile[water].walking_sound =
		{
			{
				filename = "__Noxys_Swimming__/sounds/water-1.ogg",
				volume = 0.8
			},
			{
				filename = "__Noxys_Swimming__/sounds/water-2.ogg",
				volume = 0.8
			},
			{
				filename = "__Noxys_Swimming__/sounds/water-3.ogg",
				volume = 0.8
			}
		}
end

table.insert(data.raw.explosion["water-splash"].flags, "placeable-off-grid")
