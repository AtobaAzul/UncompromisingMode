local env = env
GLOBAL.setfenv(1, GLOBAL)

local function ApplySkillsChanges(inst, owner)
    local _skilltreeupdater = owner.components.skilltreeupdater

    if _skilltreeupdater == nil then
        return
    end


    local skill_level = owner.components.skilltreeupdater:CountSkillTag("spearcondition")

    if skill_level > 0 and owner.components.efficientuser ~= nil then
        local useMult = (1 - (0.1 * skill_level))
        owner.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, useMult, "wathgrithrspear")
    end

    --[[
    local skill_level = owner.components.skilltreeupdater:CountSkillTag("inspirationgain")

    if skill_level > 0 and owner.components.singinginspiration ~= nil then
        owner.components.singinginspiration.gainratemultipliers:SetModifier(inst, TUNING.SKILLS.WATHGRITHR.INSPIRATION_GAIN_MULT[skill_level], "arsenal_spear")
    end

	
    if not inst.is_lightning_spear then
        return
    end

    if inst.components.rechargeable:IsCharged() and _skilltreeupdater:IsActivated("wathgrithr_arsenal_spear_4") then
        inst.components.aoetargeting:SetEnabled(true)
    end
	]]
end

local function RemoveSkillsChanges(inst, owner)
    if owner.components.efficientuser ~= nil then
        owner.components.efficientuser:RemoveMultiplier(ACTIONS.ATTACK, "wathgrithrspear")
    end

    --[[
    if owner.components.singinginspiration ~= nil then
        owner.components.singinginspiration.gainratemultipliers:RemoveModifier(inst, "arsenal_spear")
    end
	]]

    if not inst.is_lightning_spear then
        return
    end

    inst.components.aoetargeting:SetEnabled(false)
end

env.AddPrefabPostInit("spear_wathgrithr", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if env.GetModConfigData("wathgrithr_rework") then
        inst.ApplySkillsChanges  = ApplySkillsChanges
        inst.RemoveSkillsChanges = RemoveSkillsChanges
    end
end)

-------------------------------------------------------------------------------------------------------

local function Lightning_OnLunged(inst, doer, startingpos, targetpos)
    local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx")
    fx.Transform:SetPosition(targetpos:Get())
    fx.Transform:SetRotation(doer:GetRotation())

    inst.components.rechargeable:Discharge(inst._cooldown)

    inst._lunge_hit_count = nil

    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:Use(TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_USES)
    end
end

local function Lightning_OnLungedHit(inst, doer, target)
    inst._lunge_hit_count = inst._lunge_hit_count or 0

    if inst._lunge_hit_count < TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_MAX_HITS and
        doer.IsValidVictim ~= nil and
        doer.IsValidVictim(target)
    then
        inst.components.finiteuses:Use(TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_ONHIT_USES)
        inst._lunge_hit_count = inst._lunge_hit_count + 1
    end
end

env.AddPrefabPostInit("spear_wathgrithr_lightning", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    if env.GetModConfigData("wathgrithr_arsenal") then
        inst.components.aoeweapon_lunge:SetOnLungedFn(Lightning_OnLunged)
        inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)
    end
end)


-------------------------------------------------------------------------------------------------------


local function Strike(owner)
    --onlightningground(inst)

    if owner ~= nil then
        local fx = SpawnPrefab("electrichitsparks")

        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
        --fx.Transform:SetScale(.66, .66, .66)
        local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        item.components.fueled:DoDelta(TUNING.MED_FUEL)
        item.components.fueled.ontakefuelfn(item, TUNING.SMALL_FUEL)
        if item.components.fueled:GetPercent() > 1 then
            item.components.fueled:SetPercent(1)
        end

    end
end

local function onlightningground(inst)
    inst.components.fueled:DoDelta(TUNING.MED_FUEL)
    inst.components.fueled.ontakefuelfn(inst, TUNING.SMALL_FUEL)
    if inst.components.fueled:GetPercent() > 1 then
        inst.components.fueled:SetPercent(1)
    end
end


env.AddPrefabPostInit("spear_wathgrithr_lightning_charged", function(inst)
    inst:AddTag("electricaltool")

    if not TheWorld.ismastersim then
        return
    end

    if env.GetModConfigData("wathgrithr_arsenal") then

        inst:AddTag("lightningrod")
        inst:ListenForEvent("lightningstrike", onlightningground)

        inst.components.aoeweapon_lunge:SetOnLungedFn(Lightning_OnLunged)
        inst.components.aoeweapon_lunge:SetOnHitFn(Lightning_OnLungedHit)

        if inst.components.equippable ~= nil then
            local OnEquip_old = inst.components.equippable.onequipfn
            inst.components.equippable.onequipfn = function(inst, owner)
                owner:AddTag("batteryuser")

                owner.lightningpriority = 0
                owner:ListenForEvent("lightningstrike", Strike, owner)
                owner:RemoveTag("lightningrod")
                owner.lightningpriority = nil
                owner:RemoveEventCallback("lightningstrike", Strike)
                        

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
    end
end)
