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

local KEY_STAFF = "yellowstaff"

local function ItemTradeTest(inst, item, giver)
	if item.prefab == "moon_tear" and not inst.mooning then
		if TheWorld.state.isnight then
			inst.mooning = true
			StartFX(inst)
			item:Remove()
			inst:DoTaskInTime(5, function(inst)
				giveopal(inst, item, giver)
				StopFX(inst)
				inst.mooning = false
			end)
			return true
		else
			return false, "NOTNIGHT"
		end
	elseif not inst.mooning then
		if item == nil then
			return false
		elseif string.sub(item.prefab, -5) ~= "staff" then
			return false, "NOTSTAFF"
		end
		return true
	end
end

local function OnStaffGiven(inst, giver, item)
end

env.AddPrefabPostInit("moonbase", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.mooning = false
	
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

    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = function(inst, giver, item)
	
	if item.prefab == "moon_tear" then
		OnStaffGiven(inst, giver, item)
	else
		if _OnStaffGiven ~= nil then
			_OnStaffGiven(inst, giver, item)
		end
	end
	
	end
	
end)