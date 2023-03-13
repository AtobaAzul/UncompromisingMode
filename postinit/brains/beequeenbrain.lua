local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/chaseandattack"

local function ShouldChase_UM(self)
    local target = self.inst.components.combat.target
    if self.inst.focustarget_cd <= 0 and self.inst.ShouldChase(self.inst) then
        return not (self.inst.components.combat:InCooldown() and
                    target ~= nil and
                    target:IsValid() and
                    target:IsNear(self.inst, TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0)))
    elseif target == nil or not target:IsValid() then
        self._shouldchase = false
        return false
    end
    local distsq = self.inst:GetDistanceSqToInst(target)
    local range = TUNING.BEEQUEEN_CHASE_TO_RANGE + (self._shouldchase and 0 or 3)+4
    self._shouldchase = distsq >= range * range
    if self._shouldchase and not self.inst.ShouldChase(self.inst) then
        return true
    elseif self.inst.components.combat:InCooldown() then
        return false
    end
    range = TUNING.BEEQUEEN_ATTACK_RANGE + target:GetPhysicsRadius(0) + 1
    return distsq <= range * range
end

local function CalcDodgeMult(self)
    local found = false
    for k, v in pairs(self.inst.components.grouptargeter:GetTargets()) do
        if self.inst:IsNear(k, TUNING.BEEQUEEN_ATTACK_RANGE + k:GetPhysicsRadius(0)) then
            if found then
                return .5
            end
            found = true
        end
    end
    return 1
end

local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("spawnpoint")
end

local DODGE_DELAY = 10
local MAX_DODGE_TIME = 3

local function ShouldDodge(self)
    if self._dodgedest ~= nil then
        return true
    end
    local t = GetTime()
    if self.inst.sg.mem.wantstododge then
        --Override dodge timer once
        self.inst.sg.mem.wantstododge = nil
    elseif self.inst.components.combat:GetLastAttackedTime() + DODGE_DELAY < t then
        --Reset dodge timer
        self._dodgetime = nil
        return false
    elseif self._dodgetime == nil then
        --Start dodge timer
        self._dodgetime = t
        return false
    elseif self._dodgetime + DODGE_DELAY * CalcDodgeMult(self) >= t then
        --Wait dodge timer
        return false
    end
    --Find new dodge destination
    local homepos = GetHomePos(self.inst)
    local pos = self.inst:GetPosition()
    local dangerrangesq = TUNING.BEEQUEEN_CHASE_TO_RANGE * TUNING.BEEQUEEN_CHASE_TO_RANGE
    local maxrangesq = TUNING.BEEQUEEN_DEAGGRO_DIST * TUNING.BEEQUEEN_DEAGGRO_DIST
    local mindanger = math.huge
    local bestdest = Vector3()
    local tests = {}
    for i = 2, 6 do
        table.insert(tests, { rsq = i * i })
    end
    for i = 10, 20, 5 do
        local r = i + math.random() * 5
        local theta = 2 * PI * math.random()
        local dtheta = PI * .25
        for attempt = 1, 8 do
            local offset = FindWalkableOffset(pos, theta, r, 1, true, true)
            if offset ~= nil then
                local x, z = offset.x + pos.x, offset.z + pos.z
                if homepos ~= nil and distsq(homepos.x, homepos.z, x, z) < maxrangesq then
                    local nx, nz = offset.x / r, offset.z / r
                    for j, test in ipairs(tests) do
                        test.x = nx * (j - .5) + pos.x
                        test.z = nz * (j - .5) + pos.z
                    end
                    local danger = 0
                    for _, v in ipairs(AllPlayers) do
                        if not v:HasTag("playerghost") and v.entity:IsVisible() then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            if distsq(vx, vz, x, z) < dangerrangesq then
                                danger = danger + 1
                            end
                            for j, test in ipairs(tests) do
                                if distsq(vx, vz, test.x, test.z) < test.rsq then
                                    danger = danger + 1
                                end
                            end
                        end
                    end
                    if danger < mindanger then
                        mindanger = danger
                        bestdest.x, bestdest.z = x, z
                        if danger <= 0 then
                            break
                        end
                    end
                end
            end
            theta = theta + dtheta
        end
        if mindanger <= 0 then
            break
        end
    end
    if mindanger < math.huge then
        self._dodgedest = bestdest
        self._dodgetime = nil
        self.inst.components.locomotor.walkspeed = TUNING.BEEQUEEN_DODGE_SPEED
        self.inst.hit_recovery = TUNING.BEEQUEEN_DODGE_HIT_RECOVERY
        CommonHandlers.UpdateHitRecoveryDelay(self.inst)
        return true
    end
    --Reset dodge timer to retry in half the time
    self._dodgetime = t - DODGE_DELAY * .5
    return false
end

local function WhyAreYouStopping(self)
					
	local ChaseMe = WhileNode(function() return ShouldChase_UM(self) end, "Chase",
            ChaseAndAttack(self.inst))
	table.remove(self.bt.root.children, 3)
    table.insert(self.bt.root.children, 3, ChaseMe)
	
	local KiteMe =  WhileNode(function() return (ShouldDodge(self) and not self.inst.hasWall(self.inst)) end, "Dodge",
            SequenceNode{
                ParallelNodeAny{
                    WaitNode(MAX_DODGE_TIME),
                    NotDecorator(FailIfSuccessDecorator(
                        Leash(self.inst, function() return self._dodgedest end, 2, 2))),
                },
                ActionNode(function() self:OnStop() end),
            })
	table.remove(self.bt.root.children, 1)
    table.insert(self.bt.root.children, 1, KiteMe)
end


env.AddBrainPostInit("beequeenbrain", WhyAreYouStopping)