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

    local _OldAttackEvent = inst.events["doattack"] ~= nil and inst.events["doattack"].fn or nil
    if _OldAttackEvent then
        inst.events["doattack"].fn = function(inst, data)
            if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) and inst:HasTag("spider_regular") then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and
                    not
                    (
                    inst:IsNear(data.target, TUNING.SPIDER_WARRIOR_MELEE_RANGE) or
                        (TUNING.DSTU.REGSPIDERJUMP == false and inst:HasTag("spider_regular")))
                    and "warrior_attack" --Do leap attack
                    or "attack",
                    data.target
                )
            else
                _OldAttackEvent(inst, data)
            end
        end
    end

    local _OldAttackedEvent = inst.events["attacked"].fn
    inst.events["attacked"].fn = function(inst)
        if not inst.components.health:IsDead() and inst:HasTag("spider_warrior") then
            if not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("evade") then -- don't interrupt attack or exit shield
                if inst:HasTag("spider_warrior") and not inst:HasTag("trapdoorspider") and
                    inst.components.combat.target ~= nil and TUNING.DSTU.SPIDERWARRIORCOUNTER then
                    inst.sg:GoToState("evade_loop")
                else
                    _OldAttackedEvent(inst)
                end
            end
        else
            _OldAttackedEvent(inst)
        end
    end

    --[[local events =
{	
	EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            if inst:HasTag("spider_warrior") or inst:HasTag("spider_spitter") or inst:HasTag("spider_moon") then
                if not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("evade") then -- don't interrupt attack or exit shield
					if inst:HasTag("spider_warrior") and not inst:HasTag("trapdoorspider") and inst.components.combat.target ~= nil and TUNING.DSTU.SPIDERWARRIORCOUNTER then
					inst.sg:GoToState("evade_loop")
					else
                    inst.sg:GoToState("hit") -- can still attack
					end
                end
            elseif not inst.sg:HasStateTag("shield") then
                inst.sg:GoToState("hit_stunlock")  -- can't attack during hit reaction
            end
        end
    end),
    EventHandler("doattack", function(inst, data) 
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            --target CAN go invalid because SG events are buffered
            if inst:HasTag("spider_warrior") or inst:HasTag("spider_regular") then
                inst.sg:GoToState(
                    data.target:IsValid()
                    and not (inst:IsNear(data.target, TUNING.SPIDER_WARRIOR_MELEE_RANGE) or (TUNING.DSTU.REGSPIDERJUMP == false and inst:HasTag("spider_regular")))
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
    
}]]

    local states = {

        --[[State{
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
    },]]
        State {
            name = "shield",
            tags = { "busy", "shield" },

            onenter = function(inst)
                --If taking fire damage, spawn fire effect.
                inst.components.health:SetAbsorptionAmount(TUNING.SPIDER_HIDER_SHELL_ABSORB)
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("hide")
                inst.AnimState:PushAnimation("hide_loop")
                if inst.components.workable ~= nil then
                    inst.components.workable:SetWorkLeft(1)
                end
                inst:AddTag("hiding")
            end,

            onexit = function(inst)
                inst.components.health:SetAbsorptionAmount(0)
                if inst.components.workable ~= nil then
                    inst.components.workable:SetWorkLeft(0)
                end
                inst:RemoveTag("hiding")
            end,
        },
        State {
            name = "evade",
            tags = { "busy", "evade", "no_stun" },

            onenter = function(inst)
                inst.components.locomotor:Stop()
                --inst.AnimState:PlayAnimation("evade")
                --inst.components.locomotor:EnableGroundSpeedMultiplier(false)
                --inst.Physics:SetMotorVelOverride(-20,0,0)
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.components.combat.target ~= nil then
                        inst.sg:GoToState("evade_loop")
                    else
                        inst.sg:GoToState("hit")
                    end
                end),
            },
        },

        State {
            name = "evade_loop",
            tags = { "busy", "evade", "no_stun" },


            onenter = function(inst)
                if inst ~= nil then
                    inst.sg:SetTimeout(0.1)
                    if inst.components.combat.target and inst.components.combat.target:IsValid() then
                        inst:ForceFacePoint(inst.components.combat.target:GetPosition())
                    else
                        inst.sg:GoToState("hit")
                    end
                    inst.components.locomotor:Stop()
                    inst.AnimState:PlayAnimation("evade", true)
                    inst.Physics:SetMotorVelOverride(-30, 0, 0)
                    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
                end
            end,
            --[[
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("evade_pst") 
            end ),
        },  
]]
            timeline =
            {
                TimeEvent(3 * FRAMES, function(inst) inst.Physics:SetMotorVel(-20, 0, 0) end),

            },
            ontimeout = function(inst)
                inst.sg:GoToState("evade_pst")
            end,

            onexit = function(inst)
                inst.components.locomotor:EnableGroundSpeedMultiplier(true)
                inst.Physics:ClearMotorVelOverride()
                inst.components.locomotor:Stop()
            end,
        },

        State {
            name = "evade_pst",
            tags = { "busy", "evade", "no_stun" },

            onenter = function(inst)
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                    inst:ForceFacePoint(inst.components.combat.target:GetPosition())
                end
                inst.components.locomotor:Stop()
                --inst.AnimState:PlayAnimation("evade_pst")
            end,

            events =
            {
                EventHandler("animover", function(inst)
                    if inst.components.combat.target and inst.components.combat.target:IsValid() then

                        local JUMP_DISTANCE = 3

                        local distance = inst:GetDistanceSqToInst(inst.components.combat.target)
						
                        if distance > JUMP_DISTANCE * JUMP_DISTANCE then
                            inst.sg:GoToState("warrior_attack", inst.components.combat.target)
                        else
                            inst.sg:GoToState("attack", inst.components.combat.target)
                        end
                    else
                        inst.sg:GoToState("idle")
                    end

                end),
            },

            onexit = function(inst)
                inst.components.locomotor:EnableGroundSpeedMultiplier(true)
                inst.Physics:ClearMotorVelOverride()
                inst.components.locomotor:Stop()
            end,
        },
    }

    --[[for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end]]

    for k, v in pairs(states) do
        assert(v:is_a(State), "Non-state added in mod state table!")
        inst.states[v.name] = v
    end

end)
