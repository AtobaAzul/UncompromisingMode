WobyDance = Class(BehaviourNode, function(self, inst)
    BehaviourNode._ctor(self, "WobyDance")
    self.inst = inst
	self.fix_overhang = true -- this will put the point check back on land if self.inst is stepping on the ocean overhang part of the land
end)

function WobyDance:GetRunAngle(pt, hp, sp)
    if self.avoid_angle ~= nil then
        local avoid_time = GetTime() - self.avoid_time
        if avoid_time < 1 then
            return self.avoid_angle
        else
            self.avoid_time = nil
            self.avoid_angle = nil
        end
    end
	
	local angle
	if sp ~= nil then
		local dir1 = pt - hp
		local dir2 = sp - pt

		local offset_x, offset_z = VecUtil_Slerp(dir2.x, dir2.z, dir1.x, dir1.z, 0.5)
		angle = self.inst:GetAngleToPoint(pt + Vector3(offset_x, 0, offset_z))
	else
		angle = (self.inst:GetAngleToPoint(hp) + 180) - 105
		if angle > 360 then
			angle = angle - 360
		end
	end

    local radius = 6

	local find_offset_fn = self.inst.components.locomotor:IsAquatic() and FindSwimmableOffset or FindWalkableOffset
    local allowwater_or_allowboat = nil
    if find_offset_fn == FindWalkableOffset then
        allowwater_or_allowboat = self.inst.components.locomotor:CanPathfindOnWater()
    end
	local result_offset, result_angle, deflected = find_offset_fn(pt, angle*DEGREES, radius, 8, true, false, nil, allowwater_or_allowboat) -- try avoiding walls
    if result_angle == nil then
		result_offset, result_angle, deflected = find_offset_fn(pt, angle*DEGREES, radius, 8, true, true) -- ok don't try to avoid walls
        if result_angle == nil then
			if self.fix_overhang and not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
                if self.inst.components.locomotor:IsAquatic() then
                    local back_on_ocean = FindNearbyOcean(pt, 1)
				    if back_on_ocean ~= nil then
			            result_offset, result_angle, deflected = FindSwimmableOffset(back_on_ocean, math.random()*2*math.pi, radius - 1, 8, true, true)
				    end
                else
				    local back_on_ground = FindNearbyLand(pt, 1) -- find a point back on proper ground
				    if back_on_ground ~= nil then
			            result_offset, result_angle, deflected = FindWalkableOffset(back_on_ground, math.random()*2*math.pi, radius - 1, 8, true, true) -- ok don't try to avoid walls, but at least avoid water
				    end
                end
			end
			if result_angle == nil then
	            return angle -- ok whatever, just run
			end
        end
    end

    result_angle = result_angle / DEGREES
    if deflected then
        self.avoid_time = GetTime()
        self.avoid_angle = result_angle
    end
    return result_angle
end


function WobyDance:Visit()
    if self.status == READY then
        self.hunter = self.inst.components.follower.leader

        self.status = self.hunter ~= nil and RUNNING or FAILED
    end

    if self.status == RUNNING then
		if self.hunter == nil or not self.hunter.entity:IsValid() then
			self.status = FAILED
			self.inst.components.locomotor:Stop()
		else
			local pt = self.inst:GetPosition()
			local hp = self.hunter:GetPosition()
			local angle = self:GetRunAngle(pt, hp, nil)
			if angle ~= nil then
				self.inst.components.locomotor:RunInDirection(angle)
			else
				self.status = FAILED
				self.inst.components.locomotor:Stop()
			end

            self:Sleep(.25)
        end
    end
end
