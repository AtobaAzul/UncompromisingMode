local assets =
{
    Asset("ANIM", "anim/boat_net.zip"),
}

local prefabs =
{
    "uncompromising_fishingnetvisualizer"
}

local function fn()
    local inst = CreateEntity()

    inst:AddTag("ignorewalkableplatforms")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst:AddTag("uncompromising_fishingnetvisualizer")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("boat_net")
    inst.AnimState:SetBuild("boat_net")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetSortOrder(5)

    inst:AddComponent("groundshadowhandler")
    inst.components.groundshadowhandler:SetSize(3, 2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.item = nil

    inst:SetStateGraph("SGuncompromising_fishingnetvisualizer")

    inst:AddComponent("fishingnetvisualizer")

    return inst
end

return Prefab("uncompromising_fishingnetvisualizer", fn, assets, prefabs)
