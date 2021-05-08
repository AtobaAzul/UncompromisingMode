require "stategraphs/SGaphid"

local assets =
{
    Asset("ANIM", "anim/aphid.zip"),
}

local prefabs =
{
    --"weevole_carapace",
    "monstersmallmeat",
}

SetSharedLootTable("aphid_loot",
{
    --{'weevole_carapace', 1},
    {'monstersmallmeat',      0.25},
    {'steelwool',      0.01},
})

local brain = require "brains/aphidbrain"

local function OnDropped(inst)
    inst.sg:GoToState("idle")
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.components.stackable ~= nil then
        while inst.components.stackable:StackSize() > 1 do
            local item = inst.components.stackable:Get()
            if item ~= nil then
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(inst.Transform:GetWorldPosition())
            end
        end
    end
end

local function retargetfn(inst)
    local dist = 8
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

local function OnWorked(inst, worker)
    if worker.components.inventory ~= nil then
        inst.SoundEmitter:KillAllSounds()

        worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
    end
end



local function TryToInfestTree(inst)
if inst.components.combat ~= nil then
	if not inst.components.combat.target then
		if math.random() > 0.95 or inst:HasTag("fromthebush") then
		local tree = FindEntity(inst,30,function(tree) return not tree:HasTag("infestedtree") and tree:HasTag("giant_tree") end)
			if tree ~= nil then
			if inst.brain ~= nil then
			inst.brain:Stop()
			end
			inst.sg:GoToState("flyintree")
				if tree.components.timer ~= nil then
				tree.components.timer:StartTimer("infest", 1600)
				end
			end
		end
	end
end
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

    inst.AnimState:SetBank("weevole")
    inst.AnimState:SetBuild("aphid")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("insect")
    inst:AddTag("hostile")
    inst:AddTag("canbetrapped")
    inst:AddTag("smallcreature")
    inst:AddTag("aphid")
    inst:AddTag("animal")
	inst:AddTag("soulless")

    MakeInventoryFloatable(inst)

    MakeFeedableSmallLivestockPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 3
	 
    inst:AddComponent("inventory")
	
    inst:AddComponent("stackable")
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.pushlandedevents = false
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/aphid.xml"
	
    inst:AddComponent("tradable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("aphid_loot")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat:SetDefaultDamage(20)
    inst.components.combat:SetAttackPeriod(GetRandomMinMax(1, 3))
    inst.components.combat:SetRange(5, 2)

    inst:AddComponent("knownlocations")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("eater")
    --inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    inst.components.eater:SetDiet({ FOODGROUP.OMNI, FOODTYPE.WOOD, FOODTYPE.SEEDS, FOODTYPE.ROUGHAGE }, { FOODGROUP.OMNI, FOODTYPE.WOOD, FOODTYPE.SEEDS, FOODTYPE.ROUGHAGE })
	inst:DoPeriodicTask(4+4*math.random() ,TryToInfestTree)
    --inst.OnEntitySleep = OnEntitySleep
    --inst.OnEntityWake = OnEntityWake

	--inst.FindNewHomeFn = FindNewHome
    
    inst:SetStateGraph("SGaphid")
    inst:SetBrain(brain)

    MakeFeedableSmallLivestock(inst, TUNING.BUTTERFLY_PERISH_TIME, nil, OnDropped)
	
    MakeSmallBurnableCharacter(inst, "body")
    MakeSmallFreezableCharacter(inst, "body")

	inst:ListenForEvent("fly_in", OnFlyIn) -- matches enter_loop logic so it does not happen a frame late

    return inst
end

return Prefab("aphid", fn, assets, prefabs)
