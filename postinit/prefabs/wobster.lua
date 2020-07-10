local env = env
GLOBAL.setfenv(1, GLOBAL)

	local NEWWOBSTER_FISH_DEF =
{
    prefab = "wobster_sheller",
    loot = {"wobster_sheller_dead"},
    lures = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
    weight_min = 153.67,
    weight_max = 307.34,
}



env.AddPrefabPostInit("wobster_sheller", function(inst)
	if not TheWorld.ismastersim then
		return
	end

inst.fish_def = NEWWOBSTER_FISH_DEF

--return inst
end)