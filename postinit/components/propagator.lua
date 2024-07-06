local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------Fire spread is less efficient in winter-----------------------------------------
local TARGET_CANT_TAGS = { "INLIMBO" }
local TARGET_MELT_MUST_TAGS = { "frozen", "firemelt" }

env.AddComponentPostInit("propagator", function(self)
    local _OldOnUpdate = self.OnUpdate

    function self:OnUpdate(dt)
        if TheWorld.state.season == "winter" and not self.inst.sg then
            self:CalculateHeatCap()

            if self.currentheat > 0 then
                self.currentheat = math.max(0, self.currentheat - dt * self.decayrate)
            elseif self.currentheat < 0 then
                self.currentheat = math.min(0, self.currentheat + dt * self.decayrate)
            end

            local x, y, z = self.inst.Transform:GetWorldPosition()
            local prop_range = TheWorld.state.iswinter and self.propagaterange * TUNING.DSTU.WINTER_FIRE_MOD or self.propagaterange

            if self.spreading then
                local ents = TheSim:FindEntities(x, y, z, prop_range, nil, TARGET_CANT_TAGS)
                if #ents > 0 and prop_range > 0 then
                    local dmg_range = TheWorld.state.iswinter and self.damagerange * TUNING.DSTU.WINTER_FIRE_MOD or self.damagerange
                    local dmg_range_sq = dmg_range * dmg_range
                    local prop_range_sq = prop_range * prop_range
                    local isendothermic = self.inst.components.heater ~= nil and self.inst.components.heater:IsEndothermic()

                    for i, v in ipairs(ents) do
                        if v:IsValid() then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            local dsq = VecUtil_LengthSq(x - vx, z - vz)

                            if v ~= self.inst then
                                if v.components.propagator ~= nil and
                                    v.components.propagator.acceptsheat and
                                    not v.components.propagator.pauseheating then
                                    local percent_heat = math.max(.1, 1 - dsq / prop_range_sq)
                                    v.components.propagator:AddHeat(self.heatoutput * percent_heat * dt, self.inst)
                                end

                                if v.components.freezable ~= nil then
                                    v.components.freezable:AddColdness(-.25 * self.heatoutput * dt)
                                    if v.components.freezable:IsFrozen() and v.components.freezable.coldness <= 0 then
                                        --Skip thawing
                                        v.components.freezable:Unfreeze()
                                    end
                                end

                                if not isendothermic and (v:HasTag("frozen") or v:HasTag("meltable")) then
                                    v:PushEvent("firemelt")
                                    v:AddTag("firemelt")
                                end
                            end

                            if self.damages and
                                --V2C: DST specific (DSV does not check this)--
                                --Affects things with health but not burnable--
                                v.components.propagator ~= nil and
                                -----------------------------------------------
                                dsq < dmg_range_sq and
                                v.components.health ~= nil and
                                --V2C: vulnerabletoheatdamage isn't used, but we'll keep it in case
                                --     for MOD support and make nil default to true to save memory.
                                v.components.health.vulnerabletoheatdamage ~= false then
                                --V2C: Confirmed that distance scaling was intentionally removed as a design decision
                                --local percent_damage = math.min(.5, 1 - math.min(1, dsq / dmg_range_sq))
                                local percent_damage = self.source ~= nil and self.source:HasTag("player") and self.pvp_damagemod or 1
                                v.components.health:DoFireDamage(self.heatoutput * percent_damage * dt)
                            end
                        end
                    end
                end
            else
                if not (self.inst.components.heater ~= nil and self.inst.components.heater:IsEndothermic()) then
                    local ents = TheSim:FindEntities(x, y, z, prop_range, TARGET_MELT_MUST_TAGS)
                    for i, v in ipairs(ents) do
                        v:PushEvent("stopfiremelt")
                        v:RemoveTag("firemelt")
                    end
                end
                if self.currentheat == 0 then
                    self:StopUpdating()
                end
            end
        else
            _OldOnUpdate(self, dt)
        end
    end
end)
