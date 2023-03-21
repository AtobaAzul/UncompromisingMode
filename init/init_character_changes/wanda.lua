local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if TUNING.DSTU.WANDA_NERF then
    env.AddPrefabPostInit("wanda", function(inst)
        if inst.components.combat ~= nil then
            local _CustomCombatDamage = inst.components.combat
                .customdamagemultfn

            local function CustomCombatDamage(inst, target, weapon, multiplier,
                                              mount)
                if mount == nil then
                    if weapon ~= nil and weapon.prefab == "pocketwatch_weapon" then
                        return inst.age_state == "old" and 127.5 / 51 or
                            inst.age_state == "normal" and 68 / 51 or 1
                    end
                    return _CustomCombatDamage(inst, target, weapon, multiplier,
                        mount)
                end
            end

            inst.components.combat.customdamagemultfn = CustomCombatDamage
        end
    end)

    local function Revive_CanTarget(inst, doer, target)
        -- This is a client side function
        return target ~= nil and target:HasTag("playerghost") and
            not target:HasTag("reviving")
    end

    local function Revive_DoCastSpell(inst, doer, target)
        if Revive_CanTarget(inst, doer, target) and
            inst.components.pocketwatch.inactive then
            if target.last_death_shardid ~= nil and target.last_death_shardid ~=
                TheShard:GetShardId() then
                -- if the player is about to get teleported to another shard, give them this item so they will revive on the other side
                target.components.inventory:GiveItem(SpawnPrefab(
                    "pocketwatch_revive_reviver"))
            end

            target:PushEvent("respawnfromghost",
                { source = inst, from_haunt = doer == target })
            if target.components.health ~= nil and
                target.components.health:GetPenaltyPercent() < 0.75 then
                target.components.health:DeltaPenalty(0.25)
            end
            inst.components.rechargeable:Discharge(
                TUNING.POCKETWATCH_REVIVE_COOLDOWN)
            return true
        end

        return false, "REVIVE_FAILED"
    end

    local function Revive_OnHaunt(inst, haunter)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        if haunter:HasTag("pocketwatchcaster") and
            inst.components.pocketwatch:CastSpell(haunter, haunter) then
            -- NOTHING! Enjoy the cooldown...
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

        if owner.components.health ~= nil and
            owner.components.health:GetPenaltyPercent() < 0.75 then
            owner.components.health:DeltaPenalty(0.25)
        end
    end

    env.AddPrefabPostInit("pocketwatch_revive_reviver", function(inst)
        if not TheWorld.ismastersim then return end

        inst:DoTaskInTime(0, reviver_DoPenalty)
    end)

    env.AddPrefabPostInit("pocketwatch_recall", function(inst)
        inst.dest_name = net_string(inst.GUID, "dest_name")

        inst.displaynamefn = function(_inst)
            local name = _inst.dest_name:value()
            return name ~= "" and name ~= nil and
                STRINGS.NAMES[string.upper(_inst.prefab)] .. "\n\"" ..
                name .. "\"" or STRINGS.NAMES[string.upper(_inst.prefab)]
        end

        if not TheWorld.ismastersim then return end

        inst:AddComponent("writeable")
        inst.components.writeable:SetDefaultWriteable(false)
        inst.components.writeable:SetAutomaticDescriptionEnabled(false)
        local _Write = inst.components.writeable.Write
        inst.components.writeable.Write =
            function(self, doer, text, ...)
                if not text then
                    text = self.text
                    if doer and doer.tool_prefab then
                        doer.components.inventory:GiveItem(SpawnPrefab(doer.tool_prefab), nil, inst:GetPosition())
                    end
                else
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")
                end

                inst.dest_name:set(text and text ~= "" and text or "")

                _Write(self, doer, text, ...)
            end

        local _OnLoad = inst.components.writeable.OnLoad
        inst.components.writeable.OnLoad = function(self, ...)
            _OnLoad(self, ...)
            local text = self.text
            inst.dest_name:set(text and text ~= "" and text or "")
        end
    end)

    env.AddPrefabPostInit("pocketwatch_portal", function(inst)
        inst.dest_name = net_string(inst.GUID, "dest_name")

        inst.displaynamefn = function(_inst)
            local name = _inst.dest_name:value()
            return name ~= "" and name ~= nil and
                STRINGS.NAMES[string.upper(_inst.prefab)] .. "\n\"" ..
                name .. "\"" or STRINGS.NAMES[string.upper(_inst.prefab)]
        end

        if not TheWorld.ismastersim then return end

        inst:AddComponent("writeable")
        inst.components.writeable:SetDefaultWriteable(false)
        inst.components.writeable:SetAutomaticDescriptionEnabled(false)
        local _Write = inst.components.writeable.Write
        inst.components.writeable.Write =
            function(self, doer, text, ...)
                if not text then
                    text = self.text
                    if doer and doer.tool_prefab then
                        doer.components.inventory:GiveItem(SpawnPrefab(doer.tool_prefab), nil, inst:GetPosition())
                    end
                else
                    inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")
                end

                inst.dest_name:set(text and text ~= "" and text or "")
                _Write(self, doer, text, ...)
            end

        local _OnLoad = inst.components.writeable.OnLoad
        inst.components.writeable.OnLoad = function(self, ...)
            _OnLoad(self, ...)
            local text = self.text
            inst.dest_name:set(text and text ~= "" and text or "")
        end
    end)
end
