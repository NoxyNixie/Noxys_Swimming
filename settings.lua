data:extend({
	-- Startup
	{
		type = "double-setting",
		name = "Noxys_Swimming-swimming-speed",
		setting_type = "startup",
		minimum_value = 0.01,
		default_value = 0.35,
		maximum_value = 10,
		order = "a"
	},
	{
		type = "double-setting",
		name = "Noxys_Swimming-swimming-deep-speed",
		setting_type = "startup",
		minimum_value = 0.01,
		default_value = 0.25,
		maximum_value = 10,
		order = "b"
	},
	-- Global
	{
		type = "bool-setting",
		name = "Noxys_Swimming-enable-water-particles",
		setting_type = "runtime-global",
		default_value = true,
		order = "a"
	},
	-- Per user
})
