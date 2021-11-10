local assets =
{
	Asset("ANIM", "anim/pied_piper.zip"),
}
local brain = require "brains/pied_ratbrain"


local function fn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()


    --trader (from trader component) added to pristine state for optimization
    --inst:AddTag("trader") If you want to trade <--

    inst.AnimState:SetBank("pied_piper")
    inst.AnimState:SetBuild("pied_piper")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")

    inst:SetStateGraph("SGpied_rat")

    inst:AddComponent("lootdropper")	--must be initialized so it doesn't crash


    ---------------------        
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       

    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
	inst:AddComponent("knownlocations")


    inst:AddComponent("inspectable")

    ------------------

    MakeHauntablePanic(inst)

    --inst:SetBrain(brain)


    return inst
end


return Prefab("pied_rat", fn,assets)
