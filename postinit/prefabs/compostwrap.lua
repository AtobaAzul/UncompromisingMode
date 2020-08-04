local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("compostwrap", function(inst)
	
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.fertilizer ~= nil then
		inst.components.fertilizer:SetHealingAmount(TUNING.HEALING_MEDSMALL)
		inst.components.fertilizer:SetBuff(true)
	end

end)