return CreatePrefabSkin("wixie_none", {
	base_prefab = "wixie", 
	build_name_override = "wixie", -- This is now needed for your SWAP_ICON to show in Self Inspect
	type = "base",
	rarity = "Character",
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "WIXIE" },
	skins = {
		normal_skin = "wixie",
		
		ghost_skin = "ghost_wixie_build",
	}, 
	assets = {
		Asset( "ANIM", "anim/wixie.zip" ),
		Asset( "ANIM", "anim/ghost_wixie_build.zip" ),
	},
})