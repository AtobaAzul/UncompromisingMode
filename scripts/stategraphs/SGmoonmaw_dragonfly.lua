require("stategraphs/commonstates")

local function NotDeerclopsFootstep(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/step")
    --ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .03, 1, inst, SHAKE_DIST)
    --ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .8, inst, 40)
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .7, .02, .8, inst, 40)
end

local function SpawnMoonGlass(inst)
    local numsteps = 4
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = (inst.Transform:GetRotation() + 90) * DEGREES
    local step = 3
    local offset = 2 - step --should still hit players right up against us
    local ground = TheWorld.Map
    local targets, skiptoss = {}, {}
    local i = -1
    local noground = false
    local fx, dist, delay, x1, z1
    while i < numsteps do
        i = i + 1
        dist = i * step + offset
        delay = math.max(0, i - 1)
        x1 = x + dist * math.sin(angle)
        z1 = z + dist * math.cos(angle)
        if not ground:IsPassableAtPoint(x1, 0, z1) then
            if i <= 0 then
                return
            end
            noground = true
        end
			
        fx = SpawnPrefab("moonmaw_glass")
        fx.caster = inst
        fx.Transform:SetPosition(x1, 0, z1)
		fx.spawnin(fx,delay/10)
        if i == 0 then
            ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .6, fx, 30)
        end
        if noground then
            break
        end
    end
end

local function onattackedfn(inst, data)
    if inst.components.health and not inst.components.health:IsDead()
    and (not inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("frozen")) then
        if inst.components.combat and data and data.attacker then inst.components.combat:SuggestTarget(data.target) end
			inst.sg:GoToState("hit")
		elseif inst.sg:HasStateTag("crashed") then
			inst.sg:GoToState("getup")

    end
end

local function onattackfn(inst)
if inst.components.health ~= nil and
        not inst.components.health:IsDead() and
        (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
		
	if inst.randattack == nil then
		inst.randattack = 0
	end
	
	local lavae = false
	for i = 1,8 do
		if inst.lavae[i].hidden ~= true then
		lavae = true
		end
	end	
	
	if inst.components.combat.target ~= nil and inst.components.combat.target:HasTag("structure") or math.random() < (inst.randattack*0.05) or lavae ~= true then
		if lavae == true then
			inst.resetcooldown = true
		end
		inst.randattack = 0
		inst.sg:GoToState("attack")
	else
		inst.randattack = inst.randattack+1
		inst.sg:GoToState("lavaeattack_pre")
	end
end
end

local function SummonCrystals(inst)
if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
	for dx = -30,30,6 do
		for dy = -30,30,6 do
			local target = inst.components.combat.target
			local projectile = SpawnPrefab("moonmaw_trapprojectile")
			local a, b, c = target.Transform:GetWorldPosition()
			a=a+dx+math.random(-1,1)
			c=c+dy+math.random(-1,1)
			projectile:AddTag("moonglasscreature")
			projectile.Transform:SetPosition(a, 0, c)
		end
	end
end
end

local function ShakeIfClose(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .7, .02, .8, inst, 40)
end

local actionhandlers = 
{   
    ActionHandler(ACTIONS.LAVASPIT, "spit"),
}

local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
	EventHandler("doattack", function(inst, data)
	onattackfn(inst)
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
        name = "spit",
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.target ~= nil and ((inst.target ~= inst and not inst.target:HasTag("fire")) or inst.target == inst) and not (inst.recently_frozen or inst.flame_on) then
                inst.Transform:SetTwoFaced()
                if inst.components.locomotor then
                    inst.components.locomotor:StopMoving()
                end
                inst.AnimState:PlayAnimation("spit")
				inst:DoTaskInTime(0.5, function(inst)
				local fx = SpawnPrefab("moonmaw_glass")
				fx.caster = inst
				fx.spawnlong(fx,10+math.random(1,10))
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                fx.Transform:SetRotation(inst.Transform:GetRotation())
				end)
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/vomitrumble", "vomitrumble")
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
            --TimeEvent(2*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
            TimeEvent(55*FRAMES, function(inst) 
                inst.SoundEmitter:KillSound("vomitrumble")
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/vomit")
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
            --TimeEvent(2*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
            TimeEvent(6*FRAMES, function(inst)
                --inst.AnimState:SetBuild("dragonfly_fire_build")
                ---inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
                --inst.Light:Enable(true)
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
			--[[local fx = SpawnPrefab("moonstorm_glass_ground_fx")
			local x,y,z = inst.Transform:GetWorldPosition()
			fx.Transform:SetPosition(x,y,z)
			fx.Transform:SetScale(1.5,1.5,1.5)]]
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
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(9*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/buttstomp_voice")
                -- local fire = SpawnPrefab("firesplash_fx")
                -- fire.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end),
            TimeEvent(20*FRAMES, function(inst) 
                inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/buttstomp")
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/buttstomp_voice")
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
				inst.sg:GoToState("idle")		
			end),
        },

        timeline=
        {
            --TimeEvent(1*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
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
            --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink")
        end,
        
        events =
        {
            EventHandler("animover", function(inst)
			if math.random() < 0.1 then
                inst.sg:GoToState("taunt_pre")
			else
				inst.sg:GoToState("idle")
			end
            end),
        },
    },

    State{
        name = "lavaeattack_pre",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.components.combat:StartAttack()
        inst.AnimState:PlayAnimation("spin_pre")
			inst.SoundEmitter:PlaySound("UCSounds/moonmaw/anger")
			for i = 1,8 do
				if inst.lavae[i] ~= nil then
					inst.lavae[i].components.linearcircler.setspeed = 1
					inst.lavae[i].components.linearcircler.distance_limit = 3
				end
			end		
        end,   
        
		TimeEvent(5*FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian2/atk_spin_pre")
		end),
		
        events=
        {
            EventHandler("animover", function(inst)
			inst.sg:GoToState("lavaeattack")
		end),
        },
    },
	
    State{
        name = "lavaeattack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.components.combat:StartAttack()
        inst.AnimState:PlayAnimation("spin")
		
        inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian2/atk_spin_LP","spin_loop")
		
		--inst.TryEjectLavae(inst)
		for i = 1,8 do
			if inst.lavae[i] ~= nil then
				inst.lavae[i].destroy = true
				inst.lavae[i].components.linearcircler.setspeed = 3
				inst.AnimState:SetFinalOffset(1)
			end
		end
			
        end,
		
            onexit = function(inst)
			for i = 1,8 do
				if inst.lavae[i] ~= nil then
					inst.lavae[i].destroy = false
					inst.lavae[i].components.linearcircler.setspeed = 0.2
					inst.lavae[i].components.linearcircler.distance_limit = 4
					inst.AnimState:SetFinalOffset(2)
				end
			end		
            end,
			
        events=
        {
            EventHandler("animover", function(inst)
				inst.SoundEmitter:KillSound("spin_loop")
				inst.sg:GoToState("idle")
			end),
        },
    },
	
    State{
        name = "attack",
        tags = {"attack", "busy", "canrotate"},
        
        onenter = function(inst)
			inst.Physics:Stop()
                inst.components.combat:StartAttack()
                inst.AnimState:PlayAnimation("atk")
				inst.SoundEmitter:PlaySound("UCSounds/moonmaw/anger")
				--attackfx.AnimState:SetMultColour(0.5,1,0.5,1)
                --inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/swipe")
            
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/swipe") end),
            TimeEvent(23*FRAMES, function(inst) 
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/punchimpact")
                inst.components.combat:DoAttack()

				SpawnMoonGlass(inst)
            end),
        },
        
        
        events=
        {
            EventHandler("animover", function(inst) 
			if inst.resetcooldown and inst.components.combat ~= nil then
				inst.components.combat:ResetCooldown()
				inst.resetcooldown = nil
			end
			inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "death",  
        tags = {"busy"},
        
        onenter = function(inst)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("death")
            inst.SoundEmitter:PlaySound("UCSounds/moonmaw/death")
            --inst.Physics:ClearCollisionMask()
			inst.Light:Enable(false)
			if inst.lavae ~= nil then
			for i = 1,8 do
				if inst.lavae[i] ~= nil then
					inst.lavae[i]:Remove()
				end
			end
			end
        end,

        timeline=
        {
            --TimeEvent(12*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
            TimeEvent(26*FRAMES, function(inst) 
            end),
            TimeEvent(28*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/land") end),
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
                    inst.AnimState:PlayAnimation("walk_pre")
                    inst.SoundEmitter:PlaySound("UCSounds/moonmaw/anger")
                else
                    inst.AnimState:PlayAnimation("walk_pre")
                end
            end,

            events =
            {   
                EventHandler("animover", function(inst) inst.sg:GoToState("walk") end ),        
            },

            timeline=
            {
                --TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end end),
                --TimeEvent(2*FRAMES, function(inst) if inst.fire_build then --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end end)
            },
        },
        
    State{
            
            name = "walk",
            tags = {"moving", "canrotate"},
            
            onenter = function(inst) 
                inst.components.locomotor:WalkForward()

                inst.AnimState:PlayAnimation("walk")

            end,
            timeline=
            {
                TimeEvent(4*FRAMES, NotDeerclopsFootstep),
                TimeEvent(10*FRAMES, NotDeerclopsFootstep),
            },
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
                        inst.AnimState:PushAnimation("walk_pst", false)
                    else
                        inst.AnimState:PushAnimation("walk_pst", false)
                    end
                else
                    if inst.fire_build then
                        inst.AnimState:PlayAnimation("walk_pst")
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
                --TimeEvent(1*FRAMES, function(inst) if not inst.fire_build then --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end end),
                --TimeEvent(2*FRAMES, function(inst) if inst.fire_build then --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end end)
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
                --TimeEvent(74*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
                TimeEvent(78*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/flap", "flying") end),
                --TimeEvent(91*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
                TimeEvent(111*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/sleep_pre") end),
                TimeEvent(202*FRAMES, function(inst) 
                    --inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/dragonfly/blink") 
                    inst.SoundEmitter:KillSound("flying")
                end),
                TimeEvent(203*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/land") end),
            },
        },
        
        State{
            name = "sleeping",
            tags = {"busy", "sleeping"},
            
            onenter = function(inst) 
                inst.AnimState:PlayAnimation("sleep_loop")
                inst.playsleepsound = not inst.playsleepsound
                if inst.playsleepsound then
                    inst.SoundEmitter:PlaySound("UCSounds/moonmaw/sleep", "sleep")
                end
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
                inst.SoundEmitter:PlaySound("UCSounds/moonmaw/wake")
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
                --TimeEvent(16*FRAMES, function(inst) --inst.SoundEmitter:PlaySound("UCSounds/moonmaw/blink") end),
                TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/flap", "flying") end),
            },
        },
    State{
        name = "skyfall",
        tags = {"busy", "canrotate"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.AnimState:PlayAnimation("skyfall")
        end,
        timeline=
        {
            TimeEvent(7*FRAMES, function(inst) inst.components.groundpounder:GroundPound()
			inst.SoundEmitter:PlaySound("UCSounds/moonmaw/land") end),
        },
		
        events=
        {
            EventHandler("animover", function(inst)
			inst.sg:GoToState("crashed")
		end),
        },
    },
    State{
        name = "crashed",
        tags = {"busy", "canrotate","crashed"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.AnimState:PlayAnimation("crashed_loop")
		end,
        events=
        {
            EventHandler("animover", function(inst)
			if inst.count == nil then
				inst.count = 0
			end
			inst.count = inst.count+1
			if inst.count > 10 then
				inst.sg:GoToState("getup")
			else
				inst.sg:GoToState("crashed")
			end
		end),
        },
    },
    State{
        name = "getup",
        tags = {"busy", "canrotate"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.AnimState:PlayAnimation("getup")
		inst.SpawnLavae(inst)
		end,
        events=
        {
            EventHandler("animover", function(inst)
			inst.sg:GoToState("idle")
		end),
        },
    },
    State{
        name = "summoncrystals",
        tags = {"busy", "canrotate","attack"},
        
        onenter = function(inst)
		inst.Physics:Stop()
        inst.AnimState:PlayAnimation("bigattack")
		end,

        timeline=
        {
			TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/moonmaw/anger") end),
            TimeEvent(26*FRAMES, function(inst) 
			inst.SoundEmitter:PlaySound("UCSounds/moonmaw/punchimpact")
			inst.components.groundpounder.numRings = 3
			inst.components.groundpounder:GroundPound()
			inst.components.groundpounder.numRings = 2
			inst.SoundEmitter:PlaySound("UCSounds/moonmaw/land") 
			end),
        },
		
        events=
        {
            EventHandler("animover", function(inst)
				SummonCrystals(inst)
				inst.sg:GoToState("idle")
		end),
        },
    },
}


return StateGraph("moonmaw_dragonfly", states, events, "idle", actionhandlers)

