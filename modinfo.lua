name = "    Uncompromising Mode"
description = 
[[
󰀔 [ Version 1.0 : "Uncompromising Start" ]















							   ⬇Config⬇		 ⬇Infos⬇]]

author = "Uncompromising Team"
version = "1.0.0"

forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
hamlet_compatible = false

forge_compatible = false

all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
	"uncompromising",
}

priority = 10

game_modes =
{
	{
		name = "uncompromising_hardcore",
		label = "Hardcore",
		description = "Rollback is permanently disabled. No second chances.\n\n* Players leave a dead body upon death, which needs to be given a Telltale heart for ressurection.\n* Repair Touch Stones, attune effigies, and wear Life amulets to revive yourself.\n* If no living players remain, the world is deleted.",
		settings =
		{
			ghost_sanity_drain = true,
			portal_rez = false,
			level_type = "LEVELTYPE_FOREST",
			reset_time = { time = 10, loadingtime = 10 },
			hardcore = true
		},
	}
}

configuration_options =
{
	{
		name = "enable_knockback",
		label = "Knockback",
		hover = "Some creatures and bosses can now kick you out.",
		options =
		{
			{description = "Disabled", data = false},
			{description = "Enabled", data = true},
		},
		default = true,
	},
}