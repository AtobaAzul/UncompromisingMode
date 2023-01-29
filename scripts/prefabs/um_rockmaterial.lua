local assets =
{
    Asset("ANIM", "anim/um_rockmaterial.zip"),
}

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function makebasalt(anims)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 1)

        inst.MiniMapEntity:SetIcon("basalt.png")

        inst.AnimState:SetBank("um_rockmaterial")
        inst.AnimState:SetBuild("um_rockmaterial")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.animname = anims[math.random(#anims)]
        inst.AnimState:PlayAnimation(inst.animname)
        local color = 0.5 + math.random() * 0.5
        inst.AnimState:SetMultColour(color, color, color, 1)

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = "BASALT"
        MakeSnowCovered(inst)
        return inst
    end
end

return Prefab("um_rockmaterial1", makebasalt({"block1", "block4", "block2"}), assets),
       Prefab("um_rockmaterial2", makebasalt({"block3"}), assets)