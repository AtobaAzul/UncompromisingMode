local assets =
{
    --Asset("ANIM", "anim/amulet_red_ground.zip"),
}

local function Flash(owner)
    if owner.flashghost then
        owner.flashghost = nil
        owner.AnimState:SetHaunted(false)
    else
        owner.flashghost = true
        owner.AnimState:SetHaunted(true)
    end
end

local function Ghost(owner)
    if owner.flashingtask then
        owner.flashingtask:Cancel()
        owner.flashghost = nil
        owner.flashingtask = nil
    end

    owner.Physics:ClearCollidesWith(COLLISION.OBSTACLES)
    owner.Physics:ClearCollidesWith(COLLISION.SMALLOBSTACLES)
    owner.Physics:ClearCollidesWith(COLLISION.CHARACTERS)
    owner.Physics:ClearCollidesWith(COLLISION.FLYERS)
    owner.AnimState:SetHaunted(true)
end

local function UnGhost(owner)
    if not (owner:HasTag("psuedo_ghost") or owner:HasTag("playerghost")) then
        if owner.flashingtask then
            owner.flashingtask:Cancel()
            owner.flashghost = nil
            owner.flashingtask = nil
        end
        owner.Physics:CollidesWith(COLLISION.OBSTACLES)
        owner.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
        owner.Physics:CollidesWith(COLLISION.CHARACTERS)
        owner.Physics:CollidesWith(COLLISION.FLYERS)
        owner.AnimState:SetHaunted(false)
    end
end

local function onequip_spec(inst, owner)
    owner:AddTag("psuedo_ghost")
    if inst.skinname ~= nil then
        owner.AnimState:OverrideSymbol("swap_body", "torso_ancient_amulet_red_demoneye", "redamulet")
    else
        owner.AnimState:OverrideSymbol("swap_body", "torso_amulets_ancient", "redamulet")
    end
    Ghost(owner)
end

local function onunequip_spec(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner:RemoveTag("psuedo_ghost")
    owner.flashingtask = owner:DoPeriodicTask(1, Flash)
    owner:DoTaskInTime(4, UnGhost)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulet_red_ground")
    inst.AnimState:SetBuild("amulet_red_ground")
    inst.AnimState:PlayAnimation("Idle")

    inst.Transform:SetScale(1.1, 1.1, 1.1)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("resurrector")
    inst:AddTag("donotautopick")
    
    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    if EQUIPSLOTS["NECK"] ~= nil then
        inst.components.equippable.equipslot = EQUIPSLOTS.NECK
    else
        inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    end
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ancient_amulet_red.xml"

    inst.components.equippable:SetOnEquip(onequip_spec)
    inst.components.equippable:SetOnUnequip(onunequip_spec)

    return inst
end

return Prefab("um_specter_amulet", fn, assets)
