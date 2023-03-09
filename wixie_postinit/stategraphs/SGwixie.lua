local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson", function(inst)

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

local _OldAttack = inst.actionhandlers[ACTIONS.ATTACK].deststate
inst.actionhandlers[ACTIONS.ATTACK].deststate = 
        function(inst, action, ...)
			if inst:HasTag("troublemaker") and not inst.components.rider:IsRiding() then
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
				if weapon ~= nil and weapon:HasTag("slingshot") then
					if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
						inst.sg.mem.localchainattack = not action.forced or nil
						
						return "shove"
					end
				elseif weapon == nil then
					return "shove"
				end
				
				return _OldAttack(inst, action, ...)
			else
				return _OldAttack(inst, action, ...)
            end
        end
		
local _OldBuild = inst.actionhandlers[ACTIONS.BUILD].deststate
inst.actionhandlers[ACTIONS.BUILD].deststate = 
        function(inst, action, ...)
			local rec = GetValidRecipe(action.recipe)

			if rec.filters ~= nil then 
				print(rec.filters)
			end

			return (inst:HasTag("troublemaker") and rec ~= nil and rec.builder_tag == "pebblemaker" and "domediumaction")
				--or (inst:HasTag("pinetreepioneer") and rec ~= nil and rec.tab.str == "SURVIVAL" and "domediumaction")
				or _OldBuild(inst, action, ...)
        end
		
local _OldSpellCast = inst.actionhandlers[ACTIONS.CASTSPELL].deststate
inst.actionhandlers[ACTIONS.CASTSPELL].deststate = 
        function(inst, action, ...)
			if action.invobject ~= nil and action.invobject:HasTag("slingshot") then
				if inst:HasTag("pebblemaker") then
					if inst.sg.slingshot_charge then
						if inst.sg:HasStateTag("slingshot_ready") then
							return "slingshot_cast"
						else
							return
						end
					else
						return "slingshot_charge"
					end
				else
					return
				end
			end
			
			if action.invobject ~= nil and action.invobject:HasTag("wixiegun") then
				return "wixieshootsagun"
			end
			
			if not inst.sg.currentstate.name ~= "slingshot_charge" then
				return _OldSpellCast(inst, action, ...)
			end
        end
		
local _OldPick = inst.actionhandlers[ACTIONS.PICK].deststate
inst.actionhandlers[ACTIONS.PICK].deststate = 
        function(inst, action, ...)
			return (inst.components.rider ~= nil and 
			inst.components.rider:IsRiding() and 
			inst.components.rider:GetMount() and 
			inst.components.rider:GetMount():HasTag("woby") and 
			action.target ~= nil and 
			action.target.components.pickable ~= nil and 
			(action.target.components.pickable.jostlepick and "doshortaction" or
			action.target.components.pickable.quickpick and "domediumaction"))
			or _OldPick(inst, action, ...)
        end
		
			
local _OldPickUp = inst.actionhandlers[ACTIONS.PICKUP].deststate
inst.actionhandlers[ACTIONS.PICKUP].deststate = 
        function(inst, action, ...)
			return (inst.components.rider ~= nil and 
			inst.components.rider:IsRiding() and 
			inst.components.rider:GetMount() and 
			inst.components.rider:GetMount():HasTag("woby") and "doshortaction") 
			or _OldPickUp(inst, action, ...)
        end
		
local actionhandlers =
{
	ActionHandler(ACTIONS.WOBY_COMMAND,
        function(inst, action)
            return "play_woby_whistle"
        end),
	ActionHandler(ACTIONS.WOBY_STAY,
        function(inst, action)
            return "play_woby_whistle"
        end),
	ActionHandler(ACTIONS.WOBY_HERE,
        function(inst, action)
            return "play_woby_whistle"
        end),
	ActionHandler(ACTIONS.WOBY_OPEN,
        function(inst, action)
            return "doshortaction"
        end)
}

local states = {

	State{
        name = "shove",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
			
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
			--cooldown = 24 * FRAMES
			
			--inst.AnimState:Show("ARM_normal")
			
			inst.AnimState:PlayAnimation("punch")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
			cooldown = math.max(cooldown, 24 * FRAMES)

            inst.sg:SetTimeout(cooldown)

            if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                end
            end
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
					local target = inst.sg.statemem.attacktarget ~= nil and inst.sg.statemem.attacktarget or nil
					local dist = target ~= nil and distsq(target:GetPosition(), inst:GetPosition()) <= inst.components.combat:CalcAttackRangeSq(target) or false
					local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
					
					if target ~= nil and dist then
						if target.components.combat ~= nil then
							if (target.sg == nil or target.sg ~= nil and not target.sg:HasStateTag("notarget")) and target.components.combat ~= nil and target.components.freezable == nil or (target.sg == nil or target.sg ~= nil and not target.sg:HasStateTag("notarget")) and not (target.components.freezable ~= nil and target.components.freezable:IsFrozen()) then
								target.components.combat:GetAttacked(inst, 10)
							end
							
							if target ~= nil and 
							inst ~= nil and not 
							target:HasTag("wixieshoved") and not 
							target:HasTag("shadow") and not 
							target:HasTag("shadowcreature") and not 
							target:HasTag("shadowminion") and not 
							target:HasTag("stalkerminion") and not 
							target:HasTag("shadowchesspiece") and not 
							target:HasTag("bowlingpin") and 
							target.components and 
							target.components.locomotor then
								SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(target.Transform:GetWorldPosition())
								
								target:AddTag("wixieshoved")
								target:PushEvent("wixieshoved")
								
								if target:HasDebuff("wixiecurse_debuff") then
									target:PushEvent("wixiebite")
								end
								
								
								local x, y, z = inst.Transform:GetWorldPosition()
								
								for i = 1, 50 do
									inst:DoTaskInTime((i - 1) / 50, function(inst)
										if not target:HasTag("eyeplant") then 
											local tx, ty, tz = target.Transform:GetWorldPosition()
											if tx ~= nil then
												local EXCLUDE_TAGS = { "player", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "wixieshoved" }
												
												if i > 1 then
													local ents = TheSim:FindEntities(tx, ty, tz, 1.5 + target:GetPhysicsRadius(0), { "_combat" }, EXCLUDE_TAGS)
													
													for iv, v in ipairs(ents) do
														if v ~= target and v.components.locomotor then
															
															if not target:HasTag("epic") and target:HasDebuff("wixiecurse_stinkdebuff") and not v:HasDebuff("wixiecurse_stinkdebuff") then
																if v.components.combat then
																	v.components.combat:DropTarget()
																end

																v:AddDebuff("wixiecurse_debuff", "wixiecurse_debuff", {powerlevel = 1})
															end

															v:PushEvent("wixieshoved")
															local giantdamagereduction = target:HasTag("epic") and 2 or target:HasTag("smallcreature") and 0.5 or 1
															
															if v.components.combat ~= nil and v.components.freezable == nil or not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) then
																v.components.combat:GetAttacked(nil, 10 * giantdamagereduction)
																v.components.combat:SuggestTarget(inst)
															end
															
															SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())
														
															v:AddTag("wixieshoved")
															--[[
															if v.components.freezable == nil or not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) then
																inst.components.combat:DoAttack(v, nil, nil)
															end]]
															
															for iv = 1, 50 do
																inst:DoTaskInTime((iv - 1) / 50, function(inst)
																	if v ~= nil and v.Transform:GetWorldPosition() and target ~= nil and tx ~= nil then
																		if v == 1 then
																			v.components.locomotor:SetExternalSpeedMultiplier(target, "wixieshoved", .01)
																			--v.components.locomotor:RemoveExternalSpeedMultiplier(v, "wixieshoved")
																		end
																		
																		print("v knocked")
																		local px, py, pz = v.Transform:GetWorldPosition()
																		local rad_collision = -math.rad(v:GetAngleToPoint(tx, ty, tz))
																		local velx_collision = math.cos(rad_collision) --* 4.5
																		local velz_collision = -math.sin(rad_collision) --* 4.5
																		
																		
																		local targetreduction = target:HasTag("epic") and 1 or target:HasTag("smallcreature") and 3 or 2
																		local vreduction = v:HasTag("epic") and 3 or v:HasTag("smallcreature") and 1 or 2
																		local finalreduction = targetreduction + vreduction
																		local vdebuffmultiplier = v.components.freezable ~= nil and v.components.freezable:IsFrozen() and 1.25 or 1
																		
																		local basepower = 10 / i or 10
																		if px ~= nil then
																			local vx, vy, vz = px + (((5 / (iv + 1)) * velx_collision) / finalreduction) * vdebuffmultiplier, py, pz + (((5 / (iv + 1)) * velz_collision) / finalreduction) * vdebuffmultiplier

																			local ground_collision = TheWorld.Map:IsPassableAtPoint(vx, vy, vz)
																			local boat_collision = TheWorld.Map:GetPlatformAtPoint(vx, vz)
																			local ocean_collision = TheWorld.Map:IsOceanAtPoint(vx, vy, vz)
																			local on_water = nil
																			
																			if TUNING.DSTU.ISLAND_ADVENTURES then
																				on_water = IsOnWater(vx, vy, vz)
																			end
																			
																			if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then	
																				if v ~= nil and v.components.locomotor ~= nil and vx ~= nil and (ground_collision or boat_collision or ocean_collision and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
																					if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
																						print("v should be moving")
																						--[[if ocean_collision and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
																							v.components.amphibiouscreature:OnEnterOcean()
																						end]]
																						v.Transform:SetPosition(vx, vy, vz)
																					end
																				end
																			end
																		end
																	end
																	
																	if iv >= 50 then
																		v:RemoveTag("wixieshoved")
																		v.components.locomotor:RemoveExternalSpeedMultiplier(v, "wixieshoved")
																	end
																end)
															end
														end
													end
												else
													target.components.locomotor:SetExternalSpeedMultiplier(target, "wixieshoved", .01)
												end
												
												local scale = 0.5 - (i / 40)
												if scale > 0 then
													if not target:HasTag("flying") and target.sg ~= nil and not target.sg:HasStateTag("flight") and not target:HasTag("aquatic") then
														local dirtpuff = SpawnPrefab("dirt_puff")
														dirtpuff.Transform:SetPosition(target.Transform:GetWorldPosition())
														dirtpuff.Transform:SetScale(scale, scale, scale)
													end
												end
												
												local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
												local velx = math.cos(rad) --* 4.5
												local velz = -math.sin(rad) --* 4.5
												
												local giantreduction = target:HasTag("epic") and 1.5 or target:HasTag("smallcreature") and 0.8 or 1
												local debuffmultiplier = target.components.freezable ~= nil and target.components.freezable:IsFrozen() and target:HasDebuff("wixiecurse_debuff") and 1.75 or
														target:HasDebuff("wixiecurse_debuff") and 1.5 or 
														target.components.freezable ~= nil and target.components.freezable:IsFrozen() and 1.25 or
														1
														
												local dx, dy, dz = tx + (((3 / (i + 2)) * velx) / giantreduction) * debuffmultiplier, ty, tz + (((3 / (i + 2)) * velz) / giantreduction) * debuffmultiplier
												
												local ground_target = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
												local boat_target = TheWorld.Map:GetPlatformAtPoint(dx, dz)
												local ocean_target = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
												local on_water_target = nil
																									
												if TUNING.DSTU.ISLAND_ADVENTURES then
													on_water_target = IsOnWater(dx, dy, dz)
												end
																			
												if not (target.sg ~= nil and (target.sg:HasStateTag("swimming") or target.sg:HasStateTag("invisible"))) then		
													if target ~= nil and target.components.locomotor ~= nil and dx ~= nil and (ground_target or boat_target or ocean_target and target.components.locomotor:CanPathfindOnWater() or target.components.tiletracker ~= nil and not target:HasTag("whale")) then
														print(on_water_target)
														if not target:HasTag("aquatic") and not on_water_target or target:HasTag("aquatic") and on_water_target then
															--[[if ocean_target and target.components.amphibiouscreature and not target.components.amphibiouscreature.in_water then
																target.components.amphibiouscreature:OnEnterOcean()
															end]]
															
															target.Transform:SetPosition(dx, dy, dz)
														end
													end
												end
											end
										end
										
										if i >= 50 then
											target:RemoveTag("wixieshoved")
											
											if target.components.locomotor ~= nil then
												target.components.locomotor:RemoveExternalSpeedMultiplier(target, "wixieshoved")
											end
										end
									end)
								end
							end
						elseif weapon ~= nil and weapon:HasTag("extinguisher") and target.components.burnable ~= nil and target.components.burnable:IsBurning() then
							inst:PerformBufferedAction()
						end
					end
					
                    inst.sg:RemoveStateTag("abouttoattack")
            end),
        },


        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                --inst.AnimState:Show("ARM_carry")
                --inst.AnimState:Hide("ARM_normal")
            end
			
			inst:ClearBufferedAction()
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
        end,
    },

	State{
        name = "slingshot_charge",
        tags = { "abouttoattack" },

        onenter = function(inst)
			inst.sg.slingshot_charge = true
			
			if inst.wixiequickshot == nil then
				inst.wixiequickshot = false
			end
		
           if inst.components.combat:InCooldown() and not inst.wixiequickshot then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
			
			inst.wixiequickshot = false

			inst.sg.statemem.abouttoattack = true
			inst.framecount = -0.55
			inst.reverseanim = false

			inst.AnimState:PlayAnimation("slingshot_pre")
			--inst:DoTaskInTime(0.5, function(inst)
				--[[inst.chargeshottask = inst:DoPeriodicTask(FRAMES / 2, function(inst)
					inst.framecount = inst.framecount + (FRAMES * 1.7)
					if inst.framecount > 0 and inst.framecount < 0.35 then
						inst.AnimState:SetPercent("slingshot", inst.framecount)
					end
					
					if inst.wixiepointx ~= nil then
						inst:ForceFacePoint(inst.wixiepointx, inst.wixiepointy, inst.wixiepointz)
					end
				end)]]
			--end)
			
            --inst.AnimState:PlayAnimation("wixieshot_pre")
            --inst.AnimState:PushAnimation("wixieshot_loop", true)

            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()

            --inst.sg:SetTimeout(16 * FRAMES)
        end,
		
		onupdate = function(inst, dt)
			--[[if inst.framecount < 0.35 and not inst.reverseanim then
				print("charge")
				inst.framecount = inst.framecount + (FRAMES * 1.5)
			else
				print("uncharge")
				inst.reverseanim = true
				inst.framecount = inst.framecount - (FRAMES)
				
				if inst.framecount <= 0.2 then
					inst.reverseanim = false
				end
			end]]
			
			inst.framecount = inst.framecount + (FRAMES * 1.5)

			if inst.framecount > 0 and inst.framecount < 0.35 then
				inst.AnimState:SetPercent("slingshot", inst.framecount)
			end
					
			if inst.wixiepointx ~= nil then
				inst:ForceFacePoint(inst.wixiepointx, inst.wixiepointy, inst.wixiepointz)
			end
        end,
		
        timeline =
        {
            TimeEvent(12 * FRAMES, function(inst)
				--inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end),
			
            TimeEvent(13 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end),
			
            TimeEvent(14 * FRAMES, function(inst) -- start of slingshot
				local fx = SpawnPrefab("dr_warm_loop_1")
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0, 2.35, 0)
				fx.Transform:SetScale(0.8, 0.8, 0.8)

				inst.slingshot_power = 1
				inst.slingshot_amount = 1
				inst:ClearBufferedAction()
				inst.sg:AddStateTag("slingshot_ready")
            end),
			
            TimeEvent(19 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					--[[local fx = SpawnPrefab("dr_warm_loop_1")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")]]
				else
					local fx = SpawnPrefab("dr_warm_loop_1")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.25
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(21 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					local fx = SpawnPrefab("dr_warmer_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.25
					inst.slingshot_amount = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(24 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					--[[local fx = SpawnPrefab("dr_warmer_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")]]
				elseif weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_hot_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				else
					local fx = SpawnPrefab("dr_warm_loop_2")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
				
					inst.slingshot_power = 1.5
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),

            TimeEvent(28 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					local fx = SpawnPrefab("dr_hot_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.5
					inst.slingshot_amount = 3
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(29 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					--[[local fx = SpawnPrefab("dr_warmer_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")]]
				elseif weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_warm_loop_2")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.25
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				else
					local fx = SpawnPrefab("dr_warmer_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.75
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(34 * FRAMES, function(inst)
				local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil

				if weapon:HasTag("matilda") then
					--[[local fx = SpawnPrefab("dr_hot_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 3
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")]]
				elseif weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_warm_loop_1")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					fx.Transform:SetScale(0.8, 0.8, 0.8)
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				else
					local fx = SpawnPrefab("dr_hot_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            --[[EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
				end
            end),]]
        },

        onexit = function(inst)
			inst.sg.slingshot_charge = false
			
            if inst.sg.statemem.abouttoattack and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
			
			if inst.chargeshottask ~= nil then
				inst.chargeshottask:Cancel()
			end
			
			inst.chargeshottask = nil
			inst.framecount = 0
        end,
	},
	
	State{
        name = "slingshot_cast",
        tags = { "attack" },

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
			
			if inst.wixiepointx ~= nil then
				inst:ForceFacePoint(inst.wixiepointx, inst.wixiepointy, inst.wixiepointz)
			end

			inst.sg.statemem.abouttoattack = true

            --inst.AnimState:PlayAnimation("atk_leap_pre")
            --inst.AnimState:PushAnimation("slingshot_pre")


            --inst.AnimState:PlayAnimation("slingshot", false)
			
			
			inst.framecount = 0.35
				--[[inst.chargeshottask = inst:DoPeriodicTask(FRAMES / 2, function(inst)
					inst.framecount = inst.framecount + (FRAMES * 1.8)
					if inst.framecount < 1 then
						inst.AnimState:SetPercent("slingshot", inst.framecount)
					else
						inst.sg:GoToState("idle")
					end
					
				end)]]
            --inst.AnimState:PlayAnimation("wixieshot", false)

            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()

            --inst.sg:SetTimeout(9 * FRAMES)
        end,
		
		onupdate = function(inst, dt)
			inst.framecount = inst.framecount + (FRAMES * 2)
			if inst.framecount < 1 then
				inst.AnimState:SetPercent("slingshot", inst.framecount)
			else
				local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
					
					inst.wixiequickshot = true
					inst.sg:GoToState("slingshot_charge")
				else
					inst.sg:GoToState("idle")
				end
			end
        end,

        timeline =
        {
            --[[TimeEvent(7 * FRAMES, function(inst) -- start of slingshot
				inst.sg:RemoveStateTag("busy")
            end),
			
            TimeEvent(27 * FRAMES, function(inst) -- start of slingshot
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end),]]

            TimeEvent(3 * FRAMES, function(inst)
				local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
					inst.sg.statemem.abouttoattack = false
					
					if inst.slingshot_power == nil then
						inst.slingshot_power = 1
					end
					
					if inst.slingshot_amount == nil then
						inst.slingshot_amount = 1
					end
					
					equip.powerlevel = inst.slingshot_power
					equip.slingshot_amount = inst.slingshot_amount
					
					inst:PerformBufferedAction()
					
					inst.slingshot_power = 1
					inst.slingshot_amount = 1
					
					equip.powerlevel = inst.slingshot_power
					equip.slingshot_amount = inst.slingshot_amount
					
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
				else -- out of ammo
					inst:ClearBufferedAction()
					inst.components.talker:Say(GetString(inst, "ANNOUNCE_SLINGHSOT_OUT_OF_AMMO"))
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
				end
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
            end),
        },

        onexit = function(inst)
            if inst.sg.statemem.abouttoattack and inst.replica.combat ~= nil then
                inst.replica.combat:CancelAttack()
            end
			
			if inst.chargeshottask ~= nil then
				inst.chargeshottask:Cancel()
			end
			
			inst.chargeshottask = nil
			inst.framecount = 0
        end,
	},
	
	State{
        name = "claustrophobic",
        tags = { "busy", "pausepredict", "nomorph", "nodangle", "wixiepanic", "nointerrupt" },

        onenter = function(inst)
			--[[if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
			inst.components.inventory:Hide()
            inst:PushEvent("ms_closepopups")]]
			
			local panicshield = SpawnPrefab("wixie_panicshield")
			panicshield.Transform:SetPosition(inst.Transform:GetWorldPosition())
			panicshield.host = inst
			--panicshield.entity:SetParent(inst.entity)
			
			inst.components.sanity:DoDelta(-15)
			
            ClearStatusAilments(inst)
            ForceStopHeavyLifting(inst)
            inst.components.locomotor:Stop()
            inst:ClearBufferedAction()

            if inst.components.rider:IsRiding() then
                inst.sg:AddStateTag("dismounting")
                inst.AnimState:PlayAnimation("fall_off")
                inst.SoundEmitter:PlaySound("dontstarve/beefalo/saddle/dismount")
            else
                inst.AnimState:PlayAnimation("mindcontrol_pre")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.sg:HasStateTag("dismounting") then
                        inst.sg:RemoveStateTag("dismounting")
                        inst.components.rider:ActualDismount()
                        inst.AnimState:PlayAnimation("mindcontrol_pre")
                    else
                        inst.sg:GoToState("claustrophobic_loop")
                    end
                end
            end),
        },

        onexit = function(inst)
            if inst.sg:HasStateTag("dismounting") then
                --interrupted
                inst.components.rider:ActualDismount()
            end
            --[[if not inst.sg.statemem.mindcontrolled then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst.components.inventory:Show()
            end]]
        end,
    },

    State{
        name = "claustrophobic_loop",
        tags = { "busy", "pausepredict", "nomorph", "nodangle", "wixiepanic", "nointerrupt" },

        onenter = function(inst)
            if not inst.AnimState:IsCurrentAnimation("mindcontrol_loop") then
                inst.AnimState:PlayAnimation("mindcontrol_loop", true)
            end
			
            inst.sg:SetTimeout(5)
        end,

        events =
        {
            EventHandler("mindcontrolled", function(inst)
                inst.sg.statemem.mindcontrolled = true
                inst.sg:GoToState("mindcontrolled_loop")
            end),
        },

        ontimeout = function(inst)
			inst.sg:GoToState("claustrophobic_pst")
        end,

        --[[onexit = function(inst)
            if not inst.sg.statemem.mindcontrolled then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst.components.inventory:Show()
            end
        end,]]
    },

    State{
        name = "claustrophobic_pst",
        tags = { "busy", "pausepredict", "nomorph", "nodangle", "wixiepanic" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("mindcontrol_pst")
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
	
	State{
        name = "play_woby_whistle",
        tags = { "doing", "playing", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("whistle", false)
            inst.AnimState:OverrideSymbol("hound_whistle01", "walterwhistle", "hound_whistle01")
            --inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end,

        timeline =
        {
            TimeEvent(20 * FRAMES, function(inst)
			
				local buffaction = inst:GetBufferedAction()
				if buffaction ~= nil and buffaction.target ~= nil and buffaction.target:HasTag("CHOP_workable") then
					inst.sg:AddStateTag("chopping")
				end

                inst:PerformBufferedAction()
				inst.SoundEmitter:PlaySound("wixie/characters/wixie/walterwhistle")
            end),
            TimeEvent(24 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
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
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
    },
	
	State{
        name = "bark_at",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            local mount = inst.components.rider:GetMount()
            if mount and mount:HasTag("woby") then
				inst.AnimState:PlayAnimation("bark1_woby",  false)
            else
                inst.sg:GoToState("mounted_idle")
            end
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("mounted_idle")
                end
            end),
        },

        timeline=
        {
            TimeEvent(6*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/big/bark") end),
        },
    },
	
	State{
        name = "wixieshootsagun",
        tags = { "doing", "canrotate", "busy" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("punch")
			
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
        end,

        timeline =
        {
            TimeEvent(6 * FRAMES, function(inst)
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("busy")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
	
	State{
        name = "wixie_spawn",
        tags = { "busy", "pausepredict", "nomorph", "nodangle" },

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
                inst.components.playercontroller:RemotePausePrediction()
            end
			
			inst:SetCameraZoomed(true)
            inst.components.inventory:Hide()
            inst.components.locomotor:Stop()
        end,

        onexit = function(inst)
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:Enable(true)
			end
			
			inst.components.inventory:Show()
        end,
    },
}

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

for k, v in pairs(actionhandlers) do
    assert(v:is_a(ActionHandler), "Non-action added in mod state table!")
    inst.actionhandlers[v.action] = v
end

end)