local assets =
{
    Asset("ANIM", "anim/torso_dragonfly.zip"),
}

local function oneatfn(inst, food)
    local health = math.abs(food.components.edible:GetHealth(inst)) * inst.components.eater.healthabsorption
    local hunger = math.abs(food.components.edible:GetHunger(inst)) * inst.components.eater.hungerabsorption
    inst.components.finiteuses:SetUses(inst.components.finiteuses.current + health + hunger)

    if not inst.inlimbo then
        inst.AnimState:PlayAnimation("eat")
        inst.AnimState:PushAnimation("idle", true)

        inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/bite")
    end
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "oculet", "swap_body")

    inst.orbfn = function(attacked, data)
        if data and data.attacker and data.damage then
			if inst._cdtask == nil and data ~= nil then
				inst._cdtask = inst:DoTaskInTime(1, OnCooldown)
				
				inst.healthvalue = data.damage
				inst.components.finiteuses:Use(inst.healthvalue < 50 and inst.healthvalue or 50)
				
			end
        end 
    end
	
    local x, y, z = owner.Transform:GetWorldPosition()
	
        local eyeball_1 = SpawnPrefab("oculet_rez")
        SpawnPrefab("halloween_firepuff_"..math.random(3)).Transform:SetPosition(x + 3, y, z)
        eyeball_1.Transform:SetPosition(x + 3, y, z)
        owner.components.leader:AddFollower(eyeball_1)
        eyeball_1.components.follower.leader = owner
		
		eyeball_1.summoner = inst
		inst.eyeball_1 = eyeball_1
	
        local eyeball_2 = SpawnPrefab("oculet_spaz")
        SpawnPrefab("cursed_firespawn").Transform:SetPosition(x - 3, y, z)
        eyeball_2.Transform:SetPosition(x - 3, y, z)
        owner.components.leader:AddFollower(eyeball_2)
        eyeball_2.components.follower.leader = owner
		
		eyeball_2.summoner = inst
		inst.eyeball_2 = eyeball_2
	
    inst:ListenForEvent("attacked", inst.orbfn, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
	
	if inst.eyeball_1 ~= nil then
		local x, y, z = inst.eyeball_1.Transform:GetWorldPosition()
		
        SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(x, y, z)
	
		inst.eyeball_1:Remove()
		inst.eyeball_1 = nil
	end
	
	if inst.eyeball_2 ~= nil then
		local x1, y1, z1 = inst.eyeball_2.Transform:GetWorldPosition()
		
        SpawnPrefab("cursed_firespawn").Transform:SetPosition(x1, y1, z1)
		
		inst.eyeball_2:Remove()
		inst.eyeball_1 = nil
	end

    inst:RemoveEventCallback("attacked", inst.orbfn, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("oculet_ground")
    inst.AnimState:SetBuild("oculet_ground")
    inst.AnimState:PlayAnimation("anim")

    --MakeInventoryFloatable(inst, "small", 0.2, 0.80, nil, nil, swap_data)
    inst:AddTag("donotautopick")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/oculet.xml"
	
    inst:AddComponent("eater")
    inst.components.eater:SetOnEatFn(oneatfn)
    inst.components.eater:SetAbsorptionModifiers(4.0, 1.75, 0)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatHorrible(true)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(1000)
    inst.components.finiteuses:SetUses(1000)

    inst:AddComponent("equippable")
    if EQUIPSLOTS["NECK"] ~= nil then
        inst.components.equippable.equipslot = EQUIPSLOTS.NECK
    else
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    end
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("oculet", fn, assets)
