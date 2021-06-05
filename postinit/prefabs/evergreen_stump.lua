local env = env
GLOBAL.setfenv(1, GLOBAL)

local function find_stumpling_spawn_target(inst)
    return not inst.noleif
        and inst.components.growable ~= nil
        and inst.components.growable.stage <= 3
end

local function spawn_stumpling(inst)
    local stumpling = SpawnPrefab(inst.stumpling)

    if inst.chopper ~= nil then
        stumpling.components.combat:SuggestTarget(inst.chopper)
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    inst:Remove()
	local effect = SpawnPrefab("round_puff_fx_hi")
	effect.Transform:SetPosition(x, y, z)
    stumpling.Transform:SetPosition(x, y, z)
    stumpling.sg:GoToState("hit")
end

local function onnear(inst, target, nodupe)
	if not inst:HasTag("burnt") and inst:HasTag("stump") and target ~= nil and not target:HasTag("plantkin") then
	
		if inst.stumplingambush then
			local stumpling = SpawnPrefab(inst.stumpling)

			if target ~= nil then
				stumpling.components.combat:SuggestTarget(target)
			end
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			if nodupe ~= nil then
				inst.nodupe = false
			end
			
			for k = 1, 3 do 
				if inst.stumpling == "stumpling" then
					local stump = FindEntity(inst, 15, nil, {"stump", "evergreen"}, { "leif","burnt" })
					if stump ~= nil then
						stump.noleif = true
						stump.chopper = target
						stump.stumpling = inst.stumpling
						stump:DoTaskInTime(0, spawn_stumpling)
					end
				else
					local stump = FindEntity(inst, 15, nil, {"stump", "deciduoustree"}, { "leif","burnt" })
					if stump ~= nil then
						stump.noleif = true
						stump.chopper = target
						stump.stumpling = inst.stumpling
						stump:DoTaskInTime(0, spawn_stumpling)
					end
				end
			end

			local x, y, z = inst.Transform:GetWorldPosition()
			inst:Remove()
			local effect = SpawnPrefab("round_puff_fx_hi")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("hit")
		else
			if inst.components.timer:GetTimeLeft("stumptime") == nil then
				inst.components.timer:StartTimer("stumptime", math.random(240, 960))
			end
		end
	end
end

local function onfar(inst)
	if not inst:HasTag("burnt") and inst:HasTag("stump") then
		if inst.components.timer:GetTimeLeft("stumptime") == nil then
			inst.components.timer:StartTimer("stumptime", math.random(240, 960))
		end
	end
end

local function OnTimerDone2(inst, data)
    if data.name == "stumptime" then
		if math.random() > 0.333 then
			inst.stumplingambush = true
		end
    end
end

env.AddPrefabPostInit("evergreen", function(inst)
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
		
		if inst.components.timer:GetTimeLeft("stumptime") == nil and inst:HasTag("stump") then
			inst.components.timer:StartTimer("stumptime", math.random(240, 960))
		end

		_OnLoad(inst, data)
	end
	
	inst.nodupe = false
	inst.stumpling = "stumpling"
	inst.stumplingambush = false
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 14) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone2)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)

env.AddPrefabPostInit("deciduoustree", function(inst)
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
		if data ~= nil and data.stumplingambush ~= nil and inst:HasTag("stump") then
			inst.stumplingambush = data.stumplingambush
		end
		
		if inst.components.timer:GetTimeLeft("stumptime") == nil and inst:HasTag("stump") then
			inst.components.timer:StartTimer("stumptime", math.random(240, 960))
		end

		_OnLoad(inst, data)
	end
	
	inst.nodupe = false
	inst.stumpling = "birchling"
	inst.stumplingambush = false
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 14) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone2)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)