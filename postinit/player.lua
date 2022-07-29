local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPlayerPostInit(function(inst)
    if TUNING.DSTU.VETCURSE == "always" then
        if inst ~= nil and inst.components.health ~= nil and
            not inst:HasTag("playerghost") then
            if not inst:HasTag("vetcurse") then
                inst.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
                inst:PushEvent("foodbuffattached", {buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1})
            end
        end
    elseif TUNING.DSTU.VETCURSE == "off" and inst:HasTag("vetcurse") then
        if inst ~= nil and inst.components.debuffable ~= nil then
            inst.components.debuffable:RemoveDebuff("buff_vetcurse")
        end -- help I can't get this stupid thing to work!!
    end

    local function ChargeItem(item)
        if item ~= nil then
            if item.components.fueled ~= nil then
                local percent = item.components.fueled:GetPercent()
                local refuelnumber = 0

                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end

                item.components.fueled:SetPercent(refuelnumber)
            elseif item.components.finiteuses ~= nil then
                local percent = item.components.finiteuses:GetPercent()
                local refuelnumber = 0

                if percent + 0.33 > 1 then
                    refuelnumber = 1
                else
                    refuelnumber = percent + 0.33
                end

                item.components.finiteuses:SetPercent(refuelnumber)
            end
        end
    end

    local function OnChargeFromBattery(inst, battery)
        local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        print(item)

        if item == nil then
            print("no handslot item - using headslot")
            item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            print(item)
        end

        if item == nil then
            print("no headslot item - using bodyslot")
            item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
            print(item)
        end

        if item == nil and (inst.components.upgrademoduleowner ~= nil and inst.components.upgrademoduleowner:ChargeIsMaxed()) then
            return false, "CHARGE_FULL"
        end

        if inst.components.upgrademoduleowner == nil then
            if (item ~= nil and item.components.finiteuses ~= nil and item.components.finiteuses:GetPercent() == 1) or (item ~= nil and item.components.fueld ~= nil and item.components.fueled:GetPercent() >= 0.995) then
                return false, "CHARGE_FULL"
            else
                if item ~= nil and item:HasTag("electricaltool") then
                    ChargeItem(item)
                    if not inst.components.inventory:IsInsulated() then
                        inst.sg:GoToState("electrocute")
                        inst.components.health:DoDelta(-TUNING.HEALING_SMALL, false, "lightning")
                        inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
                        if inst.components.talker ~= nil then
                            inst:DoTaskInTime(1, inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED")))
                        end
                    else
                        if inst.components.talker ~= nil then
                            inst:DoTaskInTime(1, inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_INSULATED")))
                        end
                    end
                    return true
                end
            end
        else
            if ((item ~= nil and item.components.finiteuses ~= nil and item.components.finiteuses:GetPercent() == 1) or (item ~= nil and item.components.fueld ~= nil and item.components.fueled:GetPercent() >= 0.995)) and inst.components.upgrademoduleowner:ChargeIsMaxed() or not (item ~= nil and item:HasTag("electricaltool")) then
                return false, "CHARGE_FULL"
            else
                if item ~= nil and item:HasTag("electricaltool") then
                    ChargeItem(item)
                    if not inst.components.upgrademoduleowner:ChargeIsMaxed() then
                        inst.components.upgrademoduleowner:AddCharge(1)
                    end
                    if not inst.components.inventory:IsInsulated() then
                        inst.sg:GoToState("electrocute")
                        inst.components.health:DoDelta(-TUNING.HEALING_SMALL, false, "lightning")
                        inst.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
                        if inst.components.talker ~= nil then
                            inst:DoTaskInTime(1, inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_ELECTROCUTED")))
                        end
                    else
                        if inst.components.talker ~= nil then
                            inst:DoTaskInTime(1, inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE_SUCCESS_INSULATED")))
                        end
                    end
                    return true
                end
            end
        end
    end

    inst:AddComponent("batteryuser") -- just the component by itself doesn't do anything
    inst.components.batteryuser.onbatteryused = OnChargeFromBattery

    -- instead of just winky, why the hell not make it *all* followers?!
    local _OnDespawn = inst.OnDespawn
    inst.um_all_followers = {}
    -- adding um_ prefix just in case...

    inst.OnDespawn = function(inst, migrationdata, ...)
        for k, v in pairs(inst.components.leader.followers) do
            if (k:HasTag("spider") or k:HasTag("pig") or k:HasTag("merm") or k:HasTag("raidrat")) then--exluding things that can't/shouldn't/already do
                local savedata = k:GetSaveRecord()
                table.insert(inst.um_all_followers, savedata)
                -- remove followers
                k:AddTag("notarget")
                k:AddTag("NOCLICK")
                k.persists = false
                if k.components.health then
                    k.components.health:SetInvincible(true)
                end
                k:DoTaskInTime(math.random() * 0.2, function(k)
                    local fx = SpawnPrefab("spawn_fx_small")
                    fx.Transform:SetPosition(k.Transform:GetWorldPosition())
                    k:RemoveFromScene()
                end)
            end
        end
        _OnDespawn(inst, migrationdata, ...)
    end

    local _OnSave = inst.OnSave

    inst.OnSave = function(inst, data)
        data.um_all_followers = inst.um_all_followers
        if _OnSave ~= nil then
            _OnSave(inst, data)
        end
    end

    local _OnLoad = inst.OnLoad

    inst.OnLoad = function(inst, data)
        if data and data.um_all_followers then
            for k, v in pairs(data.um_all_followers) do
                inst:DoTaskInTime(0.2 * math.random(), function(inst)
                    local follower = SpawnSaveRecord(v)
                    inst.components.leader:AddFollower(follower)
                    follower:DoTaskInTime(0, function(follower)
                        if inst:IsValid() and not follower:IsNear(inst, 8) then
                            follower.Transform:SetPosition(
                                inst.Transform:GetWorldPosition())
                            follower.sg:GoToState("idle")
                        end
                    end)
                    local fx = SpawnPrefab("spawn_fx_small")
                    fx.Transform:SetPosition(follower.Transform:GetWorldPosition())
                end)
                data.um_all_followers = {}--empty the table to prevent duping.
            end
        end
        if _OnLoad ~= nil then
            _OnLoad(inst, data)
        end
    end
end)
