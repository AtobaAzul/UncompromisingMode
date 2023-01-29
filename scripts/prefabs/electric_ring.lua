
local function Scorch_OnUpdateFade(inst)
    inst.alpha = math.max(0, inst.alpha - (1/90) )
    inst.AnimState:SetMultColour(1, 1, 1,  inst.alpha)
    if inst.alpha == 0 then
        inst:Remove()
    end
end

local function scorchfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
    --[[inst.AnimState:SetBuild("electric_explosion_fx")
    inst.AnimState:SetBank("electric_explosion_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)]]

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.Transform:SetScale(0.85,0.85,0.85)

    --inst.alpha = 1

    --[[inst:DoTaskInTime(0.7,function(inst)
        inst:DoPeriodicTask(0, Scorch_OnUpdateFade)
    end)]]

    --inst.Transform:SetRotation(math.random() * 360)
	inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    return inst
end

local function explosionfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()    
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 1, 1)

	inst.entity:SetPristine()

	
    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst.AnimState:SetBuild("electric_explosion")
    inst.AnimState:SetBank("electric_explosion")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1,1,1)
	inst.Light:Enable(true)
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)

    return inst
end

return Prefab("electric_explosion_fx",scorchfn),
       Prefab("electric_explosion", explosionfn)