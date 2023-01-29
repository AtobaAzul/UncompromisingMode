local env = env
GLOBAL.setfenv(1, GLOBAL)

local function testfortransformonload(inst)
    return TheWorld.state.isfullmoon
end

env.AddPrefabPostInit("flower", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("uncompromising_transformer")
    inst.components.uncompromising_transformer:SetTransformWorldEvent("isfullmoon", true)
    inst.components.uncompromising_transformer:SetRevertWorldEvent("isfullmoon", false)
    inst.components.uncompromising_transformer:SetOnLoadCheck(testfortransformonload)
    inst.components.uncompromising_transformer.transformPrefab = "flower_evil"
end)

env.AddPrefabPostInit("flower_evil", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("uncompromising_transformer")
end)