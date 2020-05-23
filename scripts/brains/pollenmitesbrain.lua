require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/findlight"
require "behaviours/follow"

local MAX_WANDER_DIST = 20
local AGRO_DIST = 5
local AGRO_STOP_DIST = 7

local function findinfesttarget(inst,brain)    
   
    local target = inst:GetNearestPlayer(true)

    if target ~= nil and inst:GetDistanceSqToInst(target) < AGRO_DIST*AGRO_DIST and not inst.infesting then
        inst.chasingtargettask = inst:DoPeriodicTask(0.2,function()
                print(inst:GetDistanceSqToInst(target) , AGRO_STOP_DIST*AGRO_STOP_DIST, inst.components.infester.infesting)
                if inst:GetDistanceSqToInst(target) > AGRO_STOP_DIST*AGRO_STOP_DIST then          

                    dumptable(brain.pendingtasks,1,1,1)


                    inst:ClearBufferedAction()  
                    inst.components.locomotor:Stop()
                    inst.sg:GoToState("idle")

                    if inst.chasingtargettask then
                        inst.chasingtargettask:Cancel()
                        inst.chasingtargettask = nil
                    end

                    -- THIS IS GROSS.. why does the "infest" DoAction not get it's OnFail event?!
                    brain:Stop()
                    brain:Start()                    
                end
            end)
            
        return BufferedAction(inst, target, ACTIONS.INFEST)
    end
    return false
end

local function findlighttarget(inst)
    local light = inst.findlight(inst)
    if light then
        return light
    end
end

local PollenmitesBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GetWanderPoint(inst)
    local target = inst:GetNearestPlayer(true)
    return target ~= nil and target:GetPosition() or nil
end

function PollenmitesBrain:OnStart()

    local root =
        PriorityNode(
        {
            WhileNode( function() return not self.inst.components.infester.infesting end, "not infesting",
            PriorityNode{            
                WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", 
                    Panic(self.inst) ),
                WhileNode( function() return  TheWorld.state.isdusk or TheWorld.state.isnight end, "chase light",  
                    Follow(self.inst, function() return findlighttarget(self.inst) end, 0, 1, 1)),
                DoAction(self.inst, function() return findinfesttarget(self.inst,self) end, "infest", true),
                --DoAction(self.inst, function() return makenest(self.inst) end, "make nest", true),                          
                Wander(self.inst, GetWanderPoint, 20)
				--Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
            },.5)
        },1)
    
    
    self.bt = BT(self.inst, root)
    
         
end

return PollenmitesBrain