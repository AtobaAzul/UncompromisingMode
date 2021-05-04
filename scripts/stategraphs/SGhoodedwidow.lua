require("stategraphs/commonstates")
local easing = require("easing")
local actionhandlers =
{
ActionHandler(ACTIONS.GOHOME, "jumphome"),
}
local events=
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("nointerrupt") and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data)
        if not inst.components.health:IsDead() then
            local weapon = inst.components.combat and inst.components.combat:GetWeapon()
            if weapon then
                if weapon:HasTag("snotbomb") then
                    inst.sg:GoToState("launchprojectile", data.target)
                else
					if inst.components.timer ~= nil and not inst.components.timer:TimerExists("pounce") then
					inst.sg:GoToState("preleapattack",data.target)
					else
					if inst.components.timer ~= nil and not inst.components.timer:TimerExists("mortar") then
					inst.sg:GoToState("lobprojectile",data.target)
					else
                    inst.sg:GoToState("attack", data.target)
					end
					end
                end
            end
        end
    end),

    CommonHandlers.OnSleep(),
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnFreeze(),
}

local function ShadowFade(inst)
inst.scaleFactor = inst.scaleFactor - 0.01
inst.Transform:SetScale(inst.scaleFactor, inst.scaleFactor, inst.scaleFactor)
if inst.scaleFactor < 0.05 then
inst:Remove()
end
end
local splashprefabs =
{
    "web_splash_fx_melted",
    "web_splash_fx_low",
    "web_splash_fx_med",
    "web_splash_fx_full",
}
local function WebMortar(inst)

	if inst.components.combat.target ~= nil then
	local target = inst.components.combat.target
    local x, y, z = inst.Transform:GetWorldPosition()
    local projectile = SpawnPrefab("web_mortar")
    projectile.shadow = SpawnPrefab("warningshadow")
	local scaleFactor = Lerp(.5, 1.5, 1)
	projectile.shadow.scaleFactor = scaleFactor
	projectile.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
	projectile.shadow = projectile.shadow:DoPeriodicTask(FRAMES, ShadowFade, nil, 5)	
	
    projectile.Transform:SetPosition(x, y, z)
    local a, b, c = target.Transform:GetWorldPosition()
	local targetpos = target:GetPosition()
	local theta = inst.Transform:GetRotation()+math.random(-15,15)
	theta = theta*DEGREES

	targetpos.x = targetpos.x + 15*math.cos(theta)

	targetpos.z = targetpos.z - 15*math.sin(theta)

	local rangesq = ((a-x)^2) + ((c-z)^2)
    local maxrange = 15
    local bigNum = 10
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
	projectile:AddTag("canthit")

    projectile.components.complexprojectile:SetHorizontalSpeed(speed*2.5*math.random(0.5,.75))
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local states=
{

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle", true)
			if math.random() < .2 then
				inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream_short")
			end
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "nointerrupt"},

        onenter = function(inst, target)
		if target ~= nil then
		inst.components.combat:SuggestTarget(target)
		end
            inst.Physics:Stop()
			local weapon = inst.components.combat and inst.components.combat:GetWeapon()
            if weapon ~= nil and weapon:HasTag("snotbomb") then
			inst.sg:GoToState("launchprojectile",target)
			else
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
			end
        end,

        timeline=
        {
            TimeEvent(0*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/attack") end),
            TimeEvent(25*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/attack_grunt") end),
            TimeEvent(28*FRAMES, function(inst) inst:PerformBufferedAction() inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/swipe") end),
            TimeEvent(28*FRAMES, function(inst) 
			inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
			inst.components.combat:DoAttack() 
			end),
        },

        events=
        {
            EventHandler("animover", function(inst)	inst.sg:GoToState("idle") end),
        },
    },

  	State{
		name = "hit",
        tags = {"busy", "hit"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/hurt")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

	State{
		name = "taunt",
        tags = {"busy"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

	State{
        name = "death",
        tags = {"busy"},
        
        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/die")
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            RemovePhysicsColliders(inst)            
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
        end,
        
    },
    State{
        name = "launchprojectile",
        tags = {"attack", "busy", "superbusy","nointerrupt"},
        
        onenter = function(inst, target)
			inst.sg.statemem.target = target
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shoot_pre")
            inst.AnimState:PushAnimation("shoot_loop", false)
            inst.AnimState:PushAnimation("shoot_pst", false)
        end,
        
        
        timeline=
        {
            TimeEvent(43*FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target)
            end),
        },
        
        events=
        {
            EventHandler("animqueueover", function(inst) 
		
			inst.sg:GoToState("idle") end),
        },
    },
    State{
        name = "lobprojectile",
        tags = {"attack", "busy", "superbusy","nointerrupt"},
        
        onenter = function(inst)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shoot_pre")
            inst.AnimState:PushAnimation("shoot_loop", false)
            inst.AnimState:PushAnimation("shoot_pst", false)
        end,
        
        
        timeline=
        {
            TimeEvent(43*FRAMES, function(inst)
			if inst.components.combat ~= nil and inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then
			local target = inst.components.combat.target
			if target.components.pinnable ~= nil then
			target.components.pinnable:Stick("web_net_trap",splashprefabs)
			target:DoTaskInTime(1, function(target) target.components.pinnable:Unstick() end)
			inst.sg:GoToState("attack")
			end
			else
			WebMortar(inst)
			if inst.components.health ~= nil and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.66 then
			WebMortar(inst)
			end
			if inst.components.health ~= nil and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.33 then
			WebMortar(inst)
			WebMortar(inst)
			end
			end
			inst.components.timer:StartTimer("mortar",20+math.random(-3,5))
            end),
        },  
        events=
        {
            EventHandler("animqueueover", function(inst) 
			inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "tossplayer", --Not Finished
        tags = {"attack", "busy", "superbusy","nointerrupt"},
        
        onenter = function(inst, target)
			inst.sg.statemem.target = target
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("poop_pre")
            inst.AnimState:PushAnimation("poop_loop", false)
            inst.AnimState:PushAnimation("poop_pst", false)
        end,
        events=
        {
            EventHandler("animqueueover", function(inst) 
		
			inst.sg:GoToState("leapattack") end),
        },
    },
	
    State{
        name = "fall",
        tags = {"busy","noweb"},
        onenter = function(inst, data)
			if inst:HasTag("notarget") then
			inst:RemoveTag("notarget")
			end
			inst.AnimState:PlayAnimation("fall")	
        end,
        events=
        {
            EventHandler("animqueueover", function(inst)
			inst.components.groundpounder:GroundPound()
            inst.sg:GoToState("taunt") end),
        },          
    },
    State{
        name = "preleapattack",
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("prejump")
        end,
		timeline =
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_voice") end),

            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_foley") end),
        },
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("leapattack") end),
        },       

    },
    State{
        name = "leapattack",
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
			inst.Physics:ClearCollisionMask()
			local speed = 10
			if inst.components.combat.target ~= nil then
			inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end
            inst.components.locomotor:Stop()
			if inst.brain then
			inst.brain:Stop()
			end
			inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
			inst.AnimState:PlayAnimation("leap", true)
			inst.Physics:SetMotorVelOverride(speed,0,0)
        end,
		timeline =
        {
			TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream_short") end),
            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/attack_grunt") end),
			TimeEvent(17*FRAMES, function(inst) inst.components.locomotor:Stop()
			inst.components.groundpounder:GroundPound()
			local x,y,z = inst.Transform:GetWorldPosition()
			MakeCharacterPhysics(inst, 1000, 1)
			inst.Transform:SetPosition(x,y,z) --I know this seems strange, but if I don't the widow actually teleports 
											  --back to where it started its jump from right as MakeCharacterPhysics is called
											  --this code makes it to where it moves the queen right back to where the end of the jump left it off.
			end),
        },
        events=
        {
            EventHandler("animover", function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream_short")
			inst.components.timer:StartTimer("pounce",10+math.random(-3,5))
			
			if inst.brain then
			inst.brain:Start()
			end
			inst.sg:GoToState("idle") end),
        },       

    },
    State{
        name = "jumphome",
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
			inst:AddTag("notarget")
            inst.AnimState:PlayAnimation("precanopy")
			inst.AnimState:PushAnimation("canopy", false)
			if inst.components.locomotor ~= nil then -- Check to make sure 
            inst.components.locomotor:Stop()
            end
        end,

	
	  events=
        {
            EventHandler("animqueueover", function(inst) 
                inst:DoDespawn()
            end),
        },   
    },
	
    State{
        name = "precanopy",
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("prejump")
        end,
		timeline =
        {
            TimeEvent(4*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_voice") end),

            TimeEvent(8*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/givebirth_foley") end),
        },
        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("canopyjump") end),
        },       

    },
State{
        name = "canopyjump", --depricated
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("leap", true)
        end,
        onupdate = function(inst)
			inst.Physics:SetMotorVel(0,20,0)		
		end,
        events=
        {
            EventHandler("animover", function(inst) 
			inst:DoTaskInTime(1.5+math.random(-1,1),function(inst)inst.sg:GoToState("canopyland") end) end),
        },       

    },
    State{
        name = "canopyland",
        tags = {"busy", "noweb","superbusy","nointerrupt"},
        onenter = function(inst, data)
			if inst:HasTag("notarget") then
			inst:RemoveTag("notarget")
			end
            inst.AnimState:PlayAnimation("fall")	
        end,
        
        events=
        {
            EventHandler("animqueueover", function(inst)
			inst.components.groundpounder:GroundPound()
            inst.sg:GoToState("taunt") end),
        }, 

    },
}

CommonStates.AddSleepStates(states,
	{
		sleeptimeline = {
	        TimeEvent(30*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/sleeping") end),
		},
	},
	{
		onsleep = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/fallasleep")
		end,
		onwake = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/wakeup")
		end
	}
)


CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
		TimeEvent(38*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/walk_spiderqueen") end),
	},
})

CommonStates.AddFrozenStates(states)

-- WAS "spiderqueen" NOW "hoodedwidow" as to not replace regular spiderqueen stategraph
-- replaced "idle" with "fall" so queen always spawns from falling
return StateGraph("hoodedwidow", states, events, "fall",actionhandlers)

--You're welcome :) ~Kind Stranger
 
--Thanks ~Lureplague Guy 


