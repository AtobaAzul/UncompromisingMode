local env = env
GLOBAL.setfenv(1, GLOBAL)

if TUNING.DSTU.WANDA_NERF then
    env.AddComponentPostInit("combat", function(self)
        if not TheWorld.ismastersim then return end

        local _GetAttacked = self.GetAttacked

        function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
            if attacker ~= nil and attacker:HasTag("shadow") and self.inst.prefab == "wanda" then
                damage = damage * 1.2 --or whatever mult you want
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
        local damageredirecttarget = self.redirectdamagefn ~= nil and self.redirectdamagefn(self.inst, attacker, damage, weapon, stimuli) or nil

        local redirect_combat = damageredirecttarget ~= nil and damageredirecttarget.components.combat or nil
        if redirect_combat ~= nil and TUNING.DSTU.BEEFALO_NERF then
            if self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
                print("health not nil and not dead")
                redirect_combat:GetAttacked(attacker, damage, weapon, stimuli)
                return _GetAttacked(self, attacker, damage/2, weapon, "beefalo_half_damage", ...)--added new stimuli to prevent Stackoverflow
            else
                print("health nil and/or dead")
                redirect_combat:GetAttacked(attacker, damage, weapon, stimuli)
            end
        end
        if self.inst ~= nil and self.inst:HasTag("wathom") and self.inst.AmpDamageTakenModifier ~= nil and damage and (self.inst.components.rider ~= nil and not self.inst.components.rider:IsRiding() or self.inst.components.rider == nil) and TUNING.DSTU.WATHOM_ARMOR_DAMAGE then
            -- Take extra damage
            damage = damage * self.inst.AmpDamageTakenModifier
            return _GetAttacked(self, attacker, damage, weapon, stimuli)
        elseif self.inst ~= nil and attacker ~= nil and attacker:HasTag("wathom") and TUNING.DSTU.WATHOM_MAX_DAMAGE_CAP then
            if damage > 600 then
                damage = 600
            end
            return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
        elseif self.inst ~= nil and (self.inst.prefab == "bernie_active" or self.inst.prefab == "bernie_big") and attacker ~= nil and attacker:HasTag("shadow") then
            damage = damage * 0.2
            return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
        elseif self.inst:HasTag("ratwhisperer") and attacker ~= nil and attacker.prefab == "catcoon"  then
            damage = damage + 10
            return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
        else
            return _GetAttacked(self, attacker, damage, weapon, stimuli, ...)
        end
    end
end)