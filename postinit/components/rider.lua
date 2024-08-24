local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("rider", function(self)
    local _Mount = self.Mount

    function self:Mount(target, instant, ...)
        local ret = _Mount(self, target, instant, ...)

        -- If only Mount() returned if the mount was successful or not.
        if target.components.combat == nil
            or not target.components.rideable:TestObedience()
            or not target.components.rideable:TestRider(self.inst)
            or self.riding
            or target.components.rideable == nil
            or target.components.rideable:IsBeingRidden() then
            return ret
        end

        self.inst.components.combat.redirectdamagefn =
            function(inst, attacker, damage, weapon, stimuli)
                return target:IsValid()
                    and not (target.components.health ~= nil and target.components.health:IsDead())
                    and not (weapon ~= nil and (
                        weapon.components.projectile ~= nil or
                        weapon.components.complexprojectile ~= nil or
                        weapon.components.weapon ~= nil and weapon.components.weapon:CanRangedAttack()
                    ))
                    and stimuli ~= "electric"
                    and stimuli ~= "darkness"
                    and stimuli ~= "beefalo_half_damage"
                    and target
                    or nil
            end

        return ret
    end
end)
