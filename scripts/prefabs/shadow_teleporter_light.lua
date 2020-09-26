require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/nightmare_torch.zip"),
}

local prefabs =
{
    "collapse_small",
    "nightlight_flame",
}

local function onextinguish(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(0)
    end
	inst:RemoveTag("shadow_fire")
end

local function onignite(inst)
	inst:AddTag("shadow_fire")
end

local function CalcSanityAura(inst, observer)
    local lightRadius = inst.components.burnable ~= nil and inst.components.burnable:GetLargestLightRadius() or 0
    return lightRadius > 0 and observer:IsNear(inst, .5 * lightRadius) and -.05 or 0
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
end

local function onupdatefueled(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(), inst.components.fueled:GetSectionPercent())
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        inst.components.burnable:Extinguish()
    else
        if not inst.components.burnable:IsBurning() then
            inst.components.burnable:Ignite()
        end

        inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
    end
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
end

local function OnHaunt(inst, haunter)
    local ret = false
    if inst.components.fueled ~= nil and
        not inst.components.fueled:IsEmpty() and
        math.random() <= TUNING.HAUNT_CHANCE_HALF then
        inst.components.fueled:MakeEmpty()
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        ret = true
    end
	
    return ret
end

local function OnDoneTalking(inst)
    if inst.talktask ~= nil then
        inst.talktask:Cancel()
        inst.talktask = nil
    end
    inst.SoundEmitter:KillSound("talk")
end

local function OnTalk(inst)
    OnDoneTalking(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/talk_LP", "talk")
    inst.talktask = inst:DoTaskInTime(1.5 + math.random() * .5, OnDoneTalking)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .1)

    inst.MiniMapEntity:SetIcon("nightlight.png")

    inst.AnimState:SetBank("nightmare_torch")
    inst.AnimState:SetBuild("nightmare_torch")
    inst.AnimState:PlayAnimation("idle", false)
	
	inst.AnimState:SetMultColour(0, 0, 0, 0.6)

    inst:AddTag("wildfireprotected")
	inst:AddTag("inlimbo")

	inst:AddComponent("talker")        
    inst.components.talker.colour = Vector3(252/255, 226/255, 219/255)
    inst.components.talker.offset = Vector3(0, -500, 0)
    inst.components.talker:MakeChatter()
    inst.components.talker.lineduration = TUNING.HERMITCRAB.SPEAKTIME * 2 -0.5
    if LOC.GetTextScale() == 1 then
		inst.components.talker.fontsize = 30
    end
	
    inst.components.talker.font = TALKINGFONT_HERMIT
    inst:AddComponent("npc_talker")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------
    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("nightlight_flame", Vector3(0, 0, 0), "fire_marker")
    inst.components.burnable.canlight = false
    inst:ListenForEvent("onextinguish", onextinguish)
	inst:ListenForEvent("onignite", onignite)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    -------------------------
    inst:AddComponent("lootdropper")
   
    -------------------------
    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = TUNING.NIGHTLIGHT_FUEL_MAX
    inst.components.fueled.accepting = true
    inst.components.fueled.fueltype = FUELTYPE.NIGHTMARE
    inst.components.fueled:SetSections(4)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled:SetUpdateFn(onupdatefueled)
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTLIGHT_FUEL_START * 2)

    -----------------------------

    inst:AddComponent("inspectable")

	inst:WatchWorldState("isday", function() 
		local x, y, z = inst.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("shadow_despawn")
		despawnfx.Transform:SetPosition(x, y, z)
		
		inst:Remove()
	end)
	
    inst:ListenForEvent("ontalk", OnTalk)
    inst:ListenForEvent("donetalking", OnDoneTalking)
	
	inst.persists = false

    return inst
end

return Prefab("shadow_teleporter_light", fn, assets, prefabs)
