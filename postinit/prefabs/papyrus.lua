local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function BlowThatNose(inst, noseblower)
	if noseblower.components.hayfever and noseblower.components.hayfever.enabled then
		noseblower.components.hayfever:SetNextSneezeTime(30)
		if inst.components.stackable ~= nil and inst.components.stackable:IsStack() then
            inst.components.stackable:Get():Remove()
        else
            inst:Remove()
        end
	end
end

env.AddPrefabPostInit("papyrus", function(inst)
    --inst:AddTag("flute")
    inst:AddTag("tissue")
    --inst:AddTag("tool")
	if not TheWorld.ismastersim then
		return
	end
	
	
    inst:AddComponent("blow_nose")
	inst.components.blow_nose:SetOnPlayedFn(BlowThatNose)
    --inst.components.instrument:SetOnHeardFn(HearPanFlute)
	
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
	
	
end)