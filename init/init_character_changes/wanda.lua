local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local NOTENTCHECK_CANT_TAGS = { "FX", "INLIMBO" }

if TUNING.DSTU.WANDA_NERF then
    local function DelayedMarkTalker(player)
        -- if the player starts moving right away then we can skip this
        if player.sg == nil or player.sg:HasStateTag("idle") then
            player.components.talker:Say(GetString(player, "ANNOUNCE_POCKETWATCH_MARK"))
        end
    end

    local function noentcheckfn(pt)
        return not TheWorld.Map:IsPointNearHole(pt) and
            #TheSim:FindEntities(pt.x, pt.y, pt.z, 1, nil, NOTENTCHECK_CANT_TAGS) == 0
    end

    env.AddPrefabPostInit("wanda", function(inst)
        if inst.components.combat ~= nil then
            local _CustomCombatDamage = inst.components.combat
                .customdamagemultfn

            local function CustomCombatDamage(inst, target, weapon, multiplier,
                                              mount)
                if mount == nil then
                    if weapon ~= nil and weapon.prefab == "pocketwatch_weapon" and not weapon.components.fueled:IsEmpty() then
                        return inst.age_state == "old" and 102 / 51 or
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
                inst.components.lootdropper:DropLoot()
                SpawnPrefab("brokentool").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst:Remove()
        else
            Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
        end
    end

    env.AddPrefabPostInit("pocketwatch_revive", function(inst)
        if not TheWorld.ismastersim then
            return
        end

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

        -- local _onaccept = inst.components.trader.onaccept

        inst.components.trader.onaccept =
            function(inst, giver, item)
                local portal_watch = SpawnPrefab("pocketwatch_portal")
                portal_watch:onPreBuilt(giver,
                    { pocketwatch_recall = { [inst] = 1 } })

                if inst.dest_name ~= nil then
                    portal_watch.dest_name:set(inst.dest_name:value())
                end

                local container = inst.components.inventoryitem:GetContainer()
                if container ~= nil then
                    local slot = inst.components.inventoryitem:GetSlotNum()
                    inst:Remove()
                    container:GiveItem(portal_watch, slot)
                else
                    local x, y, z = inst.Transform:GetWorldPosition()
                    inst:Remove()
                    portal_watch.Transform:SetPosition(x, y, z)
                end
                portal_watch.SoundEmitter:PlaySound(
                    "dontstarve/common/telebase_gemplace")
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

        inst.components.pocketwatch.DoCastSpell = function(inst, doer, target, pos)
            local recallmark = inst.components.recallmark

            if recallmark:IsMarked() then
                local pt = doer:GetPosition()
                local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 3 + math.random(), 16, false, true,
                        noentcheckfn, true, true)
                    or FindWalkableOffset(pt, math.random() * 2 * PI, 5 + math.random(), 16, false, true, noentcheckfn,
                        true, true)
                    or FindWalkableOffset(pt, math.random() * 2 * PI, 7 + math.random(), 16, false, true, noentcheckfn,
                        true, true)
                if offset ~= nil then
                    pt = pt + offset
                end

                if not Shard_IsWorldAvailable(recallmark.recall_worldid) then
                    return false, "SHARD_UNAVAILABLE"
                end

                local portal = SpawnPrefab("pocketwatch_portal_entrance")
                portal.Transform:SetPosition(pt:Get())
                portal:SpawnExit(recallmark.recall_worldid, recallmark.recall_x, recallmark.recall_y, recallmark
                    .recall_z)
                inst.SoundEmitter:PlaySound("wanda1/wanda/portal_entrance_pre")

                local new_watch = SpawnPrefab("pocketwatch_recall")
                new_watch.components.recallmark:Copy(inst)
                new_watch.dest_name:set(inst.dest_name:value())

                local x, y, z = inst.Transform:GetWorldPosition()
                new_watch.Transform:SetPosition(x, y, z)
                new_watch.components.rechargeable:Discharge(TUNING.POCKETWATCH_RECALL_COOLDOWN)

                local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
                local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
                if holder ~= nil then
                    local slot = holder:GetItemSlot(inst)
                    inst:Remove()
                    holder:GiveItem(new_watch, slot, Vector3(x, y, z))
                else
                    inst:Remove()
                end

                return true
            else
                local x, y, z = doer.Transform:GetWorldPosition()
                recallmark:MarkPosition(x, y, z)
                inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/MarkPosition")

                doer:DoTaskInTime(12 * FRAMES, DelayedMarkTalker)

                return true
            end
        end
    end)
end
