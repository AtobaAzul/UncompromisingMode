local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function DoPortCheck(inst)
    local self = inst.components.uncompromising_shadowfollower

    if self.porttask ~= nil then
        self.porttask:Cancel()
        self.porttask = nil
    end

    if inst.components.combat and inst.components.combat:HasTarget() then
        local c_target = inst.components.combat.target
        if c_target ~= nil and self.target ~= c_target then -- inst.components.uncompromising_shadowfollower and
            self:SetTarget(c_target)
        end
    end

    if self.target == nil or self.target:IsAsleep() then -- or not inst:IsAsleep()
        return
    end

    local init_pos = inst:GetPosition()
    local target_pos = self.target:GetPosition()

    if distsq(target_pos, init_pos) > TUNING.DSTU.MAX_DISTANCE_TO_SHADOWS then

        local angle = self.target:GetAngleToPoint(init_pos) + 180 + math.random(-30,30)
        local offset = FindWalkableOffset(target_pos, angle * DEGREES, 32, 5, false, true, nil, true, true) -- , NoHoles   --(position, start_angle, radius, attempts, check_los, ignore_walls, customcheckfn, allow_water, allow_boats)
        if offset ~= nil then
            target_pos.x = target_pos.x + offset.x
            target_pos.z = target_pos.z + offset.z
        end
        target_pos.y = 0

        --There's a crash if you teleport without the delay
        --V2C: ORLY
        self.porttask = inst:DoTaskInTime(0, self:DoPortNeartarget(target_pos)) -- , self, target_pos
    end
end

local Uncompromising_ShadowFollower = Class(function(self, inst)
    self.inst = inst

    self.target = nil

    self.OnTargetRemoved = function()
        self:SetTarget(nil)
    end
    self:OnStart()
end)

function Uncompromising_ShadowFollower:OnStart()
    self.porttask2 = self.inst:DoPeriodicTask(1, DoPortCheck)
end

function Uncompromising_ShadowFollower:GetTarget()
    return self.target
end

function Uncompromising_ShadowFollower:DoPortNeartarget(pos)

    local delay = 14
    if self.inst.prefab == "creepingfear" then
        delay = 26
    elseif self.inst.prefab == "dreadeye" then
        delay = 21
    end

    self.inst.sg:GoToState("teleport_disapper")

    self.inst:DoTaskInTime(delay * FRAMES, function()
        if self.inst.Physics ~= nil then
            self.inst.Physics:Teleport(pos:Get())
        else
            self.inst.Transform:SetPosition(pos:Get())
        end

        if self.inst.prefab == "creepingfear" then
            self.inst.hitcount = 3
        elseif self.inst.prefab == "dreadeye" then
            self.inst.disguise = true
            self.inst.disguise_form = nil
            self.inst.disguise_cd = -1
        end

        self.porttask = nil
    end)
end

function Uncompromising_ShadowFollower:StartLeashing()
    if self._ontargetwake == nil and self.target ~= nil then
        self._ontargetwake = function() DoPortCheck(self.inst) end
        self.inst:ListenForEvent("entitywake", self._ontargetwake, self.target)
        self.inst:ListenForEvent("entitysleep", DoPortCheck)
        if self.porttask2 == nil then
            self:OnStart()
        end
    end
end

function Uncompromising_ShadowFollower:StopLeashing()
    if self._ontargetwake ~= nil then
        self.inst:RemoveEventCallback("entitysleep", DoPortCheck)
        self.inst:RemoveEventCallback("entitywake", self._ontargetwake, self.target)
        self._ontargetwake = nil
        if self.porttask ~= nil then
            self.porttask:Cancel()
            self.porttask = nil
        end
        if self.porttask2 ~= nil then
            self.porttask2:Cancel()
            self.porttask2 = nil
        end
    end
end

function Uncompromising_ShadowFollower:SetTarget(inst) -- inst == target
    self:StopLeashing()

    if self.target ~= nil then
        self.inst:RemoveEventCallback("onremove", self.OnTargetRemoved, self.target)
    end

    if inst ~= nil then
        self.inst:ListenForEvent("onremove", self.OnTargetRemoved, inst)
        self.target = inst
        self:StartLeashing()
    else
        self.target = nil
    end
end

--function Uncompromising_ShadowFollower:OnSave(data)
--    if self.target ~= nil then
--        data.target = self.target or nil
--    end
--end
--
--function Uncompromising_ShadowFollower:OnLoad(data)
--    if data ~= nil and data.target ~= nil then
--        self.target = data.target
--        self:StartLeashing()
--    end
--end
--
--function Uncompromising_ShadowFollower:OnSave()
--    if self.target ~= nil and
--        self.target:IsValid() and --This is possible because invalid targets may be released by brain polling rather than events
--        self.target.persists and --Pets and such don't save normally, so references would not work on them
--        not (self.inst:HasTag("player") or
--            self.target:HasTag("player")) then
--        return { target = self.target.GUID }, { self.target.GUID }
--    end
--end
--
--function Uncompromising_ShadowFollower:LoadPostPass(newents, data)
--    if data.target ~= nil then
--        local target = newents[data.target]
--        if target ~= nil then
--            self.target = target
--            self:StartLeashing()
--        end
--    end
--end

function Uncompromising_ShadowFollower:OnRemoveFromEntity()
    self:StopLeashing()
    if self.target ~= nil then
        self.inst:RemoveEventCallback("onremove", self.OnTargetRemoved, self.target)
    end
end

return Uncompromising_ShadowFollower