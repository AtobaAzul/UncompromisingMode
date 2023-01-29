local assets =
{
	Asset( "ANIM", "anim/deerclops_ground_fx.zip" )
}

local function onSleep(inst)
	inst:Remove()
end 

local function Freeze(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	for k, v in ipairs(TheSim:FindEntities(x, y, z, 5, { "freezable" }, { "flying", "playerghost", "INLIMBO" })) do
		if k.components.freezable then
			k.components.freezable:AddColdness(5)
		end
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.persists = false

    inst.AnimState:SetBuild("deerclops_ground_fx")
    inst.AnimState:SetBank("deerclops_ground_fx")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("FX" )
	inst:AddTag("NOCLICK")
	
	inst.OnEntitySleep = onSleep

	inst:DoTaskInTime(0.75, Freeze)

	inst:ListenForEvent("animover", function(inst) inst:Remove() end )

    return inst
end

return Prefab("deerclops_ground_fx", fn, assets)