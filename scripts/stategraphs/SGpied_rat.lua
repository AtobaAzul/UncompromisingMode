require("stategraphs/commonstates")

local actionhandlers = 
{
}


local events=
{
    CommonHandlers.OnLocomote(false,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
	EventHandler("doattack", function(inst, data) 
		if not inst.components.health:IsDead() and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then 
			if data.target:IsValid() and inst:IsNear(data.target, 3) then
				inst.sg:GoToState("attack", data.target)
			elseif data.target:IsValid() then
				inst.sg:GoToState("playattack", data.target) 
			end
		end 
	end),
    EventHandler("locomote", function(inst) 
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if not inst.sg:HasStateTag("attack") and is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("moving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),    
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit")
        end
    end),
    CommonHandlers.OnDeath(), 
}

local function SpawnRat(inst)
	local num = inst:NumHoundsToSpawn()
	local pt = inst:GetPosition()
	for i = 1, num do
		local x, y, z = inst.Transform:GetWorldPosition()
			
		local rat = SpawnPrefab("uncompromising_rat")
		rat.Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
		rat.components.follower:SetLeader(inst)
	end
end

local function GatherFollowers(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local ents = TheSim:FindEntities(x, y, z, TUNING.DSTU.PIEDPIPER_TOOT_RANGE, { "raidrat", "hostile" })
    
	for i, v in ipairs(ents) do
        if v.prefab == "uncompromising_rat" and v.components.follower ~= nil then
			v.components.follower:SetLeader(inst)
			
			if v.components.combat.target ~= nil and v.components.combat.target == inst then
				v.components.combat:GiveUp()
			end
			
			if inst.components.combat.target ~= nil and inst.components.combat.target == v then
				inst.components.combat:GiveUp()
			end
        end
    end
end

local function DoBuff(inst, number)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.DSTU.PIEDPIPER_TOOT_RANGE, { "raidrat" })
	
	for i, v in ipairs(ents) do
        if v.prefab == "uncompromising_rat" and v.note == nil then
			v:PiedPiperBuff(8)
			
			if v.components.combat.target ~= nil and v.components.combat.target == inst then
				v.components.combat:GiveUp()
			end
			
			if inst.components.combat.target ~= nil and inst.components.combat.target == v then
				inst.components.combat:GiveUp()
			end

			break
        end
    end
end

local states=
{
	State {
		name = "idle",
		tags = { "idle", "canrotate" },
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop", true)
		end,

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State {
		name = "toot",
		tags = { "attack", "busy" },
		onenter = function(inst, count)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("play")
            inst.sg.statemem.count = count
			
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/toot")
			
			GatherFollowers(inst)
		end,

		timeline =
		{
			TimeEvent(0.5, function(inst)
				DoBuff(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(1, function(inst)
				DoBuff(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(1.5, function(inst)
				DoBuff(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(2, function(inst)
				
				DoBuff(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(2.5, function(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(2.75, function(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(3, function(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(3.25, function(inst)
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
			TimeEvent(3.5, function(inst)
                if inst.sg.statemem.count == nil then
                    SpawnRat(inst)
                end
				
				DoBuff(inst)
				
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				
				inst.sg:GoToState("idle")
			end),
		},
	},

    State{
        name = "hit",
        tags = { "hit", "busy" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/hurt")
        end,

        events =
        {
            EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
            end),
        },
	},

	State{
		name = "playattack",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("playatk")
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/toot")
		end,

		timeline =
		{
			TimeEvent(10 * FRAMES, function(inst)
				for i = 1, 3 do
					DoBuff(inst)
				end
				
				inst.SoundEmitter:PlaySound("UCSounds/piedpiper/play")
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "attack",
		tags = { "attack", "busy" },

		onenter = function(inst)
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/attack")
		end,

		timeline =
		{
			TimeEvent(18 * FRAMES, function(inst)
			
			
				local target = inst.components.combat.target
                
				if target ~= nil then
					local range = 4
					local physrange = target ~= nil and target:GetPhysicsRadius(0) + range or 0
					local finalrange = physrange * physrange
					if distsq(target:GetPosition(), inst:GetPosition()) <= finalrange then
						target:PushEvent("attacked", { attacker = inst, damage = 5 })
					
						if target ~= nil and target.components.inventory ~= nil and not target:HasTag("fat_gang") and not target:HasTag("foodknockbackimmune") and not (target.components.rider ~= nil and target.components.rider:IsRiding()) and 
						--Don't knockback if you wear marble
						(target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
							target:PushEvent("knockback", {knocker = inst, radius = 8 * inst.components.combat.defaultdamage, strengthmult = 1.25})
						end
					end
				end
			
			
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},

		events =
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk", true)
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/run")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("moving")
            end),
        },
    },
	
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            
            RemovePhysicsColliders(inst)
            inst.persists = false
			
            inst.SoundEmitter:PlaySound("UCSounds/piedpiper/death")
        end,
    }, 
}

CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
})

--[[
CommonStates.AddCombatStates(states,
{
    hittimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.hit) end),
    },
    deathtimeline = 
    {
        --TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.death) end),
    },
})
]]
CommonStates.AddIdle(states)
CommonStates.AddFrozenStates(states)

    
return StateGraph("pied_rat", states, events, "idle", actionhandlers)