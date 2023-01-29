require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    EventHandler("attacked", function(inst,data) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("thrash") and data.attacker:HasTag("pig") then inst.sg:GoToState("thrash_pre",data.attacker) end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death", inst.sg.statemem.dead) end),
    EventHandler("doattack", function(inst, data) if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then inst.sg:GoToState("attack", data.target) end end),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnHop(),
    CommonHandlers.OnLocomote(true, false),
    CommonHandlers.OnFreeze(),


    EventHandler("heardwhistle", function(inst, data)
        if not (inst.sg:HasStateTag("statue") or
                inst.components.health:IsDead() or
                (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen())) then
            if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
                inst.components.sleeper:WakeUp()
                inst.components.combat:SetTarget(nil)
            else
                if inst.components.combat:TargetIs(data.musician) then
                    inst.components.combat:SetTarget(nil)
                end
                if not inst.sg:HasStateTag("howling") then
                    inst.sg:GoToState("howl", 2)
                end
            end
        end
    end),

}

local function StartAura(inst)
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
end

local function StopAura(inst)
    inst.components.sanityaura.aura = 0
end

local states =
{
    State{
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            inst.SoundEmitter:PlaySound(inst.sounds.pant)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
            inst.sg:SetTimeout(2*math.random()+.5)
        end,
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {

            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.attack) end),
            TimeEvent(16*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if math.random() < .333 then inst.components.combat:SetTarget(nil) inst.sg:GoToState("taunt") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },

    State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
        end,

        timeline =
        {
            TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bite) end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if inst:PerformBufferedAction() then inst.components.combat:SetTarget(nil) inst.sg:GoToState("taunt") else inst.sg:GoToState("idle", "atk_pst") end end),
        },
    },

    State{
        name = "thrash_pre",
        tags = { "busy", "hit","thrash"},

        onenter = function(inst,target)
			inst.Transform:SetEightFaced()
            inst.Physics:Stop()
			inst.AnimState:SetBank("haul_pigman")
			inst.AnimState:SetBuild("haul_pigman")
            inst.AnimState:PlayAnimation("thrash_pre")
		if target ~= nil and target:IsValid() then
			inst:ForceFacePoint(target.Transform:GetWorldPosition())
			target:Remove()
		end
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("thrash_loop") end),
        },
    },
    State{
        name = "thrash_loop",
        tags = { "busy", "hit","thrash"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("thrash_loop")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst) inst.Transform:SetFourFaced()
			inst.AnimState:SetBank("hound")
			inst.AnimState:SetBuild("hound_ocean")
			inst.sg:GoToState("taunt") end),
        },
    },
    State{
        name = "startle",
        tags = { "busy", "startled" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("scared_pre")
            inst.AnimState:PushAnimation("scared_loop", true)
            inst.SoundEmitter:PlaySound(inst.components.combat.hurtsound)
            inst.sg:SetTimeout(.8 + .3 * math.random())
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", "scared_pst")
        end,
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst, norepeat)
            if inst:HasTag("clay") then
                inst.sg:GoToState("howl", norepeat and -1 or 0)
            else
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("taunt")
                inst.sg.statemem.norepeat = norepeat
            end
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bark) end),
            TimeEvent(24 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bark) end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if not inst.sg.statemem.norepeat and math.random() < .333 then
                    inst.sg:GoToState("taunt", inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("player"))
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "howl",
        tags = { "busy", "howling" },

        onenter = function(inst, count)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("howl")
            inst.sg.statemem.count = count or 0
        end,

        timeline =
        {
            TimeEvent(0, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.howl) end),
        },

        events =
        {
            EventHandler("heardwhistle", function(inst)
                inst.sg.statemem.count = 2
            end),
            EventHandler("animover", function(inst)
                if inst.sg.statemem.count > 0 then
                    inst.sg:GoToState("howl", inst.sg.statemem.count > 1 and inst.sg.statemem.count - 1 or -1)
                elseif inst.sg.statemem.count == 0 and math.random() < .333 then
                    inst.sg:GoToState("howl", inst.components.follower.leader ~= nil and inst.components.follower.leader:HasTag("player") and -1 or 0)
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst, reanimating)
		inst.Transform:SetFourFaced()
            if reanimating then
                inst.AnimState:Pause()
            else
                inst.AnimState:PlayAnimation("death")
				if inst.components.amphibiouscreature ~= nil and inst.components.amphibiouscreature.in_water then
		            inst.AnimState:PushAnimation("death_idle", true)
				end			
            end
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)

            inst.SoundEmitter:PlaySound(inst.sounds.death)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end,

        timeline =
        {
            TimeEvent(TUNING.GARGOYLE_REANIMATE_DELAY, function(inst)
                if not inst:IsInLimbo() then
                    inst.AnimState:Resume()
                end
            end),
            TimeEvent(11 * FRAMES, function(inst)
                if inst.sg.statemem.clay then
                    PlayClayFootstep(inst)
                end
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				if inst._CanMutateFromCorpse ~= nil and inst:_CanMutateFromCorpse() then
					SpawnPrefab("houndcorpse").Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst:Remove()
				end
            end),
        },
		

        onexit = function(inst)
            if not inst:IsInLimbo() then
                inst.AnimState:Resume()
            end

        end,
    },

    State{
        name = "forcesleep",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("sleep_loop", true)
        end,
    },
}

CommonStates.AddAmphibiousCreatureHopStates(states, 
{ -- config
	swimming_clear_collision_frame = 9 * FRAMES,
},
{ -- anims
},
{ -- timeline
	hop_pre =
	{
		TimeEvent(0, function(inst) 
			if inst:HasTag("swimming") then 
				SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			end
		end),
	},
	hop_pst = {
		TimeEvent(4 * FRAMES, function(inst) 
			if inst:HasTag("swimming") then 
				inst.components.locomotor:Stop()
				SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			end
		end),
		TimeEvent(6 * FRAMES, function(inst) 
			if not inst:HasTag("swimming") then 
                inst.components.locomotor:StopMoving()
			end
		end),
	}
})

CommonStates.AddSleepStates(states,
{
    sleeptimeline =
    {
        TimeEvent(30 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
    },
})

CommonStates.AddRunStates(states,
{
    runtimeline =
    {
        TimeEvent(0, function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.growl)
            if inst:HasTag("swimming") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small",nil,.25)
            else
                if inst:HasTag("clay") then
                    PlayClayFootstep(inst)
                else
                    PlayFootstep(inst)
                end
            end
        end),
        TimeEvent(4 * FRAMES, function(inst)
            if inst:HasTag("swimming") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/jump_small",nil,.25)
            else            
                if inst:HasTag("clay") then
                    PlayClayFootstep(inst)
                else
                    PlayFootstep(inst)
                end
            end
        end),
    },
})
CommonStates.AddFrozenStates(states)

return StateGraph("haul_hound", states, events, "taunt", actionhandlers)
