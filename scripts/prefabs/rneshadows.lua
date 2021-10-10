local assets =
{
    Asset("ANIM", "anim/rnesushadow.zip"),
    Asset("ANIM", "anim/boat_death_shadows.zip"),
    Asset("ANIM", "anim/rnegrabby.zip"),
}

local prefabs =
{
    --"collapse_small",
    --"nightlight_flame",
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    idle = "dontstarve/sanity/creature2/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local function Teleport(inst)
	local max_tries = 5
	for k = 1, max_tries do
		local x, y, z = inst.Transform:GetWorldPosition()
		local radialoffset = 30
		x = x + math.random(2 * radialoffset) - radialoffset
		z = z + math.random(2 * radialoffset) - radialoffset
		
		local function IsValidSinkholePosition(offset)
			for dx = -1, 1 do
				for dz = -1, 1 do
					if TheSim:GetLightAtPoint(x + dx * 5, 0, z + dz * 5) > 0 then
						return false
					end
				end
			end
			return true
		end
		
		local offset = Vector3(0, 0, 0)
		offset =
			IsValidSinkholePosition(offset) and offset
		
		if offset ~= nil and TheWorld.Map:IsPassableAtPoint(x, y, z) and TheSim:GetLightAtPoint(x, y, z) < 0.05 then
			inst.Physics:Teleport(x, y, z)
			break
		end
	end
end

local RETARGET_CAN_TAGS = { "player" }
local RETARGET_CANT_TAGS = { "INLIMBO", "playerghost" }

local function retargetfn(inst)
    return FindEntity(
                inst,
                30,
                function(guy)
                    return inst.components.combat:CanTarget(guy) and guy.LightWatcher:IsInLight()
                end,
                RETARGET_CAN_TAGS,
                RETARGET_CANT_TAGS
            )
        or nil
end

local function KeepTarget(inst, target)
    return target ~= nil and target.LightWatcher:IsInLight()
end
  
local function StopGrabbing(inst)
	if inst.grabtask ~= nil then
		inst.grabtask:Cancel()
	end
	
	inst.grabtask = nil
end

local function Grab(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 1, RETARGET_CAN_TAGS, RETARGET_CANT_TAGS)
	
	for i, v in ipairs(ents) do
		if v.LightWatcher:IsInLight() and not v.sg:HasStateTag("gotgrabbed") then
			v.Physics:Stop()
			v.sg:GoToState("grabby_teleport")
			v:DoTaskInTime(62 * FRAMES, Teleport)
			SpawnPrefab("rnesus_grab").Transform:SetPosition(v.Transform:GetWorldPosition())
			inst.sg:GoToState("run_stop")
		end
	end
end

local function StartGrabbing(inst)
	if inst.grabtask == nil then
		inst.grabtask = inst:DoPeriodicTask(0.1, Grab)
	end
end

local function grabfn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst, 10, .5)
    RemovePhysicsColliders(inst)
	
    inst:AddTag("NOCLICK")
    inst:AddTag("shadow")
	
	inst.AnimState:SetBank("shadow_wavey_jones_hand")
	inst.AnimState:SetBuild("shadow_wavey_jones_hand")
	inst.AnimState:PlayAnimation("hand_in")
    inst.AnimState:SetMultColour(1, 1, 1, .6)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	--inst:DoTaskInTime(10, inst.Remove)
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_TINY
	
    inst:AddComponent("combat")
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
    inst.persists = false
	inst.grabtask = nil

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
    inst.sounds = sounds 
	
    inst:SetStateGraph("SGsushadow")
	
	inst.StartGrabbing = StartGrabbing
	inst.StopGrabbing = StopGrabbing

	return inst
end

local function grab_largefn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst:AddTag("fx")
	
	inst.AnimState:SetBank("wanda_time_fx")
	inst.AnimState:SetBuild("rne_grabbylarge")
	inst.AnimState:PlayAnimation("younger_top")
    inst.AnimState:SetFinalOffset(1)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:DoTaskInTime(10, inst.Remove)
	
	inst.persists = false

	return inst
end

local function Disappear_mini(inst)
	inst.components.sizetweener:StartTween(0.05, 0.2, inst.Remove)
end

local function shrink_mini(inst)
	inst.components.sizetweener:StartTween(0.2, 1, Disappear_mini)
end

local function shrinktask_mini(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 5, {"player"})
	
	for i, v in ipairs(ents) do
		v.Physics:Stop()
		v.sg:GoToState("changeoutsidewardrobe")
		v:DoTaskInTime(62 * FRAMES, Teleport)
	end
	
	inst:DoTaskInTime(62 * FRAMES, shrink_mini)
end

local function GrabSomeone(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local grabby = SpawnPrefab("rnesus_grab")
	grabby.Transform:SetPosition(x, y, z)
end
		
local function grow_mini(inst, time, startsize, endsize)
	inst:DoTaskInTime(62 * FRAMES, GrabSomeone)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(2, 62 * FRAMES, shrinktask_mini)
end

local function susfn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst:AddTag("fx")
	
	inst.AnimState:SetBank("rnesushadow")
	inst.AnimState:SetBuild("rnesushadow")
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(1, 1, 1, .9)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("sizetweener")
	inst.grow_mini = grow_mini
	inst:grow_mini()
	--inst:DoPeriodicTask(0.2, spawnfx)
	
    inst.persists = false

	return inst
end

return Prefab("rne_grabbyshadows", grabfn, assets, prefabs),
		Prefab("rnesus_grab", grab_largefn, assets, prefabs),
		Prefab("rnesushadow", susfn, assets, prefabs)