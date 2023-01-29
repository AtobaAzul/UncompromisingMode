require("worldsettingsutil")

local assets =
{
    --Asset("ANIM", "anim/fire_large_character.zip"),
    Asset("ANIM", "anim/campfire_fire.zip"),
    Asset("SOUND", "sound/common.fsb"),
    Asset("ANIM", "anim/pig_torch.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "pigtorch_flame",
    "pigtorch_fuel",
    "collapse_small",
    "firefx_light",
}

local firelevels =
{
    {anim="level1", sound="dontstarve/common/campfire", radius=3, intensity=.8, falloff=.44, colour = {255/255,255/255,192/255}, soundintensity=.2},
    {anim="level2", sound="dontstarve/common/campfire", radius=5, intensity=.8, falloff=.44, colour = {255/255,255/255,192/255}, soundintensity=.6},
    {anim="level3", sound="dontstarve/common/campfire", radius=7, intensity=.8, falloff=.44, colour = {255/255,255/255,192/255}, soundintensity=1},
}


local function onextinguish(inst)
    if inst.components.fueled ~= nil then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function onupdatefueledraining(inst)
    inst.components.fueled.rate = 1 + TUNING.PIGTORCH_RAIN_RATE * TheWorld.state.precipitationrate
end

local function onisraining(inst, israining)
    if inst.components.fueled ~= nil then
        if israining then
            inst.components.fueled:SetUpdateFn(onupdatefueledraining)
            onupdatefueledraining(inst)
        else
            inst.components.fueled:SetUpdateFn()
            inst.components.fueled.rate = 1
        end
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

local function OnHaunt(inst)
    inst.components.fueled:TakeFuelItem(SpawnPrefab("log"))
    return true
end

local function fn(size)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.33)

    inst.AnimState:SetBuild("rattotem")
    
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("wildfireprotected")

    --MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
	
	if size == "short" then
		inst.AnimState:SetBank("rattotem_short")
		inst.components.burnable:AddBurnFX("ratacombs_totemfire", Vector3(0, 0, 0), "fire_marker_short")
	end
	if size == "medium" then
		inst.AnimState:SetBank("rattotem_medium")
		inst.components.burnable:AddBurnFX("ratacombs_totemfire", Vector3(5, -20, 0), "fire_marker")
	end
	if size == "tall" then
		inst.AnimState:SetBank("rattotem_tall")
		inst.components.burnable:AddBurnFX("ratacombs_totemfire", Vector3(0, -5, 0), "fire_marker_tall")
	end
		
    inst:ListenForEvent("onextinguish", onextinguish) --in case of creepy hands

    inst:AddComponent("fueled")
    inst.components.fueled.accepting = true
    inst.components.fueled.maxfuel = TUNING.FIREPIT_FUEL_MAX
    inst.components.fueled:SetSections(3)
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
    inst.components.fueled.fueltype = FUELTYPE.BURNABLE
    inst.components.fueled:SetSectionCallback(onfuelchange)
    inst.components.fueled:InitializeFuelLevel(TUNING.FIREPIT_FUEL_MAX)

    inst:WatchWorldState("israining", onisraining)
    onisraining(inst, TheWorld.state.israining)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
	

	inst.components.fueled:SetPercent(1) -- This is temporary
    return inst
end

local function shortfn()
return fn("short")
end

local function mediumfn()
return fn("medium")
end

local function tallfn()
return fn("tall")
end

local function firefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("campfire_fire")
    inst.AnimState:SetBuild("campfire_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels

    return inst
end

return Prefab("ratacombs_totem_short", shortfn),
	Prefab("ratacombs_totem_medium", mediumfn),
	Prefab("ratacombs_totem_tall", tallfn),
	Prefab("ratacombs_totemfire", firefn)