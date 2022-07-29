local assets = {
	Asset( "ANIM", "anim/winky.zip" ),
	Asset( "ANIM", "anim/ghost_winky_build.zip" ),
}

local skins = {
	normal_skin = "winky",
	ghost_skin = "ghost_winky_build",
}

local base_prefab = "winky"

local tags = {"winky", "CHARACTER"}

return CreatePrefabSkin("winky_none", {
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,

	skip_item_gen = true,
	skip_giftable_gen = true,
	build_name_override = "winky", -- This is now needed for your SWAP_ICON to show in Self Inspect
})