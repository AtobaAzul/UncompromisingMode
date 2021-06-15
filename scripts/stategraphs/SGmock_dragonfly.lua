require("stategraphs/commonstates")

TUNING.DRAGONFLY_SLEEP_WHEN_SATISFIED_TIME = 240
TUNING.DRAGONFLY_VOMIT_TARGETS_FOR_SATISFIED = 40
TUNING.DRAGONFLY_ASH_EATEN_FOR_SATISFIED = 20

local function ShouldStopSpin(inst)
	local pos = inst:GetPosition()

	local nearby_player = FindClosestPlayerInRange(pos.x, pos.y, pos.z, 20, true)
	local time_out = inst.numSpins >= 3

	return not nearby_player or time_out
end

local function FireTrail(inst, x, y, z)
	SpawnPrefab("firesplash_fx").Transform:SetPosition(x, y, z)
	inst.firedrop = SpawnPrefab("firedrop")
	inst.firedrop.Transform:SetPosition(x, y, z)
	inst.firedrop:DoTaskInTime(1.5, function(inst) inst.components.burnable:Extinguish() end)
	inst.firedrop.persists = false
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo", nil, .5)
    --inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    local ents = TheSim:FindEntities(x, y, z, 3.5, nil, { "INLIMBO" })

    for i, v in ipairs(ents) do
        if v ~= inst and v:IsValid() and not v:IsInLimbo() then

            --Recheck valid after work
            if v:IsValid() and not v:IsInLimbo() then
                if v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end
            end
        end
    end
end

local function LightningStrike(inst)

	--inst.rockthrow = false

	local x, y, z = inst.Transform:GetWorldPosition()
	local targetpos = inst:GetPosition()
	local theta = inst.Transform:GetRotation()

    local angle1 = (inst.Transform:GetRotation()) * DEGREES
    local angle2 = (inst.Transform:GetRotation() + 180) * DEGREES
	--theta = theta*DEGREES
    local x1, z1, x2, z2

	x1 = x + 1 * math.sin(angle1)
	z1 = z + 1 * math.cos(angle1)
	x2 = x + 1 * math.sin(angle2)
	z2 = z + 1 * math.cos(angle2)
	
	FireTrail(inst, x1, 0, z1)
	FireTrail(inst, x2, 0, z2)

	local scorch1 = SpawnPrefab("deerclops_laserscorch")
	scorch1.Transform:SetPosition(x1, 0, z1)
	local scorch2 = SpawnPrefab("deerclops_laserscorch")
	scorch2.Transform:SetPosition(x2, 0, z2)
end

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
    and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        if inst.components.combat and data and data.attacker then inst.components.combat:SuggestTarget(data.target) end
        inst.sg:GoToState("hit")
    end
end

local function onattackfn(inst)
    if inst.components.health ~= nil and
        not inst.components.health:IsDead() and
        (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
		
        inst.sg:GoToState("attack")
    end
end

--local SHAKE_DIST = 40
local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .8, inst, 40)
end

local actionhandlers = 
{
    --ActionHandler(ACTIONS.GOHOME, "taunt"),     
    ActionHandler(ACTIONS.LAVASPIT, "spit"),
    ActionHandler(ACTIONS.PICKUP, "eat"),
}

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    --CommonHandlers.OnAttack(),
	EventHandler("doattack", function(inst, data)
		if inst.rockthrow == true and not inst.components.health:IsDead() and inst.fire_build ~= nil and inst.fire_build == true then
			inst.sg:GoToState("charge_warning")
			--[[if math.random() >= 0.5 then
				inst.sg:GoToState("flamethrower")
			else
				inst.sg:GoToState("flamethrower")
			end]]
		else
			if math.random() > 0.75 then
				inst.sg:GoToState("flamethrower")
			else
				onattackfn(inst)
			end
		end
	end),
    CommonHandlers.OnDeath(),
    EventHandler("attacked", onattackedfn),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle"},
        
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
        end,
    },

    State{
        name = "eat",
        tags = {"idle", "busy", "eat"},
        
        onenter = function(inst)
            if inst.ashes then 
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("eat")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/suckup")
                inst.last_spit_time = GetTime() -- treat this as a spit so he doesn't go directly to a spit
                if inst.ashes then 
                    inst.num_ashes_eaten = inst.num_ashes_eaten + (inst.ashes.components.stackable and inst.ashes.components.stackable:StackSize() or 1)
                    inst.ashes:VacuumUp()
                end
            else
                inst.sg:GoToState("idle")
            end
        end,

        onexit = function(inst)
            inst:ClearBufferedAction()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(31*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/chew") end),
            TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
        },
    },

    State{
        name = "spit",
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.target ~= nil and ((inst.target ~= inst and not inst.target:HasTag("fire")) or inst.target == inst) and not (inst.recently_frozen or inst.flame_on) then
                inst.Transform:SetTwoFaced()
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.AnimState:PlayAnimation("vomit")
                inst.vomitfx = SpawnPrefab("vomitfire_fx")
                inst.vomitfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.vomitfx.Transform:SetRotation(inst.Transform:GetRotation())
				inst:DoTaskInTime(2.2, function(inst)
				inst.spittle = SpawnPrefab("lavaspit")
                inst.spittle.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.spittle.Transform:SetRotation(inst.Transform:GetRotation())
                inst.spittle.dragonflyspit = true
				end)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomitrumble", "vomitrumble")
            else
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle")
            end
        end,

        onexit = function(inst)
            if inst.last_target and inst.last_target ~= inst then
                inst.num_targets_vomited = inst.last_target.components.stackable and inst.num_targets_vomited + inst.last_target.components.stackable:StackSize() or inst.num_targets_vomited + 1
                inst.last_target_spit_time = GetTime()
            end
            inst.Transform:SetSixFaced()
            if inst.vomitfx then 
                inst.vomitfx:Remove() 
            end
            inst.vomitfx = nil
            inst.SoundEmitter:KillSound("vomitrumble")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) 
                inst.sg:GoToState("idle") 
            end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(55*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("vomitrumble")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomit")
            end),
            TimeEvent(59*FRAMES, function(inst) 
                inst:PerformBufferedAction()
                inst.last_target = inst.target
                inst.target = nil
                inst.spit_interval = math.random(20,30)
                inst.last_spit_time = GetTime()
            end),
        },
    },
    
	State{
        name = "taunt_pre",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt_pre")
            inst.last_target_spit_time = nil -- Aggro, no longer care about spit timing
            inst.last_spit_time = nil -- Aggro, no longer care about spit timing
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(6*FRAMES, function(inst)
                inst.AnimState:SetBuild("dragonfly_fire_build")
                inst.SoundEmitter:KillSound("fireflying")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/firedup", "fireflying")
                ---inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
                inst.Light:Enable(true)
                inst.components.propagator:StartSpreading()
                inst.fire_build = true
            end),
        },
    },

    State{
        name = "taunt",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            local tauntfx = SpawnPrefab("tauntfire_fx")
            tauntfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            tauntfx.Transform:SetRotation(inst.Transform:GetRotation())
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("taunt_post") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(9*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
        },
    },

    State{
        name = "taunt_post",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("taunt_pst")
        end,
        
        events=
        {
            EventHandler("animover", function(inst) 
				if inst.rockthrow == true and not inst.components.health:IsDead() and inst.fire_build ~= nil and inst.fire_build == true then
					inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/distant")
					inst.sg:GoToState("charge_warning")
				else
					if math.random() > 0.75 then
						inst.sg:GoToState("flamethrower")
					else
						inst.sg:GoToState("idle")
					end
				end
			end),
        },

        timeline=
        {
            TimeEvent(1*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
        },
    },

    State{
        name = "flameoff",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("flame_off")
            inst.last_target_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
            inst.last_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
        end,
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },

        timeline=
        {
            TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(5*FRAMES, function(inst)
                local firefx = SpawnPrefab("firesplash_fx")
                firefx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.flame_on = false
                inst.Light:Enable(false)
                --inst.AnimState:ClearBloomEffectHandle()
                inst.components.propagator:StopSpreading()
                inst.AnimState:SetBuild("dragonfly_build")
                inst.fire_build = false
            end),
        },
    },

    State{
        name = "hit",
        tags = {"hit", "busy"},
        
        onenter = function(inst, cb)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end

            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) 
                if inst.flame_on and not inst.fire_build then
                    inst.sg:GoToState("idle") 
                else
                    inst.sg:GoToState("taunt_pre")
                end
            end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
            if not inst.flame_on or not inst.fire_build then
                inst.flame_on = true
                inst.sg:GoToState("taunt_pre")
            else
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk")
                local attackfx = SpawnPrefab("attackfire_fx")
                attackfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                attackfx.Transform:SetRotation(inst.Transform:GetRotation())
                --inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/swipe")
            end
        end,

        timeline=
        {
            TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/swipe") end),
            TimeEvent(15*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/punchimpact")
                inst.components.combat:DoAttack()
                if inst.components.combat.target and inst.components.combat.target.components.health then
                    inst.components.combat.target.components.health:DoFireDamage(5)
                end
            end),
        },
        
        
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "death",  
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.Light:Enable(false)
            --inst.AnimState:ClearBloomEffectHandle()
            inst.components.propagator:StopSpreading()
            -- inst.AnimState:SetBuild("dragonfly_build")
            inst.AnimState:PlayAnimation("death")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/death")
            inst.Physics:ClearCollisionMask()
        end,

        timeline=
        {
            TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
            TimeEvent(26*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("flying") 
                inst.SoundEmitter:KillSound("fireflying")
            end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") end),
            TimeEvent(29*FRAMES, function(inst)
                ShakeIfClose(inst)
                inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
            end),
        },

    },

    State{
            name = "walk_start",
            tags = {"moving", "canrotate"},

            onenter = function(inst)
                if inst.fire_build then
                    inst.AnimState:PlayAnimation("walk_angry_pre")
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry")
                else
                    inst.AnimState:PlayAnimation("walk_pre")
                end
                inst.components.locomotor:WalkForward()
            end,

            events =
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
            },

            timeline=
            {
                TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end),
                TimeEvent(2*FRAMES, function(inst) if inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end)
            },
        },
        
    State{
            
            name = "walk",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:WalkForward()
                if inst.fire_build then
                    inst.AnimState:PlayAnimation("walk_angry")
                    if math.random() < .5 then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry") end
                else
                    inst.AnimState:PlayAnimation("walk")
                end
            end,
            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
            },
        },        
    
    State{
            
            name = "walk_stop",
            tags = {"canrotate"},
            
            onenter = function(inst) 
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end

                local should_softstop = false
                if should_softstop then
                    if inst.fire_build then
                        inst.AnimState:PushAnimation("walk_angry_pst", false)
                    else
                        inst.AnimState:PushAnimation("walk_pst", false)
                    end
                else
                    if inst.fire_build then
                        inst.AnimState:PlayAnimation("walk_angry_pst")
                    else
                        inst.AnimState:PlayAnimation("walk_pst")
                    end
                end
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),        
            },

            timeline=
            {
                TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end),
                TimeEvent(2*FRAMES, function(inst) if inst.fire_build then inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end end)
            },
        },

        State{
            name = "sleep",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.last_target_spit_time = nil -- Unset spit timers so he doesn't aggro while sleeping
                inst.last_spit_time = nil -- Unset spit timers so he doesn't aggro while sleeping
                inst.AnimState:PlayAnimation("land")
                inst.AnimState:PushAnimation("land_idle", false)
                inst.AnimState:PushAnimation("takeoff", false)
                inst.AnimState:PushAnimation("sleep_pre", false)
            end,

            events=
            {   
                EventHandler("animqueueover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },

            timeline=
            {
                TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:KillSound("flying") end),
                TimeEvent(16*FRAMES, function(inst) 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land")
                    if inst.fire_build then
                        inst.SoundEmitter:KillSound("fireflying")
                        local firefx = SpawnPrefab("firesplash_fx")
                        firefx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                        inst.flame_on = false
                        inst.Light:Enable(false)
                        --inst.AnimState:ClearBloomEffectHandle()
                        inst.components.propagator:StopSpreading()
                        inst.AnimState:SetBuild("dragonfly_build")
                        inst.fire_build = false
                    end
                end),
                TimeEvent(74*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(78*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying") end),
                TimeEvent(91*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(111*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/sleep_pre") end),
                TimeEvent(202*FRAMES, function(inst) 
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") 
                    inst.SoundEmitter:KillSound("flying")
                end),
                TimeEvent(203*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/land") end),
            },
        },
        
        State{
            name = "sleeping",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                inst.AnimState:PlayAnimation("sleep_loop")
                inst.playsleepsound = not inst.playsleepsound
                if inst.playsleepsound then
                    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/sleep", "sleep")
                end
            end,

            onexit = function(inst)
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("sleeping") end ),        
                EventHandler("onwakeup", function(inst) inst.sg:GoToState("wake") end),
            },
        },        
    
        State{
            name = "wake",
            tags = {"busy", "waking"},
            
            onenter = function(inst) 
                inst.SoundEmitter:KillSound("sleep")
                inst.components.locomotor:StopMoving()
                inst.AnimState:PlayAnimation("sleep_pst")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/wake")
                inst.last_spit_time = GetTime() -- Fake this as a spit to make him not re-aggro immediately
                inst.last_target_spit_time = GetTime() -- Fake this as a target spit to make him not re-aggro immediately
                if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
                    inst.components.sleeper:WakeUp()
                end
            end,

            events=
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),        
            },

            timeline=
            {
                TimeEvent(16*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
                TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying") end),
            },
        },
		
		State{
			name = "pre_shoot",
			tags = {"busy", "canrotate"},

			onenter = function(inst, target)
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("taunt")
				if target ~= nil then
					inst:FacePoint(target.Transform:GetWorldPosition())
				end
			end,

			timeline=
			{
				TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomitrumble") end),
				TimeEvent(9*FRAMES, function(inst) DoFootstep(inst) end),
				TimeEvent(33*FRAMES, function(inst) DoFootstep(inst) end),
			},

			events=
			{
				EventHandler("animover", function(inst) inst:ClearBufferedAction() inst.sg:GoToState("shoot") end),
			},
		},
		
		State{
			name = "flamethrower",
			tags = { "attack", "canrotate", "busy" },

			onenter = function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
				
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
				if not target then
                target = inst.components.combat.target
				end
			
				if target then
					inst.sg.statemem.target = target
				else
					inst.sg:GoToState("idle")
				end
				inst.Physics:Stop()

				inst.AnimState:PlayAnimation("vomit_atk")
				if inst.foogley ~= nil then
					inst.foogley = inst.foogley + 1
				else
					inst.foogley = 0
				end
			end,

			timeline =
			{   
            TimeEvent(56*FRAMES, function(inst) 
				if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    --inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
			
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())
					inst:LaunchProjectile(inst.sg.statemem.target)
					
				end
			end),
            TimeEvent(58*FRAMES, function(inst)
				if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    --inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
			
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())
					inst:LaunchProjectile(inst.sg.statemem.target)
					
				end
			end),
            TimeEvent(60*FRAMES, function(inst) 
				if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    --inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
			
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())
					inst:LaunchProjectile(inst.sg.statemem.target)
					
				end
			end),
            TimeEvent(62*FRAMES, function(inst) 
				if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    --inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
			
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())
					inst:LaunchProjectile(inst.sg.statemem.target)
					
				end
			end),
            TimeEvent(64*FRAMES, function(inst) 
				if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    --inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
			
				if inst.sg.statemem.target and inst.sg.statemem.target:IsValid() then
					inst.sg.statemem.inkpos = Vector3(inst.sg.statemem.target.Transform:GetWorldPosition())
					inst:LaunchProjectile(inst.sg.statemem.target)
					
				end
			end)
			},

			events =
			{
            EventHandler("animover", function(inst)
				local randomness = math.random(0,1)
				if inst.foogley < randomness then
					inst.sg:GoToState("flamethrower")
				else
					inst.foogley = 0
					inst.sg:GoToState("idle")
				end
			 end),
			},
		},

		State{
			name = "charge_warning",
			tags = { "busy", "attack" },

			onenter = function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
				
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
				
				inst.components.locomotor:StopMoving()
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("fire_on")
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry")
			end,

			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("spin_pre")
				end),
			},

			timeline =
			{
				TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") end),
			},
		},  
		
		State{
			name = "spin_pre",
			tags = {"busy", "attack", "canrotate"},

			onenter = function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
				
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
			
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("dash_pre")
				inst.numSpins = 0
			end,

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("spin_loop") end),
			},

			timeline =
			{
				TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry") end),
			},
		},
		
		State{
			name = "spin_pre2",
			tags = {"busy", "attack", "canrotate"},

			onenter = function(inst)
				local target = inst.components.combat.target ~= nil and inst.components.combat.target or nil
				
				if target ~= nil and target.Transform ~= nil then
					inst:ForceFacePoint(target.Transform:GetWorldPosition())
				end
			
				inst.Physics:Stop()
				inst.AnimState:PlayAnimation("dash_pre")
			end,

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("spin_loop") end),
			},

			timeline =
			{
				TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/angry") end),
			},
		},

		State{
			name = "spin_loop",
			tags = {"busy", "spinning", "attack", "canrotate"},

			onenter = function(inst)
				inst.AnimState:PlayAnimation("charge")
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/vomitrumble", "spinLoop")

				inst.components.locomotor.runspeed = 15
				
				local fx = SpawnPrefab("mossling_spin_fx")
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0,0.1,0)
				
				inst.TrailFire = inst:DoPeriodicTask(2.3*FRAMES,
				function(inst)
					LightningStrike(inst)
				end)
			end,

			onupdate = function(inst)
				inst.components.locomotor:RunForward()
			end,

			onexit = function(inst)
				if inst.TrailFire then
					inst.TrailFire:Cancel()
					inst.TrailFire = nil
				end
				inst.components.locomotor.runspeed = 6
				inst.SoundEmitter:KillSound("spinLoop")
				inst.components.locomotor:StopMoving()
			end,

			timeline=
			{
				TimeEvent(5*FRAMES, function(inst) inst.components.combat:DoAttack() end),
				TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack() end),
				TimeEvent(45*FRAMES, function(inst) inst.components.combat:DoAttack() end),
			},

			events=
			{
				EventHandler("animover",
				function(inst)
					inst.numSpins = inst.numSpins + 1
					if ShouldStopSpin(inst) then
						inst.sg:GoToState("spin_pst")
					else
						inst.sg:GoToState("spin_pre2")
					end
				end),
			},
		},

		State{
			name = "spin_pst",
			tags = {"busy"},

			onenter = function(inst)
				inst.AnimState:PlayAnimation("charge_pst")
				
				inst.rockthrow = false
				
				inst.components.timer:StopTimer("RockThrow")
				inst.components.timer:StartTimer("RockThrow", TUNING.BEARGER_NORMAL_GROUNDPOUND_COOLDOWN * 2)
			end,

			events =
			{
				EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
			},
		},
}

--CommonStates.AddFrozenStates(states)

CommonStates.AddFrozenStates(states,
    function(inst) --onoverridesymbols
        inst.SoundEmitter:KillSound("flying")
        if inst.enraged then
            inst:TransformNormal()
            inst.SoundEmitter:KillSound("fireflying")
        end
    end,
    function(inst) --onclearsymbols
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/fly", "flying")
    end
)

return StateGraph("mock_dragonfly", states, events, "idle", actionhandlers)

