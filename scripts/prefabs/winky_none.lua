return CreatePrefabSkin("winky_none", {
	base_prefab = "winky", 
	build_name_override = "winky", -- This is now needed for your SWAP_ICON to show in Self Inspect
	type = "base",
	rarity = "Character",
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "WINKY" },
	skins = {
		normal_skin = "winky",
		
		ghost_skin = "ghost_winky_build",
	}, 
	assets = {
		Asset( "ANIM", "anim/winky.zip" ),
		Asset( "ANIM", "anim/ghost_winky_build.zip" ),
	},
})