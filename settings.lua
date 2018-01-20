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
	{
		type = "bool-setting",
		name = "Noxys_Swimming-is-deep-swimmable",
		setting_type = "startup",
		default_value = true,
		order = "c"
	},
	-- Global
	-- Per user
})
