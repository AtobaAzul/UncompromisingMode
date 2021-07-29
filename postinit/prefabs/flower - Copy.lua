local env = env
GLOBAL.setfenv(1, GLOBAL)

local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end

env.AddPrefabPostInit("flower", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("transformer")
    inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    inst.components.transformer.transformPrefab = "flower_evil"
	
--return inst
end)

env.AddPrefabPostInit("flower_evil", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("transformer")
end)
env.AddPrefabPostInit("flower_planted", function(inst)
	if not TheWorld.ismastersim then
		return
	end
--return inst
end)