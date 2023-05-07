local env = env
GLOBAL.setfenv(1, GLOBAL)

if TUNING.DSTU.WANDA_NERF then
    env.AddComponentPostInit("combat", function(self)
        if not TheWorld.ismastersim then return end

        local _GetAttacked = self.GetAttacked

        function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
            if attacker ~= nil and attacker:HasTag("shadow_aligned") and self.inst.prefab == "wanda" then
                damage = damage * 1.2 -- or whatever mult you want
                return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
            else
                return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
            end
        end
    end)
end

env.AddComponentPostInit("combat", function(self)
    if not TheWorld.ismastersim then return end

    local _GetAttacked = self.GetAttacked

    function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
        local weapon_check = weapon ~= nil and weapon:IsValid() and weapon or nil

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
                local crab = FindEntity(self.inst, 30, nil, {"crabking"})
                if crab ~= nil and crab.finishfixing ~= nil then crab.finishfixing(crab) end
            end

            return _GetAttacked(self, attacker, damage, weapon_check, stimuli)
        elseif self.inst ~= nil and self.inst:HasTag("wathom") and self.inst.AmpDamageTakenModifier ~= nil and damage and (self.inst.components.rider ~= nil and not self.inst.components.rider:IsRiding() or self.inst.components.rider == nil) and TUNING.DSTU.WATHOM_ARMOR_DAMAGE then
            -- Take extra damage
            damage = damage * self.inst.AmpDamageTakenModifier
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli)
        elseif self.inst ~= nil and attacker ~= nil and attacker:HasTag("wathom") and TUNING.DSTU.WATHOM_MAX_DAMAGE_CAP then
            if damage > 600 then damage = 600 end
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        elseif self.inst ~= nil and (self.inst.prefab == "bernie_active" or self.inst.prefab == "bernie_big") and attacker ~= nil and attacker:HasTag("shadow") and TUNING.DSTU.BERNIE_BUFF then
            damage = damage * 0.2
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        elseif self.inst:HasTag("ratwhisperer") and attacker ~= nil and attacker.prefab == "catcoon" and self.inst.components.health ~= nil then
            self.inst.components.health:DoDelta(-10, false, attacker.prefab)
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        else
            return _GetAttacked(self, attacker, damage, weapon_check, stimuli, ...)
        end
    end
end)
