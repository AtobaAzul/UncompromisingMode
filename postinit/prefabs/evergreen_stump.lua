local env = env
GLOBAL.setfenv(1, GLOBAL)

local function onnear(inst, target)
	if not inst:HasTag("burnt") and inst:HasTag("stump") and target ~= nil then
	
		if inst.stumplingambush then
			local stumpling = SpawnPrefab("stumpling")

			if target ~= nil then
				stumpling.components.combat:SuggestTarget(target)
			end

			local x, y, z = inst.Transform:GetWorldPosition()
			inst:Remove()
			local effect = SpawnPrefab("round_puff_fx_hi")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("hit")
		else
			if inst.components.timer:GetTimeLeft("stumptime") == nil then
				inst.components.timer:StartTimer("stumptime", math.random(480, 960))
			end
		end
	end
end

local function OnTimerDone(inst, data)
    if data.name == "stumptime" then
		if math.random() > 0.6 then
			inst.stumplingambush = true
		end
    end
end

env.AddPrefabPostInit("evergreen_stump", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	local function OnSave(inst, data)
		if inst.stumplingambush ~= nil then
			data.stumplingambush = inst.stumplingambush
		end
		
		_OnSave(inst, data)
	end

	local function OnLoad(inst, data)
		if data ~= nil and data.stumplingambush ~= nil then
			inst.stumplingambush = data.stumplingambush
		end

		_OnLoad(inst, data)
	end
	
	inst.stumplingambush = false
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)