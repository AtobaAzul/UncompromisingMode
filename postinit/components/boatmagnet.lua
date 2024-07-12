local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("boatmagnet", function(self)
    function self:CalcMaxVelocity()
        if not self.boat or not self.beacon
            or not self.beacon.components.boatmagnetbeacon
            or self.beacon.components.boatmagnetbeacon:IsTurnedOff() then
            return 0
        end

        local followtarget = self:GetFollowTarget()
        if not followtarget then
            return 0
        end

        -- Beyond a set distance, apply an exponential rate for catch-up speed, otherwise match the speed of the beacon its following
        local direction, distance = self:CalcMagnetDirection()

        local beaconboat = self.beacon.components.boatmagnetbeacon:GetBoat()

        local beaconspeed = (beaconboat == nil and followtarget.components.locomotor ~= nil and math.min(followtarget.components.locomotor:GetRunSpeed(), TUNING.BOAT.MAX_VELOCITY))
            or (beaconboat ~= nil and math.min(beaconboat.components.boatphysics:GetVelocity(), TUNING.BOAT.MAX_FORCE_VELOCITY))
            or 0

        local mindistance = (self.boat.components.hull ~= nil and self.boat.components.hull:GetRadius()) or 1
        if beaconboat and beaconboat.components.hull then
            mindistance = mindistance + beaconboat.components.hull:GetRadius()
        end

        -- If the beacon boat is turning, reduce max speed to prevent too much drifting while turning
        local magnetboatdirection = self.boat.components.boatphysics:GetMoveDirection()
        local magnetdir_x, magnetdir_z = VecUtil_NormalizeNoNaN(magnetboatdirection.x, magnetboatdirection.z)

        local beaconboatdirection = (beaconboat == nil and followtarget.components.locomotor and Vector3(followtarget.Physics:GetVelocity()))
            or (beaconboat ~= nil and beaconboat.components.boatphysics:GetMoveDirection())
            or Vector3(0, 0, 0)
        local beacondir_x, beacondir_z = VecUtil_NormalizeNoNaN(beaconboatdirection.x, beaconboatdirection.z)

        local boatspeed = self.boat.components.boatphysics:GetVelocity()

        local turnspeedmodifier = (boatspeed > 0 and beaconspeed > 0 and math.max(VecUtil_Dot(magnetdir_x, magnetdir_z, beacondir_x, beacondir_z), 0)) or 1
        local maxdistance = TUNING.BOAT.BOAT_MAGNET.MAX_DISTANCE / 8

        if distance > mindistance then
            local base = math.pow(TUNING.BOAT.BOAT_MAGNET.MAX_VELOCITY + TUNING.BOAT.BOAT_MAGNET.CATCH_UP_SPEED, 1 / maxdistance)
            local maxspeed = beaconspeed + (math.pow(base, distance - mindistance) - 1) * turnspeedmodifier
            return math.min(maxspeed, TUNING.BOAT.BOAT_MAGNET.MAX_VELOCITY + TUNING.BOAT.BOAT_MAGNET.CATCH_UP_SPEED)
        else
            local maxspeed = beaconspeed * turnspeedmodifier
            return math.min(maxspeed, TUNING.BOAT.BOAT_MAGNET.MAX_VELOCITY)
        end
    end
end)
