local env = env
GLOBAL.setfenv(1, GLOBAL)

local function BossPlayerScan(bossmonster)
    local x, y, z = bossmonster.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 16, {"player"}, {"playerghost"})

    return #ents
end

env.AddComponentPostInit("combat", function(self)
    if not TheWorld.ismastersim then
        return
    end

    local vanillaGetAttacked = self.GetAttacked

    function self:GetAttacked(attacker, damage, weapon, stimuli, ...)
        local bossmonster = self.inst
        local NearbyPlayers = BossPlayerScan(bossmonster)

        if self.inst ~= nil and self.inst:HasTag("epic") and attacker:HasTag("player") and not (self.inst.prefab == "toadstool" or (weapon ~= nil and (weapon.prefab == "blowdart_pipe" or weapon.prefab == "ruins_bat" or weapon:HasTag("slingshot") or weapon.prefab == "fence_rotator" or weapon:HasTag("vetcurse_item")))) then
            if NearbyPlayers <= 1 then
                return vanillaGetAttacked(self, attacker, damage, weapon, stimuli, ...)
            else
                if NearbyPlayers >= 10 then
                    NearbyPlayers = 10
                end

                if TUNING.DSTU.BOSS_RESISTANCE == "static" then
                    -- print("static")
                    damage = damage * math.pow(0.95, NearbyPlayers)
                elseif TUNING.DSTU.BOSS_RESISTANCE == "dynamic" then
                    -- TODO: config options for numbers...
                    self.inst.damage_res = self.inst.damage_res - 0.005
                    local old_damage = damage
                    damage = damage * self.inst.damage_res

                    local min_dmg = 1 - (NearbyPlayers / 10) -- maybe?
                    if min_dmg <= 0.25 then
                        min_dmg = 0.25
                    end

                    if damage < old_damage * min_dmg then
                        damage = old_damage * min_dmg
                    end
                end

                return vanillaGetAttacked(self, attacker, damage, weapon, stimuli, ...)
            end
        else
            return vanillaGetAttacked(self, attacker, damage, weapon, stimuli, ...)
        end
    end
end)

env.AddPrefabPostInitAny(function(inst)
    if inst:HasTag("epic") then
        inst:DoPeriodicTask(10, BossPlayerScan, 0, inst)

        inst.damage_res = 1
        inst:DoPeriodicTask(2.5, function(inst)
            inst.damage_res = inst.damage_res + 0.005 -- periodic damage res reduction
            if inst.damage_res > 1 then
                inst.damage_res = 1
            end
        end)
    end
end)
