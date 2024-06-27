local env = env
GLOBAL.setfenv(1, GLOBAL)
local easing = require("easing")

env.AddPrefabPostInit("boat_rotator", function(inst)
    inst:AddTag("boatrotator") -- They removed this during the beta, guh
end)

--This will apply 50% more rowing force when the boat is a portable raft

env.AddComponentPostInit("boatphysics", function(self)
    function self:GetBoatRotatorDrag()
        local x, y, z = self.inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.BOAT.RADIUS)
        local masts = TheSim:FindEntities(x, y, z, TUNING.BOAT.RADIUS, { "mast" })
        local has_rotator = false
        local has_active_mast = false

        for k, v in ipairs(masts) do
            if v.prefab == "mast_malbatross" and v:HasTag("saillowered") or v.prefab == "mast" and v:HasTag("sailraised") then --kgjrnsgndf I hate that the malb mast ends up with diff tags.
                has_active_mast = true
            end
        end

        -- look for the rotator
        if ents and #ents > 0 then --a little worried about this since it runs on update.
            for i, ent in ipairs(ents) do
                if ent:GetCurrentPlatform() and ent:GetCurrentPlatform() == self.inst then
                    if ent:HasTag("boatrotator") then
                        has_rotator = true
                    end
                end
            end
        end

        if has_rotator and has_active_mast then
            local vel_x, vel_z = VecUtil_NormalizeNoNaN(self.velocity_x, self.velocity_z)
            local tar_x, tar_z = VecUtil_NormalizeNoNaN(self.target_rudder_direction_x, self.target_rudder_direction_z)

            local diff_x, diff_z = VecUtil_Sub(vel_x, vel_z, tar_x, tar_z)

            local diff_mean = (math.abs(diff_x) + math.abs(diff_z))

            return (diff_mean + 1) * 2 --+1 since it's a multiplier
        end

        return 1
    end

    local _OnUpdate = self.OnUpdate

    function self:OnUpdate(dt)
        _OnUpdate(self, dt)
    end

    local _GetBoatDrag = self.GetBoatDrag

    function self:GetBoatDrag(velocity, total_anchor_drag, ...)
        return _GetBoatDrag(self, velocity, total_anchor_drag, ...) * self:GetBoatRotatorDrag()
    end

    local _OldApplyRowForce = self.ApplyRowForce

    function self:ApplyRowForce(dir_x, dir_z, force, max_velocity)
        if self.inst:HasTag("portableraft") then
            force = force * 1.25

            local dir_normal_x, dir_normal_z = VecUtil_NormalizeNoNaN(dir_x, dir_z)
            local velocity_normal_x, velocity_normal_z = VecUtil_NormalizeNoNaN(self.velocity_x, self.velocity_z)
            local force_dir_modifier = math.max(0,
                VecUtil_Dot(velocity_normal_x, velocity_normal_z, dir_normal_x, dir_normal_z))

            local base_dampening = self:GetForceDampening()

            if force_dir_modifier > 0 then
                local dir_length = VecUtil_Length(dir_normal_x, dir_normal_z)

                local forward_dir_length = dir_length * force_dir_modifier
                local side_dir_length = dir_length * (1 - force_dir_modifier)

                local velocity_left_normal_x, velocity_left_normal_z = velocity_normal_z, -velocity_normal_x
                local is_left = VecUtil_Dot(velocity_left_normal_x, velocity_left_normal_z, dir_normal_x, dir_normal_z) >
                    0

                local velocity_dampening = base_dampening - easing.inExpo(
                    math.min(VecUtil_Length(self.velocity_x, self.velocity_z), max_velocity),
                    TUNING.BOAT.BASE_DAMPENING,
                    TUNING.BOAT.MAX_DAMPENING - TUNING.BOAT.BASE_DAMPENING,
                    max_velocity
                )

                self:DoApplyForce(velocity_normal_x, velocity_normal_z,
                    force * math.max(0, velocity_dampening) * forward_dir_length)
                self:DoApplyForce(velocity_left_normal_x, velocity_left_normal_z,
                    force * math.max(0, base_dampening) * side_dir_length * (is_left and 1 or -1))
            else
                self:DoApplyForce(dir_x, dir_z, force * math.max(0, base_dampening))
            end
        else
            return _OldApplyRowForce(self, dir_x, dir_z, force, max_velocity)
        end
    end

    local _GetRudderTurnSpeed = self.GetRudderTurnSpeed

    function self:GetRudderTurnSpeed()
        local speed = _GetRudderTurnSpeed(self)

        local x, y, z = self.inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, TUNING.BOAT.RADIUS) --tiny extra range for stuff in the edges.

        local rudder_mult, piratehat_mult, steeringwheel_mult = 1, 1, 1

        -- look for the pirate hat
        if ents and #ents > 0 then --a little worried about this since it runs on update.
            for i, ent in ipairs(ents) do
                if ent:GetCurrentPlatform() and ent:GetCurrentPlatform() == self.inst then
                    if ent:HasTag("boatrotator") then
                        rudder_mult = 1.125
                    end
                    if ent:HasTag("steeringwheel_copper") then
                        steeringwheel_mult = 1.25
                    end
                end

                local sailor = ent.components.steeringwheel ~= nil and ent.components.steeringwheel.sailor or nil
                local platform = sailor ~= nil and sailor:GetCurrentPlatform() or nil

                if platform ~= nil and platform == self.inst and sailor ~= nil and sailor:HasTag("boat_health_buffer") then
                    piratehat_mult = TUNING.DSTU.UPDATE_CHECK and 2 or 1.25
                end
            end
        end

        local mults = rudder_mult * piratehat_mult * steeringwheel_mult

        return (speed * 2) * mults
    end
end)
