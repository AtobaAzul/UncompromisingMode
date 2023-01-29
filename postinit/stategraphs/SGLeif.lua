local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("leif", function(inst)

local events=
{
    EventHandler("snare", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            local stump = FindEntity(inst, TUNING.LEIF_MAXSPAWNDIST, nil, {"stump","evergreen"}, { "leif","burnt","deciduoustree" })
			if stump ~= nil and TUNING.DSTU.PINELINGS then
				inst.sg:GoToState("summon")
			else
				inst.sg:GoToState("snare")
			end
		else
			inst.components.timer:StartTimer("snare_cd", TUNING.STALKER_ABILITY_RETRY_CD)
        end
    end),
}

local states = {

	State{
        name = "snare",
        tags = { "attack", "busy", "snare" },

        onenter = function(inst, target)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("special")
			
			inst.sg.statemem.target = inst.components.combat.target
			
			inst.components.timer:StartTimer("snare_cd", 30)
        end,

        timeline =
        {
            TimeEvent(25 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/leif/foley") end),
			TimeEvent(34 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/leif/footstep") end),
            TimeEvent(35 * FRAMES, function(inst)
                inst.components.combat:DoAreaAttack(inst, 3.5, nil, nil, nil, { "INLIMBO", "epic", "stumpling", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature" })
                if inst.sg.statemem.target ~= nil then
                    inst:SpawnSnare(inst.sg.statemem.target)
                end
            end),
			
            TimeEvent(36 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
	State{
        name = "summon",
        tags = { "attack", "busy", "snare" },

        onenter = function(inst, target)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("special")
            --V2C: don't trigger attack cooldown
            --inst.components.combat:StartAttack()
			inst.sg.statemem.target = inst.components.combat.target
        end,

        timeline =
        {
            --TimeEvent(0 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/attack1_pbaoe_pre") end),
            TimeEvent(25 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/leif/foley") end),
			TimeEvent(34 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/leif/footstep") end),
            TimeEvent(35 * FRAMES, function(inst)
                inst.components.combat:DoAreaAttack(inst, 3.5, nil, nil, nil, { "INLIMBO", "epic", "notarget", "invisible", "noattack", "flight", "playerghost", "shadow", "shadowchesspiece", "shadowcreature" })
                if inst.sg.statemem.target ~= nil then
                    inst:SummonStumplings(inst.sg.statemem.target)
                end
            end),
			
            TimeEvent(50 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
	State{
        name = "hide",
        tags = {"hiding", "sleeping", "busy"},

        onenter = function(inst)
			inst:AddTag("notarget")
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("transform_tree", false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
			inst.sg:SetTimeout(10)
        end,
        events=
        {
		    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("wake") end end),
        },
		
        onexit = function(inst)
			inst:RemoveTag("notarget")
        end,
		
		ontimeout = function(inst)
			inst:RemoveTag("notarget")
            inst.sg:GoToState("wake")
        end,
        
        timeline=
        {
            TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
            TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/foley") end),
        },
    },
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

