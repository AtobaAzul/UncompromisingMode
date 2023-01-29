--local easing = require("easing")

local LinearCircler = Class(function(self, inst)
    self.inst = inst
	self.setspeed = 0.2
    self.speed = self.setspeed 
    self.circleTarget = nil

    self.minSpeed = 5
    self.maxSpeed = 7
	self.randAng = 0

    self.distance = 1
    self.distance_mod = 1
    self.distance_limit = 18
    self.distance_max = 15
    self.distance_max_clockwise = 17
    self.slowextend_range = 3

    self.onaccelerate = nil
    self.numAccelerates = 0

    self.sineMod = 25 * .001
    self.sine = 0
	
	self.clockwise = false

	self.retract = false
end)

function LinearCircler:Start()
    if self.circleTarget == nil or not self.circleTarget:IsValid() then
        self.circleTarget = nil
        return
    end

    self.speed = self.setspeed-- * .01
	
    self.angleRad = self.randAng * 2 * PI
    self.offset = Vector3(self.distance * math.cos(self.angleRad), 0, -self.distance * math.sin(self.angleRad))
    self.facingAngle = self.angleRad * RADIANS

    self.direction = (self.clockwise and .5 or -.5) * PI
    self.facingAngle = (math.atan2(self.offset.x, self.offset.z) + self.direction) * RADIANS

    local x, y, z = self.circleTarget.Transform:GetWorldPosition()
	self.inst.Transform:SetRotation(self.facingAngle)
	if not self.grounded then
		self.inst.Transform:SetPosition(x + self.offset.x, 0, z + self.offset.z)
	else
		local x1,y1,z1 = self.inst.Transform:GetWorldPosition()
		self.inst.Transform:SetPosition(x + self.offset.x, y1, z + self.offset.z)
	end
    self.inst:StartUpdatingComponent(self)
end

function LinearCircler:Stop()
    self.inst:StopUpdatingComponent(self)
end

function LinearCircler:SetCircleTarget(tar)
    self.circleTarget = tar
end

function LinearCircler:GetSpeed(dt)
    local speed = self.speed * 2 * PI * dt
    return self.direction > 0 and -speed or speed
end

function LinearCircler:GetMinSpeed()
    return self.minSpeed * .01
end

function  LinearCircler:GetMaxSpeed()
    return self.maxSpeed * .01
end

function LinearCircler:GetDebugString()
    return string.format("Sine: %4.4f, Speed: %3.3f/%3.3f", self.sine, self.speed, self:GetMaxSpeed())
end

function LinearCircler:OnUpdate(dt)
    if self.circleTarget == nil or not self.circleTarget:IsValid() then
        self:Stop()
        self.circleTarget = nil
        return
    end

    self.sine = GetSineVal(self.sineMod, true, self.inst)

    --self.speed = easing.inExpo(self.sine, self:GetMinSpeed(), self:GetMaxSpeed() - self:GetMinSpeed() , 1)
	--self.speed = Lerp(self:GetMinSpeed() - .003, self:GetMaxSpeed() + .003, self.sine)
    --self.speed = math.clamp(self.speed, self:GetMinSpeed(), self:GetMaxSpeed()) 
	self.speed = self.setspeed-- * .01
    self.angleRad = self.angleRad + self:GetSpeed(dt)
	
	if self.retract and self.distance > 1 and self.clockwise then
		self.distance = self.distance - 0.3
	elseif self.distance < (self.distance_limit / self.distance_mod) and not self.retract then
		if self.distance >= (self.clockwise and (self.distance_max_clockwise / self.distance_mod) or (self.distance_max / self.distance_mod)) then
			self.retract = true
		end
		if self.distance < self.slowextend_range then
			self.distance = self.distance + 0.05
		else
			self.distance = self.distance + 0.2
		end
	end
	
    self.offset = Vector3(self.distance * math.cos(self.angleRad), 0, -self.distance * math.sin(self.angleRad))

    self.facingAngle = (math.atan2(self.offset.x, self.offset.z) + self.direction) * RADIANS

    local x, y, z = self.circleTarget.Transform:GetWorldPosition()
	if not self.freeface then
		self.inst.Transform:SetRotation(self.facingAngle)
	end
	if not self.grounded then
		self.inst.Transform:SetPosition(x + self.offset.x, 0, z + self.offset.z)
	else
		local x1,y1,z1 = self.inst.Transform:GetWorldPosition()
		self.inst.Transform:SetPosition(x + self.offset.x, y1, z + self.offset.z)
	end
end

LinearCircler.OnEntitySleep = LinearCircler.Stop
LinearCircler.OnEntityWake = LinearCircler.Start

return LinearCircler
