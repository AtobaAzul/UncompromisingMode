local assets =
{
    Asset("ANIM", "anim/iceboomerang.zip"),
    Asset("ANIM", "anim/swap_iceboomerang.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
}

local function OnFinished(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)
end

 local function OnEquip(inst, owner)        
	owner.AnimState:OverrideSymbol("swap_object", "swap_iceboomerang", "swap_iceboomerang")        
	owner.AnimState:Show("ARM_carry")        
	owner.AnimState:Hide("ARM_normal")    
 end    
 
 
 
 local function OnUnequip(inst, owner)        
	owner.AnimState:Hide("ARM_carry")        
	owner.AnimState:Show("ARM_normal")    
 end


local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.pushlandedevents = true
    inst:PushEvent("on_landed")
end


local function OnThrown(inst, owner, target)
    if target ~= owner then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
end

local function OnCaught(inst, catcher)
    if catcher ~= nil and catcher.components.inventory ~= nil and catcher.components.inventory.isopen then
	inst.AnimState:PlayAnimation("idle", true)
        if inst.components.equippable ~= nil and not catcher.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
            catcher.components.inventory:Equip(inst)
        else
            catcher.components.inventory:GiveItem(inst)
        end
        catcher:PushEvent("catch")
    end
end

local function ReturnToOwner(inst, owner)
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        inst.components.projectile:Throw(owner, owner)
end

local function OnHit(inst, owner, target)
    if owner == target or owner:HasTag("playerghost") then
        OnDropped(inst)
    else
        ReturnToOwner(inst, owner)
    end
    if target ~= nil and target:IsValid() then
        local impactfx = SpawnPrefab("impact")
        if impactfx ~= nil then
            local follower = impactfx.entity:AddFollower()
			
			if target.components.combat ~= nil then
				follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
			end
			
            impactfx:FacePoint(inst.Transform:GetWorldPosition())
			if target.components.freezable ~= nil then
				if target.components.freezable ~= nil and not target:HasTag("player") then
					target.components.freezable:AddColdness(2)
					target.components.freezable:SpawnShatterFX()
				elseif target.components.freezable ~= nil and target:HasTag("player") then
					target.components.freezable:AddColdness(4)
					target.components.freezable:SpawnShatterFX()
				end
			end
        end
    end
	if inst.components.perishable then
		inst.components.perishable:ReducePercent(0.10)
	end
end

local function OnRepaired(inst)
	local icerepair = inst.components.perishable:GetPercent() + 0.20
	inst.components.perishable:SetPercent(icerepair)
end


local function OnMiss(inst, owner, target)
    if owner == target then
        OnDropped(inst)
    else
        ReturnToOwner(inst, owner)
    end
end

local function onperish(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        if owner.components.moisture ~= nil then
            owner.components.moisture:DoDelta(5)
        elseif owner.components.inventoryitem ~= nil then
            owner.components.inventoryitem:AddMoisture(5)
        end
        inst:Remove()
    else
        inst.components.inventoryitem.canbepickedup = false
        --inst:DoTaskInTime(1, inst.Remove())
    end
		inst:Remove()
end

local function onfiremelt(inst)
    inst.components.perishable.frozenfiremult = true
end

local function onstopfiremelt(inst)
    inst.components.perishable.frozenfiremult = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("iceboomerang")
    inst.AnimState:SetBuild("iceboomerang")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("frozen")

    inst:AddTag("thrown")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
	
	--inst:AddTag("scarytoprey")  --birds will fly away from this rang

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
	
	inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("donotautopick")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(20)
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE+2)
    -------

    --inst:AddComponent("finiteuses")
    --inst.components.finiteuses:SetMaxUses(TUNING.BOOMERANG_USES)
    --inst.components.finiteuses:SetUses(TUNING.BOOMERANG_USES)
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(onperish)

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.ICE
    inst.components.repairable.announcecanfix = false
	inst.components.repairable.onrepaired = OnRepaired
	
    inst:AddComponent("inspectable")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(10)
    inst.components.projectile:SetCanCatch(true)
    inst.components.projectile:SetOnThrownFn(OnThrown)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnMiss)
    inst.components.projectile:SetOnCaughtFn(OnCaught)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/iceboomerang.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("iceboomerang", fn, assets)
