local env = env
GLOBAL.setfenv(1, GLOBAL)

local function VacuumUp(inst)
	--StopBlowAway(inst)
	inst.components.disappears:StopDisappear()
    --inst.persists = false
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("inspectable")
	inst.AnimState:PlayAnimation("eaten")
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

env.AddPrefabPostInit("ash", function(inst)

inst.VacuumUp = VacuumUp

--return inst
end)