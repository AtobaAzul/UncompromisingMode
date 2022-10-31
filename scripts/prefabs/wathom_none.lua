local assets =
{
	Asset( "ANIM", "anim/wathom.zip" ),
	Asset( "ANIM", "anim/ghost_wathom_build.zip" ),
}

local skins =
{
	normal_skin = "wathom",
	ghost_skin = "ghost_wathom_build",
}

return CreatePrefabSkin("wathom_none",
{
	base_prefab = "wathom",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"WATHOM", "CHARACTER", "BASE"},
	build_name_override = "wathom",
	rarity = "Character",
})