AddMinimapAtlas("images/map_icons/wathom.xml")

require "class"
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local FRAMES = GLOBAL.FRAMES
local TimeEvent = GLOBAL.TimeEvent
local EventHandler = GLOBAL.EventHandler
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS
local SpawnPrefab = GLOBAL.SpawnPrefab
local ActionHandler = GLOBAL.ActionHandler


-- It's 1 AM and I don't want to pick apart which local is needed so I'll just grab all of it.

--------------------------------------------------------------------------
-- 90% of code here is taken from Warfarin, made by the wonderful Tiddler.

-- Setting up new actions

local function OnCooldownBark(inst)
	inst._barkcdtask = nil
end

local function OnCooldownCantBark(inst)
	inst._cantbarkcdtask = nil
end

local function Effect(inst) -- I dumbed the shit out of this.
	if GLOBAL.TheWorld.state.wetness > 25 then
		local puff = SpawnPrefab("weregoose_splash_med2")
		puff.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
end

local SGWilson = require "stategraphs/SGwilson"
local SGWilsonClient = require "stategraphs/SGwilson_client"
local Attack_Old
local ClientAttack_Old

for k1, v1 in pairs(SGWilson.actionhandlers) do
	if SGWilson.actionhandlers[k1]["action"]["id"] == "ATTACK" then
		Attack_Old = SGWilson.actionhandlers[k1]["deststate"]
	end
end

local special_staff = {
	"staff_lunarplant",
	"icestaff",
	"firestaff"
}

local function Attack_New(inst, action)
	inst.sg.mem.localchainattack = not action.forced or nil
	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
	if weapon and not ((weapon:HasTag("blowdart") or weapon:HasTag("thrown") or (weapon:HasTag("rangedweapon") and not table.contains(special_staff, weapon.prefab)))) and inst:HasTag("wathom") and
		not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding()) then
		return ("wathomleap")
	else
		return Attack_Old(inst, action)
	end
end

--Client


for k1, v1 in pairs(SGWilsonClient.actionhandlers) do
	if SGWilsonClient.actionhandlers[k1]["action"]["id"] == "ATTACK" then
		ClientAttack_Old = SGWilsonClient.actionhandlers[k1]["deststate"]
	end
end

local function AttackClient_New(inst, action)
	local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
	if weapon and not ((weapon:HasTag("blowdart") or weapon:HasTag("thrown"))) and inst:HasTag("wathom") and
		not inst.sg:HasStateTag("attack") and (inst.components.rider ~= nil and not inst.components.rider:IsRiding() or inst.replica.rider ~= nil and not inst.replica.rider:IsRiding()) then
		return ("wathomleap_pre")
	else
		return ClientAttack_Old(inst, action)
	end
end

local function RunUpdateTools(inst, client, exiting)
	--[[local method
	if client then
		method = inst.replica
	else
		method = inst.components
	end
	local weapon = method.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
	if exiting and weapon then
		inst.AnimState:Show("ARM_carry")
		inst.AnimState:Hide("ARM_normal")
	elseif weapon then
		inst.AnimState:Hide("ARM_carry")
		inst.AnimState:Show("ARM_normal")
	end]]
end

--Pack it up

AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.ATTACK, Attack_New))
GLOBAL.package.loaded["stategraphs/SGwilson"] = nil

AddStategraphActionHandler("wilson_client", ActionHandler(GLOBAL.ACTIONS.ATTACK, AttackClient_New))
GLOBAL.package.loaded["stategraphs/SGwilson_client"] = nil

AddStategraphActionHandler("wilson", ActionHandler(GLOBAL.ACTIONS.ATTACK, Attack_New))
------------------------
-- the MEAT

local function ConfigureRunState(inst)
	if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
		inst.sg.statemem.riding = true
		inst.sg.statemem.groggy = inst:HasTag("groggy")
		inst.sg:AddStateTag("nodangle")

		local mount = inst.components.rider:GetMount()
		inst.sg.statemem.ridingwoby = mount and mount:HasTag("woby")
	elseif inst.components.inventory ~= nil and inst.components.inventory:IsHeavyLifting() then
		inst.sg.statemem.heavy = true
		inst.sg.statemem.heavy_fast = inst.components.mightiness ~= nil and inst.components.mightiness:IsMighty()
	elseif inst:HasTag("wereplayer") then
		inst.sg.statemem.iswere = true
		if inst:HasTag("weremoose") then
			if inst:HasTag("groggy") then
				inst.sg.statemem.moosegroggy = true
			else
				inst.sg.statemem.moose = true
			end
		elseif inst:HasTag("weregoose") then
			if inst:HasTag("groggy") then
				inst.sg.statemem.goosegroggy = true
			else
				inst.sg.statemem.goose = true
			end
		elseif inst:HasTag("groggy") then
			inst.sg.statemem.groggy = true
		else
			inst.sg.statemem.normal = true
		end
	elseif inst:GetStormLevel() >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
		inst.sg.statemem.sandstorm = true
	elseif inst:HasTag("groggy") then
		inst.sg.statemem.groggy = true
	elseif inst:IsCarefulWalking() then
		inst.sg.statemem.careful = true
	else
		inst.sg.statemem.normal = true
		inst.sg.statemem.normalwonkey = inst:HasTag("wonkey") or nil
	end
end

AddStategraphPostInit("wilson", function(inst)
	local _RunOnEnter = inst.states["run_start"].onenter

	local function NewOnEnter(inst)
		if inst:HasTag("wathom") and inst:HasTag("wathomrun") and inst.components.rider ~= nil and not inst.components.rider:IsRiding() or inst:HasTag("wathom") and inst:HasTag("wathomrun") and inst.components.rider == nil then
			inst.sg.mem.footsteps = 0
			inst.sg:GoToState("run_wathom")
			return
		else
			_RunOnEnter(inst)
		end
	end

	inst.states["run_start"].onenter = NewOnEnter




	local actionhandlers =
	{
		ActionHandler(GLOBAL.ACTIONS.WATHOMBARK,
			function(inst, action)
				if inst._cantbarkcdtask == nil and
					(
						inst.components.adrenaline ~= nil and inst.components.adrenaline:GetPercent() < 0.5 or
						inst.replica ~= nil and inst.replica.currentadrenaline < 5) and not inst:HasTag("amped") then
					inst._cantbarkcdtask = inst:DoTaskInTime(5, OnCooldownCantBark)
					return "cantbark"
				elseif inst._cantbarkcdtask == nil and inst._barkcdtask ~= nil then
					inst._cantbarkcdtask = inst:DoTaskInTime(5, OnCooldownCantBark)
					return "cantbark"
				elseif inst._barkcdtask == nil and inst:HasTag("amped") then
					inst._barkcdtask = inst:DoTaskInTime(12, OnCooldownBark)
					return "wathombark"
				elseif inst._barkcdtask == nil and
					(
						inst.components.adrenaline ~= nil and inst.components.adrenaline:GetPercent() >= 0.5 or
						inst.replica ~= nil and inst.replica.currentadrenaline >= 50) then
					inst._barkcdtask = inst:DoTaskInTime(12, OnCooldownBark)
					return "wathombark"
				else
					return --	"idle"
				end
			end),

	}



	local states = {

		GLOBAL.State {
			name = "run_wathom",
			tags = { "moving", "running", "canrotate", "autopredict" },

			onenter = function(inst)
				ConfigureRunState(inst)
				inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + TUNING.WONKEY_SPEED_BONUS
				--inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * TUNING.WONKEY_RUN_HUNGER_RATE_MULT)
				inst.components.locomotor:RunForward()
				RunUpdateTools(inst)
				if not inst.AnimState:IsCurrentAnimation("umrun") then
					inst.AnimState:PlayAnimation("umrun", true)
				end

				--V2C: adding half a frame time so it rounds up
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			end,

			timeline =
			{
				TimeEvent(6 * FRAMES, function(inst) GLOBAL.PlayFootstep(inst, 0.5) end),
				TimeEvent(7 * FRAMES, function(inst) GLOBAL.PlayFootstep(inst, 0.5) end),
			},

			onupdate = function(inst)
				if inst.components.rider ~= nil and inst.components.rider:IsRiding() and not inst:HasTag("wathomrun") or not inst:HasTag("wathomrun") then
					inst.sg:GoToState("run")
					return
				end
				inst.components.locomotor:RunForward()
				RunUpdateTools(inst)
			end,

			events =
			{
				--[[EventHandler("gogglevision", function(inst, data)
                if not data.enabled and inst:GetStormLevel() >= TUNING.SANDSTORM_FULL_LEVEL then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("sandstormlevel", function(inst, data)
                if data.level >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("carefulwalking", function(inst, data)
                if data.careful then
                    inst.sg:GoToState("run")
                end
            end),]]
			},

			ontimeout = function(inst)
				inst.sg.statemem.funkyrunning = true
				inst.sg:GoToState("run_wathom")
			end,

			onexit = function(inst)
				if not inst.sg.statemem.funkyrunning then
					RunUpdateTools(inst, false, true)
					inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
					inst.Transform:ClearPredictedFacingModel()
				end
			end,
		},

		GLOBAL.State {
			name = "wathombark",
			tags = { "attack", "backstab", "busy", "notalking", "abouttoattack", "pausepredict", "nointerrupt" },

			onenter = function(inst, data)
				local buffaction = inst:GetBufferedAction()
				local target = buffaction ~= nil and buffaction.target or nil
				inst.AnimState:PlayAnimation("emote_angry", false)
				inst.components.locomotor:Stop()
				if inst.components.playercontroller ~= nil then
					inst.components.playercontroller:RemotePausePrediction()
				end
			end,

			onexit = function(inst)
				if not inst.components.playercontroller ~= nil then
					inst.components.playercontroller:Enable(true)
				end
			end,

			timeline =
			{
				TimeEvent(0 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/bark") --place your funky sounds here
					local fx = SpawnPrefab("statue_transition_2")
					if fx ~= nil then
						fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
						fx.Transform:SetScale(1.2, 1.2, 1.2)
					end
					fx = SpawnPrefab("statue_transition")
					if fx ~= nil then
						fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
						fx.Transform:SetScale(1.2, 1.2, 1.2)
					end
				end),


				TimeEvent(10 * FRAMES, function(inst)
					inst.components.locomotor:Stop()
					inst:PerformBufferedAction() --Dis is the important part, canis -Axe
					inst.sg:RemoveStateTag("busy")
					inst.sg:RemoveStateTag("nointerrupt")
				end),
			},

			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("idle")
				end),
			},
		},

		GLOBAL.State {
			name = "wathombark_shadow",
			tags = { "attack", "backstab", "busy", "notalking", "abouttoattack", "pausepredict", "nointerrupt" },

			onenter = function(inst, data)
				local buffaction = inst:GetBufferedAction()
				local target = buffaction ~= nil and buffaction.target or nil
				inst.AnimState:PlayAnimation("emote_angry", false)
				inst.components.locomotor:Stop()
				if inst.components.playercontroller ~= nil then
					inst.components.playercontroller:RemotePausePrediction()
				end
			end,

			onexit = function(inst)
				if not inst.components.playercontroller ~= nil then
					inst.components.playercontroller:Enable(true)
				end
			end,

			timeline =
			{
				TimeEvent(0 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/shadowbark") --place your funky sounds here
					local fx = SpawnPrefab("statue_transition_2")
					if fx ~= nil then
						fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
						fx.Transform:SetScale(1.2, 1.2, 1.2)
					end
					fx = SpawnPrefab("statue_transition")
					if fx ~= nil then
						fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
						fx.Transform:SetScale(1.2, 1.2, 1.2)
					end
				end),


				TimeEvent(10 * FRAMES, function(inst)
					inst.components.locomotor:Stop()
					inst:PerformBufferedAction() --Dis is the important part, canis -Axe
					inst.sg:RemoveStateTag("busy")
					inst.sg:RemoveStateTag("nointerrupt")
				end),
			},

			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("idle")
				end),
			},
		},

		GLOBAL.State {
			name = "cantbark",
			tags = { busy },

			onenter = function(inst)
				inst:ClearBufferedAction()

				--				inst.components.talker:Say("Can't... Breathe...", nil, true) -- I can't think of something cool for Wathom to say, so away this goes.

				inst.AnimState:PlayAnimation("sing_fail", false)

				inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/leap") -- maybe make something new later?
			end,
			timeline =
			{
				TimeEvent(12 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/leap") --place your funky sounds here
				end),                                                       --bark twice.
			},
			events =
			{
				EventHandler("animover", function(inst)
					if inst.AnimState:AnimDone() then
						inst.sg:GoToState("idle")
						inst.sg:RemoveStateTag("busy")
						inst:ClearBufferedAction()
					end
				end),
			}
		},

		GLOBAL.State {
			name = "wathomleap",
			tags = { "attack", "backstab", "busy", "notalking", "abouttoattack", "pausepredict", "nointerrupt" },

			onenter = function(inst, data)
				Effect(inst)
				local buffaction = inst:GetBufferedAction()
				local target = buffaction ~= nil and buffaction.target or nil
				inst.components.combat:SetTarget(target)
				inst.components.combat:StartAttack()
				--            inst.components.health:SetInvincible(true) -- I wonder why Tiddler did this?
				--inst.AnimState:PlayAnimation("atk_leap_pre", false)
				inst.AnimState:PlayAnimation("atk_leap", false)
				inst.Transform:SetEightFaced()
				inst.AnimState:ClearOverrideBuild("player_lunge")
				inst.AnimState:ClearOverrideBuild("player_attack_leap")
				inst.components.locomotor:Stop()
				inst.components.locomotor:EnableGroundSpeedMultiplier(false)
				if inst.components.playercontroller ~= nil then
					inst.components.playercontroller:RemotePausePrediction()
				end
			end,

			onexit = function(inst)
				--            inst.components.health:SetInvincible(false)
				inst.components.combat:SetTarget(nil)
				if inst.sg:HasStateTag("abouttoattack") then
					inst.components.combat:CancelAttack()
				end
				inst.Transform:SetFourFaced()
				inst.components.locomotor:Stop()
				inst.Physics:ClearMotorVelOverride()
				inst:DoTaskInTime(0, function(inst)
					if inst.components.playercontroller then
						inst.components.playercontroller:Enable(true)
					end
				end)
				inst.components.locomotor:EnableGroundSpeedMultiplier(true)
				inst.AnimState:AddOverrideBuild("player_lunge")
				inst.AnimState:AddOverrideBuild("player_attack_leap")
			end,

			timeline =
			{
				TimeEvent(0 * FRAMES, function(inst)
					inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/leap")
					inst.Physics:ClearCollisionMask() -- all of this physics stuff will give the impression that Wathom is jumping over things. It also allows him to slide past targets instead of ending his leap in front.
					-- 					inst.components.hunger:DoDelta(-1, 2)
					inst.Physics:CollidesWith(GLOBAL.COLLISION.WORLD)
					local buffaction = inst:GetBufferedAction()
					local target = buffaction ~= nil and buffaction.target or nil
					if target ~= nil then
						inst.sg.statemem.startingpos = inst:GetPosition()
						inst.sg.statemem.targetpos = target:GetPosition()
						if target ~= nil then
							if inst.sg.statemem.startingpos.x ~= inst.sg.statemem.targetpos.x or
								inst.sg.statemem.startingpos.z ~= inst.sg.statemem.targetpos.z then
								inst.leapvelocity = math.sqrt(GLOBAL.distsq(inst.sg.statemem.startingpos.x, inst.sg.statemem.startingpos.z,
									inst.sg.statemem.targetpos.x, inst.sg.statemem.targetpos.z)) / (12 * FRAMES)
							end
						end
					end
					inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/jump")
				end),


				TimeEvent(12 * FRAMES, function(inst)
					inst.sg:RemoveStateTag("abouttoattack")
					inst.components.locomotor:Stop()
					inst.Physics:ClearMotorVelOverride()
					inst:PerformBufferedAction()
					inst.components.playercontroller:Enable(false)
					inst.components.locomotor:EnableGroundSpeedMultiplier(true)
					inst.sg:RemoveStateTag("busy")
					inst.Physics:CollidesWith(GLOBAL.COLLISION.OBSTACLES)
					inst.Physics:CollidesWith(GLOBAL.COLLISION.SMALLOBSTACLES)
				end),

				TimeEvent(14 * FRAMES, function(inst) -- this is when the target gets hit
					if inst:HasTag("amped") and not inst:HasTag("wearingheavyarmor") then
						inst.leapvelocity = 15
					elseif inst.components.adrenaline:GetPercent() > 0.24 and inst.components.adrenaline:GetPercent() < 0.51 and not inst:HasTag("wearingheavyarmor") then
						inst.leapvelocity = 7.5 -- originally 10, lets see how this goes.
					elseif inst.components.adrenaline:GetPercent() > 0.50 and inst.components.adrenaline:GetPercent() < 0.75 and not inst:HasTag("wearingheavyarmor") then
						inst.leapvelocity = 10 -- * (inst.components.adrenaline:GetPercent() + .5)
					elseif inst.components.adrenaline:GetPercent() > 0.74 and inst.components.adrenaline:GetPercent() < 1 and not inst:HasTag("wearingheavyarmor") then
						inst.leapvelocity = 12.5 -- this is used in between 75 and 100 (Amped).
					else
						inst.leapvelocity = 0 --Either Wathom has the "wearingheavyarmor" tag, is under 25 adrenaline (ie fatigued) or the game is somehow not reading the Adrenaline meter.
					end
					SpawnPrefab("dirt_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end),

				TimeEvent(19 * FRAMES, function(inst)
					SpawnPrefab("dirt_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end),

				TimeEvent(24 * FRAMES, function(inst)
					SpawnPrefab("dirt_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.sg:RemoveStateTag("busy")
					inst.sg:RemoveStateTag("attack")
					inst.sg:RemoveStateTag("nointerrupt")
					inst.sg:RemoveStateTag("pausepredict")
					inst.sg:AddStateTag("idle")
					inst.leapvelocity = 0                   -- Stops Wathom's sliding.
					inst.Physics:Stop()
					inst.Physics:CollidesWith(GLOBAL.COLLISION.CHARACTERS) -- Re-enabling Wathom's normal collision.
					inst.components.playercontroller:Enable(true)
				end),

			},
			onupdate = function(inst)
				if inst.leapvelocity then
					inst.Physics:SetMotorVel(inst.leapvelocity, 0, 0)
				end
			end,
			events =
			{
				EventHandler("animover", function(inst)
					inst.sg:GoToState("idle")
				end),
			},
		},
	}

	for k, v in pairs(states) do
		GLOBAL.assert(v:is_a(GLOBAL.State), "Non-state added in mod state table!")
		inst.states[v.name] = v
	end

	for k, v in pairs(actionhandlers) do
		GLOBAL.assert(v:is_a(GLOBAL.ActionHandler), "Non-action added in mod state table!")
		inst.actionhandlers[v.action] = v
	end
end)

--client. Uses a "pre" as this should only be used if there's lag.

AddStategraphPostInit("wilson_client", function(inst)
	local _RunOnEnter = inst.states["run_start"].onenter

	local function NewOnEnter(inst)
		if inst:HasTag("wathom") and inst:HasTag("wathomrun") then
			inst.sg.mem.footsteps = 0
			inst.sg:GoToState("run_wathom")
			return
		else
			_RunOnEnter(inst)
		end
	end

	inst.states["run_start"].onenter = NewOnEnter

	local actionhandlers =
	{
		ActionHandler(GLOBAL.ACTIONS.WATHOMBARK,
			function(inst, action)
				return "wathombark_pre"
			end),
	}
	local states = {

		GLOBAL.State {
			name = "run_wathom",
			tags = { "moving", "running", "canrotate" },

			onenter = function(inst)
				ConfigureRunState(inst)
				inst.components.locomotor.predictrunspeed = TUNING.WILSON_RUN_SPEED + TUNING.WONKEY_SPEED_BONUS
				inst.components.locomotor:RunForward()
				RunUpdateTools(inst, true)
				if not inst.AnimState:IsCurrentAnimation("umrun") then
					inst.AnimState:PlayAnimation("umrun", true)
				end
				--V2C: adding half a frame time so it rounds up
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			end,

			timeline =
			{
				--[[TimeEvent(4*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),
            TimeEvent(5*FRAMES, function(inst) PlayFootstep(inst, 0.5) DoFoleySounds(inst) end),
            TimeEvent(10*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),
            TimeEvent(11*FRAMES, function(inst) PlayFootstep(inst, 0.5) end),]]
			},

			onupdate = function(inst)
				if not inst:HasTag("wathomrun") then
					inst.sg:GoToState("run")
					return
				end
				RunUpdateTools(inst, true)
				inst.components.locomotor:RunForward()
			end,

			--[[events =
        {
            EventHandler("gogglevision", function(inst, data)
                if not data.enabled and inst:GetStormLevel() >= TUNING.SANDSTORM_FULL_LEVEL then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("sandstormlevel", function(inst, data)
                if data.level >= TUNING.SANDSTORM_FULL_LEVEL and not inst.components.playervision:HasGoggleVision() then
                    inst.sg:GoToState("run")
                end
            end),
            EventHandler("carefulwalking", function(inst, data)
                if data.careful then
                    inst.sg:GoToState("run")
                end
            end),
        },]]

			ontimeout = function(inst)
				inst.sg.statemem.funkyrunning = true
				inst.sg:GoToState("run_wathom")
			end,

			onexit = function(inst)
				if not inst.sg.statemem.funkyrunning then
					RunUpdateTools(inst, true, true)
					inst.components.locomotor.predictrunspeed = nil
					inst.Transform:ClearPredictedFacingModel()
				end
			end,
		},

		GLOBAL.State {
			name = "wathomleap_pre",
			tags = { "busy" },

			onenter = function(inst)
				inst.components.locomotor:Stop()

				inst.AnimState:PlayAnimation("atk_leap_pre", false)
				inst.AnimState:PushAnimation("atk_leap_lag", false)

				local buffaction = inst:GetBufferedAction()
				if buffaction ~= nil then
					inst:PerformPreviewBufferedAction()

					if buffaction.pos ~= nil then
						inst:ForceFacePoint(buffaction:GetActionPoint():Get())
					end
				end

				inst.sg:SetTimeout(2)
			end,

			onupdate = function(inst)
				if inst:HasTag("busy") then
					if inst.entity:FlattenMovementPrediction() then
						inst.AnimState:PlayAnimation("atk_leap_lag", false)
					end
				elseif inst.bufferedaction == nil then
					inst.sg:GoToState("idle")
				end
			end,

			ontimeout = function(inst)
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle")
			end,
		},

		GLOBAL.State {
			name = "wathombark_pre",
			tags = { "busy" },

			onenter = function(inst)
				inst.components.locomotor:Stop()

				inst.AnimState:PlayAnimation("idle", false)

				local buffaction = inst:GetBufferedAction()
				if buffaction ~= nil then
					inst:PerformPreviewBufferedAction()

					if buffaction.pos ~= nil then
						inst:ForceFacePoint(buffaction:GetActionPoint():Get())
					end
				end

				inst.sg:SetTimeout(0)
				inst.AnimState:PushAnimation("idle", true)
			end,

			onupdate = function(inst)
				if inst:HasTag("busy") then
					if inst.entity:FlattenMovementPrediction() then
						inst.sg:GoToState("idle", "noanim")
					end
				elseif inst.bufferedaction == nil then
					inst.sg:GoToState("idle")
				end
			end,

			ontimeout = function(inst)
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle")
			end,
		}
	}

	for k, v in pairs(states) do
		GLOBAL.assert(v:is_a(GLOBAL.State), "Non-state added in mod state table!")
		inst.states[v.name] = v
	end

	for k, v in pairs(actionhandlers) do
		GLOBAL.assert(v:is_a(GLOBAL.ActionHandler), "Non-action added in mod state table!")
		inst.actionhandlers[v.action] = v
	end
end)




-----------------------------------------------------------------------------------------------------

STRINGS.ACTIONS.WATHOMBARK = "Bark"

local function AddEnemyDebuffFx(fx, target)
	target:DoTaskInTime(math.random() * 0.25, function()
		local x, y, z = target.Transform:GetWorldPosition()
		local fx = SpawnPrefab(fx)
		if fx then
			fx.Transform:SetPosition(x, y, z)
		end

		return fx
	end)
end

--helper function so I can merge the action handler and action checks easily
local function DoBark(act)

end

local wathombark = AddAction(
	"WATHOMBARK",
	STRINGS.ACTIONS.WATHOMBARK,
	function(act)
		local inst = act.doer
		if act.doer ~= nil and act.doer.components.adrenaline ~= nil then -- previously act.target
			local inst = act.doer
			inst.AnimState:AddOverrideBuild("emote_angry")
			if not inst:HasTag("amped") then
				inst.components.adrenaline:DoDelta(-25, 2)
			else
				inst.components.adrenaline:DoDelta(8, 2)
			end
			--		inst.SoundEmitter:PlaySound("wathomcustomvoice/wathomvoiceevent/bark") Commented out for now since it already plays the sound before this code is performed

			local act_pos = act:GetActionPoint()
			local ents = GLOBAL.TheSim:FindEntities(act_pos.x, act_pos.y, act_pos.z, 10, { "_combat" },
				{ "companion", "INLIMBO", "notarget", "player", "playerghost", "wall", "abigail", "shadow" }) --added playertags because of the taunt.
			for i, v in ipairs(ents) do
				if v.components.hauntable ~= nil and v.components.hauntable.panicable and not
					(
						v.components.follower ~= nil and v.components.follower:GetLeader() and
						v.components.follower:GetLeader():HasTag("player")) then
					v.components.hauntable:Panic(10) -- Fallback to TUNING.BATTLESONG_PANIC_TIME (6 seconds) if needed
					AddEnemyDebuffFx("battlesong_instant_panic_fx", v)
				end
				if v.components.hauntable == nil or
					v.components.hauntable ~= nil and not v.components.hauntable.panicable and not (
						v.components.follower ~= nil and v.components.follower:GetLeader() and
						v.components.follower:GetLeader():HasTag("player")) and not v:HasTag("player") then
					if not v:HasTag("bird") and v.components.combat then
						v.components.combat:SetTarget(act.doer)
						AddEnemyDebuffFx("battlesong_instant_taunt_fx", v)
					end
				end
			end
			--also scare enemies near wathom, at a smaller radius
			local x, y, z = act.doer.Transform:GetWorldPosition()
			ents = GLOBAL.TheSim:FindEntities(x, y, z, 4, { "_combat" },
				{ "companion", "INLIMBO", "notarget", "player", "playerghost", "wall", "abigail", "shadow", "trap" }) --added playertags because of the taunt.
			for i, v in ipairs(ents) do
				if v.components.hauntable ~= nil and v.components.hauntable.panicable and not
					(
						v.components.follower ~= nil and v.components.follower:GetLeader() and
						v.components.follower:GetLeader():HasTag("player")) then
					v.components.hauntable:Panic(8) -- Fallback to TUNING.BATTLESONG_PANIC_TIME (6 seconds) if needed
				end
				if v.components.hauntable == nil or
					v.components.hauntable ~= nil and not v.components.hauntable.panicable and not (
						v.components.follower ~= nil and v.components.follower:GetLeader() and
						v.components.follower:GetLeader():HasTag("player")) and not v:HasTag("player") then
					if not v:HasTag("bird") and v.components.combat then
						v.components.combat:SetTarget(act.doer)
					end
				end
			end
			return true
		else
			return false
		end
	end
)

wathombark.priority = HIGH_ACTION_PRIORITY
wathombark.rmb = true
wathombark.distance = 36
wathombark.mount_valid = false

STRINGS.ACTIONS.WATHOMBARK = "Bark"

-- STRINGS.ACTIONS.AMPUP = "Amp Up!"

---------------------------------------------

local KnownModIndex = GLOBAL.KnownModIndex
local Text = require "widgets/text"
local Image = require "widgets/image"
local NUMBERFONT = GLOBAL.NUMBERFONT

local function GetModName(modname) -- modinfo's modname and internal modname is different.
	for _, knownmodname in ipairs(KnownModIndex:GetModsToLoad()) do
		if KnownModIndex:GetModInfo(knownmodname).name == modname then
			return knownmodname
		end
	end
end

local function GetModOptionValue(knownmodname, known_option_name)
	local modinfo = KnownModIndex:GetModInfo(knownmodname)
	for _, option in pairs(modinfo.configuration_options) do
		if option.name == known_option_name then
			return option.saved
		end
	end
end

AddPlayerPostInit(function(inst)
	if inst:HasTag("wathom") then
		inst.counter_max = GLOBAL.net_shortint(inst.GUID, "counter_max", "counter_maxdirty")
		inst.counter_current = GLOBAL.net_shortint(inst.GUID, "counter_current", "counter_currentdirty")

		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("adrenaline")
		end
		inst:ListenForEvent("onattackother", AttackOther)
	end
end)

local function AmpbadgeDisplays(self)
	if self.owner:HasTag("wathom") then
		local ampbadge = require "widgets/ampbadge"

		self.combinedmod = GetModName("Combined Status")

		self.adrenaline = self:AddChild(ampbadge(self.owner))

		if self.combinedmod ~= nil then
			self.brain:SetPosition(0, 35, 0)
			self.stomach:SetPosition(-62, 35, 0)
			self.heart:SetPosition(62, 35, 0)

			self.adrenaline:SetScale(.9, .9, .9)
			self.adrenaline:SetPosition(-62, -50, 0)
			self.adrenaline.combinedmod = true
			self.adrenaline.showmaxonnumbers = GetModOptionValue(self.combinedmod, "SHOWMAXONNUMBERS")

			self.adrenaline.bg = self.adrenaline:AddChild(Image("images/status_bgs.xml", "status_bgs.tex"))
			self.adrenaline.bg:SetScale(.4, .43, 0)
			self.adrenaline.bg:SetPosition(-.5, -40, 0)

			if self.boatmeter then
				self.boatmeter:SetPosition(-124, -52)
			end

			self.adrenaline.num:SetFont(NUMBERFONT)
			self.adrenaline.num:SetSize(28)
			self.adrenaline.num:SetPosition(3.5, -40.5, 0)
			self.adrenaline.num:SetScale(1, .78, 1)

			self.adrenaline.num:MoveToFront()
			self.adrenaline.num:Show()

			self.adrenaline.maxnum = self.adrenaline:AddChild(Text(NUMBERFONT, self.adrenaline.showmaxonnumbers and 25 or 33))
			self.adrenaline.maxnum:SetPosition(6, 0, 0)
			self.adrenaline.maxnum:MoveToFront()
			self.adrenaline.maxnum:Hide()
		else
			self.adrenaline:SetPosition(self.column3, -130, 0)
			self.moisturemeter:SetPosition(self.column1, -130, 0)
			--self.brain:SetPosition(40, -50, 0)
			--self.stomach:SetPosition(-40, 17, 0)
		end

		--self.inst:ListenForEvent("adrenalinedelta", function(inst, data) self.adrenaline:SetPercent(data.newpercent, self.owner.components.pestilencecounter:Max()) end, self.owner)

		local _SetGhostMode = self.SetGhostMode
		function self:SetGhostMode(ghostmode)
			if not self.isghostmode == not ghostmode then --force boolean
				return
			end

			_SetGhostMode(self, ghostmode)
			if ghostmode then
				self.adrenaline:Hide()
			else
				self.adrenaline:Show()
			end
		end
	end
end

AddClassPostConstruct("widgets/statusdisplays", AmpbadgeDisplays)

-------------------------------------------------------
-- The character select screen lines
STRINGS.CHARACTER_TITLES.wathom = "The Forgotten Parody"
STRINGS.CHARACTER_NAMES.wathom = "Wathom"
STRINGS.CHARACTER_DESCRIPTIONS.wathom = "*Apex Predator\n*Gets amped up with adrenaline\n*Causes animals to panic\n*The faster he goes, the harder he falls"
STRINGS.CHARACTER_QUOTES.wathom = "\"Cruel, the abyss.\""
STRINGS.CHARACTER_SURVIVABILITY.wathom = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.WATHOM = require "speech_wathom"

-- The character's name as appears in-game
STRINGS.NAMES.WATHOM = "Wathom"
STRINGS.SKIN_NAMES.wathom_none = "Wathom"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
	{
		type = "ghost_skin",
		anim_bank = "ghost",
		idle_anim = "idle",
		scale = 0.75,
		offset = { 0, -25 }
	},
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
if GetModConfigData("holy fucking shit it's wathom") then
	AddModCharacter("wathom", "MALE", skin_modes)
end

--skincolor
for k, v in pairs(GLOBAL.CLOTHING) do
	if v and v.symbol_overrides_by_character and v.symbol_overrides_by_character.wortox then
		GLOBAL.CLOTHING[k].symbol_overrides_by_character.wathom = v.symbol_overrides_by_character.wortox
	end
end


--[[Keeping this here for standalone mod but this is causing issues with postinit/components/health
--Refuse to die Edit this not to include you
local function MayKill(self, amount)
	if self.currenthealth + amount <= 0 then
		return true
	end
end

local function HasLLA(self)
	if self.inst.components.inventory then
		local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
		if item and item.prefab == "amulet" then
			return true
		end
	end
end

AddComponentPostInit("health", function(self)
	if not GLOBAL.TheWorld.ismastersim then return end

	local _DoDelta = self.DoDelta
	function self:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)

	end
end)
]]

local PREFAB_SKINS = GLOBAL.PREFAB_SKINS
local PREFAB_SKINS_IDS = GLOBAL.PREFAB_SKINS_IDS
local SKIN_AFFINITY_INFO = GLOBAL.require("skin_affinity_info")

-- Modded Skin API
--[[
modimport("skins_api")

SKIN_AFFINITY_INFO.wathom = {
    "wathom_triumphant", --Hornet: These skins will show up for the character when the Survivor filter is enabled
}

PREFAB_SKINS["wathom"] = {"wathom_none", "wathom_triumphant",}

PREFAB_SKINS_IDS = {} --Make sure this is after you  change the PREFAB_SKINS["character"] table
for prefab,skins in pairs(PREFAB_SKINS) do
    PREFAB_SKINS_IDS[prefab] = {}
    for k,v in pairs(skins) do
          PREFAB_SKINS_IDS[prefab][v] = k
    end
end
AddSkinnableCharacter("wathom")]]


STRINGS.SKIN_NAMES.wathom_none = "Wathom"
STRINGS.SKIN_NAMES.wathom_triumphant = "The Archaic"

STRINGS.SKIN_QUOTES.wathom_none = "\"Cruel, the abyss.\""
STRINGS.SKIN_QUOTES.wathom_triumphant = "\"Pursuit of knowledge; A thousand deaths, will endure.\""

STRINGS.SKIN_DESCRIPTIONS.wathom_none = "A crude recreation of those who came before him."
STRINGS.SKIN_DESCRIPTIONS.wathom_triumphant = "Donned with military attire, Wathom acknowledges and accepts his fate when tracing the Ancients' footsteps. He was born for this."
