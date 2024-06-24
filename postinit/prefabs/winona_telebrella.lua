local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("winona_telebrella", function(inst)
    inst:AddTag("electricaltool")

    if not TheWorld.ismastersim then
        return
    end


    if inst.components.equippable ~= nil then
        local OnEquip_old = inst.components.equippable.onequipfn
        inst.components.equippable.onequipfn = function(inst, owner)
            owner:AddTag("batteryuser")


            if OnEquip_old ~= nil then
                OnEquip_old(inst, owner)
            end
        end

        local OnUnequip_old = inst.components.equippable.onunequipfn
        inst.components.equippable.onunequipfn = function(inst, owner)
            if not owner.UM_isBatteryUser then
                local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

                if item ~= nil then
                    if not item:HasTag("electricaltool") and owner:HasTag("batteryuser") then
                        owner:RemoveTag("batteryuser")
                    end
                else
                    if owner:HasTag("batteryuser") then
                        owner:RemoveTag("batteryuser")
                    end
                end
            end

            if OnUnequip_old ~= nil then
                OnUnequip_old(inst, owner)
            end
        end
    end
end)
