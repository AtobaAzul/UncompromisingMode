local env = env
GLOBAL.setfenv(1, GLOBAL)

local function BossPlayerScan(bossmonster)
    local x, y, z = bossmonster.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 24, { "player" }, { "playerghost" })

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
        --if table.contains(TUNING.DSTU.DYNRES_BOSSES, bossmonster.prefab) then
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
                    if self.inst.damage_res == nil then
                        self.inst.damage_res = 1
                    end
                    self.inst.damage_res = self.inst.damage_res - 0.005
                    local old_damage = damage
                    damage = damage * self.inst.damage_res

                    local min_dmg = 1 - ((NearbyPlayers / 10) - 0.05)
                    if min_dmg <= 0.45 then
                        min_dmg = 0.45
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
