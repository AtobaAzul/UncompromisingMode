local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/chaseandattack"

local START_FACE_DIST = 15
local KEEP_FACE_DIST = 20

local function LayEgg(inst)
    return inst.WantsToLayEgg
        and not inst.components.entitytracker:GetEntity("egg")
        and BufferedAction(inst, nil, ACTIONS.LAYEGG)
        or nil
end

local function GetFaceTargetFn(inst)
    if inst.sg:HasStateTag("busy") then
        return
    end
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
    return not (inst.sg:HasStateTag("busy") or
                inst:HasTag("notarget"))
        and inst:IsNear(target, KEEP_FACE_DIST)
end

local function WhyAreYouRunning(self)
					
	local FightMe = ChaseAndAttack(self.inst)
	local FaceMe = FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)
					
    table.insert(self.bt.root.children, 1, FightMe)
    table.insert(self.bt.root.children, 2, FaceMe)
end


env.AddBrainPostInit("moosebrain", WhyAreYouRunning)