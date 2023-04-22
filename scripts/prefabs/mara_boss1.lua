local assets = {
	Asset("ANIM", "anim/mara_boss1.zip"),
	
	Asset("SOUNDPACKAGE", "sound/stmpwyfs.fev"),
	Asset("SOUND", "sound/stmpwyfs.fsb")
}


-- No brain because skeletons don't have brains duh idiot.

-- Movement here.
local function SansDans(inst)
	local nextvictim = FindClosestEntity(inst, 85, true, {"_health"}, { "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	if nextvictim ~= nil and math.random() > 0.35 then
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
		inst:DoTaskInTime(math.random() * 0.1 + 0.2, SansDans)
	end
end

-- 'Attack' spawning happens here.
local function BoneZone(inst)	
	local function BoneProjectile(inst)
		local bulletspawn = SpawnPrefab("mara_boss1_bullets")
		if bulletspawn ~= nil then
			bulletspawn.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local anythingwithafuckinghealthbar = TheSim:FindEntities(x, y, z, 50, {"_health"}, { "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	if #anythingwithafuckinghealthbar ~= nil and #anythingwithafuckinghealthbar > 0 then
		--if math.random() > 0.01 then
			inst:DoPeriodicTask(2, BoneProjectile, nil, #anythingwithafuckinghealthbar)
		--else
			-- print ("SSSAAAAAN: IMA FIRIN MAH")
			-- codegoesherelol codegoesherelol codegoesherelol
			-- Gaster Blaster makes a good graphical beam stretching test. Also test for dealing damage in a line.
			-- Needed for Moonseer phase 2 dash attack; I'll have to do most of the work for this anyway, might as well.
			-- Like...literally the same graphic can be used for this, that, and the Discord Light Theme attack.
			-- make the blaster a crappy moonseer phase 1 head
		--end
	end
	
	inst:DoTaskInTime(math.random() * 0.6 + 0.6, BoneZone)
end

local function SoundsThatMightPlayWhenYouFightSans(inst)
	inst.SoundEmitter:KillSound("mara_boss1_stmpwyfs")
	inst.SoundEmitter:PlaySound("stmpwyfs/stmpwyfs/stmpwyfs", "mara_boss1_stmpwyfs")
	inst.SoundEmitter:SetVolume("mara_boss1_stmpwyfs", 0.85)
	-- If I can make this sound prevent music from playing in a friendly way, I'll have one potential basis for progressive boss music...

	inst:DoTaskInTime(math.random() * 0.6 + 0.3, SoundsThatMightPlayWhenYouFightSans)
end

local function AwakeFromThySlumber(inst)
	inst.AnimState:PlayAnimation("loop", true)
	inst:DoTaskInTime(0, SansDans)
	inst:DoTaskInTime(0, BoneZone)
	inst:DoTaskInTime(0, SoundsThatMightPlayWhenYouFightSans)
end

-- When spawned/loaded, have him stand there...menacingly.
local function Arise(inst)
	inst.AnimState:PlayAnimation("idle")
	-- Pass a few seconds, enough time to take in the mistake. Then...begin.
	inst:DoTaskInTime(3, AwakeFromThySlumber)
end


local function fn()
	local inst = CreateEntity()
	
	-- Core components
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, .5)
	RemovePhysicsColliders(inst)
	inst:AddTag("NOBLOCK")
	
	inst.AnimState:SetBank("mara_boss1")
	inst.AnimState:SetBuild("mara_boss1")
	inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = ((30 * math.random()) + 15)
	inst.components.locomotor.runspeed = ((30 * math.random()) + 15)
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }
	
	inst:AddComponent("inspectable")
	
	inst:DoTaskInTime(0, Arise)
	
	return inst
end

return Prefab("mara_boss1", fn, assets, prefabs)
