local assets = {
	Asset("ANIM", "anim/diviningrod.zip"),
}

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    
    MakeInventoryPhysics(inst)
	--[[local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "diviningrod.png" )]] --Eventually add a minimapicon? maybe not so it isn't easy to spot?
    
    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod")
    inst.AnimState:PlayAnimation("dropped")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddTag("irreplaceable")
	
	inst:AddTag("ratacombskey")
	inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    
    inst:AddComponent("inventoryitem")

    
    return inst
end


return Prefab("ratacombskey", fn, assets) 

