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
                local percent = item.components.fueled:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.fueled:SetPercent(refuelnumber)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local percent = item.components.finiteuses:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.finiteuses:SetPercent(refuelnumber)
            elseif item == nil or not item:HasTag("electricaltool") then
                return false
            end
                inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)

            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
                inst.components.health:DoDelta(-TUNING.HEALING_SMALL, false, "lightning")
            end
            return true
        elseif inst.components.upgrademoduleowner ~= nil and inst.components.upgrademoduleowner:ChargeIsMaxed() then
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("electricaltool") and item.components.fueled ~= nil then
                local percent = item.components.fueled:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.fueled:SetPercent(refuelnumber)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local percent = item.components.finiteuses:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.finiteuses:SetPercent(refuelnumber)
            elseif item == nil or not item:HasTag("electricaltool") then
                return false
            end
            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
                inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)

                inst.components.health:DoDelta(TUNING.HEALING_SMALL, false, "lightning")
            end
            return true
        elseif inst.components.upgrademoduleowner ~= nil and not inst.components.upgrademoduleowner:ChargeIsMaxed() then
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("electricaltool") and item.components.fueled ~= nil then
                local percent = item.components.fueled:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.fueled:SetPercent(refuelnumber)
            elseif item ~= nil and item:HasTag("electricaltool") and item.components.finiteuses ~= nil then
                local percent = item.components.finiteuses:GetPercent()
                local refuelnumber = 0
                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end
                item.components.finiteuses:SetPercent(refuelnumber)
            end

            inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        
            inst.components.upgrademoduleowner:AddCharge(1)
        
            if not inst.components.inventory:IsInsulated() then
                inst.sg:GoToState("electrocute")
                inst.components.health:DoDelta(TUNING.HEALING_SMALL, false, "lightning")
            end
        
            return true
        end
    end
        inst:AddComponent("batteryuser") --just the component by itself doesn't do anything
        inst.components.batteryuser.onbatteryused = OnChargeFromBattery
end)
