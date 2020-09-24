
require "stategraphs/SGaphid"

local assets =
{
    Asset("ANIM", "anim/aphid.zip"),
}

local prefabs =
{
    --"weevole_carapace",
    "monstermeat",
}

SetSharedLootTable("aphid_loot",
{
    --{'weevole_carapace', 1},
    {'monstermeat',      0.25},
})

local brain = require "brains/aphidbrain"

local function retargetfn(inst)
    local dist = 5
    local notags = {"FX", "NOCLICK","INLIMBO", "wall", "aphid", "structure", "aquatic"}
    return FindEntity(inst, dist, function(guy)
        return  inst.components.combat:CanTarget(guy)
    end, nil, notags)
end

local function keeptargetfn(inst, target)
   return target ~= nil
        and target.components.combat ~= nil
        and target.components.health ~= nil
        and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, 
		function(dude)
			return dude:HasTag("aphid")
				and not dude.components.health:IsDead()
		end, 10)
end

local function OnFlyIn(inst)
    inst.DynamicShadow:Enable(false)
    inst.components.health:SetInvincible(true)
    local x,y,z = inst.Transform:GetWorldPosition()
    inst.Transform:SetPosition(x,15,z)
end

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetSixFaced()
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end


    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("insect")
    inst:AddTag("hostile")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("aphid")
    inst:AddTag("animal")

    inst.AnimState:SetBank("weevole")
    inst.AnimState:SetBuild("aphid")
    inst.AnimState:PlayAnimation("idle")

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 3

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("aphid_loot")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(GetRandomMinMax(1, 3))
    inst.components.combat:SetRange(2, 2)

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)


    inst:AddComponent("eater")
    inst.components.eater.foodprefs = { "WOOD","SEEDS","ROUGHAGE" }
    inst.components.eater.ablefoods = { "WOOD","SEEDS","ROUGHAGE" }
    --inst.OnEntitySleep = OnEntitySleep
    --inst.OnEntityWake = OnEntityWake

	--inst.FindNewHomeFn = FindNewHome
    
    inst:SetStateGraph("SGaphid")
    inst:SetBrain(brain)

    MakeSmallBurnableCharacter(inst, "body")
    MakeSmallFreezableCharacter(inst, "body")

	inst:ListenForEvent("fly_in", OnFlyIn) -- matches enter_loop logic so it does not happen a frame late

    return inst
end

return Prefab("aphid", fn, assets, prefabs)
