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
			local x, y, z = inst.Transform:GetWorldPosition()
			
			local stumpling = SpawnPrefab(inst.stumpling)

			local disableambushtargets = TheSim:FindEntities(x, y, z, 100, {"stump", "evergreen"}, { "leif","burnt" })
			
			for k, b in ipairs(disableambushtargets) do
				b.stumplingambush = false
					
				if b.components.timer ~= nil and b.components.timer:TimerExists("stumptime") then
					b.components.timer:StopTimer("stumptime")
				end
			end
			
			if target ~= nil then
				stumpling.components.combat:SuggestTarget(target)
			end
			
			local stump = TheSim:FindEntities(x, y, z, 15, {"stump", "evergreen"}, { "leif","burnt" })
			
			for i, v in ipairs(stump) do
				local scaling = TheWorld.state.cycles / 35
				
				if scaling > 3 then
					scaling = 3
				end
				
				if i <= 2 + scaling then 
					if inst.stumpling == "stumpling" then
						if v ~= nil then
							v.noleif = true
							v.chopper = target
							v.stumpling = inst.stumpling
							spawn_stumpling(v)
							--v:DoTaskInTime(0, spawn_stumpling)
						end
					else
						if v ~= nil then
							v.noleif = true
							v.chopper = target
							v.stumpling = inst.stumpling
							spawn_stumpling(v)
							--v:DoTaskInTime(0, spawn_stumpling)
						end
					end
				else
					v.stumplingambush = false
					
					if v.components.timer ~= nil and v.components.timer:TimerExists("stumptime") then
						v.components.timer:StopTimer("stumptime")
					end
				end
			end

			local x, y, z = inst.Transform:GetWorldPosition()
			inst:Remove()
			local effect = SpawnPrefab("pine_needles_chop")
			effect.Transform:SetPosition(x, y, z)
			stumpling.Transform:SetPosition(x, y, z)
			stumpling.sg:GoToState("spawn")
		end
	end
end

local function OnTimerDone2(inst, data)
    if data.name == "stumptime" then
		local scaling = TheWorld.state.cycles / 200
		
		if scaling > 0.3 then
			scaling = 0.3
		end
		
		if math.random() < scaling then
			inst.stumplingambush = true
		end
    end
end

local function chop_down_tree(inst, data)
	if TheWorld.state.cycles >= 4 then
		inst.components.timer:StartTimer("stumptime", math.random(960, 2400))
	end
	
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