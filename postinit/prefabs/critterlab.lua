local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onnear(inst, target)
    if inst.components.childspawner ~= nil and inst.ambush == nil then
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        SpawnPrefab("critterlab_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
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
	inst.components.childspawner:SetMaxChildren(2)
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	local _OldOnSave = inst.OnSave
	local _OldOnLoad = inst.OnLoad
	
	if inst.OnSave ~= nil then
		_OldOnSave = inst.OnSave
	end
	
	if inst.OnLoad ~= nil then
		_OldOnLoad = inst.OnLoad
	end
	
	local function OnSave(inst, data)
		if inst.ambush ~= nil then
			data.ambush = inst.ambush
		end
		
		if _OldOnSave ~= nil then
			_OldOnSave(inst, data)
		end
	end
	
    inst.OnSave = OnSave
	
	local function OnLoad(inst, data)
		if data ~= nil then
			if data.ambush then
				inst.ambush = data.ambush
			end
		end
		
		if _OldOnLoad ~= nil then
			_OldOnLoad(inst, data)
		end
	end
	
    inst.OnLoad = OnLoad

	if inst.ambush == nil then
		inst.ambush = true
	end
end)