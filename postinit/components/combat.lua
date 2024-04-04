local env = env
GLOBAL.setfenv(1, GLOBAL)

if TUNING.DSTU.WANDA_NERF then
    env.AddComponentPostInit("combat", function(self)
        if not TheWorld.ismastersim then return end

        local _GetAttacked = self.GetAttacked

        function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
            if attacker ~= nil and attacker:HasTag("shadow_aligned") and self.inst.prefab == "wanda" then
                damage = damage * 1.25 -- or whatever mult you want
                return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
            else
                return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
            end
        end
    end)
end

local SpDamageUtil = require("components/spdamageutil")

env.AddComponentPostInit("combat", function(self)
    if not TheWorld.ismastersim then return end

    function self:DoNaughtAttack(targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)
        if instrangeoverride then
            self.temprange = instrangeoverride
        end
        if instpos then
            self.temppos = instpos
        end
        if targ == nil then
            targ = self.target
        end
        if weapon == nil then
            weapon = self:GetWeapon()
        end
        if stimuli == nil then
            if weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overridestimulifn ~= nil then
                stimuli = weapon.components.weapon.overridestimulifn(weapon, self.inst, targ)
            end
            if stimuli == nil and self.inst.components.electricattacks ~= nil then
                stimuli = "electric"
            end
        end

        if not self:CanHitTarget(targ, weapon) or self.AOEarc then
            self.inst:PushEvent("onmissother", { target = targ, weapon = weapon })
            if self.areahitrange ~= nil and not self.areahitdisabled then
                self:DoAreaAttack(projectile or self.inst, self.areahitrange, weapon, self.areahitcheck, stimuli, AREA_EXCLUDE_TAGS)
            end
            self:ClearAttackTemps()
            return
        end

		self.inst:PushEvent("onattackother", { target = targ, weapon = weapon, projectile = projectile, stimuli = stimuli })

        if weapon ~= nil and projectile == nil then
            if weapon.components.projectile ~= nil then
                local projectile = self.inst.components.inventory:DropItem(weapon, false)
                if projectile ~= nil then
                    projectile.components.projectile:Throw(self.inst, targ)
                end
                self:ClearAttackTemps()
                return
            elseif weapon.components.complexprojectile ~= nil and not weapon.components.complexprojectile.ismeleeweapon then
                local projectile = self.inst.components.inventory:DropItem(weapon, false)
                if projectile ~= nil then
                    projectile.components.complexprojectile:Launch(targ:GetPosition(), self.inst)
                end
                self:ClearAttackTemps()
                return
            elseif weapon.components.weapon:CanRangedAttack() then
                weapon.components.weapon:LaunchProjectile(self.inst, targ)
                self:ClearAttackTemps()
                return
            end
        end

        local reflected_dmg = 0
        local reflected_spdmg
        local reflect_list = {}
        if targ.components.combat ~= nil then
            local mult =
                (stimuli == "electric" or
                    (weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.stimuli == "electric")
                )
                and not (targ:HasTag("electricdamageimmune") or
                    (targ.components.inventory ~= nil and targ.components.inventory:IsInsulated()))
                and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (targ.components.moisture ~= nil and targ.components.moisture:GetMoisturePercent() or (targ:GetIsWet() and 1 or 0))
                or 1
            local dmg, spdmg = self:CalcDamage(targ, weapon, mult)
            dmg = (dmg * (instancemult or 1)) / 2
            --Calculate reflect first, before GetAttacked destroys armor etc.
            if projectile == nil then
                reflected_dmg, reflected_spdmg = self:CalcReflectedDamage(targ, dmg, weapon, stimuli, reflect_list, spdmg)
            end
            targ.components.combat:GetAttacked(self.inst, dmg, weapon, stimuli, spdmg)
        elseif projectile == nil then
            reflected_dmg, reflected_spdmg = self:CalcReflectedDamage(targ, 0, weapon, stimuli, reflect_list)
        end

        if weapon ~= nil and not weapon:HasTag("pocketwatch") then
            weapon.components.weapon:OnAttack_NoDurabilityLoss(self.inst, targ, projectile)
        end

        if self.areahitrange ~= nil and not self.areahitdisabled then
            self:DoAreaAttack(targ, self.areahitrange, weapon, self.areahitcheck, stimuli, AREA_EXCLUDE_TAGS)
        end
        self:ClearAttackTemps()
        self.lastdoattacktime = GetTime()

        --Apply reflected damage to self after our attack damage is completed
        if (reflected_dmg > 0 or reflected_spdmg ~= nil) and self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
            self:GetAttacked(targ, reflected_dmg, nil, nil, reflected_spdmg)
            for i, v in ipairs(reflect_list) do
                if v.inst:IsValid() then
                    v.inst:PushEvent("onreflectdamage", v)
                end
            end
        end
    end

    local _GetAttacked = self.GetAttacked

    function self:GetAttacked(attacker, damage, weapon, stimuli, spdamage, ...)
        if self.inst:HasTag("take_extra_spdamage") and attacker ~= nil and not attacker:HasTag("player") and attacker.components.health ~= nil and attacker.components.combat ~= nil  then
            --type check to not crash mods that pass spdamage as something other than actual spdamage.
            if spdamage ~= nil and type(spdamage) == "table" and spdamage.planar ~= nil then
                spdamage.planar = spdamage.planar + 10
            else
                spdamage = {planar = 10}
            end
        end

        local weapon_check = weapon ~= nil and weapon:IsValid() and weapon or nil

        if stimuli ~= nil and stimuli == "fire" and self.inst.components.health ~= nil and self.inst.components.health:GetFireDamageScale() ~= nil then
            damage = damage * self.inst.components.health:GetFireDamageScale()
        end

        local damageredirecttarget = self.redirectdamagefn ~= nil and self.redirectdamagefn(self.inst, attacker, damage, weapon_check, stimuli) or nil

        local redirect_combat = damageredirecttarget ~= nil and damageredirecttarget.components.combat or nil
        if redirect_combat ~= nil and TUNING.DSTU.BEEFALO_NERF then
            if self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
                redirect_combat:GetAttacked(attacker, damage, weapon_check, stimuli)
                return _GetAttacked(self, attacker, damage / 2, weapon_check, "beefalo_half_damage", ...) -- added new stimuli to prevent Stackoverflow
            else
                redirect_combat:GetAttacked(attacker, damage, weapon_check, stimuli)
            end
        end

        if (self.inst ~= nil and (self.inst.prefab == "crabking" or self.inst.prefab == "crabking_claw") and attacker ~= nil and (attacker.prefab == "cannonball_rock" or attacker.prefab == "cannonball_sludge")) and env.GetModConfigData("reworked_ck") then
            damage = damage * (attacker.prefab == "cannonball_rock" and 4 or attacker.prefab == "cannonball_sludge" and 3)
            if self.inst.attack_count ~= nil then self.inst.attack_count = math.clamp(self.inst.attack_count - 1, 0, 10) end

            if self.inst.finishfixing ~= nil then self.inst.finishfixing(self.inst) end

            if self.inst.prefab == "crabking_claw" then
                local crab = FindEntity(self.inst, 30, nil, { "crabking" })
                if crab ~= nil and crab.finishfixing ~= nil then crab.finishfixing(crab) end
            end

            return _GetAttacked(self, attacker, damage, weapon_check, stimuli)
        elseif self.inst ~= nil and self.inst:HasTag("wathom") and self.inst.AmpDamageTakenModifier ~= nil and damage and (self.inst.components.rider ~= nil and not self.inst.components.rider:IsRiding() or self.inst.components.rider == nil) and TUNING.DSTU.WATHOM_ARMOR_DAMAGE then
            -- Take extra damage
            damage = damage * self.inst.AmpDamageTakenModifier
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli)
        elseif self.inst ~= nil and self.inst.components.upgrademoduleowner and damage and (self.inst.components.rider ~= nil and not self.inst.components.rider:IsRiding() or self.inst.components.rider == nil) and TUNING.DSTU.WXLESS then
            -- Hardy circuit flat damage reduction
            local cherry_mult = 1 --cherry forest circuit compat
	    local cherry_mult2 = 1
	    if self.inst._cherriftchips and self.inst._cherriftchips > 0 then
	        cherry_mult = 1 + 0.5*self.inst._cherriftchips
	        cherry_mult2 = 1 + 0.25*self.inst._cherriftchips
	    end
            local hpmodulereduct = self.inst.components.upgrademoduleowner:GetModuleTypeCount('maxhealth') * 2 * cherry_mult + self.inst.components.upgrademoduleowner:GetModuleTypeCount('maxhealth2') * 5 * cherry_mult2
            damage = damage - hpmodulereduct
            if damage < 2 then damage = 2 end
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        elseif self.inst ~= nil and attacker ~= nil and attacker:HasTag("wathom") and TUNING.DSTU.WATHOM_MAX_DAMAGE_CAP then
            if damage > 600 then damage = 600 end
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
            --elseif self.inst ~= nil and (self.inst.prefab == "bernie_active" or self.inst.prefab == "bernie_big") and attacker ~= nil and attacker:HasTag("shadow") and TUNING.DSTU.BERNIE_BUFF then
            --damage = damage * 0.2
            --return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        elseif self.inst:HasTag("ratwhisperer") and attacker ~= nil and attacker.prefab == "catcoon" and self.inst.components.health ~= nil then
            self.inst.components.health:DoDelta(-10, false, attacker.prefab)
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        end


            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, spdamage, ...)
    end
end)
