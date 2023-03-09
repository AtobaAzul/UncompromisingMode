local prefabs = {
	CreatePrefabSkin("wathom_none",
		{
			base_prefab = "wathom",
			type = "base",
			assets = {
				Asset("ANIM", "anim/wathom.zip"),
				Asset("ANIM", "anim/ghost_wathom_build.zip"),
			},
			skins = {
				normal_skin = "wathom",
				ghost_skin = "ghost_wathom_build",
			},
			skin_tags = { "WATHOM", "CHARACTER", "BASE" },
			build_name_override = "wathom",
			rarity = "Character",
		}),

}
--[[
table.insert(prefabs,
	CreatePrefabSkin("wathom_triumphant", { --The ID of your skin, e.g. “whimsy_none”, “ms_whimsy_victorian”
		assets = { --All the assets correlated to your skin
			Asset("ANIM", "anim/wathom_triumphant.zip"),
			Asset("ANIM", "anim/wathom_shadow_triumphant.zip"),
		},
		skins = { --The skin modes, generally there are usually two modes your character is in. Either the normal mode or ghost form(And most character skins don’t have unique ghost sprites!) However if you’re developing a character similar to Woodie or Wanda with different forms you can create skins for those custom forms! I may expand this tutorial to include how to do that.
			normal_skin = "wathom_triumphant",
			ghost_skin = "ghost_wathom_build",
		},

		base_prefab = "wathom", --The prefab you are going to skin
		build_name_override = "wathom_triumphant", --The build name we’re using to skin

		type = "base", --The type of skin this is, for characters only “base” really matters, but there are of course other types of skins such as item/structure skins that we will cover later in this tutorial.
		rarity = "ModMade", --The rarity of your skin. For the ‘_none’ skins it is the ‘Character’ rarity. Actual skins however will have you use either the ‘ModMade’ or ‘ModLocked’ rarities.

		--Misc parameters, these are not at all necessary
		--torso_untuck_builds = { "esctemplate", }, --All builds in this table will have their ‘torso’ symbols ‘tucked’ into their skirt!

		skin_tags = { "BASE", "WATHOM", "SHADOW" },
	})
)
]]


return unpack(prefabs)
