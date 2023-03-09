local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("wilson_client", function(inst)

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

local function ForceStopHeavyLifting(inst)
    if inst.replica.inventory:IsHeavyLifting() then
        inst.replica.inventory:DropItem(
            inst.replica.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

local _OldAttack = inst.actionhandlers[ACTIONS.ATTACK].deststate
inst.actionhandlers[ACTIONS.ATTACK].deststate = 
        function(inst, action, ...)
			if inst:HasTag("troublemaker") and not inst.replica.rider:IsRiding() then
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil
				if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or IsEntityDead(inst)) then
					if weapon ~= nil and weapon:HasTag("slingshot") then
						inst.sg.mem.localchainattack = not action.forced or nil
						
						return "shove"
					elseif weapon == nil then
						return "shove"
					end
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
					if Profile:GetMovementPredictionEnabled() then
						ThePlayer:EnableMovementPrediction(false)
						Profile:SetMovementPredictionEnabled(false)
						
						--ThePlayer.HUD.controls.networkchatqueue:DisplaySystemMessage("The shadows have turned lag compensation off, it will be restored on nights end.")
						--TheNet:Announce("The shadows have turned lag compensation off, it will be restored on nights end.")
							
						if ThePlayer.components.playercontroller:CanLocomote() then
							ThePlayer.components.playercontroller.locomotor:Stop()
						else
							ThePlayer.components.playercontroller:RemoteStopWalking()
						end
						
						return
					end
				
					if inst.sg.slingshot_charge then
						return "slingshot_cast"
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
			return (inst.replica.rider ~= nil and 
			inst.replica.rider:IsRiding() and 
			inst.replica.rider:GetMount() and 
			inst.replica.rider:GetMount():HasTag("woby") and 
			action.target ~= nil and 
			action.target.components.pickable ~= nil and 
			(action.target.components.pickable.jostlepick and "doshortaction" or
			action.target.components.pickable.quickpick and "domediumaction"))
			or _OldPick(inst, action, ...)
        end
		
			
local _OldPickUp = inst.actionhandlers[ACTIONS.PICKUP].deststate
inst.actionhandlers[ACTIONS.PICKUP].deststate = 
        function(inst, action, ...)
			return (inst.replica.rider ~= nil and 
			inst.replica.rider:IsRiding() and 
			inst.replica.rider:GetMount() and 
			inst.replica.rider:GetMount():HasTag("woby") and "doshortaction") 
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
        end)
}

local states = {

	State{
        name = "shove",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
			inst.AnimState:PlayAnimation("punch")
			
			inst:PerformPreviewBufferedAction()
			
            inst.sg:SetTimeout(1.5)
        end,

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
    },

	State{
        name = "slingshot_charge",
        tags = { "abouttoattack", "busy" },

        onenter = function(inst)
            inst.entity:SetIsPredictingMovement(false)
            inst.entity:FlattenMovementPrediction()
			
			inst.sg.slingshot_charge = true
			inst.sg.statemem.abouttoattack = true
			inst.framecount = -0.55
			inst.reverseanim = false

			inst.AnimState:PlayAnimation("slingshot_pre")
            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()
			
			--inst:ClearBufferedAction()
			--inst:PerformPreviewBufferedAction()
        end,
		
		onupdate = function(inst, dt)
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
            TimeEvent(13 * FRAMES, function(inst)
				print("time event")
				inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
            end),
			
            TimeEvent(14 * FRAMES, function(inst) -- start of slingshot
				local fx = SpawnPrefab("dr_warm_loop_1")
				fx.entity:SetParent(inst.entity)
				fx.Transform:SetPosition(0, 2.35, 0)
				fx.Transform:SetScale(0.8, 0.8, 0.8)

				inst.slingshot_power = 1
				inst.slingshot_amount = 1
				inst.sg:AddStateTag("readytoshoot")
				
				--inst:ClearBufferedAction()
				--inst:PerformPreviewBufferedAction()
            end),
			
            TimeEvent(19 * FRAMES, function(inst)
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

				if not weapon:HasTag("matilda") then
					local fx = SpawnPrefab("dr_warm_loop_1")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.25
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(21 * FRAMES, function(inst)
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

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
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

				if weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_hot_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 2
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				elseif not weapon:HasTag("matilda") then
					local fx = SpawnPrefab("dr_warm_loop_2")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
				
					inst.slingshot_power = 1.5
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),

            TimeEvent(28 * FRAMES, function(inst)
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

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
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

				if weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_warm_loop_2")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.25
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				elseif not weapon:HasTag("matilda") then
					local fx = SpawnPrefab("dr_warmer_loop")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					
					inst.slingshot_power = 1.75
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
            end),
			
            TimeEvent(34 * FRAMES, function(inst)
				local weapon = inst.replica.combat ~= nil and inst.replica.combat:GetWeapon() or nil

				if weapon:HasTag("gnasher") then
					local fx = SpawnPrefab("dr_warm_loop_1")
					fx.entity:SetParent(inst.entity)
					fx.Transform:SetPosition(0, 2.35, 0)
					fx.Transform:SetScale(0.8, 0.8, 0.8)
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				elseif not weapon:HasTag("matilda") then
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
        },

        onexit = function(inst)
            inst.entity:SetIsPredictingMovement(false)
            inst.entity:FlattenMovementPrediction()
			inst.sg.slingshot_charge = false
			inst:ClearBufferedAction()
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
        tags = { "busy", "doing" },
        onenter = function(inst)
            inst.entity:SetIsPredictingMovement(false)
            inst.entity:FlattenMovementPrediction()

			inst:PerformPreviewBufferedAction()
			--inst:ClearBufferedAction()
			
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

            inst.replica.combat:StartAttack()
            inst.components.locomotor:Stop()

            inst.sg:SetTimeout(1)
            --inst.sg:SetTimeout(9 * FRAMES)
        end,
		
		onupdate = function(inst, dt)
			inst.framecount = inst.framecount + (FRAMES * 2)
			if inst.framecount < 1 then
				inst.AnimState:SetPercent("slingshot", inst.framecount)
			else
				inst.sg:GoToState("idle")
			end
        end,

        

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
				inst.sg:GoToState("idle")
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
            inst.entity:SetIsPredictingMovement(true)
			
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
			inst.replica.inventory:Hide()
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

            if inst.replica.rider:IsRiding() then
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
                        inst.replica.rider:ActualDismount()
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
                inst.replica.rider:ActualDismount()
            end
            --[[if not inst.sg.statemem.mindcontrolled then
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst.replica.inventory:Show()
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
                inst.replica.inventory:Show()
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
				inst:PerformPreviewBufferedAction()
        end,

        timeline =
        {
            --[[TimeEvent(20 * FRAMES, function(inst)
			
				local buffaction = inst:GetBufferedAction()
				if buffaction ~= nil and buffaction.target ~= nil and buffaction.target:HasTag("CHOP_workable") then
					inst.sg:AddStateTag("chopping")
				end

                --inst:PerformBufferedAction()
				inst:PerformPreviewBufferedAction()
				--inst.SoundEmitter:PlaySound("wixie/characters/wixie/walterwhistle")
            end),]]
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
            if inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end,
    },
	
	State{
        name = "bark_at",
        tags = { "busy", "canrotate" },

        onenter = function(inst)
            local mount = inst.replica.rider:GetMount()
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
				inst:PerformPreviewBufferedAction()
                --inst:PerformBufferedAction()
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
            inst.replica.inventory:Hide()
            inst.components.locomotor:Stop()
        end,

        onexit = function(inst)
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:Enable(true)
			end
			
			inst.replica.inventory:Show()
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