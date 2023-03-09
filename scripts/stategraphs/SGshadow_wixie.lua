require("stategraphs/commonstates")

local easing = require("easing")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "action"),
}

local function ResetShield(inst)
	inst.components.health:SetInvincible(true)
	inst.force_invincible_value = 0
	
	if inst.physbox == nil then
		inst.physbox = SpawnPrefab("wixie_shadow_shield")
		inst.physbox.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.physbox.entity:AddFollower()
		--inst.physbox.Follower:FollowSymbol(inst.GUID, "swap_hat", 0, 90, 0)
		inst.physbox.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 90, 0)
	end
end

local events =
{
    CommonHandlers.OnLocomote(false, true),
    EventHandler("attacked", function(inst, data)
		--if not (inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("hit") or inst.sg:HasStateTag("noattack") or inst.components.health:IsDead()) then
        if not inst.sg:HasStateTag("busy") and inst.components.health:IsDead() then
			inst.sg:GoToState("disappear")
        end
    end),
    EventHandler("death", function(inst) 
		if inst.physbox ~= nil then
			inst.physbox:Remove()
			inst.physbox = nil
		end
	
		if inst.helper then
			SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove() 
		else
			inst.sg:GoToState("death")
		end
	end),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			if inst.decoy_attack ~= nil and inst.decoy_attack then
				inst.sg:GoToState("swap_ammo")
			elseif inst.marble_bag_attack ~= nil and inst.marble_bag_attack then
				inst.marble_bag_attack = false
				
				inst.sg:GoToState("throw_marbles", data.target)
			elseif inst.components.health:GetPercent() <= 0.4 and math.random() < 0.5 then
				inst.sg:GoToState("cast_charles")
			elseif inst:IsNear(data.target, 2) then
				inst.sg:GoToState("attack", data.target)
			else
				if inst.stunned_count == nil then
					inst.stunned_count = 0
				end
			
				inst.stunned_count = inst.stunned_count + 1
			
				inst.sg:GoToState("slingshot_shoot")
			end
        end
    end),
}

local function TossDistraction(inst, thisone)
	local targetpos = inst:GetPosition()
    local x, y, z = inst.Transform:GetWorldPosition()
				
	local ball = SpawnPrefab("shadow_wixie_cloneball")
	ball.Transform:SetPosition(targetpos.x, 0, targetpos.z)
		
		
	targetpos.x = targetpos.x + math.random(-12, 12)
	targetpos.z = targetpos.z + math.random(-12, 12)
	
	local dx = targetpos.x - x
	local dz = targetpos.z - z
		
	local rangesq = dx * dx + dz * dz
	local maxrange = TUNING.FIRE_DETECTOR_RANGE * 2
	local speed = easing.linear(rangesq, maxrange, 1, maxrange * maxrange)
	ball.components.complexprojectile:SetHorizontalSpeed(speed)
	ball.components.complexprojectile:Launch(targetpos, inst, inst)
	ball.caster = inst
					
	if thisone ~= nil and thisone then
		ball.thisistheone = true
	end
end

local function DamageNearbyEnemies(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local fxcircle = SpawnPrefab("dreadeye_sanityburstring")
	fxcircle:AddTag("ignore_transparency")
	fxcircle.Transform:SetScale(1.4, 1.4, 1.4)
	fxcircle.entity:SetParent(inst.entity)
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 4, { "_combat", "player"}, {"playerghost"})) do
		if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil then
			if not (v.components.health:IsDead() or v:HasTag("playerghost")) then
				v.components.combat:GetAttacked(inst, 50, inst)
			end
		end
	end
end

local function ShootVolley(inst, i, x, y, z, pattern)
	if inst ~= nil and inst:IsValid() and x ~= nil then
		local spittarget = SpawnPrefab("slingshot_target")
				
		local x2, y2, z2 = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("wixie_shadow_shot")
		projectile.Transform:SetPosition(x2, .5, z2)
		
		local maxangle = pattern and -66 or 66
		local varangle = pattern and 22 or -22
		
		local theta = (inst:GetAngleToPoint(x, 0.5, z) + (maxangle + (varangle * (i-1)))) * DEGREES
				
		x = x + 15*math.cos(theta)
		z = z - 15*math.sin(theta)
		spittarget.Transform:SetPosition(x, 0.5, z)
		projectile.components.projectile:Throw(inst, spittarget, inst)
		spittarget:DoTaskInTime(.1, spittarget.Remove)
	end
end

local function onothercollide(inst, target)
	target.components.combat:GetAttacked(inst, 75)

	target:PushEvent("knockback", {knocker = inst, radius = 20, strengthmult = 1.5})
	
	if inst.physbox ~= nil then
		inst.physbox.AnimState:PlayAnimation("hit")
		inst.physbox.AnimState:PushAnimation("idle_loop", true)
	end
	
	target:AddTag("shadowwixie_collision")
	target:DoTaskInTime(1, function()
		target:RemoveTag("shadowwixie_collision")
	end)
end

local NOTAGS = { "fx", "INLIMBO", "playerghost", "shadowwixie_collision" }
local function Check_Bowling(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2.9, { "_combat", "player" }, NOTAGS)
	for i, v in ipairs(ents) do
		if v ~= nil and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() then
			inst.collided = true
			onothercollide(inst, v)
		end
	end
end

local function GetANewTarget(inst)
	if inst:HasTag("prime_shadow_wixie") then
		inst.components.combat:DropTarget()
	end
	
	--[[
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = TheSim:FindEntities(x, y, z, 30, { "player" })
	for i, v in ipairs(players) do
		if not inst.components.combat.target == v and inst.components.combat:CanTarget(v) then
			inst.components.combat:SetTarget(v)
		end
	end]]
end

local function SpawnDupes(inst)
	local shadowhelper = SpawnPrefab("shadow_wixie_helper")
	shadowhelper.Transform:SetPosition(inst.Transform:GetWorldPosition())
	shadowhelper:AddTag("puzzlespawn")
	shadowhelper.Transform:SetRotation(math.random(0, 360))
	
	local max_tries = 4
	for k = 1, max_tries do
		local x, y, z = inst.Transform:GetWorldPosition()
		local offset = 10
		x = x + math.random(2 * offset) - offset
		z = z + math.random(2 * offset) - offset
		if TheWorld.Map:IsPassableAtPoint(x, y, z) then
			shadowhelper.Transform:SetPosition(x, y, z)
			break
		end
	end
end

local states =
{
    State {
        name = "trickster",
        tags = { "busy" },
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
			
			inst.decoy_attack = false
			inst.AnimState:SetBank("wixie_shadowclone")
			inst.AnimState:SetBuild("wixie_shadowclone")
			inst.AnimState:PlayAnimation("pose"..math.random(5), false)
			inst.AnimState:SetMultColour(0, 0, 0, 1)
			
			inst.components.health:SetInvincible(false)
			
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/idle")
			
			if inst.physbox ~= nil then
				inst.physbox:Remove()
				inst.physbox = nil
			end
			
            inst.sg:SetTimeout(15)
        end,

        timeline =
        {
            TimeEvent(7.5, function(inst)
				inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/idle")
            end),
        },

        onexit = function(inst)
			inst.AnimState:SetMultColour(0, 0, 0, .6)
            inst.AnimState:SetBank("wilson")
			inst.AnimState:SetBuild("wixie")
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("disappear")
        end,
    },
	
    State {
        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },
	
    State {
        name = "laugh_at_you",
        tags = { "busy" },
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("emote_laugh")
			
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/laugh")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State {
        name = "attack",
        tags = { "attack", "abouttoattack", "busy" },

        onenter = function(inst, target)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("punch")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")

            inst.components.combat:StartAttack()
            if target == nil then
                target = inst.components.combat.target
            end
            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                --inst.components.combat:DoAttack(inst.sg.statemem.target)
				
				local other = inst.sg.statemem.target
				
				if other:HasTag("creatureknockbackable") then
					other:PushEvent("knockback", {knocker = inst, radius = 20, strengthmult = 1})
				else
					other:PushEvent("knockback", {knocker = inst, radius = 20, strengthmult = 1})
				end
            end),
            TimeEvent(12 * FRAMES, function(inst) -- Keep FRAMES time synced up with ShouldKiteProtector.
                inst.sg:RemoveStateTag("busy")
            end),
            TimeEvent(13 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
			GetANewTarget(inst)
		
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    },
	
	
	
	State{
        name = "cast_charles",
        tags = { "doing", "busy", "canrotate" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
			
			inst.AnimState:OverrideSymbol("swap_object", "swap_charles_shadow", "swap_charles_shadow")
	
            inst.AnimState:PlayAnimation("staff_pre")
            inst.AnimState:PushAnimation("staff", false)
            inst.components.locomotor:Stop()
			
            inst.sg:SetTimeout(1.8)
			
        end,

        timeline =
        {
            TimeEvent(13 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/voice")
            end),
        },

        ontimeout = function(inst)
			inst.sg:GoToState("charles_charge_pre")
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("charles_charge_pre")
                end
            end),
        },
    },
	
    State {
        name = "charles_charge_pre",
        tags = { "busy" },
		
        onenter = function(inst, pushanim)
            inst.AnimState:PlayAnimation("spearjab_pre")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("charles_charge")
                end
            end),
        },
    },

	State{
        name = "charles_charge",
        tags = { "moving", "running", "canrotate", "busy" },

        onenter = function(inst)
			inst.components.locomotor:Stop()
		
			if inst.charge_count == nil then
				inst.charge_count = 1
			else
				inst.charge_count = inst.charge_count + 1
			end
			
			local target = inst.components.combat.target

            if target ~= nil and target:IsValid() then
                inst:ForceFacePoint(target.Transform:GetWorldPosition())
            end
		
			inst.AnimState:PlayAnimation("spearjab")
			
			--inst.AnimState:PlayAnimation("spearjab_pre")
			--inst.AnimState:PushAnimation("spearjab", false)
			inst.sg.statemem.start_bowling = false
        end,

        onupdate = function(inst)
			if inst.sg.statemem.start_bowling then
				inst.components.locomotor:RunForward()
			end
        end,

        timeline =
        {
            TimeEvent(1 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/knight_nightmare/attack")
			
				inst.components.locomotor:WalkForward()
				inst.sg.statemem.start_bowling = true
				
				Check_Bowling(inst)
            end),
			
            TimeEvent(8 * FRAMES, function(inst)
				Check_Bowling(inst)
            end),
			
            TimeEvent(18 * FRAMES, function(inst)
				Check_Bowling(inst)
            end),
			
            TimeEvent(28 * FRAMES, function(inst)
				Check_Bowling(inst)
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
				if inst.charge_count >= 5 then
					inst.charge_count = nil
					inst.collided = nil
					inst.AnimState:OverrideSymbol("swap_object", "swap_slingshot", "swap_slingshot")
					inst.sg:GoToState("claustrophobia")
				else
					if inst.collided ~= nil then
						inst.collided = nil
						
						GetANewTarget(inst)
						inst.sg:GoToState("laugh_at_you")
					else
						inst.sg:GoToState("charles_charge")
					end
				end
            end),
        },
    },
	
    State{
        name = "slingshot_shoot",
		tags = { "attack", "abouttoattack" },

        onenter = function(inst)
			inst.AnimState:OverrideSymbol("swap_object", "swap_slingshot", "swap_slingshot")
					
            local buffaction = inst:GetBufferedAction()
			local target = inst.components.combat.target
			if target ~= nil and target:IsValid() then
	            inst:ForceFacePoint(target.Transform:GetWorldPosition())
			end

            inst.AnimState:PlayAnimation("slingshot_pre")
            inst.AnimState:PushAnimation("slingshot", false)

            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
        end,

        timeline =
        {
            TimeEvent(19 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end),
			
            TimeEvent(24 * FRAMES, function(inst)
			
				local target = inst.components.combat.target
				if target ~= nil then
					local x, y, z = target.Transform:GetWorldPosition()
					local pattern = false
						
					if math.random() > 0.5 then
						pattern = true
					end
					
					DamageNearbyEnemies(inst)
					
					for i = 1, 7 do
						inst:DoTaskInTime(0.05 * i, function()
							ShootVolley(inst, i, x, y, z, pattern)
						end)
					end
				end
			
				inst:PerformBufferedAction()
				inst.sg:RemoveStateTag("abouttoattack")
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
					if inst.helper then
						if inst.stunned_count >= 3 then
							inst.stunned_count = 0
									
							inst.sg:GoToState("claustrophobia")
						else
							inst.sg:GoToState("idle")
						end
					else
						local shot_calc = 6 - ((15 * inst.components.health:GetPercent()) / 3)
						
						if inst.multisling == nil then
							inst.multisling = 1
						end
						
						inst.multisling = inst.multisling + 1
							
						if inst.multisling <= shot_calc then
							inst.sg:GoToState("slingshot_shoot")
						else
							inst.multisling = nil
								
							if inst.stunned_count >= 3 then
								inst.stunned_count = 0
									
								inst.sg:GoToState("claustrophobia")
							else
								GetANewTarget(inst)
								
								inst.sg:GoToState("idle")
							end
						end
					end
                end
            end),
        },

        onexit = function(inst)
			if inst.sg:HasStateTag("abouttoattack") then
				inst.components.combat:CancelAttack()
            end
        end,
	},
	
    State{
        name = "swap_ammo",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("cointoss_pre")
            inst.AnimState:PushAnimation("cointoss", false)
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/taunt")
			
			inst.decoy_attack_count = 0
        end,

        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
				local teleport_to = math.random(1, 15)
			
				for i = 1, 15 do
					inst:DoTaskInTime(i / 40, function(inst)
						if teleport_to == i then
							TossDistraction(inst, true)
						else
							TossDistraction(inst, false)
						end
					end)
				end
            end),
            TimeEvent(53 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
			TimeEvent(70 * FRAMES, function(inst)
				inst.sg:GoToState("idle", true)
			end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_wixie")
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/taunt")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:Hide("swap_arm_carry")
            inst.AnimState:PlayAnimation("death")
			
			inst.components.colourtweener:StartTween({ 1, 1, 1, 1 }, 2.5, nil, true)
			inst.AnimState:ShowSymbol("face")
			
			
			local papyrus = SpawnPrefab("wixie_piano_card")
			papyrus.Transform:SetPosition(inst.Transform:GetWorldPosition())
			papyrus.name = "Omnia bona finiri debent"
			Launch2(papyrus, inst, 2, 0, 1, .5)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst:DoTaskInTime(1, function()
					local x, y, z = inst.Transform:GetWorldPosition()
					
					local players = FindPlayersInRange( x, y, z, 40, true )
					
					for i,player in ipairs(players) do
						if player ~= nil and player:IsValid() then
							local fx = SpawnPrefab("archive_lockbox_player_fx")
							if fx ~= nil then
								player:AddChild(fx)
							end
								
							player.components.builder:UnlockRecipe("the_real_charles_t_horse")
							
							if player:HasTag("troublemaker") then
								player.components.builder:UnlockRecipe("slingshotammo_shadow")
							end

							if player.components.talker then
								player.components.talker:Say(GetString(player, "ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE"), nil, true)
							end
							
							Launch2(SpawnPrefab("nightmarefuel"), inst, 1.5, 1, 3, .75)
						end
					end
					
					inst.components.lootdropper:DropLoot()
                    SpawnPrefab("statue_transition").Transform:SetPosition(x, y, z)
                    SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)
                    inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_despawn")
                    inst:Remove()
                end)
            end),
        },
    },

    State{
        name = "disappear",
        tags = { "busy", "noattack" },

        onenter = function(inst)
			ResetShield(inst)
			
            inst.AnimState:PlayAnimation("wortox_portal_jumpin")
			
			SpawnPrefab("cavehole_flick_warn").Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/appear")
            inst.Physics:Stop()
            inst:AddTag("NOCLICK")
        end,

        events =
        {
			EventHandler("animover", function(inst)
                local max_tries = 4
                for k = 1, max_tries do
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local offset = 12
                    x = x + math.random(2 * offset) - offset
                    z = z + math.random(2 * offset) - offset
                    if TheWorld.Map:IsPassableAtPoint(x, y, z) then
                        inst.Physics:Teleport(x, y, z)
                        break
                    end
                end

                inst.sg:GoToState("appear")
            end),
        },
    },

    State{
        name = "appear",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
			
			if not inst.helper then
				local x, y, z = inst.Transform:GetWorldPosition()
				local players = FindPlayersInRange(x, y, z, 40, true)
				for i = 1, (#players / 2) - 0.5 do
					SpawnDupes(inst)
				end
			end

			SpawnPrefab("cavehole_flick").Transform:SetPosition(inst.Transform:GetWorldPosition())
			ResetShield(inst)
            inst.AnimState:PlayAnimation("jumpout")
			inst.SoundEmitter:PlaySound("UCSounds/shadow_wixie/appear")
        end,

        timeline =
        {
            TimeEvent(2*FRAMES, function(inst) inst.Physics:SetMotorVelOverride(4,0,0) end),
            TimeEvent(20*FRAMES,
                function(inst)
                    inst.Physics:ClearMotorVelOverride()
                    inst.components.locomotor:Stop()
                end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },

        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end,
    },

    State{
        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst:PerformBufferedAction()
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
	
    State{
        name = "claustrophobia",
        tags = { "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("mindcontrol_pre")
			inst.AnimState:PushAnimation("mindcontrol_loop", true)

			inst.components.health:SetInvincible(false)
			
			inst.charge_count = nil
			inst.stunned_count = 0
			
			if inst.physbox ~= nil then
				inst.physbox.AnimState:PlayAnimation("close")
				inst.physbox:DoTaskInTime(0.3, inst.physbox.Remove)
				inst.physbox = nil
			end
			
            inst.sg:SetTimeout(inst.helper and 8 or 5)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("claustrophobia_pst")
        end,
    },

    State{
        name = "claustrophobia_pst",
        tags = { "busy" },

        onenter = function(inst)
			ResetShield(inst)
            inst.AnimState:PlayAnimation("mindcontrol_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					GetANewTarget(inst)
				
					inst.sg:GoToState("disappear")
                end
            end),
        },
    },

    State{
        name = "throw_marbles",
        tags = { "busy" },

        onenter = function(inst, target)
			inst.components.locomotor:Stop()
			
			inst.AnimState:OverrideSymbol("swap_object", "swap_marblebag", "swap_sleepbomb")
		
            inst.AnimState:PlayAnimation("throw")

            if target ~= nil and target:IsValid() then
                inst:FacePoint(target.Transform:GetWorldPosition())
				
				inst.sg.statemem.target = target
            end
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES, function(inst)
				local targetpos = inst.sg.statemem.target:GetPosition()
				local bag = SpawnPrefab("bagofwarbles")
				bag.Transform:SetPosition(inst.Transform:GetWorldPosition())
				bag.components.complexprojectile:Launch(targetpos, inst, inst)
				bag.AnimState:SetMultColour(0, 0, 0, 0.6)
				
                inst:ClearBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
				
				inst.AnimState:OverrideSymbol("swap_object", "swap_slingshot", "swap_slingshot")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					GetANewTarget(inst)
				
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
}
CommonStates.AddWalkStates(states)

return StateGraph("shadow_wixie", states, events, "appear", actionhandlers)