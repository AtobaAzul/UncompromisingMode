local function OnUpdateChargingFuel(inst)
    if inst.components.fueled:IsFull() then
        inst.components.fueled:StopConsuming()
    end
end

local function SetCharging(inst, powered, duration)
    if not powered then
        if inst._powertask then
            inst._powertask:Cancel()
            inst._powertask = nil
            inst.components.fueled:StopConsuming()
            inst.components.fueled.rate = inst._oldrate or 1
            inst.components.fueled:SetUpdateFn(nil)
            inst.components.powerload:SetLoad(0)
            --RefreshLedStatus(inst)
        end
    else
        local waspowered = inst._powertask ~= nil
        local remaining = waspowered and GetTaskRemaining(inst._powertask) or 0

        if duration > remaining then
            if inst._powertask then
                inst._powertask:Cancel()
            end
            inst._powertask = inst:DoTaskInTime(duration, SetCharging, false)
            --idk why klei does the "not waspowered" thing here. doesn't seem to do anything other than prevent the thing from wokring???
            if waspowered then
                inst._oldrate = inst.components.fueled.rate
                inst.components.fueled.rate = (TUNING.WINONA_TELEBRELLA_RECHARGE_RATE / 2) * (inst._quickcharge and TUNING.SKILLS.WINONA.QUICKCHARGE_MULT or 1)
                inst.components.fueled:SetUpdateFn(OnUpdateChargingFuel)
                inst.components.fueled:StartConsuming()
                inst.components.powerload:SetLoad(TUNING.WINONA_TELEBRELLA_POWER_LOAD_CHARGING)
                --RefreshLedStatus(inst)
            end
        end
    end
end

local function OnPutInInventory(inst, owner)
    if inst._inittask then
        inst._inittask:Cancel()
        inst._inittask = nil
    end
    inst._landed_owner = nil
    inst._owner = owner
    inst._quickcharge = false
    inst.components.circuitnode:Disconnect()
    --RefreshLedStatus(inst)
end

local function OnDropped(inst)
    if inst._owner then
        if inst._owner.components.skilltreeupdater and
            inst._owner.components.skilltreeupdater:IsActivated("winona_gadget_recharge") and
            not (inst._owner.components.health and inst._owner.components.health:IsDead() or inst._owner:HasTag("playerghost"))
        then
            inst._quickcharge = true
        end
        inst._landed_owner = inst._owner
        inst._owner = nil
    end

    if inst.components.inventoryitem.is_landed then
        inst.components.circuitnode:ConnectTo("engineeringbattery")
        if inst._landed_owner then
            inst.components.circuitnode:ForEachNode(function(inst, node)
                node:OnUsedIndirectly(inst._landed_owner)
            end)
            inst._landed_owner = nil
        end
    else
        inst.components.circuitnode:Disconnect()
    end
    --RefreshLedStatus(inst)
end

local function OnNoLongerLanded(inst)
    inst.components.circuitnode:Disconnect()
end

local function OnLanded(inst)
    if not (inst.components.circuitnode:IsEnabled() or inst.components.inventoryitem:IsHeld()) then
        inst.components.circuitnode:ConnectTo("engineeringbattery")
        if inst._landed_owner and inst._landed_owner:IsValid() then
            inst.components.circuitnode:ForEachNode(function(inst, node)
                node:OnUsedIndirectly(inst._landed_owner)
            end)
        end
    end
    inst._landed_owner = nil
end

local function OnSave(inst, data)
    data.power = inst._powertask and math.ceil(GetTaskRemaining(inst._powertask) * 1000) or nil

    --skilltree
    data.quickcharge = inst._quickcharge or nil
end

local function OnLoad(inst, data) --, newents)
    if inst._inittask then
        inst._inittask:Cancel()
        inst._inittask = nil
    end

    --skilltree
    inst._quickcharge = data and data.quickcharge or false

    if data and data.power then
        inst:AddBatteryPower(math.max(2 * FRAMES, data.power / 1000))
    else
        SetCharging(inst, false)
    end
    --Enable connections, but leave the initial connection to batteries' OnPostLoad
    inst.components.circuitnode:ConnectTo(nil)
end

local function OnInit(inst)
    inst._inittask = nil
    if not inst:HasTag("INLIMBO") then
        inst.components.circuitnode:ConnectTo("engineeringbattery")
    end
end



local function AddBatteryPower(inst, power)
    if inst.components.fueled:IsFull() then
        SetCharging(inst, false)
    else
        SetCharging(inst, true, power)
    end
end

local function OnUpdateSparks(inst)
    if inst._flash > 0 then
        local k = inst._flash * inst._flash
        inst.components.colouradder:PushColour("wiresparks", .3 * k, .3 * k, 0, 0)
        inst._flash = inst._flash - .15
    else
        inst.components.colouradder:PopColour("wiresparks")
        inst._flash = nil
        inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateSparks)
    end
end

local function DoWireSparks(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/electricity", nil, .5)
    SpawnPrefab("winona_battery_sparks").Transform:SetPosition(inst.Transform:GetWorldPosition())
    if inst.components.updatelooper then
        if inst._flash == nil then
            inst.components.updatelooper:AddOnUpdateFn(OnUpdateSparks)
        end
        inst._flash = 1
        OnUpdateSparks(inst)
    end
end

local function NotifyCircuitChanged(inst, node)
    node:PushEvent("engineeringcircuitchanged")
end

local function OnCircuitChanged(inst)
    --Notify other connected batteries
    inst.components.circuitnode:ForEachNode(NotifyCircuitChanged)
end

local function OnConnectCircuit(inst) --, node)
    if not inst._wired then
        inst._wired = true
        if not POPULATING then
            DoWireSparks(inst)
        end
    end
    OnCircuitChanged(inst)
end

local function OnDisconnectCircuit(inst) --, node)
    if inst.components.circuitnode:IsConnected() then
        OnCircuitChanged(inst)
    elseif inst._wired then
        inst._wired = nil
        --This will remove mouseover as well (rather than just :Hide("wire"))
        DoWireSparks(inst)
        SetCharging(inst, false)
    end
end

local function fn(inst)
    inst:AddTag("engineering")
    inst:AddTag("engineeringbatterypowered")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("updatelooper")
    inst:AddComponent("colouradder")

    local _onputininventoryfn = inst.components.inventoryitem.onputininventoryfn
    inst.components.inventoryitem.onputininventoryfn = function(inst, owner)
        if _onputininventoryfn ~= nil then _onputininventoryfn(inst) end
        OnPutInInventory(inst, owner)
    end


    local _ondropfn = inst.components.inventoryitem.ondropfn
    inst.components.inventoryitem.ondropfn = function(inst)
        if _ondropfn ~= nil then 
            _ondropfn(inst) 
        end
        OnDropped(inst)
    end


    inst:AddComponent("circuitnode")
    inst.components.circuitnode:SetRange(TUNING.WINONA_BATTERY_RANGE)
    inst.components.circuitnode:SetFootprint(0)
    inst.components.circuitnode:SetOnConnectFn(OnConnectCircuit)
    inst.components.circuitnode:SetOnDisconnectFn(OnDisconnectCircuit)
    inst.components.circuitnode.connectsacrossplatforms = false
    inst.components.circuitnode.rangeincludesfootprint = false

    inst:AddComponent("powerload")
    inst.components.powerload:SetLoad(0)

    inst:ListenForEvent("engineeringcircuitchanged", OnCircuitChanged)
    inst:ListenForEvent("on_no_longer_landed", OnNoLongerLanded)
    inst:ListenForEvent("on_landed", OnLanded)

    inst.AddBatteryPower = AddBatteryPower

    local _OnSave = inst.OnSave
    local _OnLoad = inst.OnLoad
    inst.OnSave = function(inst, data)
        OnSave(inst, data)
        if _OnSave ~= nil then _OnSave(inst, data) end
    end
    inst.OnLoad = function(inst, data)
        OnLoad(inst, data)
        if _OnLoad ~= nil then _OnLoad(inst, data) end
    end

    --skilltree
    inst._quickcharge = false

    inst._wired = nil
    inst._inittask = inst:DoTaskInTime(0, OnInit)
end

return fn
