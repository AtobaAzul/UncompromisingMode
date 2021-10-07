local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddStategraphPostInit("catcoon", function(inst)

local events={
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            if data.target:HasTag("cattoyairborne") then
                if data.target.sg and (data.target.sg:HasStateTag("landing") or data.target.sg:HasStateTag("landed")) then
                    inst.components.combat:SetTarget(nil)
                else
                    inst.sg:GoToState("pounceplay", data.target)
                end
            elseif data.target and data.target:IsValid() and (inst:GetDistanceSqToInst(data.target) > TUNING.CATCOON_MELEE_RANGE*TUNING.CATCOON_MELEE_RANGE/(1.5*1.5) or math.random() > 0.5) and inst.countercounter == 0 then
                inst.sg:GoToState("pounce_pre", data.target)
            else
                inst.sg:GoToState("attack", data.target)
            end
        end
    end)
}

local states={
    State{
        name = "pounce_pre",
        tags = {"busy","attack"},

        onenter = function(inst)
			inst.countercounter = 1
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
            inst.AnimState:PushAnimation("taunt", false)
            inst.AnimState:PushAnimation("taunt_pst", false)
			inst.sg:SetTimeout(0.777)
        end,

        ontimeout = function(inst)
			if inst.components.combat.target ~= nil then
				inst.sg:GoToState("pounceattack",inst.components.combat.target)
			else
				inst.sg:GoToState("idle")
			end
        end,  

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/hiss_pre") end),
            TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/hiss") end)
        },
		
    },
    State{
        name = "pounceattack",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
			inst.components.combat:SetRange(TUNING.CATCOON_ATTACK_RANGE/2)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("jump_atk")
            inst.hiss = (target:HasTag("smallcreature") and math.random() <= .5)
        end,

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
			inst.components.combat:SetRange(TUNING.CATCOON_ATTACK_RANGE/1.5)
			inst:DoTaskInTime(4+math.random(0,2),function(inst) inst.countercounter = 0 end)
        end,

        timeline =
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/attack") end),
            TimeEvent(6*FRAMES, function(inst)
                inst.Physics:SetMotorVelOverride(12,0,0)
                -- When the catcoon jumps, check if the target is a bird. If so, roll a chance for the bird to fly away
                local isbird = inst.components.combat and inst.components.combat.target and inst.components.combat.target:HasTag("bird")
                if isbird and math.random() > TUNING.CATCOON_ATTACK_CONNECT_CHANCE then
                    inst.components.combat.target:PushEvent("threatnear")
                end
            end),
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/jump") end),
            TimeEvent(19*FRAMES, function(inst) inst.components.combat:DoAttack() end),
            TimeEvent(20*FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },
        events=
        {
            EventHandler("animover", function(inst)
                if inst.hiss then
                    inst.hiss = false
                    inst.sg:GoToState("hiss")
                else
                    inst.sg:GoToState("idle")
                end
            end),
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

env.AddStategraphActionHandler("catcoon", ActionHandler(ACTIONS.PICKUP, "pawgroundaction"))