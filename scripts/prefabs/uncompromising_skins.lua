local prefs = {}

--require("uncompprefabskin")

table.insert(prefs, CreatePrefabSkin("ms_hat_plaguemask_formal",
{
	assets = {
		Asset("ANIM", "anim/hat_plaguemask_formal.zip"),
	},
	base_prefab = "plaguemask",
	build_name_override = "hat_plaguemask_formal",
	type = "item",
	rarity = "ModMade",
	skin_tags = {"CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_feather_frock_fancy",
{
	assets = {
		Asset("ANIM", "anim/featherfrock_fancy_ground.zip"),
	},
	base_prefab = "feather_frock",
	build_name_override = "featherfrock_fancy_ground",
	type = "item",
	rarity = "ModMade",
	skin_tags = {},
}))

table.insert(prefs, CreatePrefabSkin("ms_twisted_antler",
{
	assets = {
		Asset("ANIM", "anim/twisted_antler.zip"),
	},
	base_prefab = "cursed_antler",
	build_name_override = "twisted_antler",
	type = "item",
	rarity = "ModMade",
	skin_tags = {},
}))

table.insert(prefs, CreatePrefabSkin("ms_ancient_amulet_red_demoneye",
{
	assets = {
		Asset("ANIM", "anim/ancient_amulet_red_demoneye.zip"),
	},
	base_prefab = "ancient_amulet_red",
	build_name_override = "ancient_amulet_red_demoneye",
	type = "item",
	rarity = "ModMade",
	skin_tags = {"CRAFTABLE"},
}))

return unpack(prefs)