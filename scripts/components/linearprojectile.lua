local LinearProjectile = Class(function(self, inst)
    self.inst = inst

    self.velocity = Vector3(0, 0, 0)
    self.gravity = -9.81

    self.horizontalSpeed = 4
    self.launchoffset = nil
    self.targetoffset = nil

    self.owningweapon = nil
    self.attacker = nil

    self.onlaunchfn = nil
    self.onhitfn = nil
    self.onmissfn = nil
    self.onupdatefn = nil

    self.usehigharc = true

    --NOTE: projectile and LinearProjectile components are mutually
    --      exclusive because they share this tag!
    --V2C: Recommended to explicitly add tag to prefab pristine state
    inst:AddTag("projectile")
end)

function LinearProjectile:OnRemoveFromEntity()
    self.inst:RemoveTag("projectile")
end

function LinearProjectile:GetDebugString()
    return tostring(self.velocity)
end

function LinearProjectile:SetHorizontalSpeed(speed)
    self.horizontalSpeed = speed
end

function LinearProjectile:SetGravity(g)
    self.gravity = g
end

function LinearProjectile:SetLaunchOffset(offset)
    self.launchoffset = offset -- x is facing, y is height, z is ignored
end

function LinearProjectile:SetTargetOffset(offset)
    self.targetoffset = offset -- x is ignored, y is height, z is ignored
end

function LinearProjectile:SetOnLaunch(fn)
    self.onlaunchfn = fn
end

function LinearProjectile:SetOnHit(fn)
    self.onhitfn = fn
end

function LinearProjectile:SetOnUpdate(fn)
    self.onupdatefn = fn
end

function LinearProjectile:CalculateTrajectory(startPos, endPos, speed)
    local speedSq = speed * speed
    local g = -self.gravity

    local dx = endPos.x - startPos.x
    local dy = endPos.y - startPos.y
    local dz = endPos.z - startPos.z

    local rangeSq = dx * dx + dz * dz
    local range = math.sqrt(rangeSq)
    local discriminant = speedSq * speedSq - g * (g * rangeSq + 2 * dy * speedSq)
    local angle
    if discriminant >= 0 then
        local discriminantSqrt = math.sqrt(discriminant)
        local gXrange = g * range
        local angleA = math.atan((speedSq - discriminantSqrt) / gXrange)
        local angleB = math.atan((speedSq + discriminantSqrt) / gXrange)
        angle = self.usehigharc and math.max(angleA, angleB) or math.min(angleA, angleB)
    else
        --Not enough speed to reach endPos
        angle = 30 * DEGREES
    end

    local cosangleXspeed = math.cos(angle) * speed
    self.velocity.x = cosangleXspeed
    self.velocity.z = 0.0
    self.velocity.y = math.sin(angle) * speed
end

function LinearProjectile:Launch(targetPos, attacker, owningweapon)
    local pos = self.inst:GetPosition()
    self.owningweapon = owningweapon or self
    self.attacker = attacker

	self.inst:ForceFacePoint(targetPos:Get())

    local offset = self.launchoffset
    if attacker ~= nil and offset ~= nil then
        local facing_angle = self.inst.Transform:GetRotation() * DEGREES
        pos.x = pos.x + offset.x * math.cos(facing_angle)
        pos.y = pos.y + offset.y
        pos.z = pos.z - offset.x * math.sin(facing_angle)
		
        if self.inst.Physics ~= nil then
            self.inst.Physics:Teleport(pos:Get())
        else
            self.inst.Transform:SetPosition(pos:Get())
        end
    end

    -- use targetoffset height, otherwise hit when you hit the ground
    targetPos.y = self.targetoffset ~= nil and self.targetoffset.y or 0

    self:CalculateTrajectory(pos, targetPos, self.horizontalSpeed)

	-- if the attacker is standing on a moving platform, then inherit it's velocity too
	local attacker_platform = attacker ~= nil and attacker:GetCurrentPlatform() or nil
	if attacker_platform ~= nil then
		local vx, vy, vz = attacker_platform.Physics:GetVelocity()
	    self.velocity.x = self.velocity.x + vx
	    self.velocity.z = self.velocity.z + vz
	end

    if self.onlaunchfn ~= nil then
        self.onlaunchfn(self.inst)
    end

    self.inst:StartUpdatingComponent(self)
end

function LinearProjectile:Hit(target)
    self.inst:StopUpdatingComponent(self)

    self.inst.Physics:SetMotorVel(0,0,0)
    self.inst.Physics:Stop()
    self.velocity.x, self.velocity.y, self.velocity.z = 0, 0, 0

    if self.onhitfn ~= nil then
        self.onhitfn(self.inst, self.attacker, target)
    end
end

function LinearProjectile:OnUpdate(dt)
    if self.onupdatefn ~= nil and self.onupdatefn(self.inst) then
        return
    end
    self.inst.Physics:SetMotorVel(self.velocity:Get())
  
--[[  self.velocity.y = self.velocity.y + (self.gravity * dt)
    if self.velocity.y < 0 then
        local x, y, z = self.inst.Transform:GetWorldPosition()
        if y <= 0.05 then -- a tiny bit above the ground, to account for collision issues
            self:Hit()
        end
    end]]
end

return LinearProjectile
