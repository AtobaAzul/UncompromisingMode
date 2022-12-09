local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end

	local function TentacleRegrowth()
		return (
			_worldstate.isspring and TUNING.CACTUS_REGROWTH_TIME_SUMMER_MULT or -- Bloom.
			_worldstate.iswinter and TUNING.CACTUS_REGROWTH_TIME_WINTER_MULT or -- Hibernation.
			TUNING.CACTUS_REGROWTH_TIME_BASE_MULT -- Generic.
		) * (
			_worldstate.israining and TUNING.CACTUS_REGROWTH_RAINING_MULT or 1
		) * TUNING.CACTUS_REGROWTH_TIME_MULT
	end
	inst.components.regrowthmanager:SetRegrowthForType("tentacle", TUNING.CACTUS_REGROWTH_TIME, "tentacle", TentacleRegrowth)
end)