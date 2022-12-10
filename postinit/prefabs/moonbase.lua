local env = env
GLOBAL.setfenv(1, GLOBAL)

local function StartLight(inst)
    inst._startlighttask = nil
    inst.Light:Enable(true)
    if inst._staffstar == nil then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
end

local function StopLight(inst)
    inst._stoplighttask = nil
    inst.Light:Enable(false)
    if inst._staffstar == nil then
        inst.AnimState:ClearBloomEffectHandle()
    end
end

local function HasStaff(inst, staffname)
    return (inst._staffinst ~= nil and inst._staffinst.prefab or inst.components.pickable.product) == staffname or inst.mooning
end


local function StopFX(inst)
    if inst._fxpulse ~= nil then
        inst._fxpulse:KillFX()
        inst._fxpulse = nil
    end
    if inst._fxfront ~= nil or inst._fxback ~= nil then
        if inst._fxback ~= nil then
            inst._fxfront:KillFX()
            inst._fxfront = nil
        end
        if inst._fxback ~= nil then
            inst._fxback:KillFX()
            inst._fxback = nil
        end
        if inst._stoplighttask ~= nil then
            inst._stoplighttask:Cancel()
        end
        inst._stoplighttask = inst:DoTaskInTime(9 * FRAMES, StopLight)
    end
    if inst._startlighttask ~= nil then
        inst._startlighttask:Cancel()
        inst._startlighttask = nil
    end
end

local function StartFX(inst)
    if inst._fxfront == nil or inst._fxback == nil then
        local x, y, z = inst.Transform:GetWorldPosition()

        if inst._fxpulse ~= nil then
            inst._fxpulse:Remove()
        end
        inst._fxpulse = SpawnPrefab("positronpulse")
        inst._fxpulse.Transform:SetPosition(x, y, z)

        if inst._fxfront ~= nil then
            inst._fxfront:Remove()
        end
        inst._fxfront = SpawnPrefab("positronbeam_front")
        inst._fxfront.Transform:SetPosition(x, y, z)

        if inst._fxback ~= nil then
            inst._fxback:Remove()
        end
        inst._fxback = SpawnPrefab("positronbeam_back")
        inst._fxback.Transform:SetPosition(x, y, z)

        if inst._startlighttask ~= nil then
            inst._startlighttask:Cancel()
        end
        inst._startlighttask = inst:DoTaskInTime(3 * FRAMES, StartLight)
    end
    if inst._stoplighttask ~= nil then
        inst._stoplighttask:Cancel()
        inst._stoplighttask = nil
    end
end

local function launchitem(item, angle)
    local speed = math.random() * 4 + 2
    angle = (angle + math.random() * 60 - 30) * DEGREES
    item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
end

local function giveopal(inst, item, giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 2.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    local item = SpawnPrefab("opalpreciousgem")
	if item ~= nil then
		item.Transform:SetPosition(x, y, z)
		launchitem(item, angle)
    end
end

local function givetear(inst, item, giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 2.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    local item = SpawnPrefab("moon_tear")
	if item ~= nil then
		item.Transform:SetPosition(x, y, z)
		launchitem(item, angle)
    end
end

local KEY_STAFF = "yellowstaff"


local function StartFX(inst)
    if inst._fxfront == nil or inst._fxback == nil then
        local x, y, z = inst.Transform:GetWorldPosition()

        if inst._fxpulse ~= nil then
            inst._fxpulse:Remove()
        end
        inst._fxpulse = SpawnPrefab("positronpulse")
        inst._fxpulse.Transform:SetPosition(x, y, z)

        if inst._fxfront ~= nil then
            inst._fxfront:Remove()
        end
        inst._fxfront = SpawnPrefab("positronbeam_front")
        inst._fxfront.Transform:SetPosition(x, y, z)

        if inst._fxback ~= nil then
            inst._fxback:Remove()
        end
        inst._fxback = SpawnPrefab("positronbeam_back")
        inst._fxback.Transform:SetPosition(x, y, z)

        if inst._startlighttask ~= nil then
            inst._startlighttask:Cancel()
        end
        inst._startlighttask = inst:DoTaskInTime(3 * FRAMES, StartLight)
    end
    if inst._stoplighttask ~= nil then
        inst._stoplighttask:Cancel()
        inst._stoplighttask = nil
    end
end

local function SpawnReinforcements(inst, giver)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local x1 = x + math.random(-10, 10)
	local z1 = z + math.random(-10, 10)
	
	inst.fxpulse = SpawnPrefab("positronpulse")
	inst.fxpulse.Transform:SetPosition(x1, y, z1)
	
	inst.fxfront = SpawnPrefab("positronbeam_front")
	inst.fxfront.Transform:SetPosition(x1, y, z1)

	inst.fxback = SpawnPrefab("positronbeam_back")
	inst.fxback.Transform:SetPosition(x1, y, z1)
	
	inst:DoTaskInTime(3.5, function(inst)
		if inst.fxpulse ~= nil then
			inst.fxpulse:KillFX()
			inst.fxpulse = nil
		end
		
		if inst.fxfront ~= nil then
			inst.fxfront:KillFX()
			inst.fxfront = nil
		end
		
		if inst.fxback ~= nil then
			inst.fxback:KillFX()
			inst.fxback = nil
		end

		local x, _, z = inst.Transform:GetWorldPosition()
		local moonpulsefx = SpawnPrefab("moonpulse_fx")
		moonpulsefx.Transform:SetPosition(x1, 0, z1)
		moonpulsefx.Transform:SetScale(0.8, 0.8, 0.8)
		
		local threat = TUNING.DSTU.MOON_TRANSFORMATIONS and SpawnPrefab("mutatedhound") or SpawnPrefab("hound")
		threat.Transform:SetPosition(x1, 0, z1)
		threat.SoundEmitter:PlaySound("grotto/common/moon_alter/link/wave1")
	end)
end

local function ItemTradeTest(inst, item, giver)
	if item.prefab == "moon_tear" and not inst.mooning then
		if TheWorld.state.isfullmoon then
			inst.mooning = true
			StartFX(inst)
			item:Remove()
			
			for i = 1, 6 do
				inst:DoTaskInTime(i * 4, function(inst, giver)
					if TheWorld.state.isfullmoon then
						SpawnReinforcements(inst, giver)
					end
				end)
			end
			
			TheWorld:PushEvent("ms_forceprecipitation")
			
			inst.moonteartransformtask = inst:DoTaskInTime(30, function(inst, item, giver)
				giveopal(inst, item, giver)
				StopFX(inst)
				inst.mooning = false
				
				inst:StopWatchingWorldState("isday")
				
				if inst.moonteartransformtask ~= nil then
					inst.moonteartransformtask:Cancel()
				end
				
				inst.moonteartransformtask = nil
			end)
			
			inst:WatchWorldState("isday", function(inst, item, giver)
				if inst.moonteartransformtask ~= nil then
					inst.moonteartransformtask:Cancel()
					givetear(inst, item, giver)
				end
				
				inst.moonteartransformtask = nil
				
				StopFX(inst)
				inst.mooning = false
			
				inst:StopWatchingWorldState("isday")
			end)
			
			return true
		else
			return false, "NOTNIGHT"
		end
	elseif not inst.mooning then
		return inst._OldItemTradeTest(inst, item)
		--[[if item == nil then
			return false
		elseif string.sub(item.prefab, -5) ~= "staff" then
			return false, "NOTSTAFF"
		end
		return true]]
	end
end

local function OnTearGiven(inst, giver, item)
end

local function MakeRepairable(inst)
    if inst.components.repairable == nil then
        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = MATERIALS.MOONROCK
        inst.components.repairable.onrepaired = OnRepaired
        inst.components.repairable.noannounce = true
    end
end

env.AddPrefabPostInit("moonbase", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.mooning = false
	
    MakeRepairable(inst)
	--[[local _ItemTradeTest = inst.components.trader.abletoaccepttest
	
	inst.components.trader.abletoaccepttest = function(inst, item, giver)
		if item.prefab == "moon_tear" then
			ItemTradeTest(inst, item, giver)
		else
			if _ItemTradeTest ~= nil then
				_ItemTradeTest(inst, item, giver)
			end
		end
	end]]
	
	local _OnStaffGiven = inst.components.trader.onaccept
	inst._OldItemTradeTest = inst.components.trader.abletoaccepttest

    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = function(inst, giver, item)
	
	if item.prefab == "moon_tear" then
		OnTearGiven(inst, giver, item)
	else
		if _OnStaffGiven ~= nil then
			_OnStaffGiven(inst, giver, item)
		end
	end
	
	end
	
end)