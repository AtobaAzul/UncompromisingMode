local env = env
GLOBAL.setfenv(1, GLOBAL)
require "behaviours/runaway"
-----------------------------------------------------------------

local function ShouldSnare(self)
    if not self.inst.components.timer:TimerExists("snare_cd") then
        local target = self.inst.components.combat.target
        if target ~= nil and target:IsValid() and self.inst:GetDistanceSqToInst(target) < 200 then
            return true
        end
        self.inst.components.timer:StartTimer("snare_cd", TUNING.STALKER_ABILITY_RETRY_CD)
    end
    return false
end

local function LeifRoot(self)

    local specialattack = WhileNode(function() return self.inst.components.combat:HasTarget() and ShouldSnare(self) end, "Snare",
                ActionNode(function()
                    self.inst:PushEvent("snare")
                end))
	
	table.insert(self.bt.root.children, 2, specialattack)
end

env.AddBrainPostInit("leifbrain", LeifRoot)