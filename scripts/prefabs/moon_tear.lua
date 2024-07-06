local assets =
{
    Asset("ANIM", "anim/moonrock_seed.zip"),
}

local function startcrying(inst)
    inst.owner = inst.components.inventoryitem.owner
	
	if inst.owner ~= nil and inst.owner.components.inventoryitem ~= nil then
		inst.owner = inst.owner.components.inventoryitem.owner
	end
	
    if inst.owner ~= nil then
		if inst.components.inventoryitem.owner ~= nil and not
			inst.components.inventoryitem.owner:HasTag("waterproofer") and 
			inst.owner.components.moisture ~= nil and 
			inst.owner.components.moisture:GetMoisture() < 48 then
				inst.owner.components.moisture:DoDelta(3)
		end
	end
end

local function topockettear(inst, owner)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(1, startcrying)
	end
end

local function togroundtear(inst)
	if inst.task ~= nil then
		inst.task:Cancel()
		inst.task = nil
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("moonrock_seed")
    inst.AnimState:SetBuild("moontear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("donotautopick")--sucks to pick this up on accident lol

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/moon_tear.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem:SetSinks(true)
	
    inst:AddComponent("tradable")

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("onputininventory", topockettear)
    inst:ListenForEvent("ondropped", togroundtear)

    return inst
end

return Prefab("moon_tear", fn, assets, prefabs)
