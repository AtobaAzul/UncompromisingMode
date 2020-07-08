local assets=
{
	Asset("ANIM", "anim/lava_vomit.zip"),
}

local function OnLoad(inst, data)
	inst:Remove()
end

local function GetStatus(inst, viewer)
    if inst.cooled then return "COOL" end
    return "HOT"
end

local INTENSITY = .8

local function fade_in(inst)
    inst.components.fader:StopAll()
    inst.Light:Enable(true)
    inst.components.fader:Fade(0, INTENSITY, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end)
end

local function fade_out(inst)
    inst.components.fader:StopAll()
    inst.components.fader:Fade(INTENSITY, 0, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end, function() inst.Light:Enable(false) end)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    inst.AnimState:SetBank("lava_vomit")
    inst.AnimState:SetBuild("lava_vomit")
    inst.Transform:SetFourFaced()

    -- inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    -- inst.AnimState:SetLayer( LAYER_BACKGROUND )
    -- inst.AnimState:SetSortOrder( 3 )
    
    inst:AddComponent("fader")
	inst.entity:AddLight()
    inst.entity:AddNetwork()
    local light = inst.entity:AddLight()
    light:SetFalloff(.5)
    light:SetIntensity(INTENSITY)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(200/255, 100/255, 170/255)
    fade_in(inst)
	--[[
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
]]
    inst.AnimState:PlayAnimation("dump")
    inst.AnimState:PushAnimation("idle_loop")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    MakeLargePropagator(inst)
    inst.components.propagator.heatoutput = 24
    inst.components.propagator.decayrate = 0
    inst.components.propagator:Flash()
    inst.components.propagator:StartSpreading()

    inst.cooltask = inst:DoTaskInTime(3, function(inst) 
    	inst.AnimState:PushAnimation("cool", false)
    	fade_out(inst)
        inst:DoTaskInTime(4*FRAMES, function(inst)
            inst.AnimState:ClearBloomEffectHandle()
        end)
    end)
    inst:ListenForEvent("animqueueover", function(inst)
   		inst.AnimState:SetPercent("cool", 1)
        if inst.components.propagator then 
            inst.components.propagator:StopSpreading()
            inst:RemoveComponent("propagator") 
        end
        inst.cooled = true
        inst:AddComponent("colourtweener")
        inst.components.colourtweener:StartTween({0,0,0,0}, 7, function(inst) inst:Remove() end)
    end)
      
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.cooled = false

    inst.OnLoad = OnLoad

    return inst
end

return Prefab( "common/objects/lavaspit", fn, assets)