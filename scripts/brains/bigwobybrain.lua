require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"
require "behaviours/doaction"
require "behaviours/jukeandjive"

local BrainCommon = require("brains/braincommon")

local MIN_FOLLOW_DIST = 0
local TARGET_FOLLOW_DIST = 7
local MAX_FOLLOW_DIST = 12

local SIT_DOWN_DISTANCE = 10

local PLATFORM_WANDER_DIST = 4
local WANDER_DIST = 12

local function GetOwner(inst)
    return inst.components.follower.leader
end

local function KeepFaceOwnerFn(inst, target)
    return inst.components.follower.leader == target
end

local function IsTryingToPerformAction(inst, performer, action)
    local act = performer.components.locomotor.bufferedaction--performer:GetBufferedAction()
    return act ~= nil and act.target == inst and act.action == action
end

local function TryingToInteractWithWoby(inst, performer)
    local interactions = { ACTIONS.FEED, ACTIONS.RUMMAGE, ACTIONS.STORE }
    for _, action in ipairs(interactions) do
        if IsTryingToPerformAction(inst, performer, action) then
            return true
        end
    end

    if inst.components.container:IsOpenedBy(performer) then
        return true
    end

    return false
end

local function GetRiderFn(inst)
    local leader = inst.components.follower ~= nil and inst.components.follower.leader
    if leader ~= nil and IsTryingToPerformAction(inst, leader, ACTIONS.MOUNT) then
        return leader
    end

    return nil
end

local function KeepRiderFn(inst, target)
    return IsTryingToPerformAction(inst, target, ACTIONS.MOUNT)
end

local function GetWalterInteractionFn(inst)
   local leader = inst.components.follower ~= nil and inst.components.follower.leader
    if leader ~= nil and TryingToInteractWithWoby(inst, leader) then
        return leader
    end

    return nil
end

local function GetGenericInteractionFn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, SIT_DOWN_DISTANCE, true)
    for k,player in pairs(players) do
        if TryingToInteractWithWoby(inst, player) then
            return player
        end
    end

    return nil
end

local function KeepGenericInteractionFn(inst, target)
    return TryingToInteractWithWoby(inst, target)
end

local function GetHomePos(inst)
    local platform = inst:GetCurrentPlatform()
    if platform then
        return platform:GetPosition()
    else
        local owner = GetOwner(inst)
        if owner then
            return owner:GetPosition()
        end
    end

    return nil
end

local function GetWanderDist(inst)
   local platform = inst:GetCurrentPlatform()
    if platform then
        return platform.components.walkableplatform and platform.components.walkableplatform.platform_radius or PLATFORM_WANDER_DIST
    else
        return WANDER_DIST
    end
end

-------------------------------------------------------------------------------
--  Combat Avoidance, transplanted from crittersbrain

local COMBAT_TOO_CLOSE_DIST = 10                 -- distance for find enitities check
local COMBAT_TOO_CLOSE_DIST_SQ = COMBAT_TOO_CLOSE_DIST * COMBAT_TOO_CLOSE_DIST
local COMBAT_SAFE_TO_WATCH_FROM_DIST = 12        -- will run to this distance and watch if was too close
local COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST = 14   -- combat is quite far away now, better catch up
local COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST_SQ = COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST * COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST
local COMBAT_TIMEOUT = 8

local function _avoidtargetfn(self, target)
    if target == nil or not target:IsValid() then
        return false
    end

    local owner = self.inst.components.follower.leader
    local owner_combat = owner ~= nil and owner.components.combat or nil
    local target_combat = target.components.combat
    if owner_combat == nil or target_combat == nil or not self.inst:IsNear(owner, 20) then
        return false
    elseif target_combat:TargetIs(owner)
        or (target.components.grouptargeter ~= nil and target.components.grouptargeter:IsTargeting(owner))
		or target_combat:TargetIs(self.inst)
        or (target.components.grouptargeter ~= nil and target.components.grouptargeter:IsTargeting(self.inst)) then
        return true
    end

    local distsq = owner:GetDistanceSqToInst(target)
    if distsq >= COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST_SQ then
        -- Too far
        return false
    elseif distsq < COMBAT_TOO_CLOSE_DIST_SQ and target_combat:HasTarget() then
        -- Too close to any combat
        return true
    end

    -- Is owner in combat with target?
    -- Are owner and target both in any combat?
    local t = GetTime()
    return  (   (owner_combat:IsRecentTarget(target) or target_combat:HasTarget()) and
                math.max(owner_combat.laststartattacktime or 0, owner_combat.lastdoattacktime or 0) + COMBAT_TIMEOUT > t
            ) or
            (   owner_combat.lastattacker == target and
                owner_combat:GetLastAttackedTime() + COMBAT_TIMEOUT > t
            )
end

local function CombatAvoidanceFindEntityCheck(self)
    return function(ent)
            if _avoidtargetfn(self, ent) then
                self.inst:PushEvent("critter_avoidcombat", {avoid=true})
                self.runawayfrom = ent
                return true
            end
            return false
        end
end

local function ValidateCombatAvoidance(self)
    if self.runawayfrom == nil or 
		self.inst:GetCurrentPlatform() ~= nil or 
		self.inst.components.follower.leader ~= nil and not 
		self.inst:IsNear(self.inst.components.follower.leader, 20) then
        return false
    end

    if not self.runawayfrom:IsValid() then
        self.inst:PushEvent("critter_avoidcombat", {avoid=false})
        self.runawayfrom = nil
        return false
    end

    if not self.inst:IsNear(self.runawayfrom, COMBAT_SAFE_TO_WATCH_FROM_MAX_DIST) then
        return false
    end

    if not _avoidtargetfn(self, self.runawayfrom) then
        self.inst:PushEvent("critter_avoidcombat", {avoid=false})
        self.runawayfrom = nil
        return false
    end

    return true
end

--- Minigames
local function WatchingMinigame(inst)
	return (inst.components.follower.leader ~= nil and inst.components.follower.leader.components.minigame_participator ~= nil) and inst.components.follower.leader.components.minigame_participator:GetMinigame() or nil
end
local function WatchingMinigame_MinDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_min or 0
end
local function WatchingMinigame_TargetDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_target or 0
end
local function WatchingMinigame_MaxDist(inst)
	local minigame = WatchingMinigame(inst)
	return minigame ~= nil and minigame.components.minigame.watchdist_max or 0
end

-------------------------------------------------------------------------------
-- CUSTOM FUNCTIONS FOR WOBY ACTIONS

local function HasWobyTarget(inst)
    return inst.wobytarget ~= nil and
			inst.wobytarget:IsValid() and not
			inst.wobytarget:HasTag("outofreach") and not
			inst.wobytarget:HasTag("INLIMBO") and
			inst.wobytarget:IsOnPassablePoint() ~= nil and inst.wobytarget:IsOnPassablePoint() and
			-- is my pal walter near?
			(inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, 25)) and
			(
			-- Check for Picking (plants)
			(inst.wobytarget.components.pickable ~= nil and inst.wobytarget.components.pickable.canbepicked) or
			-- Check for item to pick up		
			(inst.wobytarget.components.inventoryitem ~= nil and inst.wobytarget.components.inventoryitem.canbepickedup and not inst.wobytarget.components.combat) or
			-- Check for harvestable target	
			(inst.wobytarget.components.harvestable ~= nil and inst.wobytarget.components.harvestable:CanBeHarvested()) or 
			-- I'm big AF and I can dig things
			(inst.wobytarget.components.workable ~= nil and inst.wobytarget.components.workable:GetWorkAction() == ACTIONS.DIG and not (inst.wobytarget.components.pickable ~= nil and inst.wobytarget.components.pickable.canbepicked)) or 
			-- Bark Bark! Attack me you dink!
			(inst.wobytarget.components.combat ~= nil and 
			inst.wobytarget.components.combat:CanTarget(inst) and not
			(inst.wobytarget.components.combat:TargetIs(inst) or inst.wobytarget.components.grouptargeter ~= nil and inst.wobytarget.components.grouptargeter:IsTargeting(self.inst)) and not
			(inst.wobytarget.sg ~= nil and inst.wobytarget.sg:HasStateTag("attack")))
			
			) or false
end

local function DoTargetAction(inst)
    return inst.wobytarget ~= nil and
			inst.wobytarget:IsValid() and not
			inst.wobytarget:HasTag("outofreach") and not
			inst.wobytarget:HasTag("INLIMBO") and
			inst.wobytarget:IsOnPassablePoint() ~= nil and inst.wobytarget:IsOnPassablePoint() and
			-- is my pal walter near?
			(inst.components.follower.leader ~= nil and
            inst:IsNear(inst.components.follower.leader, 25)) and
			(
			-- Check for Picking (plants)
			(inst.wobytarget.components.pickable ~= nil and inst.wobytarget.components.pickable.canbepicked and
			BufferedAction(inst, inst.wobytarget, ACTIONS.PICK)) or
			-- Check for item to pick up		
			(inst.wobytarget.components.inventoryitem ~= nil and inst.wobytarget.components.inventoryitem.canbepickedup and not inst.wobytarget.components.combat and
			BufferedAction(inst, inst.wobytarget, ACTIONS.PICKUP)) or
			-- Check for harvestable target	
			(inst.wobytarget.components.harvestable ~= nil and inst.wobytarget.components.harvestable:CanBeHarvested() and
			BufferedAction(inst, inst.wobytarget, ACTIONS.HARVEST)) or 
			-- I'm big AF and I can dig things
			((inst.wobytarget.components.workable ~= nil and inst.wobytarget.components.workable:GetWorkAction() == ACTIONS.DIG and not (inst.wobytarget.components.pickable ~= nil and inst.wobytarget.components.pickable.canbepicked)) and 
			BufferedAction(inst, inst.wobytarget, ACTIONS.DIG)) or 
			-- Bark Bark! Attack me you dink!
			(inst.wobytarget.components.combat ~= nil and 
			inst.wobytarget.components.combat:CanTarget(inst) and not
			(inst.wobytarget.components.combat:TargetIs(inst) or inst.wobytarget.components.grouptargeter ~= nil and inst.wobytarget.components.grouptargeter:IsTargeting(inst)) and not
			(inst.wobytarget.sg ~= nil and inst.wobytarget.sg:HasStateTag("attack")) and
			BufferedAction(inst, inst.wobytarget, ACTIONS.WOBY_BARK))
			
			) or nil
end

local function HasSitTarget(inst)
    return inst.wobytarget ~= nil and inst.wobytarget:HasTag("wobysittarget")  and inst.wobytarget:IsOnPassablePoint() or nil
end

local function GoSitAction(inst)
    if inst.wobytarget == nil then
		return
	end
	
    local sitPos = inst.wobytarget:GetPosition()
    return sitPos ~= nil
        and BufferedAction(inst, nil, ACTIONS.WALKTO, nil, sitPos, nil, .3)
        or nil
end

local function ShouldWobyRun(inst)
    return inst:GetCurrentPlatform() == nil or 
		inst.components.follower.leader ~= nil and 
		inst:IsNear(inst.components.follower.leader, 25)
end

-------------------------------------------------------------------------------

local WobyBigBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function WobyBigBrain:OnStart()
	local watch_game = WhileNode( function() return WatchingMinigame(self.inst) end, "Watching Game",
        PriorityNode{
				Follow(self.inst, WatchingMinigame, WatchingMinigame_MinDist, WatchingMinigame_TargetDist, WatchingMinigame_MaxDist),
				RunAway(self.inst, "minigame_participator", 5, 7),
				FaceEntity(self.inst, WatchingMinigame, WatchingMinigame ),
        }, 0.1)

    local root = PriorityNode(
    {
        WhileNode(function() return self.inst.components.hauntable ~= nil and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
        WhileNode(function() return false end, "OnFire", -- TODO add the fire case again
            Panic(self.inst)),
			
		watch_game,
		
		WhileNode( function() return HasWobyTarget(self.inst) end, "Has Target",
			DoAction(self.inst, DoTargetAction, nil, true )
		),
		
		PriorityNode{
			JukeAndJive(self.inst, {tags={"_combat", "_health"}, notags={"player", "wall", "INLIMBO"},
					fn=CombatAvoidanceFindEntityCheck(self)},
					COMBAT_TOO_CLOSE_DIST,
					COMBAT_SAFE_TO_WATCH_FROM_DIST),

			WhileNode( function() return ValidateCombatAvoidance(self) end, "Is Near Combat",
				FaceEntity(self.inst, GetOwner, KeepFaceOwnerFn, nil, "cower")
				),
		},
				
		WhileNode( function() return HasSitTarget(self.inst) end, "Has Target",
			DoAction(self.inst, GoSitAction, nil, true )
		),

        -- These two are kept separatly because we have different animations for mounting vs. opening and feeding
        FaceEntity(self.inst, GetRiderFn, KeepRiderFn),
        FaceEntity(self.inst, GetWalterInteractionFn, KeepGenericInteractionFn, nil, "sit_alert_tailwag"),

        Follow(self.inst, function() return self.inst.components.follower.leader end,
                     MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true),

        -- Kept down here because woby should prioritize following walter over storage and food by other players
        FaceEntity(self.inst, GetGenericInteractionFn, KeepGenericInteractionFn, nil, "sit_alert"),


        Wander(self.inst, GetHomePos, GetWanderDist, {minwaittime = 6, randwaittime = 6}),
    }, .25)

    self.bt = BT(self.inst, root)
end

return WobyBigBrain
