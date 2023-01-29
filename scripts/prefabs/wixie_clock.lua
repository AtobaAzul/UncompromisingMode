local assets =
{
    Asset("ANIM", "anim/wixie_clock.zip"),
    Asset("ANIM", "anim/wixie_clock_hands.zip"),
    Asset("ANIM", "anim/wixie_dangley.zip"),
}

local prefabs =
{
}

local function InitializeClockPieces(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	inst.second = SpawnPrefab("wixie_clockhand_second")
	inst.minute = SpawnPrefab("wixie_clockhand_minute")
	inst.hour = SpawnPrefab("wixie_clockhand_hour")
	
	inst.seconddangle = SpawnPrefab("wixie_clockdangley1")
	inst.minutedangle = SpawnPrefab("wixie_clockdangley2")
	inst.hourdangle = SpawnPrefab("wixie_clockdangley3")
	
	inst.front = SpawnPrefab("wixie_clockfront")
	
	inst.front.Transform:SetPosition(x, y - 0.1, z)
	
	inst.second.entity:SetParent(inst.entity)
	inst.second.Transform:SetPosition(0,0,0)
	inst.entity:AddFollower()
	
	inst.minute.entity:SetParent(inst.entity)
	inst.minute.Transform:SetPosition(0,0,0)
	inst.entity:AddFollower()
	
	inst.hour.entity:SetParent(inst.entity)
	inst.hour.Transform:SetPosition(0,0,0)
	inst.entity:AddFollower()
	
	--inst.seconddangle.entity:SetParent(inst.entity)
	inst.seconddangle.Transform:SetPosition(x, y - 0.05, z)
	inst.seconddangle.myhand = inst.second
	
	--inst.minutedangle.entity:SetParent(inst.entity)
	inst.minutedangle.Transform:SetPosition(x, y - 0.06, z)
	inst.minutedangle.myhand = inst.minute
	
	--inst.hourdangle.entity:SetParent(inst.entity)
	inst.hourdangle.Transform:SetPosition(x, y - 0.06, z)
	inst.hourdangle.myhand = inst.hour
end

local function fn(Sim)
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	--inst.entity:AddMiniMapEntity()
	--inst.MiniMapEntity:SetIcon("veteranshrine_map.tex")

    inst.AnimState:SetBuild("wixie_clock")    
    inst.AnimState:SetBank("wixie_clock")
    inst.AnimState:PlayAnimation("idle", true)
	
	--MakeObstaclePhysics(inst, .2)
	--inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:DoTaskInTime(1, InitializeClockPieces)

    return inst
end

local function fncommon(handtype, startpoint)
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_clock_hands")    
    inst.AnimState:SetBank("wixie_clock_hands")
	inst.AnimState:PlayAnimation(handtype..startpoint, false)
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.handtype = handtype
	
	inst.persists = false
	
    return inst
end

local function minfn()
    local inst = fncommon("min", 12)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function secfn()
    local inst = fncommon("sec", 4)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function hourfn()
    local inst = fncommon("hour", 8)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function OnActivate(inst)
	if inst.count >= 12 then
		inst.count = 1
	else
		inst.count = inst.count + 1
	end


	if inst.myhand ~= nil then
		inst.myhand.AnimState:PlayAnimation(inst.myhand.handtype..inst.count, false)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
	end
	
	inst.AnimState:SetPercent(inst.dangletype, ((1 / 12) * inst.count))
	
	inst.components.activatable.inactive = true
end

local function fncommondangle(dangle, startpoint)
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_dangley")    
    inst.AnimState:SetBank("wixie_dangley")
	inst.AnimState:SetPercent(dangle, ((1 / 12) * startpoint))
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.dangletype = dangle
	inst.myhand = nil
	inst.count = startpoint
	
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	
	inst.persists = false

    return inst
end

local function dangle1fn()
    local inst = fncommondangle("dangley1", 4)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function dangle2fn()
    local inst = fncommondangle("dangley2", 12)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function dangle3fn()
    local inst = fncommondangle("dangley3", 8)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function frontfn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_clock")    
    inst.AnimState:SetBank("wixie_clock")
	inst.AnimState:PlayAnimation("back")
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false

    return inst
end

return Prefab("wixie_clock", fn, assets, prefabs),
		Prefab("wixie_clockhand_minute", minfn, assets, prefabs),
		Prefab("wixie_clockhand_second", secfn, assets, prefabs),
		Prefab("wixie_clockhand_hour", hourfn, assets, prefabs),
		Prefab("wixie_clockdangley1", dangle1fn, assets, prefabs),
		Prefab("wixie_clockdangley2", dangle2fn, assets, prefabs),
		Prefab("wixie_clockdangley3", dangle3fn, assets, prefabs),
		Prefab("wixie_clockfront", frontfn, assets, prefabs)