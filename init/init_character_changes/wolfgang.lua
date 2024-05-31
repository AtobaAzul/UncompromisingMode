TUNING.MIGHTY_HUNGER_RATE_MULT = 2
TUNING.SHADOW_HUNGER_RATE_MULT = 1.5
TUNING.WOLFGANG_HUNGER = 300
TUNING.WOLFGANG_SANITY = 150
TUNING.SHADOW_WOLFGANG_MAX_HEALTH = 125
TUNING.LUNAR_WOLFGANG_MAX_HEALTH = 250

TUNING.MIGHTINESS_CHANGE_RATE = 1 --per second
TUNING.MIGHTINESS_CHANGE_MULT_NORMAL = 1
TUNING.MIGHTINESS_CHANGE_STANDARD_DELTA = TUNING.MIGHTINESS_CHANGE_MULT_NORMAL/2
TUNING.MIGHTINESS_CHANGE_MULT_NONE = 0

TUNING.WOLFGANG_SHADOW_STRIKE_GRACE_PERIOD = 3
TUNING.WOLFGANG_SHADOW_STRIKE_MAX_COMBO = 5
TUNING.WOLFGANG_SHADOW_STRIKE_MULT_BOOST_PER_COMBO = 0.134
TUNING.WOLFGANG_SHADOW_STRIKE_BASE_MULT = 0.75

TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_COOLDOWN = 5
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_BASE_COST = 50
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_1_COST = 45
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_2_COST = 40
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_3_COST = 35
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_4_COST = 30
TUNING.FEAT_OF_STRENGTH_MIGHTY_STRIKE_5_COST = 25

TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO = 2
TUNING.LUNAR_MIGHTY_FISHING_CATCH_GOLD_CHANCE = 0.5
TUNING.LUNAR_MIGHTY_FISHING_CATCH_EXTRA_FISH_CHANCE = 0.75

TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_COST = 50
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_1_COST = 45
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_2_COST = 40
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_3_COST = 35
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_4_COST = 30
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_EXPERT_COST = 25
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_MIN_DIST = 6
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_COOLDOWN = 5
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_EXPERT_COOLDOWN = 2.5
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE = 34
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE_MIGHTY = 68
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE_HEAVY = 102
TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_AOE_RANGE_HEAVY = 5


TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_EXPERT = 1.5
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_4 = 2
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_3 = 3
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_2 = 4
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_1 = 5
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST = 6

TUNING.WOLFGANG_MIGHTY_WORK_COST_MULT =
	{
		CHOP = 1,				-- ~0.4s
		MINE = 2.5,				-- ~0.4s
		HAMMER = 4,			-- ~0.4s -- please dont hammer down other people's bases...
		DIG = 1,
		ROW = 1,				-- ~0.4s without lag
		LOWER_SAIL_BOOST = 1,
		TILL = 1,				-- ~1.1s
		TERRAFORM = 1,
		HACK = 1 -- For IA compatibility
	}

TUNING.HARD_MATERIAL_MULT = 2.5

TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_CHANCE_3 = 1
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_CHANCE_2 = 1
TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_CHANCE_1 = 1
TUNING.MIGHTY_WORK_CHANCE = 1

TUNING.WOLFGANG_MIGHTINESS_ATTACK_GAIN_GIANT = 0
TUNING.WOLFGANG_MIGHTINESS_ATTACK_GAIN_SMALLCREATURE = 0
TUNING.WOLFGANG_MIGHTINESS_ATTACK_GAIN_DEFAULT = 0

TUNING.WOLFGANG_MIGHTINESS_WORK_GAIN =
	{
		CHOP = 0,				-- ~0.4s
		MINE = 0,				-- ~0.4s
		HAMMER = 0,			-- ~0.4s -- please dont hammer down other people's bases...
		DIG = 0,
		ROW = 0,				-- ~0.4s without lag
		LOWER_SAIL_BOOST = 0,
		TILL = 0,				-- ~1.1s
		TERRAFORM = 0,
		HACK = 0 -- For IA compatibility
	}


local MIGHTYSWING = AddAction("MIGHTYSWING", "Mighty Strike", function(act)
	if act.doer ~= nil and act.target ~= nil and act.target ~= act.doer and act.doer:HasTag('strongman') and act.target.replica.health ~= nil and not act.doer:HasTag("mighty_strike_cooldown") then
		act.doer.components.featsofstrength:MightySwing(act.target)
		return true
	else
		return false
	end
end)

MIGHTYSWING.distance = TUNING.DEFAULT_ATTACK_RANGE * 1.1

local MIGHTYLEAP = AddAction("MIGHTYJUMP", "Leap", function(act)
	if act.doer ~= nil and act.doer.components.mightiness ~= nil and act.doer:HasTag("strongman") then
		local mightiness = act.doer.components.mightiness:GetCurrent()
		local cost = (act.doer:HasTag("mighty_leap_expert") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_EXPERT_COST) or
			(act.doer:HasTag("mighty_leap_4") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_4_COST) or
			(act.doer:HasTag("mighty_leap_3") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_3_COST) or
			(act.doer:HasTag("mighty_leap_2") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_2_COST) or
			(act.doer:HasTag("mighty_leap") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_1_COST) or
			TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_COST
		local hunger = act.doer.components.hunger:GetPercent() * TUNING.WOLFGANG_HUNGER
		local canmightyhunger = act.doer:HasTag("mighty_hunger") and (hunger >= (mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO)
		if mightiness >= cost or canmightyhunger then
			act.doer.components.mightiness:DoDelta(-cost)
			act.doer:AddTag("mighty_leap_cooldown")
			act.doer:DoTaskInTime((act.doer:HasTag("mighty_leap_expert") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_EXPERT_COOLDOWN) or TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_COOLDOWN, function(inst) inst:RemoveTag("mighty_leap_cooldown") end)
			if mightiness < cost then
				act.doer:DoTaskInTime(1.25, function(inst) inst.components.hunger:DoDelta((mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO) end) --to prevent it cancelling the jump with a transformation
			end
			return true
		else
			act.doer.sg:GoToState("idle")
			return false
		end
	else
		act.doer.sg:GoToState("idle")
		return false
	end
end)

MIGHTYLEAP.distance = 12
MIGHTYLEAP.mindistance = TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_MIN_DIST
MIGHTYLEAP.encumbered_valid = true
MIGHTYLEAP.rmb = true
MIGHTYLEAP.priority = HIGH_ACTION_PRIORITY

AddComponentAction("SCENE", "combat", function(inst, doer, actions, right)
	if right then
		if doer:HasTag('strongman') and not doer:HasTag("mighty_strike_cooldown") and inst ~= doer and
                not GLOBAL.IsEntityDead(inst, true) and
                inst.replica.combat ~= nil and inst.replica.combat:CanBeAttacked(doer)
				and doer.replica.combat:CanTarget(inst) then
			table.insert(actions, GLOBAL.ACTIONS.MIGHTYSWING)
		end
	end
end)

local state_mightyjump_pre = GLOBAL.State{ name = "mightyjump_pre",
	tags = { "doing", "busy", "canrotate", "nomorph" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("jump_pre")
		inst.sg:SetTimeout(GLOBAL.FRAMES*18)
		
		local buffaction = inst:GetBufferedAction()
		if buffaction ~= nil then
			inst:PerformPreviewBufferedAction()

			if buffaction.pos ~= nil then
				inst:ForceFacePoint(buffaction:GetActionPoint():Get())
			end
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(1 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
		end),
	},
	
	events =
	{
		GLOBAL.EventHandler("animover", function(inst)
			inst.sg:GoToState("mightyjump")
		end),
	},
	
	onupdate = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle", true)
			end
		end
	end,

	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,

	onexit = function(inst)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson", state_mightyjump_pre)
AddStategraphState("wilson_client", state_mightyjump_pre)

AddStategraphState("wilson", GLOBAL.State{ name = "mightyjump",
	tags = { "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		--GLOBAL.ChangeToGhostPhysics(inst)
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
		inst.Physics:CollidesWith(GLOBAL.COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
	
		inst.AnimState:PlayAnimation("jumpout")
		inst.Physics:SetMotorVel(13, 0, 0)
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(30 * GLOBAL.FRAMES)
	end,

	timeline =
	{
		GLOBAL.TimeEvent(4.5 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(25, 18, 0)
			inst.SoundEmitter:PlaySound("wanda1/wanda/jump_whoosh")
		end),
		GLOBAL.TimeEvent(9 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(25, 0, 0)
		end),
		GLOBAL.TimeEvent(13.5 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(25, -30, 0)
		end),
		GLOBAL.TimeEvent(15.2 * GLOBAL.FRAMES, function(inst)
			local function HasFriendlyLeader(inst, target)
				local target_leader = (target.components.follower ~= nil) and target.components.follower.leader or nil
				
				if target_leader ~= nil then

					if target_leader.components.inventoryitem then
						target_leader = target_leader.components.inventoryitem:GetGrandOwner()
					end

					local PVP_enabled = GLOBAL.TheNet:GetPVPEnabled()
					return (target_leader ~= nil 
							and (target_leader:HasTag("player") 
							and not PVP_enabled)) or
							(target.components.domesticatable and target.components.domesticatable:IsDomesticated() 
							and not PVP_enabled) or
							(target.components.saltlicker and target.components.saltlicker.salted
							and not PVP_enabled)
				end

				return false
			end

			local function CanDamage(inst, target)
				if target.components.minigame_participator ~= nil or target.components.combat == nil then
					return false
				end

				if target:HasTag("player") and not GLOBAL.TheNet:GetPVPEnabled() then
					return false
				end

				if target:HasTag("playerghost") and not target:HasTag("INLIMBO") then
					return false
				end

				if target:HasTag("monster") and not GLOBAL.TheNet:GetPVPEnabled() and 
				   ((target.components.follower and target.components.follower.leader ~= nil and 
					 target.components.follower.leader:HasTag("player")) or target.bedazzled) then
					return false
				end

				if HasFriendlyLeader(inst, target) then
					return false
				end

				return true
			end
			local x,y,z = inst.Transform:GetWorldPosition()
			local AOE_ATTACK_MUST_TAGS = {"_combat", "_health"}
			local AOE_ATTACK_NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO"}
			local isHeavyLifting = inst.components.inventory:IsHeavyLifting()
			local range = (isHeavyLifting and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_AOE_RANGE_HEAVY) or TUNING.DEFAULT_ATTACK_RANGE
			local damage = (isHeavyLifting and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE_HEAVY) or
				(inst:HasTag("mightiness_mighty") and TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE_MIGHTY) or
				TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_DAMAGE
			local ents = GLOBAL.TheSim:FindEntities(x, y, z, range, AOE_ATTACK_MUST_TAGS, AOE_ATTACK_NO_TAGS)
			if GLOBAL.TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
				if isHeavyLifting then
					GLOBAL.SpawnPrefab("groundpound_fx").Transform:SetPosition(x,y,z)
					local groundpound = GLOBAL.SpawnPrefab("groundpoundring_fx")
					groundpound.Transform:SetScale(0.6, 0.6, 0.6)
					groundpound.Transform:SetPosition(x,y,z)
					inst:ShakeCamera(GLOBAL.CAMERASHAKE.VERTICAL, 0.1, 0.03, 1)
				else
					GLOBAL.SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(x,y-1,z)
					inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
					inst:ShakeCamera(GLOBAL.CAMERASHAKE.VERTICAL, 0.1, 0.03, 1)
				end
				if inst:HasTag("mighty_leap") then
					for i, ent in ipairs(ents) do
						local canfreeze = inst:HasTag("mighty_hunger")
						if CanDamage(inst, ent) then
							ent.components.combat:GetAttacked(inst, damage)
							if canfreeze then
								if ent.components.freezable ~= nil then
									ent.components.freezable:AddColdness(1)
								end
							end
						end
					end
				end
			elseif inst:HasTag("mighty_hunger") and inst.components.drownable:IsOverWater(x,y,z) then
				local iceboat = GLOBAL.SpawnPrefab("boat_ice")
				iceboat.Transform:SetPosition(x,y-1,z)
				iceboat:DoTaskInTime(28, function(inst)
					GLOBAL.SpawnPrefab("degrade_fx_ice").Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst:Remove() 
				end)
				GLOBAL.SpawnPrefab("degrade_fx_ice").Transform:SetPosition(x,y-1,z)
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_hit")
			end
			if inst:HasTag("shadow_strikes") then
				inst:IncreaseCombo(1)
			end
		end),
		GLOBAL.TimeEvent(16 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(2, 0, 0)
		end),
		GLOBAL.TimeEvent(18 * GLOBAL.FRAMES, function(inst)
			inst.Physics:Stop()
		end),
	},

	events =
	{
		GLOBAL.EventHandler("animqueueover", function(inst)
			local x,y,z = inst.Transform:GetWorldPosition()
			if inst.AnimState:AnimDone() then
				GLOBAL.ChangeToCharacterPhysics(inst)
				inst.Transform:SetPosition(x,0,z)
				inst.sg:GoToState("idle")
			end
		end),
	},
	
	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		GLOBAL.ChangeToCharacterPhysics(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x,0,z)
		inst.sg:GoToState("idle")
	end,
	
	onexit = function(inst)
		GLOBAL.ChangeToCharacterPhysics(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x,0,z)
		inst:DoTaskInTime(1.25, function(inst)
			if GLOBAL.TheWorld:HasTag("cave") and not GLOBAL.TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
				if not inst:HasTag("shadow_mighty") then 
					inst.components.health:DeltaPenalty(GLOBAL.TUNING.DROWNING_DAMAGE.DEFAULT.HEALTH_PENALTY)
				end
				inst:PutBackOnGround()
			end
		end)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
})

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.MIGHTYSWING, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "attack"
	end
end))

AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.MIGHTYSWING, function(inst, action)
	if not inst.sg:HasStateTag("attack") then
		return "attack"
	end
end))

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.MIGHTYJUMP, "mightyjump_pre"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.MIGHTYJUMP, "mightyjump_pre"))

local env = env
GLOBAL.setfenv(1, GLOBAL)

STRINGS.CHARACTERS.WOLFGANG.NEED_MORE_MIGHTINESS = "Mighty muscles must rest!"
STRINGS.CHARACTERS.WOLFGANG.NEED_MORE_SANITY = "Is too scary!"

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_1_TITLE = "Mighty Work I"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_2_TITLE = "Mighty Work II"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_3_TITLE = "Mighty Work III"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_4_TITLE = "Mighty Work IV"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_EXPERT_TITLE = "Mighty Work Expert"

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_1_DESC = "Cost to one-shot while working decreased 17%."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_2_DESC = "Cost to one-shot while working decreased 33%."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_3_DESC = "Cost to one-shot while working decreased 50%."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_4_DESC = "Cost to one-shot while working decreased 67%."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_CRITWORK_EXPERT_DESC = "Cost to one-shot while working decreased 75%.\nYou can break harder materials by forcing tools beyond their limit while mighty."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_COACH_DESC = "Learn to craft a Coaching Whistle.\nWhile coaching, Normal or Mighty Wolfgang will boost followers' damage."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_TITLE = "Leg Day"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_2_TITLE = "Leg Day II"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_3_TITLE = "Leg Day III"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_4_TITLE = "Leg Day IV"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_EXPERT_TITLE = "Leg Day Expert"

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_DESC = "Cost to leap is reduced by 10%, and landing on an enemy will cause damage."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_2_DESC = "Cost to leap is reduced by 20%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_3_DESC = "Cost to leap is reduced by 30%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_4_DESC = "Cost to leap is reduced by 40%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_LEGS_EXPERT_DESC = "Cost to leap is reduced by 50%, the cooldown is halved, and you can leap carrying heavy objects for more damage and a larger area."


STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_1_DESC = "You can now gain mightiness up to 110."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_2_DESC = "You can now gain mightiness up to 120."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_3_DESC = "You can now gain mightiness up to 130."
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_4_DESC = "You can now gain mightiness up to 140."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_5_TITLE = "Push the Limits Expert"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_GYM_OVERBUFF_5_DESC = "You can now gain mightiness up to 150, and you gain twice as much mightiness from using the gym."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_1_TITLE = "Mighty Strikes I"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_2_TITLE = "Mighty Strikes II"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_3_TITLE = "Mighty Strikes III"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_4_TITLE = "Mighty Strikes IV"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_5_TITLE = "Mighty Strikes V"

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_1_DESC = "Cost of Mighty Strikes decreases by 10%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_2_DESC = "Cost of Mighty Strikes decreases by 20%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_3_DESC = "Cost of Mighty Strikes decreases by 30%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_4_DESC = "Cost of Mighty Strikes decreases by 40%"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_MIGHTY_STRIKES_5_DESC = "Cost of Mighty Strikes decreases by 50%"

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_TITLE = "Faustian Bargain"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_DESC = "The Queen will reward your loyalty with devastating strength.\nYou will now always be mighty and with only 1.5x hunger rate, but your body becomes more fragile."

STRINGS.SKILLTREE.ALLEGIANCE_LOCK_SHADOW_DESC = "Master your shadow-fueled strength, but locks other masteries if chosen."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_MASTERY_TITLE = "Shadow Mastery"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_SHADOW_MASTERY_DESC = "Your base damage is lower, but increases as you land hits, leap, and do mighty work without being hit yourself."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_TITLE = "Monstrous Growth"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_DESC = "The Cryptic Founder will reward your curiosity with lunar energy causing monstrous growth.\nYou gain an alternative mighty form with a dusting of fish scales and improved sailing and fishing capabilities."

STRINGS.SKILLTREE.ALLEGIANCE_LOCK_LUNAR_DESC = "Master your overgrown hunger, but locks other masteries if chosen."

STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_MASTERY_TITLE = "Lunar Mastery"
STRINGS.SKILLTREE.WOLFGANG.WOLFGANG_ALLEGIANCE_LUNAR_MASTERY_DESC = "Having insufficient mightiness will drain hunger instead.\nLeaping will create ice platforms on water.\nYou are immune to accursed trinkets."

STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_MONSTERTONORMAL = "Wolfgang feel tiny now."
STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_NORMALTOMONSTER = "The sea calls to Wolfgang!"
STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_IGNOREDTRINKETCURSE = "Puny bracelet no match for mighty scales!"

STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_WASHED_ASHORE = "Wolfgang glad to be back on land."
STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_FELLINTOVOID = "Wolfgang barely managed to grab ledge!"
STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_BOAT_SINK = "Water is cold!"


ACTIONS.PLAY.strfn = function(act)
	if act.invobject ~= nil then
		if act.invobject:HasTag("coach_whistle") then
			if act.doer:HasTag("wolfgang_coach") and not act.doer:HasTag("mightiness_wimpy") then
				return act.doer:HasTag("coaching") and "COACH_OFF" or "COACH_ON"
			end
			return "TWEET"
		end
	end
end

local function ToughWorker(inst)
	local workmastery = inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_expert")
	local mighty = inst.components.mightiness:IsMighty()
	if mighty and workmastery and not inst:HasTag("toughworker") then
		inst:AddTag("toughworker")
	else
		inst:RemoveTag("toughworker")
    end
end

local function GetDowningDamgeTunings(inst)
    return TUNING.DROWNING_DAMAGE[inst:HasTag("merm") and "WURT" or "DEFAULT"]
end

local function ShouldDropItems(inst)
	return not inst:HasTag("merm")
end

local function IARescue(inst)
    if TheWorld.has_ia_drowning and inst:HasTag("merm") then
        return "WURT_RESURRECT"
    end
end

local function HandleComboMult(inst)
	if inst:HasTag("shadow_strikes") and inst.combo >= 1 then
		local combobonus = 1 + inst.combo * TUNING.WOLFGANG_SHADOW_STRIKE_MULT_BOOST_PER_COMBO
		inst.components.combat.externaldamagemultipliers:SetModifier("shadow_strikes", combobonus)
	else 
		inst.components.combat.externaldamagemultipliers:RemoveModifier("shadow_strikes")
	end
end

local function ComboTimerOver(inst, data)
	inst.combo = 0
	HandleComboMult(inst)
end

local function ResetComboTimer(inst)
	if not inst.components.timer:TimerExists("inCombat") then
		inst.components.timer:StartTimer("inCombat", TUNING.WOLFGANG_SHADOW_STRIKE_GRACE_PERIOD)
	else
		inst.components.timer:SetTimeLeft("inCombat", TUNING.WOLFGANG_SHADOW_STRIKE_GRACE_PERIOD)
	end
end

local function IncreaseCombo(inst, num)
	ResetComboTimer(inst)
	if inst.combo == nil then
		inst.combo = 0
	end
	inst.combo = math.min(inst.combo + num, TUNING.WOLFGANG_SHADOW_STRIKE_MAX_COMBO)
	if inst.combo == TUNING.WOLFGANG_SHADOW_STRIKE_MAX_COMBO then
		SpawnPrefab("statue_transition_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	HandleComboMult(inst)
end

local function OnHitOther(inst, data)	
	if inst:HasTag("shadow_strikes") then
		IncreaseCombo(inst, 1)
	end
end

local function OnAttacked(inst, data)
	if inst.components.timer:TimerExists("inCombat") then
		inst.components.timer:SetTimeLeft("inCombat", 0)
	end
	if inst:HasTag("shadow_strikes") then
		inst.combo = 0
		HandleComboMult(inst)
	end
end

local function GetPointSpecialActions(inst, pos, useitem, right)
	if right and useitem == nil and not inst:HasTag("mightiness_wimpy") and not inst:HasTag("mighty_leap_cooldown") then
		local platform = inst:GetCurrentPlatform()
		local targetPlatform = TheWorld.Map:GetPlatformAtPoint(pos.x, pos.y, pos.z)
		local distance = pos:Dist(inst:GetPosition())
		local tooClose = distance < TUNING.FEAT_OF_STRENGTH_MIGHTY_LEAP_MIN_DIST
        local rider = inst.replica.rider
		local isHeavyLifting = inst.replica.inventory:IsHeavyLifting()
		local leapExpert = inst:HasTag("mighty_leap_expert")
		if TheWorld:HasTag("cave") and not TheWorld.Map:IsVisualGroundAtPoint(pos.x, pos.y, pos.z) then
			return {} --prevent void leaping
		end
        if rider == nil or not rider:IsRiding() and not tooClose and not (isHeavyLifting and not leapExpert) and not (platform ~= nil and platform == targetPlatform) then
            return { ACTIONS.MIGHTYJUMP }
        end
    end
    return {}
end

local function OnSetOwner(inst)
	if not inst:HasTag("ingym") and inst.components.playeractionpicker ~= nil then
		if inst.components.playeractionpicker.pointspecialactionsfn ~= nil and inst._OldPointSpecialActions == nil then
			inst._OldPointSpecialActions = inst.components.playeractionpicker.pointspecialactionsfn
		elseif inst.components.playeractionpicker.pointspecialactionsfn == nil and inst._OldPointSpecialActions ~= nil then
			inst.components.playeractionpicker.pointspecialactionsfn = inst._OldPointSpecialActions
		elseif inst.components.playeractionpicker.pointspecialactionsfn == nil and inst._OldPointSpecialActions == nil then
			inst.components.playeractionpicker.pointspecialactionsfn = GetPointSpecialActions
		end
		inst._Old_UM_pointspecialactionsfn = GetPointSpecialActions
    end
end

local function getFishingBonus(inst, data)
	if data ~= nil and inst:HasTag("lunar_mighty") and inst:HasTag("mightiness_mighty") then
		if math.random() >= TUNING.LUNAR_MIGHTY_FISHING_CATCH_GOLD_CHANCE then
			local gold = SpawnPrefab("goldnugget")
			inst.components.inventory:GiveItem(gold)
		end
		if math.random() >= TUNING.LUNAR_MIGHTY_FISHING_CATCH_EXTRA_FISH_CHANCE then
			local fish = SpawnPrefab(data.fish.prefab.."_inv")
			inst.components.inventory:GiveItem(fish)
		end
	end
end

local function UnpauseMightiness(inst, data)
	if data ~= nil and data.item ~= nil and data.item:HasTag("heavy") then
		inst:DoTaskInTime(0.1, function(inst) inst.components.mightiness:Resume() end)
	end
end

local function SpecialWorkMultiplierFn(inst, action, target, tool, numworks, recoil)

	if not recoil and numworks ~= 0 and not inst.components.mightiness:IsWimpy() then
		local basecost = 
			(inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_expert") and TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_EXPERT) or
			(inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_4") and TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_4) or
			(inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_3") and TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_3) or
			(inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_2") and TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_2) or
			(inst.components.skilltreeupdater:IsActivated("wolfgang_critwork_1") and TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST_1)	or
			TUNING.SKILLS.WOLFGANG_MIGHTY_WORK_COST
			
		local mightiness = inst.components.mightiness:GetCurrent()
		local hunger = inst.components.hunger:GetPercent() * TUNING.WOLFGANG_HUNGER
		local workleft = target.components.hackable and target.components.hackable:GetHacksLeft() or target.components.workable:GetWorkLeft()
		local work_action = target.components.hackable and ACTIONS.HACK or target.components.workable:GetWorkAction()
		local work_type_mult = TUNING.WOLFGANG_MIGHTY_WORK_COST_MULT[work_action.id]
		local cost = (basecost * workleft * work_type_mult) / numworks
		local golden = string.match(tool.prefab, "golden*")
		local uses = workleft/numworks
		local tough = target.components.workable ~= nil and target.components.workable.tough
		local tooltough = tool.components.tool ~= nil and tool.components.tool:CanDoToughWork()
		local canmightyhunger = inst:HasTag("mighty_hunger") and inst:HasTag("mightiness_mighty") and hunger >= ((mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO)
		
		if golden then
			uses = uses / TUNING.GOLDENTOOLFACTOR
		end
		
		if tough and not tooltough then
			uses = uses * TUNING.HARD_MATERIAL_MULT
			cost = cost * 2
		end
		
		if workleft <= numworks then
			return
		end
		
		if mightiness >= cost or canmightyhunger then
            if inst.player_classified ~= nil then
                inst.player_classified.playworkcritsound:push()
            end
			inst.components.mightiness:DoDelta(-cost)
			if mightiness < cost then
				inst.components.hunger:DoDelta((mightiness - cost)/TUNING.LUNAR_MIGHTY_HUNGER_TO_MIGHTINESS_RATIO)
			end
			tool.components.finiteuses:Use(uses)
			if inst:HasTag("shadow_strikes") then
				IncreaseCombo(inst, 1)
			end
			return 99999
		end
	end
end

local function OnDoingHackHelper(inst, data)
	if data ~= nil and data.hack_target ~= nil then
		local target = data.hack_target
		local tool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		local result = SpecialWorkMultiplierFn(inst, ACTIONS.HACK, target, tool, 1, false)
		if (result == 99999) then
			target.components.hackable.hacksleft = 0
		end
	end
end

local function OnPickup(inst, data)
	local thing = data.item
	if inst:HasTag("mighty_hunger") then
		if thing ~= nil and thing.prefab == "cursed_monkey_token" then
			inst.components.cursable:RemoveCurse("MONKEY", 9)
			inst:DoTaskInTime(2.5, function(inst)
				inst.components.talker:Say(GetString(inst, "ANNOUNCE_IGNOREDTRINKETCURSE"))
			end)
		end
	end
end

env.AddPrefabPostInit("wolfgang", function(inst)
	
	inst:ListenForEvent("hungerdelta", OnSetOwner)
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst.components.workmultiplier:SetSpecialMultiplierFn(SpecialWorkMultiplierFn)
	
	inst.IncreaseCombo = IncreaseCombo
	
	inst:AddComponent("featsofstrength")
	
	inst:ListenForEvent("mightiness_statechange", ToughWorker)
	inst:ListenForEvent("equip", ToughWorker)
	
	inst:ListenForEvent("equip", UnpauseMightiness)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onhitother", OnHitOther)
	
	inst:ListenForEvent("timerdone", ComboTimerOver)
	
	inst:ListenForEvent("fishcaught", getFishingBonus)
	
	inst:ListenForEvent("working", OnDoingHackHelper)

	inst:ListenForEvent("itemget", OnPickup)
	
	if inst.components.drownable ~= nil then
		inst.components.drownable:SetCustomTuningsFn(GetDowningDamgeTunings)
		inst.components.drownable.shoulddropitemsfn = ShouldDropItems
		inst.components.drownable.fallback_rescuefn = IARescue
	end
end)