local speed = settings.startup["Noxys_Swimming-swimming-speed"].value
local is_deep_swimmable = settings.startup["Noxys_Swimming-is-deep-swimmable"].value
local deepspeed = settings.startup["Noxys_Swimming-swimming-deep-speed"].value
local waters = {"water", "water-green"}
if is_deep_swimmable then
	table.insert(waters, "deepwater")
	table.insert(waters, "deepwater-green")
end

for _,water in pairs(waters) do
	-- Collision mask
	local mask = data.raw.tile[water].collision_mask
	for i=#mask,1,-1 do
		if mask[i] == "player-layer" then
			table.remove(mask, i)
		end
	end
	-- Sound
	data.raw.tile[water].walking_sound = {
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

-- Speed
for _,water in pairs{"water", "water-green"} do
	data.raw.tile[water].vehicle_friction_modifier = 6 / speed
	data.raw.tile[water].walking_speed_modifier    = speed
end
if is_deep_swimmable then
	for _,water in pairs{"deepwater", "deepwater-green"} do
		data.raw.tile[water].vehicle_friction_modifier = 6 / deepspeed
		data.raw.tile[water].walking_speed_modifier    = deepspeed
	end
end

data:extend{{
	type = "smoke-with-trigger",
	name = "water-splash-smoke",
	flags = {"not-on-map", "placeable-off-grid"},
	render_layer = "object",
	show_when_smoke_off = true,
	deviation = {0, 0},
	start_scale = 1,
	end_scale = 1,
	animation =
	{
		filename = "__base__/graphics/entity/water-splash/water-splash.png",
		priority = "extra-high",
		width = 92,
		height = 66,
		frame_count = 15,
		line_length = 5,
		shift = {-0.437, 0.5},
		animation_speed = 0.35
	},
	slow_down_factor = 0,
	affected_by_wind = false,
	cyclic = false,
	duration = 43,
	fade_away_duration = 0,
	spread_duration = 0,
	color = { r = 0.8, g = 0.8, b = 0.8 },
	action = nil,
	action_cooldown = 0
},{
	type = "smoke-with-trigger",
	name = "greenwater-splash-smoke",
	flags = {"not-on-map", "placeable-off-grid"},
	render_layer = "object",
	show_when_smoke_off = true,
	deviation = {0, 0},
	animation =
	{
		filename = "__base__/graphics/entity/water-splash/water-splash.png",
		priority = "extra-high",
		width = 92,
		height = 66,
		frame_count = 15,
		line_length = 5,
		shift = {-0.437, 0.5},
		animation_speed = 0.35
	},
	slow_down_factor = 0,
	affected_by_wind = false,
	cyclic = false,
	duration = 43,
	fade_away_duration = 0,
	spread_duration = 0,
	color = { r = 0.15, g = 0.6, b = 0.1 },
	action = nil,
	action_cooldown = 30
}}

local function make_ripple(prefix, nr, color)
	return {
		type = "smoke-with-trigger",
		name = prefix .. "-ripple" .. nr .. "-smoke",
		flags = {"not-on-map", "placeable-off-grid"},
		render_layer = "tile-transition",
		show_when_smoke_off = true,
		deviation = {0, 0},
		animation =
		{
			filename = "__Noxys_Swimming__/graphics/ripple" .. nr .. ".png",
			priority = "extra-high",
			width = 192,
			height = 128,
			frame_count = 48,
			line_length = 8,
			shift = {0, 0.5},
			animation_speed = 0.25
		},
		slow_down_factor = 0,
		affected_by_wind = false,
		cyclic = false,
		duration = 192,
		fade_away_duration = 0,
		spread_duration = 0,
		color = color,
		action = nil,
		action_cooldown = 0
	}
end

for i = 1, 4 do
	data:extend{make_ripple("water", i, {r = 0.3, g = 0.8, b = 0.9})}
end
for i = 1, 4 do
	data:extend{make_ripple("greenwater", i, {r = 0.1, g = 0.5, b = 0})}
end
