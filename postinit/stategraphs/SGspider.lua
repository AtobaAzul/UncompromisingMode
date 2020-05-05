local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("spider", function(inst)

local function SoundPath(inst, event)
    local creature = "spider"

    if inst:HasTag("spider_moon") then
		return "turnoftides/creatures/together/spider_moon/" .. event
    elseif inst:HasTag("spider_warrior") then
        creature = "spiderwarrior"
    elseif inst:HasTag("spider_hider") or inst:HasTag("spider_spitter") then
        creature = "cavespider"
    else
        creature = "spider"
    end
    return "dontstarve/creatures/" .. creature .. "/" .. event
end

local events =
{
    EventHandler("doattack", function(inst, data) 
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            --target CAN go invalid because SG events are buffered
            if inst:HasTag("spider_warrior") or inst:HasTag("spider_regular") then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, TUNING.SPIDER_WARRIOR_MELEE_RANGE)
                    and "warrior_attack" --Do leap attack
                    or "attack",
                    data.target
                )
            elseif inst:HasTag("spider_spitter") then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, TUNING.SPIDER_SPITTER_MELEE_RANGE)
                    and "spitter_attack" --Do spit attack
                    or "attack",
                    data.target
                )
			elseif inst:HasTag("spider_moon") then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not inst:IsNear(data.target, TUNING.SPIDER_WARRIOR_MELEE_RANGE)
                    and "spike_attack"
                    or "attack",
                    data.target
                )
            else
                inst.sg:GoToState("attack", data.target)
            end
        end
    end),
    
}

local states = {

    State{
        name = "warrior_attack",
        tags = {"attack", "canrotate", "busy", "jumping"},

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(false)

            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("warrior_atk")
            inst.sg.statemem.target = target
        end,

        onexit = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.Physics:ClearMotorVelOverride()
        end,

        timeline =
        {
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "attack_grunt")) end),
            TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Jump")) end),
            TimeEvent(8*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(20,0,0) end),
            TimeEvent(9*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Attack")) end),
            --TimeEvent(19*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
            TimeEvent(20*FRAMES,
                function(inst)
					inst.components.combat:DoAttack(inst.sg.statemem.target)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events=
        {
            EventHandler("animover", 
			function(inst) 
			inst.sg:GoToState("taunt")
			end),
        },
    },
	State{
        name = "taunt",
        tags = {"busy","taunting"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound(SoundPath(inst, "scream"))
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        ontimeout = function(inst)
            inst.sg:GoToState("taunt")
        end,

        onenter = function(inst, start_anim)
            inst.Physics:Stop()
            local animname = "idle"
            if math.random() < .3 then
                inst.sg:SetTimeout(math.random()*2 + 2)
            end

            if inst.LightWatcher:GetLightValue() > 1 then
				if not inst:HasTag("tauntless") then
                inst.AnimState:PlayAnimation("cower" )
                inst.AnimState:PushAnimation("cower_loop", true)
				end
            elseif start_anim then
                inst.AnimState:PlayAnimation(start_anim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,
    },
    State{
        name = "shield",
        tags = {"busy", "shield"},

        onenter = function(inst)
            --If taking fire damage, spawn fire effect. 
            inst.components.health:SetAbsorptionAmount(TUNING.SPIDER_HIDER_SHELL_ABSORB)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hide")
            inst.AnimState:PushAnimation("hide_loop")
			if inst.components workable ~= nil then
				inst.components.workable:SetWorkLeft(1)
			end
			inst:AddTag("hiding")
        end,

        onexit = function(inst)
            inst.components.health:SetAbsorptionAmount(0)
			if inst.components workable ~= nil then
				inst.components.workable:SetWorkLeft(0)
			end
			inst:RemoveTag("hiding")
        end,
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

