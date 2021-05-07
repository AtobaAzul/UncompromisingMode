local assets =
{
    Asset("ANIM", "anim/armor_bramble.zip"),
}

local prefabs =
{
    "bramblefx_armor",
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_bramble", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("bramble_resistant")
    inst:AddTag("wingsuit")

    inst.AnimState:SetBank("armor_bramble")
    inst.AnimState:SetBuild("armor_bramble")
    inst.AnimState:PlayAnimation("anim")
	
    inst:AddTag("backpack")

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("wingsuit") 
		end
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("wingsuit")
	inst.components.container.canbeopened = true

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("wingsuit", fn, assets, prefabs)
