require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/attackwall"
require "behaviours/panic"
require "behaviours/minperiod"

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20


local MAX_CHASE_TIME = 20
local MAX_CHASE_DIST = 32
local SEE_STRUCTURE_DIST = 30
local SEE_BAIT_DIST = 15

local BASE_TAGS = {"structure"}
local NO_TAGS = {"FX", "NOCLICK", "DECOR","INLIMBO"}

local function GoHome(inst)
    if inst.components.knownlocations:GetLocation("home") then
        return BufferedAction(inst, nil, ACTIONS.GOHOME, nil, inst.components.knownlocations:GetLocation("home") )
    end
end

local function EatAshAction(inst)
    if inst.sg:HasStateTag("sleeping") or inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED or inst.hassleepdestination then return false end
    if inst.sg:HasStateTag("busy") or inst.flame_on then return false end
    if (inst.components.combat and inst.components.combat.target) or inst.fire_build or inst.flame_on then return false end
    --if inst.last_spit_time and ((GetTime() - inst.last_spit_time) < 10) then return false end

    local action = nil

    local pt = inst:GetPosition()
    local target = FindEntity(inst, SEE_BAIT_DIST, nil, {"ashes"}, {"fire", "FX", "NOCLICK", "DECOR", "INLIMBO"})
    
    if target then
        inst.ashes = target
        return BufferedAction(inst, inst.ashes, ACTIONS.PICKUP)
    end
end

local function ShouldSpitFn(inst)
    if inst.sg:HasStateTag("sleeping") or inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED or inst.hassleepdestination then return false end
    if not inst.recently_frozen and not inst.flame_on then
        if not inst.last_spit_time then 
            if inst:GetTimeAlive() > 5 then return true end
        else
            return (GetTime() - inst.last_spit_time) >= inst.spit_interval
        end
    end
    return false
end

local function LavaSpitAction(inst)
    if not inst.target or (inst.target ~= inst and not inst.target:HasTag("fire")) then
        inst.last_spit_time = GetTime()
        inst.spit_interval = math.random(20,30)
        if not inst.target then
            inst.target = inst
        end
        return BufferedAction(inst, inst.target, ACTIONS.LAVASPIT)
    end
end

local function FindLavaSpitTargetAction(inst) 
    if inst.sg:HasStateTag("sleeping") or inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED or inst.hassleepdestination then return false end
    if inst.last_spit_time and ((GetTime() - inst.last_spit_time) < 5) then return false end

    local target = nil
    local action = nil

    if inst.sg:HasStateTag("busy") or inst.recently_frozen or inst.flame_on then
        return
    end

    --local tagpriority = {"dragonflybait_highprio", "dragonflybait_medprio", "dragonflybait_lowprio"}
	local tagpriority = {"plant", "tree", "dragonflybait_lowprio"}
    local prio = 1
    local currtag = nil
    
    local pt = inst:GetPosition()
    local ents = nil

    while not target and prio <= #tagpriority do
        currtag = {tagpriority[prio]}
        ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_BAIT_DIST, currtag, {"fire"})
    
        for k,v in pairs(ents) do
            if v and v.components.burnable and (not v.components.inventoryitem or not v.components.inventoryitem:IsHeld()) then
                if not target or (distsq(pt, Vector3(v.Transform:GetWorldPosition())) < distsq(pt, Vector3(target.Transform:GetWorldPosition()))) then
                    if inst.last_target ~= v then
                        target = v
                    end
                end
            end
        end

        prio = prio + 1
    end

    if target and not target:HasTag("fire") then
        inst.target = target
        return BufferedAction(inst, inst.target, ACTIONS.LAVASPIT)
    end
end

local function SleepAction(inst)
    if ((inst.num_ashes_eaten >= TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED) or (inst.num_targets_vomited >= TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED)) 
    and not inst.hassleepdestination then
        local angle = math.random(0,360)
        local offset = FindWalkableOffset(inst:GetPosition(), angle*DEGREES, math.random(3,10), 120, false, false)
        inst:ClearBufferedAction()
        inst.components.locomotor:GoToPoint(inst:GetPosition() + offset)
        inst.components.locomotor.atdestfn = function(inst) inst.arrivedatsleepdestination = true end
        inst.hassleepdestination = true
    end
end

local function FlameOffAction(inst)
    if inst.fire_build and inst.components.combat and not inst.components.combat.target and inst.last_kill_time and ((GetTime() - inst.last_kill_time) > 3) then
        inst:SetFlameOn(false)
        inst.last_kill_time = nil
    end
end

local function ShouldFollowFn(inst)
    return not inst.NearPlayerBase(inst) and not inst.SeenBase
end

local DragonflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function DragonflyBrain:OnStart()
    local root =
        PriorityNode(
        {
            DoAction(self.inst, FlameOffAction),
            DoAction(self.inst, SleepAction),
            DoAction(self.inst, EatAshAction),
            WhileNode(function() return ShouldSpitFn(self.inst) end, "Spit",
                DoAction(self.inst, LavaSpitAction)),
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
            DoAction(self.inst, FindLavaSpitTargetAction),
            WhileNode(function() return ShouldFollowFn(self.inst) end, "Follow To Base",
                PriorityNode(
                {   --[[We want the dragonfly to follow the player]]
                    Follow(self.inst, function() return  ThePlayer end, 0, 15, 20)
					--Follow(self.inst, function() return  GetPlayer() end, 0, 15, 20)
                })),
            Wander(self.inst, function() return self.inst:GetPosition() end, 5),
        },1)
    self.bt = BT(self.inst, root)
end

function DragonflyBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", Point(self.inst.Transform:GetWorldPosition()))
end

return DragonflyBrain