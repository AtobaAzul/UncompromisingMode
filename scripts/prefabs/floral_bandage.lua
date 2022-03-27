local assets =
{
	Asset("ANIM", "anim/floral_bandage.zip"),
	Asset("ATLAS", "images/inventoryimages/floral_bandage.xml"),
	Asset("IMAGE", "images/inventoryimages/floral_bandage.tex"),	
}

local function fn()                     --Y Add This Item?       --Cactus flower's "bonus" is supposedly flower salad, which has a super quick spoil time with a baseline
	local inst = CreateEntity()                                  --healing value. This is terrible, especially whenever this is a summer exclusive resource. [Which is also kinda lacking]
                                                                 --So here's the proposition, buff flower salad, add alternative healing item that does 40 health and is nonperishable,
	inst.entity:AddTransform()                                   --allows you to decide whether you'd rather get more healing now or a decent amount of healing later.
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
															     --If you feel it's absolutely necessary to nerf this item (it probably isn't) then I would recommend just
    MakeInventoryPhysics(inst)                                   --swapping the instant health to 20, then adding 20 overtime health.   --AXE

    inst.AnimState:SetBank("floral_bandage")
    inst.AnimState:SetBuild("floral_bandage")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/floral_bandage.xml"
	
    inst:AddComponent("healer")
    inst.components.healer:SetHealthAmount(40)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("floral_bandage", fn, assets)