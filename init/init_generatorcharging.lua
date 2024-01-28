local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local BATTERY_COST = TUNING.WINONA_BATTERY_LOW_MAX_FUEL_TIME * 0.25
local function CanBeUsedAsBattery(inst, user)
    if inst.components.fueled ~= nil and inst.components.fueled.currentfuel >= BATTERY_COST then
        return true
    else
        return false, "NOT_ENOUGH_CHARGE"
    end
end

local function UseAsBattery(inst, user)
    inst.components.fueled:DoDelta(-BATTERY_COST, user)
end

env.AddPrefabPostInit("winona_battery_low", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.battery ~= nil then
        inst.components.battery.canbeused = CanBeUsedAsBattery
        inst.components.battery.onused = UseAsBattery
    end
end)

env.AddPlayerPostInit(function(inst)
    local _onbatteryused = nil
    local batteryuser = inst.components.batteryuser

    if batteryuser ~= nil then
        inst.UM_isBatteryUser = true
        _onbatteryused = batteryuser.onbatteryused
    else
        batteryuser = inst:AddComponent("batteryuser") -- just the component by itself doesn't do anything
    end

    local function OnChargeFromBattery(inst)
        local items = {}
        local items_fuel = {}
        local selected_item, selected_item_fuel

        for k, v in pairs(EQUIPSLOTS) do
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS[k])

            if item ~= nil and item:HasTag("electricaltool") then
                items[k] = item
            end
        end

        for k, v in pairs(items) do
            table.insert(
                items_fuel,
                v.components.fueled ~= nil and v.components.fueled:GetPercent() or
                v.components.finiteuses ~= nil and v.components.finiteuses:GetPercent()
            )
        end

        if #items_fuel > 0 then
            selected_item_fuel = math.min(unpack(items_fuel))
        end

        for k, v in pairs(items) do
            if
                v.components.fueled ~= nil and v.components.fueled:GetPercent() == selected_item_fuel or
                v.components.finiteuses ~= nil and v.components.finiteuses:GetPercent() == selected_item_fuel
            then
                selected_item = v
            end
        end

        if selected_item == nil and not inst.UM_isBatteryUser then
            return false
        end

        if selected_item == nil and _onbatteryused ~= nil then
            return _onbatteryused(inst)
        end

        local percent =
            selected_item.components.fueled ~= nil and selected_item.components.fueled:GetPercent() or
            selected_item.components.finiteuses:GetPercent()
        local refuelnumber = math.clamp(percent + 0.33, 0, inst:HasTag("handyperson") and 2 or 1)

        if selected_item.components.finiteuses ~= nil and
            (inst:hasTag("handyperson") and percent == 2 or not inst:HasTag("handyperson") and percent > 1) then
            return false, "CHARGE_FULL"
        end

        if selected_item.components.fueled ~= nil then
            selected_item.components.fueled:SetPercent(refuelnumber)
            selected_item.components.fueled.ontakefuelfn(selected_item, 0)
        elseif selected_item.components.finiteuses ~= nil then
            selected_item.components.finiteuses:SetPercent(refuelnumber)
        end

        if not inst.components.inventory:IsInsulated() then
            inst.sg:GoToState("electrocute")
            inst.components.health:DoDelta(-TUNING.HEALING_SMALL, false, "lightning")
            inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
            if inst.components.talker ~= nil then
                inst:DoTaskInTime(1,
                    inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED")))
            end
        else
            if inst.components.talker ~= nil then
                inst:DoTaskInTime(1,
                    inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_INSULATED")))
            end
        end
        if _onbatteryused ~= nil then
            _onbatteryused(inst)
        end
        return true
    end

    batteryuser.onbatteryused = OnChargeFromBattery
end)