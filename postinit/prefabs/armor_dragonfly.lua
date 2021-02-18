local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSave(inst, data)
    if inst.highTemp ~= nil then
        data.highTemp = math.ceil(inst.highTemp)
    elseif inst.lowTemp ~= nil then
        data.lowTemp = math.floor(inst.lowTemp)
    end
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.highTemp ~= nil then
            inst.highTemp = data.highTemp
            inst.lowTemp = nil
        elseif data.lowTemp ~= nil then
            inst.lowTemp = data.lowTemp
            inst.highTemp = nil
        end
    end
end

local function OnRemove(inst)
    inst._light:Remove()
end

local relative_temperature_thresholds = { -30, -10, 10, 30 }

local function GetRangeForTemperature(temp, ambient)
    local range = 1
    for i,v in ipairs(relative_temperature_thresholds) do
        if temp > ambient + v then
            range = range + 1
        end
    end
    return range
end

-- Heatrock emits constant temperatures depending on the temperature range it's in
local emitted_temperatures = { -10, 10, 25, 40, 60 }

local function HeatFn(inst, observer)
    local range = GetRangeForTemperature(inst.components.temperature:GetCurrent(), TheWorld.state.temperature)
    if range <= 2 then
        inst.components.heater:SetThermics(false, true)
    elseif range >= 4 then
        inst.components.heater:SetThermics(true, false)
    else
        inst.components.heater:SetThermics(false, false)
    end
    return emitted_temperatures[range]
end

local function AdjustLighting(inst, range, ambient)
    if range == 5 then
		print("light should spawn now")
        local relativetemp = inst.components.temperature:GetCurrent() - ambient
        local baseline = relativetemp - relative_temperature_thresholds[4]
        local brightline = relative_temperature_thresholds[4] + 20
        inst._light.Light:SetIntensity( math.clamp(0.5 * baseline/brightline, 0, 0.5 ) )
    else
        inst._light.Light:SetIntensity(0)
    end
end

local function TemperatureChange(inst, data)
    local ambient_temp = TheWorld.state.temperature
    local cur_temp = inst.components.temperature:GetCurrent()
    local range = GetRangeForTemperature(cur_temp, ambient_temp)

	print(ambient_temp)
	print(cur_temp)
	print(range)
	
    AdjustLighting(inst, range, ambient_temp)

    if range <= 1 then
        if inst.lowTemp == nil or inst.lowTemp > cur_temp then
            inst.lowTemp = math.floor(cur_temp)
        end
        inst.highTemp = nil
    elseif range >= 5 then
        if inst.highTemp == nil or inst.highTemp < cur_temp then
            inst.highTemp = math.ceil(cur_temp)
        end
        inst.lowTemp = nil
    elseif inst.lowTemp ~= nil then
        if GetRangeForTemperature(inst.lowTemp, ambient_temp) >= 3 then
            inst.lowTemp = nil
        end
    elseif inst.highTemp ~= nil and GetRangeForTemperature(inst.highTemp, ambient_temp) <= 3 then
        inst.highTemp = nil
    end

    if range ~= inst.currentTempRange then
        --UpdateImages(inst, range)

        if (inst.lowTemp ~= nil and range >= 3) or
            (inst.highTemp ~= nil and range <= 3) then
            inst.lowTemp = nil
            inst.highTemp = nil
        end
    end
end

local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("equipped", inst._onownerchange, owner)
            inst:ListenForEvent("unequipped", inst._onownerchange, owner)
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    inst._light.entity:SetParent(owner.entity)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:ListenForEvent("equipped", inst._onownerchange, k)
            inst:ListenForEvent("unequipped", inst._onownerchange, k)
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners
end

local function onequip(inst, owner) 
end

local function onunequip(inst, owner) 
end

env.AddPrefabPostInit("armordragonfly", function(inst)

	inst:AddTag("heatrock")

    inst:AddTag("HASHEATER")
	
	if not TheWorld.ismastersim then
		return
	end
	--[[
	local _SetOnEquip = inst.components.equippable.onequipfn

	inst.components.equippable.onequipfn = function(inst, owner)
		if _SetOnEquip ~= nil then
		   _SetOnEquip(inst, owner)
		end
	end
	
	local _SetOnUnequip = inst.components.equippable.onunequipfn

	inst.components.equippable.onunequipfn = function(inst, owner)
		if _SetOnUnequip ~= nil then
		   _SetOnUnequip(inst, owner)
		end
	end
	]]
    inst:AddComponent("temperature")
    inst.components.temperature.current = TheWorld.state.temperature
    inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
    inst.components.temperature.inherentsummerinsulation = TUNING.INSULATION_MED
    inst.components.temperature:IgnoreTags("heatrock")
	
    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn
    inst.components.heater.carriedheatmultiplier = TUNING.HEAT_ROCK_CARRIED_BONUS_HEAT_FACTOR
    inst.components.heater:SetThermics(false, false)
	
    inst:ListenForEvent("temperaturedelta", TemperatureChange)
    inst.currentTempRange = 0
	
    inst._light = SpawnPrefab("armor_dragonfly_light")
    inst._owners = {}
    inst._onownerchange = function() OnOwnerChange(inst) end
	
    OnOwnerChange(inst)
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnRemoveEntity = OnRemove
end)