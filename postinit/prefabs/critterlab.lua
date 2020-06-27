local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onnear(inst, target)
    if inst.components.childspawner ~= nil then
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("critterlab_real_blueprint").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.components.childspawner:ReleaseAllChildren(target, "mutatedhound")
		inst:DoTaskInTime(0, function() inst:Remove() end)
    end
end

env.AddPrefabPostInit("critterlab", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "mutatedhound"
	inst.components.childspawner:SetRegenPeriod(TUNING.HOUNDMOUND_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(3)
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)

end)