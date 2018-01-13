local speed = settings.startup["Noxys_Swimming-swimming-speed"].value
local deepspeed = settings.startup["Noxys_Swimming-swimming-deep-speed"].value

for _,water in pairs{"water", "deepwater", "water-green", "deepwater-green"} do
	-- Collision mask
	local mask = data.raw.tile[water].collision_mask
	for i=#mask,1,-1 do
		if mask[i] == "player-layer" then
			table.remove(mask, i)
		end
	end
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

for _,water in pairs{"water", "water-green"} do
	-- Speed
	data.raw.tile[water].vehicle_friction_modifier = 6 / speed
	data.raw.tile[water].walking_speed_modifier    = speed
end

for _,water in pairs{"deepwater", "deepwater-green"} do
	-- Speed
	data.raw.tile[water].vehicle_friction_modifier = 6 / deepspeed
	data.raw.tile[water].walking_speed_modifier    = deepspeed
end

data:extend{
	{
		type = "explosion",
		name = "greenwater-splash",
		flags = {"not-on-map"},
		animations =
		{
			{
				filename = "__Noxys_Swimming__/graphics/greenwater-splash.png",
				priority = "extra-high",
				width = 92,
				height = 66,
				frame_count = 15,
				line_length = 5,
				shift = {-0.437, 0.5},
				animation_speed = 0.35
			}
		}
	}
}

table.insert(data.raw.explosion["water-splash"].flags, "placeable-off-grid")
