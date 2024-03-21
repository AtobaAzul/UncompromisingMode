local env = env
GLOBAL.setfenv(1, GLOBAL)

local BOUNCESTUFF_MUST_TAGS = { "_inventoryitem" }
local BOUNCESTUFF_CANT_TAGS = { "locomotor", "INLIMBO" }

local function shield_fxanim(inst)
    inst._fx.AnimState:PlayAnimation("hit")
    inst._fx.AnimState:PushAnimation("idle_loop")
end

local function ClearRecentlyBounced(inst, other)
    inst.sg.mem.recentlybounced[other] = nil
end

local function SmallLaunch(inst, launcher, basespeed)
    local hp = inst:GetPosition()
    local pt = launcher:GetPosition()
    local vel = (hp - pt):GetNormalized()
    local speed = basespeed * 2 + math.random() * 2
    local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
    inst.Physics:Teleport(hp.x, .1, hp.z)
    inst.Physics:SetVel(math.cos(angle) * speed, 1.5 * speed + math.random(), math.sin(angle) * speed)

    launcher.sg.mem.recentlybounced[inst] = true
    launcher:DoTaskInTime(.6, ClearRecentlyBounced, inst)
end

local function BounceStuff(inst) --Possibly upvaluehack this function in the future?
    if inst.sg.mem.recentlybounced == nil then
        inst.sg.mem.recentlybounced = {}
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 6, BOUNCESTUFF_MUST_TAGS, BOUNCESTUFF_CANT_TAGS)
    for i, v in ipairs(ents) do
        if v:IsValid() and not (v.components.inventoryitem.nobounce or inst.sg.mem.recentlybounced[v]) and v.Physics ~= nil and v.Physics:IsActive() then
            local distsq = v:GetDistanceSqToPoint(x, y, z)
            local intensity = math.clamp((36 - distsq) / 27, 0, 1)
            SmallLaunch(v, inst, intensity)
        end
    end
end

local function SetUpProjectiles(inst)
	for i = 1,5 do
		inst:LaunchProjectile(inst)
	end
end

env.AddStategraphPostInit("minotaur", function(inst)
	local _OldAttackEvent = inst.events["doattack"].fn --Event handler to force the leap if we haven't done the leap for long enough (brainside leap still independent
	inst.events["doattack"].fn = function(inst, data)
		if inst.forcebelch and inst.components.combat and inst.components.combat.target and not inst.sg:HasStateTag("running") then
			inst.sg:GoToState("belch")
		else
			if inst.forceleap and inst.components.combat and inst.components.combat.target and inst.components.combat.target:IsValid() and inst:GetDistanceSqToInst(inst.components.combat.target) < 15^2 then
				inst.sg:GoToState("leap_attack_pre",inst.components.combat.target)
			else
				_OldAttackEvent(inst, data)
			end
		end
    end	
	
	local _OldAttackedEvent = inst.events["attacked"].fn
	inst.events["attacked"].fn = function(inst, data)
		if inst:HasTag("forcefield") then
			shield_fxanim(inst)
		else
			_OldAttackedEvent(inst, data)
		end
	end
	
	local _OldOnEnter = inst.states["run_start"].onenter 
	inst.states["run_start"].onenter = function(inst)
		if inst.forceleap and inst.components.combat and inst.components.combat.target then
			inst.sg:GoToState("leap_attack_pre",inst.components.combat.target)
		else
			_OldOnEnter(inst)
		end
	end
	
	------------------------------------------------------------
	inst.states["stun_pst"].onexit = function(inst)
		if inst.forcebelch and inst.components.health and not inst.components.health:IsDead() then
			inst:DoTaskInTime(0,function(inst) inst.sg:GoToState("belch") end)
		end
	end
	
	local _OldOnExit = inst.states["leap_attack_pst"].onexit    --Both of these calls are to make AG belch if it can and is getting up from being stunned
	
	inst.states["leap_attack_pst"].onexit = function(inst)
		if inst.forcebelch and inst.components.health and not inst.components.health:IsDead() then
			inst:DoTaskInTime(0,function(inst) inst.sg:GoToState("belch") end)
		end
		
		if _OldOnExit ~= nil then
			_OldOnExit(inst)
		end
	end
	------------------------------------------------------------
	
	
	inst.states["leap_attack"].events["animover"].fn = function(inst) --Less intrusive than redoing the whole leap_attack state
        inst.forceleap = false
		inst.components.groundpounder:GroundPound()
        BounceStuff(inst)
		----------------------------------------------- Break any organ shields.
		local x,y,z = inst.Transform:GetWorldPosition()
		local organs = TheSim:FindEntities(x,y,z,7,{"minotaur_organ"})
		if organs then
			for i,organ in ipairs(organs) do
				organ:DeactivateShield(organ)
			end
		end
		if inst.components.combat and inst.components.combat.target and ((inst.combo < math.random(2,3) and (inst.components.health:GetPercent() > 0.3 and inst.components.health:GetPercent() < 0.6)) or (inst.combo < math.random(4,5) and inst.components.health:GetPercent() < 0.3)) then
			inst.sg:GoToState("leap_attack_pre_quick",inst.components.combat.target) 		-- Leap attack combo depends on how much health the AG has
			inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/groundpound")		-- it won't combo if it doesn't have low enough health and
			inst.combo = inst.combo + 1														-- the lower it gets, the longer the combo can possibly go.
		else
			inst.components.groundpounder.numRings = 2
			inst.combo = 0
			inst.components.timer:StartTimer("forceleapattack", 30+math.random(0,15)) --Secondary means to force the leap if the player is never in position for it to happen naturally
			if inst.jumpland(inst) then
				inst.sg:GoToState("leap_attack_pst")
				inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/groundpound")
			elseif inst.components.health and inst.components.health:GetPercent() < 0.6 then
					inst.sg:GoToState("stun",{land_stun=true})
					return
				else
					inst.sg:GoToState("leap_attack_pst")
					return
			end
		end
	end
	
	local states = {
		State{ --This state is almost a perfect copy of the leap_attack_pre state... it uses different time paramaters so that it passes quicker
			name = "leap_attack_pre_quick",
			tags = {"attack", "busy","leapattack","newbuild"},
			
			onenter = function(inst)
				inst.components.timer:StartTimer("leapattack_cooldown", 15)
				inst.components.locomotor:Stop()
				inst.AnimState:SetBank("um_minotaur_actions")
				inst.AnimState:SetBuild("um_minotaur_actions")
				inst.AnimState:PlayAnimation("jump_atk_pre_quick")
				inst.sg.statemem.startpos = Vector3(inst.Transform:GetWorldPosition())
				inst:DoTaskInTime(0.5,function()
					local target = inst.components.combat.target or nil
					if target then
						inst.sg.statemem.targetpos = Vector3(inst.components.combat.target.Transform:GetWorldPosition())
						inst:ForceFacePoint(inst.sg.statemem.targetpos)
					else
						local range = 6 -- overshoot range
						local theta = inst.Transform:GetRotation()*DEGREES
						local offset = Vector3(range * math.cos( theta ), 0, -range * math.sin( theta ))
						if inst.sg.statemem.startpos ~= nil then
							inst.sg.statemem.targetpos = Vector3(inst.sg.statemem.startpos.x + offset.x, 0, inst.sg.statemem.startpos.z + offset.z)
						else
							inst.sg.statemem.targetpos = Vector3(inst.Transform:GetWorldPosition())
						end
					end
				end)
				inst.sg:SetTimeout(1)
			end,

			onexit = function(inst)
				inst.AnimState:SetBank("rook")
				if inst.components.health:GetPercent() > 0.6 then
					inst.AnimState:SetBuild("rook_rhino")
				else
					inst.AnimState:SetBuild("rook_rhino_damaged_build")
				end
			end,

			ontimeout = function(inst, target)
				inst.components.groundpounder.numRings = 2 -- The quick combo jumps have a smaller groundpound than the first one, which gives a longer window for the player to move.
				
				if inst.sg.statemem.targetpos ~= nil then
					inst.sg:GoToState("leap_attack",{targetpos = inst.sg.statemem.targetpos}) 
				else
					inst.sg:GoToState("leap_attack",{targetpos = Vector3(inst.Transform:GetWorldPosition())})
				end
			end,
		},
		
State{ --This state is for the guardian belching a bunch of shadow goo out! It's a decent attack, but may provide a bit more interesting aspects later...
			name = "belch",
			tags = {"attack", "busy","newbuild"},
			
			onenter = function(inst)
				inst.forcebelch = false
				inst.components.timer:StartTimer("forcebelch", math.random(20,40))
				inst.components.locomotor:Stop()
				inst.AnimState:SetBank("um_minotaur_actions")
				inst.AnimState:SetBuild("um_minotaur_actions")
				inst.AnimState:PlayAnimation("belch")
				inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/hurt")

			end,
			
			onupdate = function(inst)
				if inst.components.combat and inst.components.combat.target ~= nil then
					inst:ForceFacePoint(Vector3(inst.components.combat.target.Transform:GetWorldPosition()))
					inst.belchtarget = inst.components.combat.target
				end
			end,
			
			timeline=
			{ 
				TimeEvent(36*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					inst.tentbelch = true
					SetUpProjectiles(inst)
				 end), 			
				TimeEvent(38*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end), 				
				TimeEvent(40*FRAMES, function(inst)
					inst.projectilespeed = 2
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end),
				TimeEvent(42*FRAMES, function(inst)
					inst.tentbelch = true
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end), 
				TimeEvent(44*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end),
				TimeEvent(46*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end),
				TimeEvent(48*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					SetUpProjectiles(inst)
				 end), 
				TimeEvent(50*FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("ancientguardian_rework/minotaur2/bite")
					inst.tentbelch = true
					SetUpProjectiles(inst)
				 end), 
			},		
			
			onexit = function(inst)
				inst.AnimState:SetBank("rook")
				inst.belchtarget = nil
				if inst.components.health:GetPercent() > 0.6 then
					inst.AnimState:SetBuild("rook_rhino")
				else
					inst.AnimState:SetBuild("rook_rhino_damaged_build")
				end
			end,

			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("idle")
				end),
			},
		},
	
    State{
        name = "arena_return_pre",
        tags = {"busy", "leapattack"},
        
        onenter = function(inst)
			inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("jump_atk_pre",false)
			inst.sg:SetTimeout(1.5)
        end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("arena_return")
		end,
    },	
    State{
        name = "arena_return",
        tags = {"attack", "busy", "leapattack"},
        
        onenter = function(inst)
            inst.AnimState:PushAnimation("jump_atk_loop",false)
            inst.components.locomotor:Stop()
            
			inst.Physics:SetMotorVelOverride(0,40,0)

            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.WORLD)
			inst.ascended = false
        end,
		
		onupdate = function(inst)
			if inst:IsValid() then
				local x,y,z = inst.Transform:GetWorldPosition()
				if inst.ascended then
					inst.Physics:SetMotorVelOverride(0,-40,0)
					if y < 1 then
						inst.Transform:SetPosition(x,0,z)
						inst.components.groundpounder:GroundPound()
						BounceStuff(inst)
						inst.OnChangeToObstacle(inst)
						inst.sg:GoToState("leap_attack_pst")
					end
				else
					if y > 50 then
						if inst.spawnlocation then
							local point = inst.spawnlocation
							inst.Transform:SetPosition(point.x,y,point.z)
							inst.ascended = true
						else
							inst:Remove()
						end
					end
					inst.Physics:SetMotorVelOverride(0,40,0)
				end
			end
        end,
    },
	}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

