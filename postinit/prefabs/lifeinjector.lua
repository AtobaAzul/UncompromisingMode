local env = env
GLOBAL.setfenv(1, GLOBAL)



local function OnUse(inst, target)
	if target.components.debuffable ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.debuffable:AddDebuff("lifeinjector_redcap_buff", "lifeinjector_redcap_buff")
	end
end


env.AddPrefabPostInit("lifeinjector", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:AddComponent("healer")
	inst:RemoveComponent("maxhealer")
	inst.components.healer.onhealfn = OnUse
end)
