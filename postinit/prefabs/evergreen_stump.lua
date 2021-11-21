local env = env
GLOBAL.setfenv(1, GLOBAL)

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

local function onnear(inst, target)
	if not inst:HasTag("burnt") and inst:HasTag("stump") and target ~= nil and not target:HasTag("plantkin") then
		if inst.stumplingambush then
			local stumpling = SpawnPrefab(inst.stumpling)

			if target ~= nil then
				stumpling.components.combat:SuggestTarget(target)
			end
			
			local x, y, z = inst.Transform:GetWorldPosition()
			
			local stump = FindEntity(inst, 20, nil, {"stump", "evergreen"}, { "leif","burnt" })
			
			if stump ~= nil then
				for i, v in ipairs(stump) do
					if v.stumplingambush ~= nil and v.stumplingambush then
						v.stumplingambush = false
					end
				end
				
				for k = 1, 3 do 
					if inst.stumpling == "stumpling" then
						if stump ~= nil then
							stump.noleif = true
							stump.chopper = target
							stump.stumpling = inst.stumpling
							stump:DoTaskInTime(0, spawn_stumpling)
						end
					else
						if stump ~= nil then
							stump.noleif = true
							stump.chopper = target
							stump.stumpling = inst.stumpling
							stump:DoTaskInTime(0, spawn_stumpling)
						end
					end
				end
			end

			local x, y, z = inst.Transform:GetWorldPosition()
			inst:Remove()
			local effect = SpawnPrefab("round_puff_fx_hi")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("hit")
		end
	end
end

local function OnTimerDone2(inst, data)
    if data.name == "stumptime" then
		--local scaling = TheWorld.state.cycles / 200
		
		--if math.random() < (0.15 + scaling) then
			inst.stumplingambush = true
		--end
    end
end

local function chop_down_tree(inst, data)
	if TheWorld.state.cycles >= 4 then
		--inst.components.timer:StartTimer("stumptime", math.random(240, 960))
	end
	
		inst.components.timer:StartTimer("stumptime", 1)
	
	return inst._OldOnFinish(inst, data)
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

		_OnLoad(inst, data)
	end
	
	inst.stumpling = "stumpling"
	inst.stumplingambush = false
	
	if not inst:HasTag("stump") and not inst:HasTag("burnt") and inst.components.workable ~= nil then
		inst._OldOnFinish = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(chop_down_tree)
	end
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 14) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	if not inst.components.timer then
		inst:AddComponent("timer")
	end
	
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

		_OnLoad(inst, data)
	end
	
	inst.stumpling = "birchling"
	inst.stumplingambush = false
	
	if not inst:HasTag("stump") and not inst:HasTag("burnt") and inst.components.workable ~= nil then
		inst._OldOnFinish = inst.components.workable.onfinish
        inst.components.workable:SetOnFinishCallback(chop_down_tree)
	end
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 14) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	if not inst.components.timer then
		inst:AddComponent("timer")
	end
	
    inst:ListenForEvent("timerdone", OnTimerDone2)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)