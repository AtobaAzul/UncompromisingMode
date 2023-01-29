local function SpawnMist(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    x = x - 44
    z = z - 44
    for i = 1, 5 do
        for k = 1, 5 do
            local shadow = SpawnPrefab("marshmist")
            local x1, z1
            x1 = x + math.random(-5, 5)
            z1 = z + math.random(-5, 5)
            shadow.Transform:SetPosition(x1, y, z1)
            x = x + 22 + math.random(-0.75, 0.75)
        end
        x = x - 110
        z = z + 22 + math.random(-0.75, 0.75)
    end
    inst:Remove()
end
local function fnspawner()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddDynamicShadow()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(0, SpawnMist)

    return inst
end

local function Shade(inst, shade)
    if not TheWorld.state.isdusk and inst ~= nil and inst.AnimState ~= nil and
        shade ~= nil then
        inst.AnimState:SetMultColour(shade, shade, shade, shade)
    end
end

local function FadeIn(inst, shade)
    Shade(inst, shade)
    if shade < 0.15 and TheWorld.state.isnight then
        inst.shade = shade + 0.005
        inst:DoTaskInTime(0.2, function(inst) FadeIn(inst, inst.shade) end)
    end
end

local function FadeOut(inst, shade)
    Shade(inst, shade)
    if shade > 0 and TheWorld.state.isday then
        inst.shade = shade - 0.005
        inst:DoTaskInTime(0.2, function(inst) FadeOut(inst, inst.shade) end)
    end
end

local function TrySwap(inst)
    if TheWorld.state.isnight then
        FadeIn(inst, 0)
    elseif TheWorld.state.isday then
        FadeOut(inst, 0.15)
    end
end

local function TrySwapSpectre(inst)
    if TheWorld.state.isnight or TheWorld.state.isdusk then
        FadeIn(inst, 0)
    elseif TheWorld.state.isday then
        FadeOut(inst, 0.15)
    end
end

local function WaterCheck(inst) -- Mist doesn't like the map borders (or areas outside of marsh)
    --[[if not inst.components.areaaware:CurrentlyInTag("MarshMist") then
inst:Remove()
end]]
    local x, y, z = inst.Transform:GetWorldPosition()
    if not (TheWorld.Map:IsAboveGroundAtPoint(x, y, z) and
        TheWorld.Map:IsAboveGroundAtPoint(x + 14, y, z) and
        TheWorld.Map:IsAboveGroundAtPoint(x - 14, y, z) and
        TheWorld.Map:IsAboveGroundAtPoint(x, y, z + 7) and
        TheWorld.Map:IsAboveGroundAtPoint(x, y, z - 7)) then
        inst:Remove()
    else
        TrySwap(inst)
    end
end

local function fnmist()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("marshmist")
    inst.AnimState:SetBuild("marshmist")
    inst.AnimState:SetBank("marshmist")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetScale(10, 8, 5)

    inst.AnimState:SetMultColour(0.15, 0.15, 0.15, 0.15)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:WatchWorldState("isnight", TrySwap)
    inst:WatchWorldState("isday", TrySwap)

    inst:AddComponent("areaaware")
    inst:DoTaskInTime(0.1, WaterCheck)
    return inst
end

local function fnmist_specter()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("marshmist")
    inst.AnimState:SetBuild("marshmist")
    inst.AnimState:SetBank("marshmist")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetScale(10, 8, 5)

    inst.AnimState:SetMultColour(0.15, 0.15, 0.15, 0.15)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then return inst end

    inst:WatchWorldState("isnight", TrySwapSpectre)
    inst:WatchWorldState("isday", TrySwapSpectre)
	inst:WatchWorldState("isdusk", TrySwapSpectre)

    inst:AddComponent("areaaware")
    return inst
end

return Prefab("marshmist", fnmist), Prefab("spectermist", fnmist_specter),Prefab("marshmist_spawner", fnspawner)
