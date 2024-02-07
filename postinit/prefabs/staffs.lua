local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("icestaff", function(inst)
    if not TheWorld.ismastersim then return end
    local _onattack = inst.components.weapon.onattack

    local function OnAttack(inst, attacker, target, skipsanity)
        if attacker:HasTag("wathom") then
            local ret = _onattack(inst, attacker, target, skipsanity)
            local x, y, z = target.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 4, nil, { "player", "playerghost", "notarget", "companion", "abigail", "INLIMBO" })

            if target.components.freezable ~= nil then target.components.freezable:AddColdness(1) end
            for k, v in ipairs(ents) do
                if v ~= target then
                    if v.components.freezable ~= nil then
                        v.components.freezable:AddColdness(2)
                        v.components.freezable:SpawnShatterFX()
                    end
                end
            end
            if target.components.health ~= nil then target.components.health:DoDelta(-34) end
            return ret
        else
            return _onattack(inst, attacker, target, skipsanity)
        end
    end

    inst.components.weapon:SetOnAttack(OnAttack)
end)

env.AddPrefabPostInit("firestaff", function(inst)
    if not TheWorld.ismastersim then return end
    local _onattack = inst.components.weapon.onattack

    local function OnAttack(inst, attacker, target, skipsanity)
        if attacker:HasTag("wathom") then
            local ret = _onattack(inst, attacker, target, skipsanity)
            local x, y, z = target.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 4, { "_health" }, { "player", "playerghost", "notarget", "companion", "abigail", "INLIMBO" })

            for k, v in ipairs(ents) do
                if v ~= target then if v.components.burnable ~= nil then v.components.burnable:Ignite(true, attacker) end end
                if v.components.health ~= nil and not v.components.health:IsDead() and v.components.combat ~= nil then v.components.combat:GetAttacked(attacker, 34, nil) end
            end
            return ret
        else
            return _onattack(inst, attacker, target, skipsanity)
        end
    end

    inst.components.weapon:SetOnAttack(OnAttack)
end)

if env.GetModConfigData("cooldown_orangestaff_") then
    local function onblink(staff, pos, caster)
        if caster and staff.components.rechargeable:IsCharged() then
            if caster.components.staffsanity then
                caster.components.staffsanity:DoCastingDelta(-TUNING.SANITY_MED)
            elseif caster.components.sanity ~= nil then
                caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
            end
            staff.components.rechargeable:Discharge(5)
        else
            staff.components.blinkstaff.blinktask:Cancel()
        end
        staff:RemoveComponent("blinkstaff")
        staff:DoTaskInTime(5, function(inst)
            staff:AddComponent("blinkstaff")
            staff.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
            staff.components.blinkstaff.onblinkfn = onblink
        end)
    end

    env.AddPrefabPostInit("orangestaff", function(inst)
        if not TheWorld.ismastersim then return end
        inst:AddComponent("rechargeable")

        inst:RemoveComponent("finiteuses")
        if inst ~= nil and inst.components.blinkstaff ~= nil then inst.components.blinkstaff.onblinkfn = onblink end
    end)
end

-- TELELOCATOR STAFF STUFF
if env.GetModConfigData("telestaff_rework") then
    local function GetAllActiveTelebases()
        local valid_telebases = {}
        for k, telebase in pairs(Ents) do if telebase.prefab == "telebase" then if telebase.canteleto(telebase) then table.insert(valid_telebases, telebase) end end end
        return valid_telebases
    end

    local ICON_SCALE = .6
    local ICON_RADIUS = 50

    local function getrandomposition(caster, teleportee, target_in_ocean)
        if target_in_ocean then
            local pt = TheWorld.Map:FindRandomPointInOcean(20)
            if pt ~= nil then return pt end
            local from_pt = teleportee:GetPosition()
            local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16) or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16) or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16) or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
            if offset ~= nil then return from_pt + offset end
            return teleportee:GetPosition()
        else
            local centers = {}
            for i, node in ipairs(TheWorld.topology.nodes) do if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then table.insert(centers, { x = node.x, z = node.y }) end end
            if #centers > 0 then
                local pos = centers[math.random(#centers)]
                return Point(pos.x, 0, pos.z)
            else
                return caster:GetPosition()
            end
        end
    end

    local function teleport_end(teleportee, locpos, loctarget, staff)
        if loctarget ~= nil and loctarget:IsValid() and loctarget.onteleto ~= nil then loctarget:onteleto() end

        if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then teleportee.components.inventory:DropItem(teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true) end

        -- #v2c hacky way to prevent lightning from igniting us
        local preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
        if preventburning then teleportee.components.burnable.burning = true end
        TheWorld:PushEvent("ms_sendlightningstrike", locpos)
        if preventburning then teleportee.components.burnable.burning = false end

        if teleportee:HasTag("player") then
            teleportee.sg.statemem.teleport_task = nil
            teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
            teleportee.SoundEmitter:PlaySound(staff.skin_castsound or "dontstarve/common/staffteleport")
        else
            teleportee:Show()
            if teleportee.DynamicShadow ~= nil then teleportee.DynamicShadow:Enable(true) end
            if teleportee.components.health ~= nil then teleportee.components.health:SetInvincible(false) end
            teleportee:PushEvent("teleported")
        end
        -- staff.target_focus = nil
    end

    local function teleport_continue(teleportee, locpos, loctarget, staff)
        if teleportee.Physics ~= nil then
            teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
        else
            teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
        end
        staff.components.finiteuses:Use(teleportee.components.locomotor ~= nil and 3 or teleportee:HasTag("heavy") and 2 or 1)
        if teleportee:HasTag("player") then
            teleportee:SnapCamera()
            teleportee:ScreenFade(true, 1)
            teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, teleport_end, locpos, loctarget, staff)
        else
            teleport_end(teleportee, locpos, loctarget, staff)
        end
    end

    local function teleport_start(teleportee, staff, caster, loctarget, target_in_ocean)
        local ground = TheWorld

        -- V2C: Gotta do this RIGHT AWAY in case anything happens to loctarget or caster
        local locpos = teleportee.components.teleportedoverride ~= nil and teleportee.components.teleportedoverride:GetDestPosition() or loctarget == nil and getrandomposition(caster, teleportee, target_in_ocean) or loctarget.teletopos ~= nil and loctarget:teletopos() or loctarget:GetPosition()

        if teleportee.components.locomotor ~= nil then teleportee.components.locomotor:StopMoving() end

        if ground:HasTag("cave") then
            -- There's a roof over your head, magic lightning can't strike!
            ground:PushEvent("ms_miniquake", { rad = 3, num = 5, duration = 1.5, target = teleportee })
            return
        end

        local isplayer = teleportee:HasTag("player")
        if isplayer then
            teleportee.sg:GoToState("forcetele")
        else
            if teleportee.components.health ~= nil then teleportee.components.health:SetInvincible(true) end
            if teleportee.DynamicShadow ~= nil then teleportee.DynamicShadow:Enable(false) end
            teleportee:Hide()
        end

        -- #v2c hacky way to prevent lightning from igniting us
        local preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
        if preventburning then teleportee.components.burnable.burning = true end
        ground:PushEvent("ms_sendlightningstrike", teleportee:GetPosition())
        if preventburning then teleportee.components.burnable.burning = false end

        if caster ~= nil then
            if caster.components.staffsanity then
                caster.components.staffsanity:DoCastingDelta(teleportee:HasTag("_inventoryitem") and -TUNING.SANITY_HUGE * 0.25 or -TUNING.SANITY_HUGE * 0.5)
            elseif caster.components.sanity ~= nil then
                caster.components.sanity:DoDelta(teleportee:HasTag("_inventoryitem") and -TUNING.SANITY_HUGE * 0.25 or -TUNING.SANITY_HUGE * 0.5)
            end
        end

        if teleportee ~= nil then
            if teleportee.components.staffsanity then
                teleportee.components.staffsanity:DoCastingDelta(-TUNING.SANITY_HUGE / 2)
            elseif teleportee.components.sanity ~= nil then
                teleportee.components.sanity:DoDelta(-TUNING.SANITY_HUGE / 2)
            end
        end

        ground:PushEvent("ms_deltamoisture", TUNING.TELESTAFF_MOISTURE)

        if isplayer then
            teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3, teleport_continue, locpos, loctarget, staff)
        else
            teleport_continue(teleportee, locpos, loctarget, staff)
        end
    end

    local function validteleporttarget(inst) return true end

    function FindNearestActiveTelebase(x, y, z, range, minrange)
        range = (range == nil and math.huge) or (range > 0 and range * range) or 0
        minrange = math.min(range, minrange ~= nil and minrange > 0 and minrange * minrange or 0)
        if minrange < range then
            local mindistsq = math.huge
            local nearest = nil
            for k, v in pairs(TELEBASES) do
                if validteleporttarget(k) then
                    local distsq = k:GetDistanceSqToPoint(x, y, z)
                    if distsq < mindistsq and distsq >= minrange and distsq < range then
                        mindistsq = distsq
                        nearest = k
                    end
                end
            end
            return nearest
        end
    end

    local function teleport_func(inst, target)
        local caster = inst.components.inventoryitem.owner or target
        if target == nil then target = caster end

        local x, y, z = target.Transform:GetWorldPosition()
        local target_in_ocean = target.components.locomotor ~= nil and target.components.locomotor:IsAquatic()

        local loctarget = target.components.minigame_participator ~= nil and target.components.minigame_participator:GetMinigame() or target.components.teleportedoverride ~= nil and target.components.teleportedoverride:GetDestTarget() or target.components.hitchable ~= nil and target:HasTag("hitched") and target.components.hitchable.hitched or nil

        if loctarget == nil and not target_in_ocean then loctarget = inst.target_focus ~= nil and inst.target_focus or FindNearestActiveTelebase(x, y, z, nil, 1) end
        teleport_start(target, inst, caster, loctarget, target_in_ocean)
    end

    local function GetAllValidSpells(inst)
        local spells = {}
        local deselect_spell = {
            widget_scale = ICON_SCALE,
            hit_radius = ICON_RADIUS,
            atlas = inst.target_focus ~= nil and "images/tele_icon1c.xml" or "images/tele_icon1d.xml",
            normal = inst.target_focus ~= nil and "tele_icon1c.tex" or "tele_icon1d.tex",
            label = "Location: Nearest.",
            execute = function(inst)
                inst.target_focus = nil
                SendModRPCToServer(GetModRPC("UncompromisingSurvival", "GetTargetFocus"), nil, inst)
                inst.components.spellbook.items = GetAllValidSpells(inst)
            end,
            onselect = function(inst)
                inst.target_focus = nil
                SendModRPCToServer(GetModRPC("UncompromisingSurvival", "GetTargetFocus"), nil, inst)
                inst.components.spellbook.items = GetAllValidSpells(inst)
            end
        }

        if #GetAllActiveTelebases() < 2 then -- only show
            return spells
        end

        for k, v in pairs(GetAllActiveTelebases()) do
            if not table.contains(spells, deselect_spell) then -- only show deselect spell with focuses
                table.insert(spells, deselect_spell)
            end

            local spell = { widget_scale = ICON_SCALE, hit_radius = ICON_RADIUS }
            spell.target_focus = v

            local skin = spell.target_focus.AnimState:GetBuild()
            spell.atlas = skin == "telebase_hallowpylon" and "images/tele_icon3.xml" or skin == "telebase_crystal" and "images/tele_icon2.xml" or "images/tele_icon1.xml"

            spell.normal = skin == "telebase_hallowpylon" and "tele_icon3.tex" or skin == "telebase_crystal" and "tele_icon2.tex" or "tele_icon1.tex"

            if spell.target_focus == inst.target_focus then
                -- spell.widget_scale = ICON_SCALE * 2

                spell.atlas = skin == "telebase_hallowpylon" and "images/tele_icon3b.xml" or skin == "telebase_crystal" and "images/tele_icon2b.xml" or "images/tele_icon1b.xml"

                spell.normal = skin == "telebase_hallowpylon" and "tele_icon3b.tex" or skin == "telebase_crystal" and "tele_icon2b.tex" or "tele_icon1b.tex"
            end

            if spell.target_focus.spell_location ~= nil then
                spell.label = "Location: " .. (spell.target_focus.custom_location_name ~= nil and spell.target_focus.custom_location_name:value() ~= "" and spell.target_focus.custom_location_name:value() or spell.target_focus.spell_location)
            else
                spell.label = "Location: Unknown."
            end

            spell.execute = function(inst)
                inst.target_focus = spell.target_focus
                inst.components.spellbook.items = GetAllValidSpells(inst)
                inst:DoTaskInTime(0, function(inst)
                    inst.target_focus = spell.target_focus
                    inst.components.spellbook.items = GetAllValidSpells(inst)
                end)
            end

            spell.onselect = function(inst)
                inst.target_focus = spell.target_focus
                SendModRPCToServer(GetModRPC("UncompromisingSurvival", "GetTargetFocus"), inst.target_focus, inst)
                inst.components.spellbook.items = GetAllValidSpells(inst)
                inst:DoTaskInTime(0, function(inst)
                    inst.target_focus = spell.target_focus
                    SendModRPCToServer(GetModRPC("UncompromisingSurvival", "GetTargetFocus"), inst.target_focus, inst)
                    inst.components.spellbook.items = GetAllValidSpells(inst)
                end)
            end

            table.insert(spells, spell)
        end

        return spells
    end

    local function UpdateSpells(inst) inst.components.spellbook.items = GetAllValidSpells(inst) end

    env.AddPrefabPostInit("telestaff", function(inst)
        inst:AddTag("telestaff")
        inst:AddComponent("spellbook")
        inst.components.spellbook.items = GetAllValidSpells(inst)
        --inst.components.spellbook:SetOnOpenFn(UpdateSpells)
        --inst.components.spellbook:SetOnCloseFn(UpdateSpells)

        inst.components.spellbook:SetRequiredTag("telestaff_spellbook_user")

        --inst:ListenForEvent("openspellwheel", UpdateSpells)
        --inst:ListenForEvent("closespellwheel", UpdateSpells)

        if not TheWorld.ismastersim then return end

        if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:SetUses(30)
            inst.components.finiteuses:SetMaxUses(30)
        end

        local _OnUnequip = inst.components.equippable.onunequipfn

        inst.components.equippable.onunequipfn = function(inst, owner)
            if inst.components.spellbook ~= nil then inst.components.spellbook.items = GetAllValidSpells(inst) end
            owner:RemoveTag("telestaff_spellbook_user")
            _OnUnequip(inst, owner)
        end

        inst.components.spellcaster:SetSpellFn(teleport_func)
        inst.components.spellcaster.canonlyuseonlocomotorspvp = nil
        inst.components.spellcaster.can_cast_fn = function(doer, target, pos)
            if target:HasTag("heavy") or target:HasTag("_inventoryitem") or target.components.locomotor ~= nil then return true end
            return nil
        end
        local _OnEquip = inst.components.equippable.onequipfn

        inst.components.equippable.onequipfn = function(inst, owner)
            if inst.components.spellbook ~= nil then inst.components.spellbook.items = GetAllValidSpells(inst) end
            owner:AddTag("telestaff_spellbook_user")
            _OnEquip(inst, owner)
        end
    end)

    local function teleport_target(inst)
        -- nothing!!!
    end

    local function UpdateTelestaffs() for k, v in pairs(Ents) do if v.prefab == "telestaff" then UpdateSpells(v) end end end

    local locations1 = {
        ["The hunters"] = "Triple Mac Tusk",
        ["HermitcrabIsland"] = "Hermit's Island",
        -- ["MoonIsland"] = "Lunar Island",
        ["Make a pick"] = "Spawn Surroundings",
        ["Lightning Bluff"] = "Oasis Desert",
        ["Squeltch"] = "Marsh",
        ["Forest hunters"] = "Forest",
        ["PigKingdom"] = "Pig King",
        ["Speak to the king"] = "Pig King Deciduous",
        ["For a nice walk"] = "Forest",
        ["MooseBreedingTask"] = "Moose Breeding Grounds",
        ["Magic meadow"] = "Meadow",
        ["Badlands"] = "Dragonfly Desert",
        ["Kill the spiders"] = "Spider Quarry Region",
        ["Dig that rock"] = "Mosaic",
        ["Befriend the pigs"] = "Pig Village Surroundings",
        ["Great Plains"] = "Savannah",
        ["PigVillage"] = "Pig Village",
        ["Frogs and bugs"] = "Grasslands",
        ["GiantTrees"] = "Hooded Forest"
    }
    local locations2 = { ["veteranshrine"] = "Veteran's Shrine", ["START"] = "Spawn", ["GiantTrees"] = "Hooded Forest", ["MoonIsland_Mine"] = "Lunar Island", ["MoonIsland_Beach"] = "Lunar Island", ["MoonIsland_Baths"] = "Lunar Island", ["MoonIsland_Forest"] = "Lunar Island", ["DeepDeciduous"] = "Deciduous Forest", ["Killer bees!"] = "Killer Bee Field", ["LightningBluffOasis"] = "Oasis", ["Make a Beehat"] = "Grasslands", ["Mole Colony Rocks"] = "Rocky" }

    local function ParseAreaAwareData(inst)
        if inst.custom_location_name ~= nil and inst.custom_location_name:value() ~= "" then return inst.custom_location_name:value() end

        local x, y, z = inst.Transform:GetWorldPosition()
        local data = inst.components.areaaware:GetCurrentArea()
        if data == nil then inst.components.areaaware:UpdatePosition(x, y, z) end
        data = inst.components.areaaware.current_area_data
        -- hoo boy...
        local _string = "Unknown"

        if data == nil then return "Ocean." end

        local thing1, thing2
        if data.id ~= "START" then
            thing1, thing2 = string.match(data.id, "([^:]+):.+:(.+)$")
            _string = locations2[thing2] or locations1[thing1] or _string
        else
            _string = "Spawn"
        end

        local ret = _string .. "."
        return ret
    end

    local function onhit(inst)
        for k, v in pairs(inst.components.objectspawner.objects) do
            v.AnimState:PlayAnimation("hit_full")
            v.AnimState:PushAnimation("idle_full_loop")
        end
    end

    env.AddPrefabPostInit("telebase", function(inst)
        inst:AddTag("telebase")

        inst.OnRemoveEntity = UpdateTelestaffs

        inst.onteleto = teleport_target
        inst.canteleto = validteleporttarget

        inst:AddComponent("areaaware")
        inst.update_location = function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            inst.components.areaaware:UpdatePosition(x, y, z)
            inst.spell_location = ParseAreaAwareData(inst)
            UpdateTelestaffs()
        end

        inst:DoTaskInTime(0, inst.update_location)

        inst.custom_location_name = net_string(inst.GUID, "custom_location_name")

        if not TheWorld.ismastersim then return end

        inst.components.workable:SetOnWorkCallback(onhit)

        inst.entity:SetCanSleep(false)

        inst:AddComponent("writeable")
        inst:RemoveEventCallback("onbuilt", inst.event_listening.onbuilt[inst][2])
        inst.components.writeable:SetDefaultWriteable(false)
        inst.components.writeable:SetAutomaticDescriptionEnabled(false)

        local _Write = inst.components.writeable.Write
        inst.components.writeable.Write = function(self, doer, text, ...)
            if not text then
                text = self.text
                if doer.tool_prefab then doer.components.inventory:GiveItem(SpawnPrefab(doer.tool_prefab), nil, inst:GetPosition()) end
            else
                inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")
            end

            SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "UpdateAllFocuses"))

            self.inst.custom_location_name:set(text and text ~= "" and text or "")

            UpdateTelestaffs()

            _Write(self, doer, text, ...)
        end

        local _OnLoad = inst.components.writeable.OnLoad
        inst.components.writeable.OnLoad = function(self, ...)
            _OnLoad(self, ...)
            local text = self.text
            self.inst.custom_location_name:set(text and text ~= "" and text or "")
        end
    end)

    -- I basicly have to remake this thing, fun!!

    local function OnGemGiven(inst, giver, item)
        -- inst.SoundEmitter:PlaySound("dontstarve/common/telebase_hum", "hover_loop")
        inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        inst.AnimState:PlayAnimation("idle_full_loop", true)
        inst.components.trader:Disable()
    end

    local function OnLoad(inst, data) end

    local function OnSave(inst, data) end

    local function getstatus(inst) return "VALID" end

    local function ShatterGem(inst)
        inst.SoundEmitter:KillSound("hover_loop")
        inst.AnimState:ClearBloomEffectHandle()
        inst.AnimState:PlayAnimation("shatter")
        inst.AnimState:PushAnimation("idle_empty")
        inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    end

    local function DestroyGem(inst)
        inst.components.trader:Enable()
        inst:DoTaskInTime(math.random() * 0.5, ShatterGem)
    end

    env.AddPrefabPostInit("gemsocket", function(inst)
        inst.teleports = 0

        if not TheWorld.ismastersim then return end

        inst:RemoveComponent("pickable")
        -- I uhh, am lazy?
        inst:DoTaskInTime(1 + math.random(), function(inst)
            OnGemGiven(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("crab_king_shine").Transform:SetPosition(x, y + 1.75, z)
        end)

        inst.components.trader.onaccept = OnGemGiven
        inst.components.inspectable.getstatus = getstatus
        inst.DestroyGemFn = DestroyGem

        inst.OnLoad = OnLoad
        inst.OnSave = OnSave
    end)
end



local function SpikeWaves(inst, target, attacker, angle)
    local target_index = {}
    local ix, iy, iz = inst.Transform:GetWorldPosition()
    local rad = math.rad(angle)
    local velx = math.cos(rad) * 1.25
    local velz = -math.sin(rad) * 1.25
    for i = 1, 5 do
        inst:DoTaskInTime(FRAMES * i * 1.5, function()
            local dx, dy, dz = ix + (i * velx), 0, iz + (i * velz)
            local fx = SpawnPrefab("warg_mutated_ember_fx")
            fx.Transform:SetPosition(dx + math.random(), dy, dz + math.random())
            fx:RestartFX(0.25 + math.random())
            fx:DoTaskInTime(math.random() + 0.5 , fx.KillFX)

            if math.random() > 0.5 then
                local fx2 = SpawnPrefab("warg_mutated_breath_fx")
                fx2.Transform:SetPosition(dx + math.random(), dy, dz + math.random())
                fx2:RestartFX(.25 + math.random())
                fx2:DoTaskInTime(math.random() + 0.5, fx2.KillFX)
                fx2.Transform:SetScale(0.5, 0.5, 0.5)
            end
            inst:DoTaskInTime(.6, function()
                local ents = TheSim:FindEntities(dx, dy, dz, 1.5, { "_health", "_combat" }, { "FX", "NOCLICK", "INLIMBO", "notarget", "player", "playerghost", "companion"})
                for k, v in ipairs(ents) do
                    if  v ~= inst and v.components.combat ~= nil and attacker.components.combat ~= nil and attacker.components.combat:IsValidTarget(v) then
                        v.components.combat:GetAttacked(attacker, 0, nil, nil, { planar = 17.5 })
                    end
                end
            end)
        end)
    end
end

env.AddPrefabPostInit("staff_lunarplant", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    local _onattack = inst.components.weapon.onattack

    local function OnAttack(inst, attacker, target, skipsanity)
        if attacker:HasTag("wathom") then
            inst.components.weapon:SetProjectile(nil)
            local ret = _onattack(inst, attacker, target, skipsanity)

            for angle = -20, 20, 4 do
                SpikeWaves(inst, target, attacker, angle + attacker.Transform:GetRotation())
                target.components.combat:GetAttacked(attacker, 0, nil, nil, { planar = 34 })
            end
            inst.SoundEmitter:PlaySound("rifts/lunarthrall_bomb/explode")

            return ret
        else
            inst.components.weapon:SetProjectile("brilliance_projectile_fx")
            return _onattack(inst, attacker, target, skipsanity)
        end
    end

    inst.components.weapon:SetOnAttack(OnAttack)
end)
