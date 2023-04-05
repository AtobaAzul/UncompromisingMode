require("stategraphs/commonstates")
local easing = require("easing")
local actionhandlers =
{
ActionHandler(ACTIONS.GOHOME, "jumphome"),
}

--sdfqocipqowiecjAAAAAAASSDFFASDFASDFQWCQWCQWE
local events=
{
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() and not inst.sg:HasStateTag("ability") and not inst.sg:HasStateTag("attack") then inst.sg:GoToState("hit") end end),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("doattack", function(inst, data)
		if not inst.sg:HasStateTag("busy") then
			if not inst.components.health:IsDead() then
				local weapon = inst.components.combat and inst.components.combat:GetWeapon()
				if weapon then
					if weapon:HasTag("snotbomb") then
						inst.sg:GoToState("launchprojectile", data.target)
					else
						if inst.components.timer and not inst.components.timer:TimerExists("pounce") then
							inst.sg:GoToState("preleapattack")
						else
							if inst.components.timer and not inst.components.timer:TimerExists("mortar") then
								inst.sg:GoToState("lobprojectile")
							else
								inst.sg:GoToState("attack", data.target)
							end
						end
					end
				else
					inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
					inst.sg:GoToState("attack", data.target)
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
local function WebMortar(inst,angle)

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
	if angle == nil then
	angle = 0
	end
	local theta = inst.Transform:GetRotation()+angle
	theta = theta*DEGREES

	targetpos.x = targetpos.x + 15*math.cos(theta)

	targetpos.z = targetpos.z - 15*math.sin(theta)

	local rangesq = ((a-x)^2) + ((c-z)^2)
	--print("rangsq "..rangesq)
    local maxrange = 15
    local bigNum = 10
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
	projectile:AddTag("canthit")
	--print("speed "..speed)
	speed = speed*2*math.random(0.5,1)
	--print("speedrand ".. speed)
	if speed < 5 then
	speed = 14*math.random(100,200)*0.01
	end
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local states=
{

    State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
			if inst.should_go_tired then
				inst.sg:GoToState("tired")
				inst.should_go_tired = false
			end
		
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
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
			if math.random() < 0.5/inst.combo and inst.components.health ~= nil and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.5 then
				inst.docombo = true
				if inst.combo == 1 then
					--TheNet:SystemMessage("Starting Attack/Combo!")
					inst.combosucceed = false
				end
			end
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
            EventHandler("animover", function(inst)
				--TheNet:Announce("combo is "..inst.combo)
				if inst.components.health and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.5 and inst.docombo then
					inst.docombo = false
					--TheNet:SystemMessage(inst.combo)
					inst.combo = inst.combo+2
					inst.sg:RemoveStateTag("busy")
					inst.sg:GoToState("attack")
				else
					if inst.combosucceed == false and inst.combo > 1 then
						--TheNet:Announce("told_to_go_to_tired")
						inst.combosucceed = true
						inst.sg:GoToState("tired")
					else
						inst.combo = 1
						inst.sg:GoToState("idle") 
					end
				end 
			end),
        },
		
		onexit = function(inst)
			inst.components.inventory:Equip(inst.weaponitems.meleeweapon)
		end,
    },

  	State{
		name = "hit",
        tags = {"hit"},

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
		name = "tired",
        tags = {"busy", "ability"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("tired")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spiderqueen/scream")
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
        tags = {"attack", "busy", "ability"},
        
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
            TimeEvent(47*FRAMES, function(inst)
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
        tags = {"attack", "busy", "ability"},
        
        onenter = function(inst)
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("shoot_pre")
            inst.AnimState:PushAnimation("shoot_loop", false)
            inst.AnimState:PushAnimation("shoot_pst", false)
        end,
        
        
        timeline=
        {
            TimeEvent(47*FRAMES, function(inst)
			if inst.components.combat and inst.components.combat.target ~= nil and inst.components.combat:CanHitTarget(inst.components.combat.target) then
				local target = inst.components.combat.target
				if target.components.pinnable ~= nil then
					target.components.pinnable:Stick("web_net_trap",splashprefabs)
					target:DoTaskInTime(1, function(target) target.components.pinnable:Unstick() end)
				end
				inst.armorcrunch = true --!
				inst.sg:GoToState("attack")
			end
			WebMortar(inst,-15)
			WebMortar(inst,15)
			if inst.components.health and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.66 and inst.components.health.currenthealth > TUNING.DSTU.WIDOW_HEALTH*0.33 then
				WebMortar(inst,0)
			end
			if inst.components.health and inst.components.health.currenthealth < TUNING.DSTU.WIDOW_HEALTH*0.33 then
				WebMortar(inst,-30)
				WebMortar(inst,30)
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
        tags = {"attack", "busy", "ability"},
        
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
		
			inst.sg:GoToState("attack") end),
        },
    },
	
    State{
        name = "fall",
        tags = {"busy","noweb","ability"},
        onenter = function(inst, data)
			if inst:HasTag("notarget") then
				inst:RemoveTag("notarget")
			end
			inst.AnimState:PlayAnimation("fall")	
        end,
		timeline =
        {
            TimeEvent(10*FRAMES, function(inst) 
			inst.components.combat:DoAreaAttack(inst, TUNING.SPIDERQUEEN_ATTACKRANGE * 1.2) --GroundPound Is purely visual
			inst.components.groundpounder:GroundPound() end),

        },
        events=
        {
            EventHandler("animqueueover", function(inst)
            inst.sg:GoToState("taunt") end),
        },          
    },
    State{
        name = "preleapattack",
        tags = {"busy", "noweb","ability"},
        onenter = function(inst)
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
        tags = {"busy", "noweb","ability"},
        onenter = function(inst, data)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.WORLD)
			local speed = 10
			if inst.components.combat.target ~= nil then
				inst:ForceFacePoint(inst.components.combat.target:GetPosition())
			end
            inst.components.locomotor:Stop()
			if inst.components.combat ~= nil and inst.components.combat.target ~= nil then
				inst.oldtarget = inst.components.combat.target
			end
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
			TimeEvent(20*FRAMES, function(inst) inst.components.locomotor:Stop()
			
			inst.components.combat:DoAreaAttack(inst, TUNING.SPIDERQUEEN_ATTACKRANGE) --GroundPound Is purely visual
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
			
			if inst.oldtarget ~= nil and inst.components.combat ~= nil and inst.oldtarget:IsValid() then
				inst.components.combat:SuggestTarget(inst.oldtarget)
			end
			inst.sg:GoToState("idle") end),
        },       
		
		onexit = function(inst)
			if inst.brain then
				inst.brain:Start()
			end
		end,

    },
    State{
        name = "jumphome",
        tags = {"busy", "noweb","ability"},
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
        tags = {"busy", "noweb","ability"},
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
        tags = {"busy", "noweb","ability"},
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
        tags = {"busy", "noweb","ability"},
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
			inst.components.combat:DoAreaAttack(inst, TUNING.SPIDERQUEEN_ATTACKRANGE * 1.2) --GroundPound Is purely visual
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


