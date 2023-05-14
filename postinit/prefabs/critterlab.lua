local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onnear(inst, target)
	if not inst.repaired then
		if inst.components.childspawner ~= nil and inst.doafuckingambush then
			SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
			SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
			SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
			SpawnPrefab("critterlab_real_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.components.childspawner:ReleaseAllChildren(target, "mutatedhound")
			inst:DoTaskInTime(0, function() inst:Remove() end)
		end
	end
end

local function OnSave(inst, data)
	data.repaired = inst.repaired
	data.doafuckingambush = inst.doafuckingambush
		
	if inst._OldOnSave ~= nil then
		return inst._OldOnSave(inst, data)
	end
end
	
local function OnLoad(inst, data)
    if data then
		inst.repaired = data.repaired
		inst.doafuckingambush = data.doafuckingambush or inst.doafuckingambush
	end
		
	if inst._OldOnLoad ~= nil then
		return inst._OldOnLoad(inst, data)
	end
end

env.AddPrefabPostInit("critterlab", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst.doafuckingambush = true
	inst.repaired = false

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
		inst._OldOnSave = inst.OnSave
	end
	
	if inst.OnLoad ~= nil then
		inst._OldOnLoad = inst.OnLoad
	end
	
    inst.OnSave = OnSave
	
    inst.OnLoad = OnLoad
end)