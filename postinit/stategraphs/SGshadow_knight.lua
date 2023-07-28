local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddStategraphPostInit("shadow_knight", function(inst)
local ShadowChess = require("stategraphs/SGshadow_chesspieces")

local states = {
State{
        name = "taunt",
        tags = { "taunt", "busy" },

        onenter = function(inst, remaining)
			inst.sg.statemem.total_taunt = math.random(inst.level, 3)
            inst.sg.statemem.remaining = (remaining or inst.sg.statemem.total_taunt) - 1 --can taunt one more time!
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")

            if inst.sg.statemem.remaining == 0 then
                -- change target
                local x, y, z = inst.Transform:GetWorldPosition()
                local players = shuffleArray(FindPlayersInRange(x, y, z, TUNING.SHADOWCREATURE_TARGET_DIST, true))
                for i, v in ipairs(players) do
                    if v ~= inst.components.combat.target and inst.components.combat:CanTarget(v) then
                        inst.components.combat:SetTarget(v)
                        break
                    end
                end
            end
        end,

        timeline =
        {
            ShadowChess.Functions.ExtendedSoundTimelineEvent(3.5 * FRAMES, "taunt"),
            TimeEvent(30 * FRAMES, function(inst)
                ShadowChess.Functions.AwakenNearbyStatues(inst)
                ShadowChess.Functions.TriggerEpicScare(inst)
            end),
            --[[TimeEvent(44 * FRAMES, function(inst) --what if I made it remove busy tag a bit later? So it won't flinch if you attacked it at the wrong pace
                inst.sg:RemoveStateTag("busy")
            end),]]
        },

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:RemoveStateTag("busy")
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState(inst.sg.statemem.remaining > 0 and "taunt" or "idle", inst.sg.statemem.remaining)
                end
            end),
        },
    }
}

for k, v in pairs(states) do
	assert(v:is_a(State), "Non-state added in mod state table!")
	inst.states[v.name] = v
end

end)