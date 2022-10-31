local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if TUNING.DSTU.WANDA_NERF then
    env.AddPrefabPostInit("wanda", function(inst)
        if inst.components.combat ~= nil then
            local _CustomCombatDamage = inst.components.combat.customdamagemultfn

            local function CustomCombatDamage(inst, target, weapon, multiplier, mount)
                if mount == nil then
                    if weapon ~= nil and weapon.prefab == "pocketwatch_weapon" then
                        return inst.age_state == "old" and 127.5 / 51 or
                            inst.age_state == "normal" and 68 / 51 or 1
                    end
                    return _CustomCombatDamage(inst, target, weapon, multiplier, mount)
                end
            end

            inst.components.combat.customdamagemultfn = CustomCombatDamage
        end
    end)

    local function Revive_CanTarget(inst, doer, target)
        -- This is a client side function
        return target ~= nil and target:HasTag("playerghost") and not target:HasTag("reviving")
    end

    local function Revive_DoCastSpell(inst, doer, target)
        if Revive_CanTarget(inst, doer, target) and inst.components.pocketwatch.inactive then
            if target.last_death_shardid ~= nil and target.last_death_shardid ~= TheShard:GetShardId() then
                -- if the player is about to get teleported to another shard, give them this item so they will revive on the other side
                target.components.inventory:GiveItem(SpawnPrefab("pocketwatch_revive_reviver"))
            end

            target:PushEvent("respawnfromghost", { source = inst, from_haunt = doer == target })
            if target.components.health ~= nil and target.components.health:GetPenaltyPercent() < 0.75 then
                target.components.health:DeltaPenalty(0.25)
            end
            inst.components.rechargeable:Discharge(TUNING.POCKETWATCH_REVIVE_COOLDOWN)
            return true
        end

        return false, "REVIVE_FAILED"
    end

    local function Revive_OnHaunt(inst, haunter)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        if haunter:HasTag("pocketwatchcaster") and inst.components.pocketwatch:CastSpell(haunter, haunter) then
            --NOTHING! Enjoy the cooldown...
        else
            Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
        end
    end

    env.AddPrefabPostInit("pocketwatch_revive", function(inst)
        if inst.components.pocketwatch ~= nil then
            inst.components.pocketwatch.DoCastSpell = Revive_DoCastSpell
        end
        if inst.components.hauntable ~= nil then
            inst.components.hauntable:SetOnHauntFn(Revive_OnHaunt)
        end
    end)

    local function reviver_DoPenalty(inst)
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner == nil or not owner:HasTag("playerghost") then
            inst:Remove()
            return
        end
        if owner.components.health ~= nil and owner.components.health:GetPenaltyPercent() < 0.75 then
            owner.components.health:DeltaPenalty(0.25)
        end
    end

    env.AddPrefabPostInit("pocketwatch_revive_reviver", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0, reviver_DoPenalty)
    end)
end
