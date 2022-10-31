local brain = require "brains/umbralhound_brain"
local assets = {
Asset("ANIM", "anim/umbral_hound.zip"),
}

local function umbral_hound()
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

    inst.AnimState:SetBank("umbral_hound")
    inst.AnimState:SetBuild("umbral_hound")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")

    inst:SetStateGraph("SGumbral_hound")

    inst:AddComponent("lootdropper")	--must be initialized so it doesn't crash
	inst:AddComponent("knownlocations")

    ---------------------        
    MakeMediumBurnableCharacter(inst, "THING")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       
	inst.Transform:SetScale(2,2,2)
	
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "THING"


    ------------------

    -- inst:AddComponent("sleeper")
    -- inst.components.sleeper:SetResistance(2)
    -- inst.components.sleeper:SetSleepTest(ShouldSleep)
    -- inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------

    inst:AddComponent("inspectable")

    ------------------

    MakeHauntablePanic(inst)

    inst:SetBrain(brain)


    -- inst:WatchWorldState("iscaveday", OnIsCaveDay)
    -- OnIsCaveDay(inst, TheWorld.state.iscaveday)

    return inst
end


return Prefab("sinheniddnadtdfo", umbral_hound,assets)
