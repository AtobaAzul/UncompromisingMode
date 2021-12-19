local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddStategraphPostInit("rook", function(inst)

local function GetDebrisFn()
	return "minotaur_boulder", 0
end

local HEAVY_WORK_ACTIONS =
{
    CHOP = true,
    DIG = true,
    HAMMER = true,
    MINE = true,
}
--[[
local function BreakDebris(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    debris:PushEvent("stopfalling")
end--]]

local function UpdateShadowSize(shadow, height)
    local scaleFactor = Lerp(.5, 1.5, height / 25)
    shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
end

local function OnRemoveDebris(debris)
    debris.shadow:Remove()
end

local function GroundDetectionUpdate(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .2 then
        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        elseif TheWorld.Map:IsPointNearHole(Vector3(x, 0, z)) then
		local xremove, yremove, zremove = debris.Transform:GetWorldPosition()
		SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(xremove, 0, zremove)
		debris:Remove()
        else
            --PlayFallingSound(debris)

            -- break stuff we land on
            -- NOTE: re-check validity as we iterate, since we're invalidating stuff as we go
            local softbounce = false
            if debris:HasTag("heavy") then
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, nil, "structure")
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        --NOTE: "smashable" excluded for now
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.workable ~= nil then
                            if v.sg == nil or not v.sg:HasStateTag("busy") then
                                local work_action = v.components.workable:GetWorkAction()
                                --V2C: nil action for NPC_workable (e.g. campfires)
                                if (    (work_action == nil and v:HasTag("NPC_workable")) or
                                        (work_action ~= nil and HEAVY_WORK_ACTIONS[work_action.id]) ) and
                                    (work_action ~= ACTIONS.DIG
                                    or (v.components.spawner == nil and
                                        v.components.childspawner == nil)) then
                                    v.components.workable:Destroy(debris)
                                end
                            end
                        elseif v.components.combat ~= nil then
                            v.components.combat:GetAttacked(debris, 30, nil)
                        elseif v.components.inventoryitem ~= nil then
                            if v.components.mine ~= nil then
                                v.components.mine:Deactivate()
                            end
                            Launch(v, debris, TUNING.LAUNCH_SPEED_SMALL)
                        end
                    end
                end
            else
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        --NOTE: "smashable" excluded for now
                        if v:HasTag("quakedebris") then
                            local vx, vy, vz = v.Transform:GetWorldPosition()
                            SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(vx, 0, vz)
                            v:Remove()
                        elseif v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall")) then
                            v.components.combat:GetAttacked(debris, 20, nil)
                        end
                    end
                end
            end

            debris.Physics:SetDamping(.9)

            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(
                    speed * math.cos(angle),
                    speed * 2.3,
                    speed * math.sin(angle)
                )
            end

            debris.shadow:Remove()
            debris.shadow = nil

            debris.updatetask:Cancel()
            debris.updatetask = nil

            local density = 1 or DENSITYRADIUS
            if density <= 0 or
                debris.prefab == "mole" or
                debris.prefab == "rabbit" or
                not (math.random() < .75 or
                    --NOTE: There will always be at least one found within DENSITYRADIUS, ourself!
                    #TheSim:FindEntities(x, 0, y, density, nil, { "quakedebris" }, { "INLIMBO" }) > 1
                ) then
                --keep it
                debris.persists = true
                debris.entity:SetCanSleep(true)
                if debris._restorepickup then
                    debris._restorepickup = nil
                    if debris.components.inventoryitem ~= nil then
                        debris.components.inventoryitem.canbepickedup = true
                    end
                end
                debris:PushEvent("stopfalling")
            else
                --we missed detecting our first bounce, so break immediately this time
                
                debris:PushEvent("stopfalling")
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
        UpdateShadowSize(debris.shadow, y)
    elseif debris:IsInLimbo() then
        --failsafe, but maybe we got trapped or picked up somehow, so keep it
        debris.persists = true
        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
    elseif debris.prefab == "mole" or debris.prefab == "rabbit" then
        --failsafe
        debris:PushEvent("detachchild")
        debris:Remove()
    else
        --failsafe
                debris:PushEvent("stopfalling")
    end
end

local function fallingpianogag(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local target1 = TheSim:FindEntities(x, y, z, 50, nil, { "playerghost" }, { "player" })
	
			--if target ~= nil then
	if #target1 > 0 then
	local target2 = inst:GetNearestPlayer(true)
		if target2 ~= nil then
		local x, y, z = target2.Transform:GetWorldPosition()

		local debris = SpawnPrefab("minotaur_boulder")
		
			if debris ~= nil then
				debris.entity:SetCanSleep(false)
				debris.persists = false
				
				local xrandom = x + math.random(-5, 5)
				local zrandom = z + math.random(-5, 5)
						
				SpawnPrefab("cavein_debris").Transform:SetPosition(xrandom, 0, zrandom)
						
				debris.shadow = SpawnPrefab("warningshadow")
				debris.shadow:ListenForEvent("onremove", OnRemoveDebris, debris)
				debris.shadow.Transform:SetPosition(xrandom, 0, zrandom)
				debris.shadow.Transform:SetScale(2.75, 2.75, 2.75)
				UpdateShadowSize(debris.shadow, 25)
						
				debris.Physics:Teleport(xrandom, 25, zrandom)
				debris.updatetask = debris:DoPeriodicTask(FRAMES, GroundDetectionUpdate, nil, 1)
				debris:PushEvent("startfalling")
			end
		end
	end
end

local function giantfallingpianogag(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local target1 = TheSim:FindEntities(x, y, z, 50, nil, { "playerghost" }, { "player" })
	
			--if target ~= nil then
	if #target1 > 0 then
	
		local target2 = inst:GetNearestPlayer(true)
	
		if target2 ~= nil then
			local x, y, z = target2.Transform:GetWorldPosition()

			local debris = SpawnPrefab("minotaur_boulder_big")
			
			if debris ~= nil then
				debris.entity:SetCanSleep(false)
				debris.persists = false
				
				local xrandom = x + math.random(-5, 5)
				local zrandom = z + math.random(-5, 5)
				
				SpawnPrefab("cavein_debris").Transform:SetPosition(xrandom, 0, zrandom)
						
				debris.shadow = SpawnPrefab("warningshadow")
				debris.shadow:ListenForEvent("onremove", OnRemoveDebris, debris)
				debris.shadow.Transform:SetPosition(xrandom, 0, zrandom)
				debris.shadow.Transform:SetScale(3.5, 3.5, 3.5)
				UpdateShadowSize(debris.shadow, 35)
						
				debris.Physics:Teleport(xrandom, 35, zrandom)
				debris.updatetask = debris:DoPeriodicTask(FRAMES, GroundDetectionUpdate, nil, 1)
				debris:PushEvent("startfalling")
			end
		end
	end
end

local _OldLocomoteEvent = inst.events["locomote"].fn
	inst.events["locomote"].fn = function(inst, data)
        if inst:HasTag("minotaur") then
			if inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("runningattack") then
				return
			end

			local is_moving = inst.sg:HasStateTag("moving")
			local is_running = inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack")
			local should_move = inst.components.locomotor:WantsToMoveForward()
			local should_run = inst.components.locomotor:WantsToRun()

			if is_moving and not should_move then
				inst.sg:GoToState(is_running and "run_stop" or "walk_stop")
			elseif (not is_moving and should_move) or (is_moving and should_move and is_running ~= should_run) then
				if inst.jumpready == true then
					inst.sg:GoToState("leap_attack_pre", data.target)
				else
					inst.sg:GoToState(should_run and "run_start" or "walk_start")
				end
			end
		else
			_OldLocomoteEvent(inst, data)
        end
    end
	--[[
local events=
{
    EventHandler("locomote", function(inst,data)
        if inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("attack") or inst.sg:HasStateTag("runningattack") then
            return
        end

        local is_moving = inst.sg:HasStateTag("moving")
        local is_running = inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack")
        local should_move = inst.components.locomotor:WantsToMoveForward()
        local should_run = inst.components.locomotor:WantsToRun()

        if is_moving and not should_move then
            inst.sg:GoToState(is_running and "run_stop" or "walk_stop")
        elseif (not is_moving and should_move) or (is_moving and should_move and is_running ~= should_run) then
            if inst.jumpready == true then
				inst.sg:GoToState("leap_attack_pre", data.target)
			else
				inst.sg:GoToState(should_run and "run_start" or "walk_start")
			end
        end
    end),
}
]]
local states = {

    State{

        name = "leap_attack_pre",
        tags = {"busy", "moving", "canrotate", "hopping", "nointerrupt"},
        
        onenter = function(inst, target)
		
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/voice")
            inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
            
			inst.components.combat:SetRange(9, 12)
			inst.AnimState:PlayAnimation("taunt")

        end,
		
		timeline =
        {
            
            TimeEvent(35 * FRAMES, function(inst)
						inst:DoTaskInTime(20, function(inst) 
						inst.jumpready = true
						end)
                
			inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk_loop")
            end),
			
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack") ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40) end),
        },
    },
	
	State{

        name = "leap_attack",
        tags = {"busy", "moving", "canrotate", "hopping", "nointerrupt"},
        
        onenter = function(inst, target)
		

		inst.components.groundpounder:GroundPound()
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)

		inst.components.locomotor:WalkForward()
		inst.AnimState:PlayAnimation("walk_loop")
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "player" })
		
		if ents ~= nil then
			fallingpianogag(inst)
		end
		
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack2") ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40) end),
        },
    },
	
	State{

        name = "leap_attack2",
        tags = {"busy", "moving", "canrotate", "hopping", "nointerrupt"},
        
        onenter = function(inst, target)
		
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
				
			inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk_loop")
			
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "player" })
		
		if ents ~= nil then
			fallingpianogag(inst)
		end
			
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("leap_attack_pst") ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40) end),
        },
    },
	
	State{

        name = "leap_attack_pst",
        tags = {"busy", "moving", "canrotate", "hopping", "nointerrupt"},
        
        onenter = function(inst, target)
		
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
			ShakeAllCameras(CAMERASHAKE.FULL, .35, .02, 1, inst, 40)
			inst.jumpready = false
			
			inst.components.locomotor:WalkForward()
			inst.AnimState:PlayAnimation("walk_loop")
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "player" })
		
		if ents ~= nil then
			fallingpianogag(inst)
		end
		end,
		
        onexit = function(inst)
			inst.components.combat:SetRange(3, 4)
        end,
			

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") 
			ShakeAllCameras(CAMERASHAKE.FULL, 1, .02, 1, inst, 40)
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound",nil,.5)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 50, { "player" })
		local ents2 = TheSim:FindEntities(x, y, z, 50, { "megaboulder" })
		
		if ents ~= nil then
			if ents2 ~= nil then
				if #ents2 == 0 and math.random() < 0.5 then
					giantfallingpianogag(inst)
				else
					fallingpianogag(inst)
				end
			else
				fallingpianogag(inst)
			end
		end
			
			end),
        },
    },
	
	State{
        name = "AGStun",
        tags = { "busy", "sleeping", "nowake" },

        onenter = function(inst)
            if inst.components.locomotor ~= nil then
                inst.components.locomotor:StopMoving()
            end
			
			if inst.components.freezable then
				inst.components.freezable:Unfreeze()
			end
			
            inst.AnimState:PlayAnimation("rhinostun_pre")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("AGStunned") end),
        },
    },

    State{
        name = "AGStunned",
        tags = { "busy", "sleeping" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("rhinostun_loop")
			
			if inst.components.freezable then
				inst.components.freezable:Unfreeze()
			end
			
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("AGStunned") end),
        },
    },

    State{
        name = "AGStunwake",
        tags = { "busy", "waking", "nosleep" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("rhinostun_post")
			
			if inst.components.freezable then
				inst.components.freezable:Unfreeze()
			end
			
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
	}
}

--[[for k, v in pairs(events) do
    assert(v:is_a(EventHandler), "Non-event added in mod events table!")
    inst.events[v.name] = v
end]]

for k, v in pairs(states) do
    assert(v:is_a(State), "Non-state added in mod state table!")
    inst.states[v.name] = v
end

end)

