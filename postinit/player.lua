local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPlayerPostInit(function(inst)
    if TUNING.DSTU.VETCURSE == "always" then
        if inst ~= nil and inst.components.health ~= nil and not inst:HasTag("playerghost") then
            if not inst:HasTag("vetcurse") then
                inst.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
                inst:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1 })
            end
        end
    elseif TUNING.DSTU.VETCURSE == "off" and inst:HasTag("vetcurse") then
        if inst ~= nil and inst.components.debuffable ~= nil then
            inst.components.debuffable:RemoveDebuff("buff_vetcurse")
        end --help I can't get this stupid thing to work!!
    end

    local function OnChargeFromBattery(inst, battery)
        if inst.components.upgrademoduleowner == nil then
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("electricaltool") and item.components.fueled ~= nil then
                item.components.fueled:DoDelta(50, inst)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local currentuses = item.components.finiteuses:GetPercent()
                item.components.finiteuses:SetPercent(currentuses + 50)
            elseif item == nil or not item:HasTag("electricaltool")then
                return false
            end
                inst.components.health:DoDelta(TUNING.HEALING_SMALL, false, "lightning")
                inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)

            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
            end
            return true
        elseif inst.components.upgrademoduleowner ~= nil and inst.components.upgrademoduleowner:ChargeIsMaxed() then
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("electricaltool") and item.components.fueled ~= nil then
                item.components.fueled:DoDelta(50, inst)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local currentuses = item.components.finiteuses:GetPercent()
                item.components.finiteuses:SetPercent(currentuses + 50)
            elseif item == nil or item:HasTag("electricaltool") == false then
                return false
            end
                inst.components.health:DoDelta(TUNING.HEALING_SMALL, false, "lightning")
                inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)

            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
            end
            return true
        elseif inst.components.upgrademoduleowner ~= nil and not inst.components.upgrademoduleowner:ChargeIsMaxed() then
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("electricaltool") and item.components.fueled ~= nil then
                item.components.fueled:DoDelta(50, inst)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local currentuses = item.components.finiteuses:GetPercent()
                item.components.finiteuses:SetPercent(currentuses + 50)
            end

            inst.components.health:DoDelta(TUNING.HEALING_SMALL, false, "lightning")
            inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        
            inst.components.upgrademoduleowner:AddCharge(1)
        
            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
            end
        
            return true
        end
    end
    if WX78_CONFIG then --temp until beta changes releases, as this relies on WX rework stuff.
        inst:AddTag("batteryuser")          -- from batteryuser component
        inst:AddComponent("batteryuser")
        inst.components.batteryuser.onbatteryused = OnChargeFromBattery
    end
end)