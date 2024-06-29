local prefabs = {
	"mara_boss1_bullets"
}


-- No brain because skeletons don't have brains duh idiot.

-- Movement here.
local function SansDans(inst)
	local nextvictim = FindClosestEntity(inst, 85, true, { "_health" }, { "sans", "plant", "blocker", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	local function Moveit(inst)
		if nextvictim ~= nil and nextvictim.components.health ~= nil and math.random() > 0.35 then
			--print ("SSSAAAAAN: I am rapidly approaching your location.")
			inst.components.locomotor:GoToPoint(Vector3(nextvictim.Transform:GetWorldPosition()), nil, true)
			inst.components.locomotor:RunForward()
			inst:DoTaskInTime(0.05, SansDans)
		-- More potential movement patterns:
		-- Find target location, double the distance, and apply a sine pattern to path there (randomize sine severity).
		-- Quarter-circular motion that maintains current distance from the target.
		else
			--print ("SSSAAAAAN: Obama OUT")
			inst.components.locomotor:RunInDirection(math.random() * 359)
			inst.components.locomotor:RunForward()
		end
	end
	
	
	-- Cheap time tracking.
	if inst.taskcountmove ~= nil then
		inst.taskcountmove = (inst.taskcountmove + 1)
	else
		inst.taskcountmove = 1
	end
	
	if math.random() > 0.5 or inst.taskcountmove > 1 then
		Moveit(inst)
		inst.taskcountmove = 0
	end
end

-- 'Attack' spawning happens here.
local function BoneZone(inst)	
	local function Projectile(inst)
		local bulletspawn = SpawnPrefab("mara_boss1_bullets")
		
		--if math.random() > 0.05 then
			bulletspawn.Transform:SetPosition(inst.Transform:GetWorldPosition())
		--else
			--
			-- codegoesherelol codegoesherelol codegoesherelol
			-- Gaster Blaster makes a good graphical beam stretching test. Also test for dealing damage in a line.
			-- Needed for Moonseer phase 2 dash attack; I'll have to do most of the work for this anyway, might as well.
			-- Like...literally the same graphic can be used for this, that, and the Discord Light Theme attack.
			-- make the blaster a crappy moonseer phase 1 head
		--end
	end
	
	-- Cheap time tracking.
	if inst.taskcountprojectile ~= nil then
		inst.taskcountprojectile = (inst.taskcountprojectile + 1)
	else
		inst.taskcountprojectile = 1
	end

	if (inst.taskcountprojectile > 2 and math.random() > 0.5) or inst.taskcountprojectile > 4 then
		local x, y, z = inst.Transform:GetWorldPosition()
		-- Next line determines how many bones are spawned.
		local anythingwithafuckinghealthbar = TheSim:FindEntities(x, y, z, 50, { "_health" }, { "sans", "plant", "blocker", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
		
		if #anythingwithafuckinghealthbar ~= nil then
			for i = 1, (#anythingwithafuckinghealthbar * math.random(2, 5)) do
				inst:DoTaskInTime(0, Projectile)
			end
		end
		inst.taskcountprojectile = 0
	end
end

local function SoundsThatMightPlayWhenYouFightSans(inst)
	local function CycleSound(inst)
		inst.SoundEmitter:KillSound("mara_boss1_stmpwyfs")
		inst.SoundEmitter:PlaySound("stmpwyfs/stmpwyfs/stmpwyfs", "mara_boss1_stmpwyfs")
		inst.SoundEmitter:SetVolume("mara_boss1_stmpwyfs", 0.85)
		
		-- Kill music. TODO: Add as a cycling task to the Moonseer controller, to clear the air for progressive music.
		TheFocalPoint.SoundEmitter:KillSound("busy")
		TheFocalPoint.SoundEmitter:KillSound("danger")
	end
	
	-- Cheap time tracking.
	if inst.taskcountsound ~= nil then
		inst.taskcountsound = (inst.taskcountsound + 1)
	else
		inst.taskcountsound = 1
	end
	
	if (inst.taskcountsound > 1 and math.random() > 0.5) or inst.taskcountsound > 4 then
		CycleSound(inst)
		inst.taskcountsound = 0
	end
end


local function OnEntityWake(inst)
	if inst.SansPeriodicTask == nil then
		inst.SansPeriodicTask = inst:DoPeriodicTask(0.2, function()
			inst:DoTaskInTime(0, SansDans)
			inst:DoTaskInTime(0, BoneZone)
			inst:DoTaskInTime(0, SoundsThatMightPlayWhenYouFightSans)
		end, 3) 
	end
end

local function OnEntitySleep(inst)
	if inst.SansPeriodicTask ~= nil then
		inst.SansPeriodicTask:Cancel()
		inst.SansPeriodicTask = nil
	end
end


local function fn()
	local inst = CreateEntity()
	
	-- Core components
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, .5)
	RemovePhysicsColliders(inst)
	inst:AddTag("NOBLOCK")
	
	inst.AnimState:SetBank("mara_boss1")
	inst.AnimState:SetBuild("mara_boss1")
	inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
	inst:AddTag("scarytoprey")
	inst:AddTag("sans")
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(4)
	inst.Light:SetFalloff(0.75)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(0, 0.5, 0.9)
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 40
	inst.components.locomotor.runspeed = 40
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(1)
	inst.components.health:SetMinHealth(0.0001)
	inst.components.health:SetInvincible(true) -- REMOVE WHEN THE DROPPED ITEM IS ADDED
	
	inst:AddComponent("combat")
	
	
	-- When spawned/loaded, pass a few seconds, standing there...menacingly. Enough time to take in the mistake. Then...begin.
	inst:DoTaskInTime(3, function()
		inst.AnimState:PlayAnimation("loop", true)
	end)
	
	inst.OnEntityWake = OnEntityWake -- Should begin when spawned.
	inst.OnEntitySleep = OnEntitySleep
	
	return inst
end

return Prefab("mara_boss1", fn, nil, prefabs)
