local assets=
{
	Asset("ANIM", "anim/geyser.zip"),
    Asset("MINIMAP_IMAGE", "geyser"),
}

local function StartBurning(inst)
    inst.Light:Enable(true)
    inst.components.geyserfx:Ignite()
	inst.components.childspawner:StartSpawning()
end

local function OnIgnite(inst)
    StartBurning(inst)
end

local function OnBurn(inst)
    inst.components.fueled:StartConsuming()
    inst.components.propagator:StartSpreading()
    inst.components.geyserfx:SetPercent(inst.components.fueled:GetPercent())
    inst:AddComponent("cooker")
end

local function SetIgniteTimer(inst)
    inst:DoTaskInTime(GetRandomWithVariance(30, 15), function()
        --if not inst.components.floodable.flooded then 
            inst.components.fueled:SetPercent(1.0)
            OnIgnite(inst)
        --end 
    end)
end

local function OnErupt(inst)
    StartBurning(inst)
    inst.components.fueled:SetPercent(1.0)
    OnBurn(inst)
    TheCamera:Shake("FULL", 0.7, 0.02, 0.75)
end

local function OnExtinguish(inst, setTimer)
    if setTimer == nil then 
        setTimer = true
    end
    inst.AnimState:ClearBloomEffectHandle()
    inst.components.fueled:StopConsuming()
    inst.components.propagator:StopSpreading()
    inst.components.geyserfx:Extinguish()
    if inst.components.cooker then 
        inst:RemoveComponent("cooker")
    end 
    if setTimer then 
        SetIgniteTimer(inst)
    end
	inst.components.childspawner:StopSpawning()
	
	if not TheWorld.state.issummer then
		inst:DoTaskInTime(10, function(inst) SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition()) inst:Remove() end)
	end
	
	--inst:RemoveTag("fire")
end

local function OnIdle(inst)
    inst.AnimState:PlayAnimation("idle_dormant", true)
    inst.Light:Enable(false)
	--inst:StopUpdatingComponent(inst.components.geyserfx)
	
end

local function OnLoad(inst, data)
    if not inst.components.fueled:IsEmpty() then
        OnIgnite(inst)
    else
        SetIgniteTimer(inst)
    end
end

local heats = { 70, 85, 100, 115 }
local function GetHeatFn(inst)
    return 100 --heats[inst.components.geyserfx.level] or 20
end
--[[
local function onFloodedStart(inst)
    inst.components.fueled:SetPercent(0)
    OnExtinguish(inst, false)
end


local function onFloodedEnd(inst)
    SetIgniteTimer(inst)
end 
--]]

local function fn(Sim)
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    local sound = inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
	
	inst.entity:AddNetwork()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()

    MakeObstaclePhysics(inst, 2.05)
    inst.Physics:SetCollides(false)

	minimap:SetIcon("geyser.png")
    anim:SetBank("geyser")
    anim:SetBuild("geyser")
    anim:PlayAnimation("idle_dormant", true)
    anim:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst.entity:SetPristine()
	
	inst:AddTag("flamegeyser")

	if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("inspectable")
    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn

    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = 15
    inst.components.fueled.accepting = false
    inst:AddComponent("propagator")
    inst.components.propagator.damagerange = 4
    inst.components.propagator.damages = true

    inst.components.fueled:SetSections(4)
    inst.components.fueled.rate = 1
    inst.components.fueled.period = 1
--[[
    inst:AddComponent("floodable")
    inst.components.floodable.onStartFlooded = onFloodedStart
    inst.components.floodable.onStopFlooded = onFloodedEnd
--]]

	inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()
	inst.components.childspawner.childname = "lavae2"
	
    inst:AddComponent("fader")

    inst.components.fueled:SetUpdateFn( function()
        if not inst.components.fueled:IsEmpty() then
            inst.components.geyserfx:SetPercent(inst.components.fueled:GetPercent())
        end
    end)
        
    inst.components.fueled:SetSectionCallback( function(section)
        if section == 0 then
            OnExtinguish(inst)
        else
            local damagerange = {2,2,2,2}
            local ranges = {2,2,2,4}
            local output = {4,10,20,40}
            inst.components.propagator.damagerange = damagerange[section]
            inst.components.propagator.propagaterange = ranges[section]
            inst.components.propagator.heatoutput = output[section]
        end
    end)
        
    inst.components.fueled:InitializeFuelLevel(15)

    inst:AddComponent("geyserfx")
    inst.components.geyserfx.usedayparamforsound = true
    inst.components.geyserfx.lightsound = "dontstarve/common/fireAddFuel"
    --inst.components.geyserfx.extinguishsound = "dontstarve_DLC002/common/flamegeyser_out"
    inst.components.geyserfx.pre =
    {
        {percent=1.0, anim="active_pre", radius=0, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=.1},
        {percent=1.0-(24/42), sound="dontstarve/common/campfire", radius=1, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
        {percent=0.0, sound="dontstarve/common/campfire", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
    }
    inst.components.geyserfx.levels =
    {
        {percent=1.0, anim="active_loop", sound="dontstarve/common/campfire", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
    }
    inst.components.geyserfx.pst =
    {
        {percent=1.0, anim="active_pst", sound="dontstarve/common/campfire", radius=3.5, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=1},
        {percent=1.0-(61/96), sound="dontstarve/common/fireOut", radius=0, intensity=.8, falloff=.33, colour = {255/255,187/255,187/255}, soundintensity=.1},
    }


    if not inst.components.fueled:IsEmpty() then
        OnIgnite(inst)
    end
	
    --[[
    inst:DoTaskInTime(1, function()
        if inst:GetIsFlooded() then 
            onFloodedStart(inst)
        end 
    end)
	--]]

    inst.OnIgnite = OnIgnite
    inst.OnErupt = OnErupt
    inst.OnBurn = OnBurn
    inst.OnIdle = OnIdle

    return inst
end

return Prefab( "flamegeyser", fn, assets)