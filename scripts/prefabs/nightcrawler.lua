require "stategraphs/SGnightcrawler"

local assets =
{
    --Asset("ANIM", "anim/aphid.zip"),
}

local prefabs =
{
    --"weevole_carapace",
    "monstersmallmeat",
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    idle = "dontstarve/sanity/creature2/idle",
    --idle = "dontstarve/sanity/creature1/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}
	
local brain = require "brains/nightcrawlerbrain"

local function retargetfn(inst)
	local target = 
	FindEntity(
				inst,
                15,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                { "player" },
                { "playerghost" }
            )
        or FindEntity(
				inst,
                30,
                function(guy)
                    return inst.components.combat:CanTarget(guy) and not guy:IsInLight()
                end,
                { "player" },
                { "playerghost" }
            )
        or nil
	
	return target
end

local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("nightcrawler")
    inst.AnimState:SetBuild("nightcrawler_build")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetMultColour(0, 0, 0, 1)

	inst:AddTag("monster")
    inst:AddTag("hostile")   
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 5
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('shadow_creature')

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(10)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRange(6, 3)
    inst.sounds = sounds 
	
	inst:WatchWorldState("isday", function() 
		inst:Remove()
	end)

    inst:SetStateGraph("SGnightcrawler")
    inst:SetBrain(brain)
	
    return inst
end

return Prefab("nightcrawler", fn, assets, prefabs)
