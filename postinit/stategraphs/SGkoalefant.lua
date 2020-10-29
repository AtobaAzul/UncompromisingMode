local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("koalefant", function(inst)
local events= {
EventHandler("doattack", function(inst)
								if not inst.sg:HasStateTag("precharging") then
                                local nstate = "attack"
                                if inst.sg:HasStateTag("charging") or inst:HasTag("chargespeed") then
                                    nstate = "chargeattack"
                                end
                                if inst.components.health and not inst.components.health:IsDead()
                                   and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
                                    inst.sg:GoToState(nstate)
                                end
								end
                            end),
EventHandler("attacked", function(inst, data) 
if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("charging") then

if (math.random() > 0.75) and inst.components.combat.target ~= nil and (2 > inst:GetDistanceSqToInst(inst.components.combat.target)) then
inst.sg:GoToState("stomp") 
else
inst.sg:GoToState("hit")
end
end
end),

	}
	
	
local function DisarmTarget(inst, target)
	local item = nil
	if target and target.components.inventory then
		item = target.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	end
	if item and item.Physics then
		target.components.inventory:DropItem(item)
		local x, y, z = item:GetPosition():Get()
		y = .1
		item.Physics:Teleport(x,y,z)
		local hp = target:GetPosition()
		local pt = inst:GetPosition()
		local vel = (hp - pt):GetNormalized()
		local speed = 5 + (math.random() * 2)
		local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
		item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
	end
	inst.CanDisarm = false
end

local states = {
	State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk", false)
			if inst:HasTag("chargespeed") then
			inst.components.locomotor.runspeed = 7
			inst:RemoveTag("chargespeed")
			end
			
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)
			if inst.components.combat.target ~= nil then
			local distance = inst:GetDistanceSqToInst(inst.components.combat.target)
			local chance = math.random()
			if chance < 0.33 then
				inst.sg:GoToState("charge_start")
			else
				if chance > 0.77 then
				inst.sg:GoToState("disarm")
				else
				inst.sg:GoToState("idle")
				end
			end
			end
			end),
        },
    },
	
    State{  name = "charge_start",
            tags = {"moving", "running", "charging", "precharging", "busy", "atk_pre", "canrotate"},
            
            onenter = function(inst)
                inst.Physics:Stop()
				inst.components.locomotor:StopMoving()
				inst.components.combat:ResetCooldown()
				inst.AnimState:PlayAnimation("shake")
				inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")
				inst.components.locomotor.runspeed = 7*2.29  --should be equal to rook
				inst:AddTag("chargespeed")
            end,
            

            
            timeline=
            {
			TimeEvent(5*FRAMES, PlayFootstep),
			TimeEvent(10*FRAMES, PlayFootstep),
            },        

			events =
            {
                EventHandler("animover", function(inst) 		
				if inst.components.rideable and inst.components.rideable:GetRider() ~= nil then
				inst:ApplyBuildOverrides(inst.components.rideable:GetRider().AnimState)
				end
                inst.sg:GoToState("charge")
                inst:PushEvent("attackstart")
				if inst.components.combat ~= nil then
				inst.components.combat:ResetCooldown()
				end 
				end),
            },
        },

    State{  name = "charge",
            tags = {"moving", "charging", "busy", "running"},
            
            onenter = function(inst) 
				inst.components.combat:ResetCooldown()
                inst.components.locomotor:RunForward()
                if inst.components.combat.target and inst.components.combat.target:IsValid() then
                inst:ForceFacePoint(inst.components.combat.target:GetPosition() )
				end
                if not inst.AnimState:IsCurrentAnimation("run_loop") then
                    inst.AnimState:PlayAnimation("run_loop", true)
                end
                --inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
            end,
            timeline=
            {
		        --TimeEvent(5*FRAMES,  function(inst) inst.SoundEmitter:PlaySound(inst.effortsound) end ),
                TimeEvent(5*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
										
                                    end ),
				TimeEvent(9*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
										
                                    end ),
				TimeEvent(10*FRAMES, PlayFootstep),
				TimeEvent(14*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
										
                                    end ),
				TimeEvent(15*FRAMES, PlayFootstep),
				TimeEvent(24*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
										
                                    end ),
				TimeEvent(25*FRAMES, PlayFootstep),
				TimeEvent(29*FRAMES, function(inst)
                                        SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
										
                                    end ),
				TimeEvent(30*FRAMES, function(inst)
                    local MAXDIST = 5 

                    local distance = inst:GetDistanceSqToInst(inst.components.combat.target )
                    --print(distance)
                    if distance > MAXDIST then
                        inst.sg:GoToState("idle") 
						if inst:HasTag("chargespeed") then
						inst.components.locomotor.runspeed = 7
						inst:RemoveTag("chargespeed")
						end
                    end
									end ),
            },
            
            {   
                EventHandler("animover", function(inst) 
				inst.sg:GoToState("charge") end ),        
            },
        },
    
    State{  name = "charge_stop",
            tags = {"canrotate", "busy", "idle","charging"},
            
            onenter = function(inst) 
                --inst.SoundEmitter:KillSound("charge")
                inst.components.locomotor:Stop()
                --inst.AnimState:PlayAnimation("run_pst")
		        --inst.SoundEmitter:PlaySound(inst.effortsound)
				if inst:HasTag("chargespeed") then
					inst.components.locomotor.runspeed = 7
					inst:RemoveTag("chargespeed")
				end
				
				inst.sg:GoToState("attack")
            end,
            
            events=
            {   
                --EventHandler("animover", function(inst) inst.sg:GoToState("attack") end ),        
            },
        },    

    State{  name = "chargeattack",
            tags = {"busy", "runningattack","charging"},
            
            onenter = function(inst)
				print("chargeattack")
                --inst.SoundEmitter:KillSound("charge")
                inst.components.combat:StartAttack()
                inst.components.locomotor:StopMoving()
		        --inst.SoundEmitter:PlaySound(inst.effortsound)
                inst.AnimState:PlayAnimation("atk")
				if inst:HasTag("chargespeed") then
					inst.components.locomotor.runspeed = 7
					inst:RemoveTag("chargespeed")
				end
            end,
            
            timeline =
            {
                TimeEvent(1*FRAMES, function(inst)
                                        inst.components.combat:DoAttack()
                                     end),
            },
            
            events =
            {
                EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
            },
        },
	State{
		name = "disarm",
		tags = {"attack","busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("scare")
		end,

		timeline =
		{
			TimeEvent(2*FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")
				if inst.components.combat.target and inst.components.combat.target.ShakeCamera then
					inst.components.combat.target:ShakeCamera(CAMERASHAKE.FULL, 0.75, 0.01, 1.5, 40)
				end
			end),
			TimeEvent(2*FRAMES, function(inst) DisarmTarget(inst, inst.components.combat.target) end),
		},

		events=
		{
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
			end ),
		},

	},
	State{
        name = "stomp",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.sg.statemem.target = target
            inst.SoundEmitter:PlaySound("dontstarve/creatures/koalefant/angry")
            inst.components.combat:StartAttack()
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("surprise", false)
			if inst:HasTag("chargespeed") then
			inst.components.locomotor.runspeed = 7
			inst:RemoveTag("chargespeed")
			end
			local function isplayer(ent)
			if ent ~= nil and ent:HasTag("player") then-- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
			end
			inst.components.combat:SetAreaDamage(1, 1, isplayer)
			
        end,

        timeline=
        {
            TimeEvent(30*FRAMES, function(inst) 
			
			inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events=
        {
            EventHandler("animqueueover", function(inst)
			local function isplayer(ent)
			if ent ~= nil and ent:HasTag("player") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
			end
			inst.components.combat:ResetCooldown()
			inst.components.combat:SetAreaDamage(0,0,isplayer)
			inst.sg:GoToState("idle")
			end),
        },
    },
}

for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end
end)

