local assets =
{
	Asset("ANIM", "anim/swap_rain_horn.zip"),
	Asset("ANIM", "anim/rain_horn.zip"),
	Asset("ATLAS", "images/inventoryimages/rain_horn.xml"),
	Asset("IMAGE", "images/inventoryimages/rain_horn.tex"),
	Asset("ATLAS", "images/inventoryimages/dormant_rain_horn.xml"),
	Asset("IMAGE", "images/inventoryimages/dormant_rain_horn.tex"),
}

local function reticuletargetfunction(inst)
    return Vector3(ThePlayer.entity:LocalToWorldSpace(3.5, 0.001, 0))
end

local function onusesfinished(inst)
    local item = SpawnPrefab("dormant_rain_horn")
    local x,y,z = inst.Transform:GetWorldPosition()
    item.Transform:SetPosition(x,y,z)

    if inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner.components.inventory:GiveItem(item)
    end

    inst:Remove()
end

local function onequipped(inst, equipper)
    equipper.AnimState:OverrideSymbol("swap_object", "swap_rain_horn", "swap_rain_horn")
    equipper.AnimState:Show("ARM_carry")
    equipper.AnimState:Hide("ARM_normal")
end

local function onunequipped(inst, equipper)
    equipper.AnimState:Hide("ARM_carry")
    equipper.AnimState:Show("ARM_normal")
end

local PLANT_TAGS = {"tendable_farmplant"}

local function forcerain(inst, target, position)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner == nil then
        return
    end
	TheWorld:PushEvent("ms_forceprecipitation", true)
    inst.components.finiteuses:Use(1)
    local x, y, z = owner.Transform:GetWorldPosition()
    for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING.GNARWAIL_HORN_FARM_PLANT_INTERACT_RANGE, PLANT_TAGS)) do
		if v.components.farmplanttendable ~= nil then
			v.components.farmplanttendable:TendTo(owner)
		end
	end
end

local function fn() --Drown the world.
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("gnarwail_horn")
    inst:AddTag("nopunch")
    inst:AddTag("allow_action_on_impassable")

    inst.spelltype = "MUSIC"

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = reticuletargetfunction
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true

    inst.AnimState:SetBank("rain_horn")
    inst.AnimState:SetBuild("rain_horn")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)

    ---------------------------------------------------------------------

    inst:AddComponent("inspectable")

    ---------------------------------------------------------------------

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/rain_horn.xml"
    ---------------------------------------------------------------------

    inst:AddComponent("tradable")

    ---------------------------------------------------------------------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.GNARWAIL_HORN.USES)
    inst.components.finiteuses:SetUses(TUNING.GNARWAIL_HORN.USES)
    inst.components.finiteuses:SetOnFinished(onusesfinished)

    ---------------------------------------------------------------------

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequipped)
    inst.components.equippable:SetOnUnequip(onunequipped)

    ---------------------------------------------------------------------

    inst.playsound = "hookline/creatures/gnarwail/horn"

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(forcerain)
	inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true

    return inst
end

local function fndormant()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rain_horn")
    inst.AnimState:SetBuild("rain_horn")
    inst.AnimState:PlayAnimation("dormant")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    MakeHauntableLaunch(inst)

    ---------------------------------------------------------------------

    inst:AddComponent("inspectable")

    ---------------------------------------------------------------------

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dormant_rain_horn.xml"
    ---------------------------------------------------------------------

    return inst
end
return Prefab("rain_horn", fn, assets, prefabs),
Prefab("dormant_rain_horn", fndormant)
