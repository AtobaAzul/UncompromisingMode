local assets =
{
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip"),
}

local function onequip_blue(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")

    inst.orbfn = function(attacked, data)
        if data and data.attacker and data.damage then
			inst.healthvalue = data.damage
			inst.components.finiteuses:Use(1)
			print(inst.healthvalue)
        end 
    end

    inst:ListenForEvent("attacked", inst.orbfn, owner)

end

local function onunequip_blue(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    inst:RemoveEventCallback("attacked", inst.orbfn, owner)
end

local function ancient_red_amulet_fn(anim, tag, should_sink)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulets")
    inst.AnimState:SetBuild("amulets")
    inst.AnimState:PlayAnimation("redamulet")

    inst:AddTag("resurrector")

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("inventoryitem")
	
    inst.components.equippable:SetOnEquip(onequip_blue)
    inst.components.equippable:SetOnUnequip(onunequip_blue)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(TUNING.REDAMULET_USES)
    inst.components.finiteuses:SetUses(TUNING.REDAMULET_USES)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)

    return inst
end

return Prefab("ancient_red_amulet", ancient_red_amulet_fn, assets)
