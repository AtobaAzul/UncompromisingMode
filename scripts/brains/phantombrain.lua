require "behaviours/follow"
require "behaviours/wander"
require "behaviours/leash"

local PhantomBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MAX_WANDER_DIST = 12

local function HasTarget(inst)
	return inst.components.combat and inst.components.combat.target
end

local function GetHome(inst)
    return inst.components.homeseeker and inst.components.homeseeker.home
end

local function GetHomePos(inst)
    local home = GetHome(inst)
    return home and home:GetPosition()
end

local function GetWanderPoint(inst)
    local target = GetHome(inst)

    if target then
        return target:GetPosition()
    end
end


function PhantomBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode(function() return HasTarget(self.inst) end, "Followpoint",
			Leash(self.inst, function() return self.inst.point end, 1, 1)
        ),
		WhileNode(function() return GetHome(self.inst) end, "HasHome", Wander(self.inst, GetHomePos, 8)),
		--    Wander(self.inst, GetWanderPoint, 20),
		Wander(self.inst, GetWanderPoint, MAX_WANDER_DIST, { minwalktime = .5, randwalktime = math.random() < 0.5 and .5 or 1, minwaittime = 6, randwaittime = .2, }),
        
    }, 1)

    self.bt = BT(self.inst, root)
end

function PhantomBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end
return PhantomBrain