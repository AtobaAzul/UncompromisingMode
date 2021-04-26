local assets =
{
    Asset("ANIM", "anim/armor_bramble.zip"),
}

local prefabs =
{
    "bramblefx_armor",
}

local function reticuletargetfn(inst, pos)
	local offset = inst.replica.oceanfishingrod ~= nil and inst.replica.oceanfishingrod:GetMaxCastDist() or TUNING.OCEANFISHING_TACKLE.BASE.dist_max
    return Vector3(ThePlayer.entity:LocalToWorldSpace(offset, 0.001, 0)) -- raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
end

local function reticuleshouldhidefn(inst)
    return inst.replica.inventoryitem ~= nil and inst.replica.inventoryitem:IsHeldBy(ThePlayer) and ThePlayer.components.playercontroller ~= nil and ThePlayer:HasTag("fishing")
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_bramble", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function createlight(staff, target, pos)
    local light = SpawnPrefab("stafflight")
    light.Transform:SetPosition(pos:Get())

    local caster = staff.components.inventoryitem.owner
    if caster ~= nil and caster.components.hunger ~= nil then
        caster.components.hunger:DoDelta(-TUNING.SANITY_MEDLARGE)
    end
end

local function light_reticuletargetfn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(5, 0.001, 0)) -- raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
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

    inst.foleysound = "dontstarve/movement/foley/cactus_armor"

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
	
    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = light_reticuletargetfn
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(createlight)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("wingsuit", fn, assets, prefabs)
