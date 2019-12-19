local assets =
{
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_basic_transformation.zip"),
}

local prefabs =
{
    "moonspiderden",
}

local function SpawnMutatedHound(inst)
	inst:DoTaskInTime(0, function(inst)
	local hound = SpawnPrefab("moonspiderden")
	hound.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
	inst:RemoveComponent("inspectable")
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst.persists = false
	inst:DoTaskInTime(0, inst.Remove)
end

local function play_punch( inst)
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/mutated_hound/punch")
end
local function play_body_fall(inst)
    inst.SoundEmitter:PlaySound("dontstarve/movement/body_fall")
end

local function StartReviving(inst)

    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/mutated_hound/mutate")

	
	local mete = SpawnPrefab("shadowmeteor")
	mete.Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst.spawn_task = inst:DoTaskInTime(2, SpawnMutatedHound)
end

local function ontimerdone(inst, data)
    if data.name == "revive" then
		StartReviving(inst)
    end
end

local function onsave(inst, data)
    data.reviving = inst.spawn_task ~= nil
end

local function onload(inst, data)
    if data ~= nil and data.reviving then
		inst.components.timer:StopTimer("revive")
    end
end

local function onignight(inst)
	DefaultBurnFn(inst)
	inst.components.timer:StopTimer("revive")
end

local function onextinguish(inst)
	DefaultExtinguishFn(inst)
	if inst.spawn_task == nil then
		inst.perists = false
		inst:DoTaskInTime(math.random()*0.5 + 0.5, ErodeAway)
	end
end

local function getstatus(inst)
    return inst.spawn_task ~= nil and "REVIVING"
			or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) and "BURNING"
			or nil
end



local function OnIsFullmoon(inst, isfullmoon)
	if not isfullmoon then
        	print("no")
    	else
        	inst.components.timer:StartTimer("revive", TUNING.MUTATEDHOUND_SPAWN_DELAY + math.random())
    	end
end  

local function OnInit(inst)     
	inst:WatchWorldState("isfullmoon", OnIsFullmoon)     
	OnIsFullmoon(inst, TheWorld.state.isfullmoon) 
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetBank("spider_queen")
    inst.AnimState:SetBuild("spider_queen_build")
	inst.AnimState:PlayAnimation("death")

	inst:AddTag("blocker")

    inst:SetPhysicsRadiusOverride(.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus

	inst:DoTaskInTime(0, OnInit)

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", ontimerdone)

    MakeLargeBurnable(inst, TUNING.HIGH_BURNTIME, nil, nil, "body")
    inst.components.burnable:SetOnIgniteFn(onignight)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)


    MakeSmallPropagator(inst)

    MakeHauntableIgnite(inst)

    return inst
end

return Prefab("spiderqueencorpse", fn, assets, prefabs)
