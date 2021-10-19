require "stategraphs/SGmindweaver"

--local brain = require "brains/swilsonbrain"
local assets =
{
    Asset("ANIM", "anim/mindweaver.zip"),
}

local prefabs =
{
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    --idle = "dontstarve/sanity/creature2/idle",
    idle = "dontstarve/sanity/creature1/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require "brains/fuelseekerbrain"

local function Init(inst)
	local fx = SpawnPrefab("fuelseeker_darkfire")
	fx.entity:SetParent(inst.entity)
	fx.entity:AddFollower()
	fx.Follower:FollowSymbol(inst.GUID, "p3_moon_base", 0, 0, 0)
	
	inst.fire = fx
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

	MakeCharacterPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)

	--inst.Transform:SetFourFaced()
	inst:AddTag("monster")
    inst:AddTag("hostile")   
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("fuelseeker")
    inst.AnimState:SetBuild("fuelseeker")
    inst.AnimState:PlayAnimation("appear")
	
	inst.Transform:SetScale(0.44, 0.44, 0.44)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6
	
    inst:AddComponent("follower")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('shadow_creature')
	
    inst:AddComponent("combat")
	
    inst.sounds = sounds 
	inst.cooldown = false
	
    inst:SetStateGraph("SGfuelseeker")
    inst:SetBrain(brain)
	
	inst:WatchWorldState("isday", function() 
		inst:Remove()
	end)
	
	inst:DoTaskInTime(0, Init)

    return inst
end

local function circlefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("sporecloud")
    inst.AnimState:SetBuild("sporecloud")
	inst.AnimState:SetMultColour(0, 0, 0, 1)
	inst.Transform:SetScale(.44, .44, .44)

    inst.AnimState:PlayAnimation("sporecloud_pst")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local function LevelUp(inst)
	inst.level = inst.level + 0.2
	inst.SoundEmitter:SetParameter("shadowfire", "intensity", inst.level / 3)
	inst.Transform:SetScale(inst.level / 2, inst.level / 2, inst.level / 2)
end

local function Reset(inst)
	inst.level = 0
	inst.SoundEmitter:SetParameter("shadowfire", "intensity", inst.level / 3)
	inst.Transform:SetScale(inst.level / 2, inst.level / 2, inst.level / 2)
end

local function darkfirefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("fire")
    inst.AnimState:SetBuild("fire")
    inst.AnimState:PlayAnimation("level4", true)
	inst.AnimState:SetMultColour(0, 0, 0, 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/nightlight", "shadowfire")
	
	inst.level = 0
	inst.Transform:SetScale(inst.level / 2, inst.level / 2, inst.level / 2)
	
	inst.LevelUp = LevelUp
	inst.Reset = Reset

    inst.persists = false

    return inst
end

return Prefab( "fuelseeker", fn, assets, prefabs),
		Prefab( "fuelseeker_circle", circlefn, assets, prefabs),
		Prefab( "fuelseeker_darkfire", darkfirefn, assets, prefabs)