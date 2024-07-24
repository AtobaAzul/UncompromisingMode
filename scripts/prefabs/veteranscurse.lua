-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------
----------------------------------ATTACH---------------------------------
local function ForceToTakeMoreDamage(inst)
    local self = inst.components.combat
    local _GetAttacked = self.GetAttacked
    self.GetAttacked = function(self, attacker, damage, weapon, stimuli, ...)
        if attacker and damage then
            -- Take extra damage
            damage = damage * 1.2
        end
        return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
    end
end

local function ForceToTakeMoreHunger(inst)
    local self = inst.components.hunger
    local _DoDelta = self.DoDelta
    self.DoDelta = function(self, delta, overtime, ignore_invincible)
        if delta and overtime and delta < 0 then
            -- Take extra hunger
            delta = delta * 1.2
        end
        return _DoDelta(self, delta, overtime, ignore_invincible)
    end
end

local function ForceToTakeMoreTime(inst)
    local self = inst.components.oldager
    local _OnTakeDamage = self.OnTakeDamage
    self.OnTakeDamage = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
        if amount and overtime and amount < 0 then
            -- Take extra time
            amount = amount * 1.2
        end
        return _OnTakeDamage(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    end
end

----------------------------------DETACH---------------------------------

local function ForceToTakeUsualDamage(inst)
    local self = inst.components.combat
    local _GetAttacked = self.GetAttacked
    self.GetAttacked = function(self, attacker, damage, weapon, stimuli, ...)
        if attacker and damage then
            -- Take normal damage
            damage = damage / 1.2
        end
        return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
    end
end

local function ForceToTakeUsualHunger(inst)
    local self = inst.components.hunger
    local _DoDelta = self.DoDelta
    self.DoDelta = function(self, delta, overtime, ignore_invincible, ...)
        if delta and overtime and delta < 0 then
            -- Take normal hunger
            delta = delta / 1.2
        end
        return _DoDelta(self, delta, overtime, ignore_invincible, ...)
    end
end

local function ForceToTakeUsualTime(inst)
    local self = inst.components.oldager
    local _OnTakeDamage = self.OnTakeDamage
    self.OnTakeDamage = function(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
        if amount and overtime and amount < 0 then
            -- Take extra time
            amount = amount / 1.2
        end
        return _OnTakeDamage(self, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb, ...)
    end
end

--------------------------------------------------------------------------

local function oneat(inst, data)
    if inst.modded_healthabsorption == nil then
        inst.modded_healthabsorption = inst.components.eater.healthabsorption
    end

    if inst.modded_hungerabsorption == nil then
        inst.modded_hungerabsorption = inst.components.eater.hungerabsorption
    end

    if inst.modded_sanityabsorption == nil then
        inst.modded_sanityabsorption = inst.components.eater.sanityabsorption
    end

    inst.components.eater:SetAbsorptionModifiers(0, inst.modded_hungerabsorption or 1, 0)

    local stack_mult = inst.components.eater.eatwholestack and data.food.components.stackable ~= nil and data.food.components.stackable:StackSize() or 1

    local base_mult = inst.components.foodmemory ~= nil and inst.components.foodmemory:GetFoodMultiplier(data.food.prefab) or 1

    local warlybuff = inst:HasTag("warlybuffed") and 1.2 or 1

    local health_delta = 0
    local sanity_delta = 0
    local hunger_delta = 0

    if inst.components.health ~= nil and
        (data.food.components.edible.healthvalue >= 0 or inst.components.eater:DoFoodEffects(data.food)) then
        health_delta = data.food.components.edible:GetHealth(inst) * base_mult * inst.modded_healthabsorption * warlybuff
    end

    if inst.components.sanity ~= nil and
        (data.food.components.edible.sanityvalue >= 0 or inst.components.eater:DoFoodEffects(data.food)) then
        sanity_delta = data.food.components.edible:GetSanity(inst) * base_mult * inst.modded_sanityabsorption * warlybuff
    end

    if inst.components.eater.custom_stats_mod_fn ~= nil then
        health_delta, hunger_delta, sanity_delta = inst.components.eater.custom_stats_mod_fn(inst, health_delta, hunger_delta, sanity_delta, data.food, data.feeder)
    end

    local foodaffinitysanitybuff = inst:HasTag("playermerm") and (data.food.prefab == "kelp" or data.food.prefab == "kelp_cooked") and 0 or inst.components.foodaffinity:HasPrefabAffinity(data.food) and 15 or 0
    sanity_delta = sanity_delta + foodaffinitysanitybuff

    if health_delta > 3 and not (inst:HasTag("ignores_foodregen") or inst:HasTag("ignores_healthregen")) then
        inst.components.debuffable:AddDebuff("healthregenbuff_vetcurse_" .. data.food.prefab, "healthregenbuff_vetcurse", { duration = (health_delta * 0.1) })
    else
        inst.components.health:DoDelta(health_delta)
    end

    if sanity_delta > 3 and not (inst:HasTag("ignores_foodregen") or inst:HasTag("ignores_healthregen")) then
        inst.components.debuffable:AddDebuff("sanityregenbuff_vetcurse_" .. data.food.prefab, "sanityregenbuff_vetcurse", { duration = (sanity_delta * 0.1) })
    else
        inst.components.sanity:DoDelta(sanity_delta)
    end
end

local function ForceOvertimeFoodEffects(inst)
    if inst.modded_healthabsorption == nil then
        inst.modded_healthabsorption = inst.components.eater.healthabsorption
    end

    if inst.modded_hungerabsorption == nil then
        inst.modded_hungerabsorption = inst.components.eater.hungerabsorption
    end

    if inst.modded_sanityabsorption == nil then
        inst.modded_sanityabsorption = inst.components.eater.sanityabsorption
    end

    inst.components.eater:SetAbsorptionModifiers(0, inst.modded_hungerabsorption or 1, 0)

    inst:ListenForEvent("oneat", oneat)
end

local function ForceUsualFoodEffects(inst)
    inst.components.eater:SetAbsorptionModifiers(inst.modded_healthabsorption, inst.modded_hungerabsorption, inst.modded_sanityabsorption)

    inst:RemoveEventCallback("oneat", oneat)
end

local function ForceWalterCurse_On(inst, target)
    target.walter_vetcurse = true

    target.walter_curse = target:ListenForEvent("attacked", function(target, data)
        if data ~= nil and data.damage ~= nil then
            local attacker = data.attacker.prefab ~= nil and data.attacker.prefab or "_projectile_attack"

            target.components.debuffable:AddDebuff("healthregenbuff_vetcurse_walter_curse" .. attacker, "healthregenbuff_vetcurse_walter_curse", { duration = data.damage * 0.1, negative_value = true })
        end
    end)
end

local function ForceWalterCurse_Off(inst, target)
    if target.walter_curse ~= nil then
        target.walter_curse:Cancel()
    end

    target.walter_curse = nil
    target.walter_vetcurse = nil
end

local function ForceWortoxCurse_On(inst, target)
    target.wortox_vetcurse = true

    target.wortox_curse = target:ListenForEvent("killed", function(target, data)
        if data ~= nil and data.victim ~= nil and data.victim:IsValid() then
            local explosive = SpawnPrefab("gunpowder")
            explosive.Transform:SetPosition(data.victim.Transform:GetWorldPosition())
            explosive.components.burnable:Ignite()

            if data.victim.components.health ~= nil then
                explosive.components.explosive.explosivedamage = data.victim.components.health.maxhealth / 10
            end
        end
    end)
end

local function ForceWortoxCurse_Off(inst, target)
    target:RemoveTag("wortox_vetskull")

    if target.wortox_curse ~= nil then
        target.wortox_curse:Cancel()
    end

    target.wortox_curse = nil
    target.wortox_vetcurse = nil
end

local function ForceMaxwellCurse_On(inst, target)
    target.maxwell_vetcurse = true
    target:AddTag("shambler_target")
    if target.maxwell_shambler == nil then
        local shambler = SpawnPrefab("um_shambler")
        target.maxwell_shambler = shambler
        shambler:LinkToPlayer(target)
        shambler.Transform:SetPosition(target.Transform:GetWorldPosition())
    end
end

local function ForceMaxwellCurse_Off(inst, target)
    target.maxwell_vetcurse = nil
    target:RemoveTag("shambler_target")

    if target.maxwell_shambler ~= nil then
        target.maxwell_shambler.sg:GoToState("disssipate")
    end
end

local function ForceWillowCurse_On(inst, target)
    target.willow_vetcurse = true
    target:AddTag("willow_vetcurse")

    target.willow_curse_check = target:ListenForEvent("sanitydelta", function(target)
        if target.components.sanity ~= nil and target.components.sanity:GetPercent() < 0.4 then
            if target.willow_curse == nil then
                target.willow_curse = target:DoPeriodicTask(1, function(target)
                    if target.components.sanity ~= nil and target.components.sanity:GetPercent() <= 0.4 then
                        local x, y, z = target.Transform:GetWorldPosition()
                        local fires = TheSim:FindEntities(x, y, z, 3, { "um_shadowfire" })

                        if #fires > 0 then
                            fire:AdvanceStage()
                        else
                            SpawnPrefab("um_shadowfire").Transform:SetPosition(x, y, z)
                        end
                    end
                end)
            end
        else
            if target.willow_curse ~= nil then
                target.willow_curse:Cancel()
            end

            target.willow_curse = nil
        end
    end)
end

local function ForceWillowCurse_Off(inst, target)
    target.willow_vetcurse = nil

    if target.willow_curse_check ~= nil then
        target.willow_curse_check:Cancel()
    end

    if target.willow_curse ~= nil then
        target.willow_curse:Cancel()
    end

    target.willow_curse = nil
end

local function ForceWarlyCurse_On(inst, target)
    target.warly_vetcurse = true

    target.warly_curse = target:ListenForEvent("onpreeat", function(target, data)
        if target:HasTag("vetcurse") and data.food ~= nil and data.food.components.edible ~= nil and data.food.components.edible.hungervalue ~= nil then
            local overstuffed = target.components.hunger.current + (data.food.components.edible.hungervalue * target.components.eater.hungerabsorption)
            local maxhunger = target.components.hunger.max
            local clampvalue = overstuffed - maxhunger

            if target.components.grogginess ~= nil then
                if overstuffed > maxhunger then
                    if target.components.grogginess:HasGrogginess() then
                        target.components.talker:Say(GetString(target, "ANNOUNCE_OVER_EAT", "OVERSTUFFED"))
                        target.components.grogginess:MaximizeGrogginess()
                    else
                        target.components.talker:Say(GetString(target, "ANNOUNCE_OVER_EAT", "STUFFED"))
                        local delta = math.clamp(clampvalue / 10, 0.1, 2.9)
                        target.components.grogginess:AddGrogginess(delta)
                    end
                end
            end
        end
    end)
end

local function ForceWarlyCurse_Off(inst, target)
    target.warly_vetcurse = nil

    if target.warly_curse ~= nil then
        target.warly_curse:Cancel()
    end

    target.warly_curse = nil
end

local function ForceWinkyCurse_On(inst, target)
    target.winky_vetcurse = true

    target.winky_curse = target:ListenForEvent("dropitem", function(target)
        target.components.health:DoDelta(-5)
    end)
end

local function ForceWinkyCurse_Off(inst, target)
    target.winky_vetcurse = nil

    if target.winky_curse ~= nil then
        target.winky_curse:Cancel()
    end

    target.winky_curse = nil
end

local function ResetSleepyCD(target)
    target.vetcurse_sleepycd = nil
end

local function ForceWickerbottomCurse_On(inst, target)
    target.wickerbottom_vetcurse = true

    target.wickerbottom_curse = target:DoPeriodicTask(1, function(target)
        if target.vetcurse_sleepiness == nil then
            target.vetcurse_sleepiness = 0
        end

        if target.sg:HasStateTag("sleeping") or
            target.sg:HasStateTag("bedroll") or
            target.sg:HasStateTag("tent") or
            target.sg:HasStateTag("waking") or
            target.sg:HasStateTag("knockout") then
            if target.vetcurse_sleepiness > 0 then
                target.vetcurse_sleepiness = target.vetcurse_sleepiness - (1 / target.components.grogginess:GetResistance())
            elseif target.vetcurse_sleepiness < 0 then
                target.vetcurse_sleepiness = 0
            end
        elseif target.vetcurse_sleepiness < 600 then
            target.vetcurse_sleepiness = target.vetcurse_sleepiness + (1 * target.components.grogginess:GetResistance())
        end

        if target.vetcurse_sleepycd == nil then
            if target.vetcurse_sleepiness > 480 then
                target:PushEvent("yawn", { grogginess = 4, knockoutduration = target.vetcurse_sleepiness / 50 })
            elseif target.vetcurse_sleepiness <= 480 and target.vetcurse_sleepiness > 360 then
                target:PushEvent("yawn", { grogginess = 2, knockoutduration = 0 })
            elseif target.vetcurse_sleepiness <= 360 and target.vetcurse_sleepiness > 280 then
                target:PushEvent("yawn", { grogginess = 0, knockoutduration = 0 })
            end

            if target.vetcurse_sleepiness > 280 then
                target.vetcurse_sleepycd = target:DoTaskInTime(240 / (target.vetcurse_sleepiness / 100), ResetSleepyCD)
            end
        end
    end)
end

local function ForceWickerbottomCurse_Off(inst, target)
    target.wickerbottom_vetcurse = nil

    if target.wickerbottom_curse ~= nil then
        target.wickerbottom_curse:Cancel()
    end

    if target.vetcurse_sleepycd ~= nil then
        target.vetcurse_sleepycd:Cancel()
    end

    target.vetcurse_sleepycd = nil

    target.wickerbottom_curse = nil
end

local SPAWN_DIST = 30

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function GetSpawnPoint(pt)
    if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, NoHoles)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

local function MakeAKrampusForPlayer(player)
    local pt = player:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        local kramp = SpawnPrefab("krampus")
        kramp.Physics:Teleport(spawn_pt:Get())
        kramp:FacePoint(pt)
        kramp.spawnedforplayer = player
        kramp:ListenForEvent("onremove", function() kramp.spawnedforplayer = nil end, player)
        return kramp
    end
end

local function ForceWixieCurse_On(inst, target)
    target.wixie_vetcurse = true

    target.wixie_curse = target:ListenForEvent("killed", function(target, data)
        if data ~= nil and data.victim ~= nil and data.victim.prefab ~= nil then
            local naughtiness = NAUGHTY_VALUE[data.victim.prefab]
            if naughtiness ~= nil then
                if not (data.victim.prefab == "pigman" and
                        data.victim.components.werebeast ~= nil and
                        data.victim.components.werebeast:IsInWereState()) then
                    local naughty_val = FunctionOrValue(naughtiness, target, data)
                    if math.random() > (1 - naughty_val / 50) then
                        MakeAKrampusForPlayer(target)
                    end
                end
            end
        end
    end)
end

local function ForceWixieCurse_Off(inst, target)
    target.wixie_vetcurse = nil

    if target.wixie_curse ~= nil then
        target.wixie_curse:Cancel()
    end

    target.wixie_curse = nil
end

local MUTANT_BIRD_MUST_HAVE = { "bird_mutant" }
local MUTANT_BIRD_MUST_NOT_HAVE = { "INLIMBO" }


local BIRDBLOCKER_TAGS = { "birdblocker" }
local function customcheckfn(pt)
    return #(TheSim:FindEntities(pt.x, 0, pt.z, 4, BIRDBLOCKER_TAGS)) == 0 or false
end

local function SpawnBirds(target, angle, prefab)
    if target and target:IsValid() and not target.components.health:IsDead() then
        local pos = Vector3(target.Transform:GetWorldPosition())
        local bird = SpawnPrefab(prefab)

        local newpos = FindWalkableOffset(pos, angle + (math.random() * PI / 4), 16 + math.random() * 8, 16, nil, nil, customcheckfn, nil, nil)

        if newpos then
            pos = pos + newpos
            pos.y = 15
            bird.Transform:SetPosition(pos.x, pos.y, pos.z)
            bird.components.entitytracker:TrackEntity("swarmTarget", target)
            bird:PushEvent("arrive")

            if prefab == "bird_mutant" then
                bird.components.locomotor.walkspeed = TUNING.MUTANT_BIRD_WALK_SPEED * 3
                bird.components.locomotor.runspeed = TUNING.MUTANT_BIRD_WALK_SPEED * 3
            else
                bird.components.locomotor.walkspeed = TUNING.MUTANT_BIRD_WALK_SPEED * 2
                bird.components.locomotor.runspeed = TUNING.MUTANT_BIRD_WALK_SPEED * 2
            end

            bird:ListenForEvent("isnight", function(bird) bird.components.health:Kill() end)
            bird:ListenForEvent("isday", function(bird) bird.components.health:Kill() end)
        end
    end
end

local function ForceWoodieCurse_On(inst, target)
    target.woodie_vetcurse = true

    target.woodie_curse = target:DoPeriodicTask(15, function(target)
        if TheWorld.state.isdusk and not target.components.health:IsDead() then
            local x, y, z = target.Transform:GetWorldPosition()

            local ents = TheSim:FindEntities(x, y, z, 30, MUTANT_BIRD_MUST_HAVE, MUTANT_BIRD_MUST_NOT_HAVE)

            if #ents < 12 then
                local currentpos = Vector3(target.Transform:GetWorldPosition())
                local angle = math.random() * 2 * PI

                for i = 1, math.random(2, 4) do
                    target:DoTaskInTime(math.random() * 0.5, function() SpawnBirds(target, angle, "bird_mutant") end)
                end
                for i = 1, math.random(1, 2) do
                    target:DoTaskInTime(math.random() * 0.5, function() SpawnBirds(target, angle, "bird_mutant_spitter") end)
                end
            end
        end
    end)
end

local function ForceWoodieCurse_Off(inst, target)
    target.woodie_vetcurse = nil

    if target.woodie_curse ~= nil then
        target.woodie_curse:Cancel()
    end

    target.woodie_curse = nil
end

local skull =
{
    {
        name = "walter_vetskull",
        anim = "idle",
        attachfn = ForceWalterCurse_On,
        detachfn = ForceWalterCurse_Off,
    },
    {
        name = "wortox_vetskull",
        anim = "idle",
        attachfn = ForceWortoxCurse_On,
        detachfn = ForceWortoxCurse_Off,
    },
    {
        name = "maxwell_vetskull",
        anim = "idle",
        attachfn = ForceMaxwellCurse_On,
        detachfn = ForceMaxwellCurse_Off,
    },
    {
        name = "willow_vetskull",
        anim = "idle",
        attachfn = ForceWillowCurse_On,
        detachfn = ForceWillowCurse_Off,
    },
    {
        name = "warly_vetskull",
        anim = "idle",
        attachfn = ForceWarlyCurse_On,
        detachfn = ForceWarlyCurse_Off,
    },
    {
        name = "winky_vetskull",
        anim = "idle",
        attachfn = ForceWinkyCurse_On,
        detachfn = ForceWinkyCurse_Off,
    },
    {
        name = "wickerbottom_vetskull",
        anim = "idle",
        attachfn = ForceWickerbottomCurse_On,
        detachfn = ForceWickerbottomCurse_Off,
    },
    {
        name = "wixie_vetskull",
        anim = "idle",
        attachfn = ForceWixieCurse_On,
        detachfn = ForceWixieCurse_Off,
    },
    {
        name = "woodie_vetskull",
        anim = "idle",
        attachfn = ForceWoodieCurse_On,
        detachfn = ForceWoodieCurse_Off,
    },
}

--[[
Wilson ?
Wendy
WX78
Wolfgang
Woodie
Winona
Wanda
Wormwood
Wurt
Wigfrid
Webber
Wathom

]]

local function AttachCurse(inst, target)
    if target.components.combat ~= nil then
        --target.components.combat.externaldamagemultipliers:SetModifier(inst, .75)    Effect Removed
        target.vetcurse = true

        if target.components ~= nil and target.components.oldager ~= nil then
            ForceToTakeMoreTime(target)
        else
            ForceToTakeMoreDamage(target)
        end

        ForceToTakeMoreHunger(target)
        ForceOvertimeFoodEffects(target)
        target:AddTag("vetcurse")

        target:DoTaskInTime(1, function()
            if target.walter_vetcurse then
                ForceWalterCurse_On(inst, target)
            end

            if target.wortox_vetcurse then
                ForceWortoxCurse_On(inst, target)
            end

            if target.maxwell_vetcurse then
                ForceMaxwellCurse_On(inst, target)
            end
        end)

        target:ListenForEvent("respawnfromghost", function()
            target:DoTaskInTime(3, function(target)
                if TUNING.DSTU.VETCURSE ~= "off" then
                    target.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
                end
            end)
        end, target)

        target:ListenForEvent("ms_playerseamlessswaped", function()
            target:DoTaskInTime(3, function(target)
                if TUNING.DSTU.VETCURSE ~= "off" then
                    target.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
                end
            end)
        end, target)
    end
end

local function DetachCurse(inst, target)
    if target.components.combat ~= nil then
        --target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
        --target.vetcurse = false

        if target.components ~= nil and target.components.oldager ~= nil then --taking a guess thats what her tag is, I swear, I actually don't know
            ForceToTakeUsualTime(target)
        else
            ForceToTakeUsualDamage(target)
        end

        ForceToTakeUsualHunger(target)
        ForceUsualFoodEffects(target)
        target:RemoveTag("vetcurse")


        for i, v in pairs(skull) do
            if target:HasTag(v.name) then
                v.detachfn(inst, target)
            end
        end
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs)
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        --[[inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)]]

        --target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end


    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        --target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff.keepondespawn = true


        return inst
    end

    return Prefab("buff_" .. name, fn, nil, prefabs)
end

local function skull_fn(skull_def)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst:AddTag("vetskull")

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("slingshotammo")
    inst.AnimState:PlayAnimation("idle", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst.skull_effect = skull_def.attachfn

    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/"..skull_def.name..".xml"

    return inst
end

local skull_prefabs = {}
for _, v in ipairs(skull) do
    table.insert(skull_prefabs, Prefab(v.name, function() return skull_fn(v) end --[[, assets, prefabs]]))
end

return MakeBuff("vetcurse", AttachCurse, nil, DetachCurse, nil, 1),
    unpack(skull_prefabs)
