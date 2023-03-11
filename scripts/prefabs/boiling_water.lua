local function fn()
    local inst = CreateEntity()

    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.AnimState:SetBuild("crab_king_bubble_fx")
    inst.AnimState:SetBank("Bubble_fx")
    inst.AnimState:PlayAnimation("bubbles_" .. tostring(math.random(1, 3)))

    inst.entity:SetPristine()

    inst:AddTag("FX")
    inst:AddTag("scarytoprey")
    inst:AddTag("scarytooceanprey")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("animover", inst.Remove)

    inst:DoTaskInTime(0, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 6, {"_health"}, { "dead", "INLIMBO" }, { "_combat", "boat"})
        local oceanfish = TheSim:FindEntities(x, y, z, 4, { "oceanfishable" }, { "INLIMBO" })

        for k, v in ipairs(ents) do
            local x1, y1, z1 = v.Transform:GetWorldPosition()
            if v:GetCurrentPlatform() == nil and TheWorld.Map:IsOceanAtPoint(x1, y1, z1) and not v:HasTag("flying") and not v:HasTag("boat") and v.prefab ~= "waterplant" then
                v.components.health:DoDelta(-34)
            elseif v:HasTag("boat") then
                v.components.health:DoDelta(-5)
            end
        end

        for k, v in ipairs(oceanfish) do
            if v.components.oceanfishable ~= nil and v.fish_def ~= nil and v.fish_def.loot ~= nil and v.prefab ~= "oceanfish_small_9" then
                for i, product in ipairs(v.fish_def.loot) do
                    local loot = SpawnPrefab(product)
                    if loot ~= nil then
                        local ae_x, ae_y, ae_z = v.Transform:GetWorldPosition()
                        loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                    end
                end
                v:Remove()
            end
        end
    end)

    return inst
end

local function DoBubbleFX(inst)
    for i = 1, math.random(2, 4) do
        local x, y, z = inst.Transform:GetWorldPosition()
        if x == nil or y == nil or z == nil then
            break
        end
        local fx = SpawnPrefab("boiling_water")
        local x1, y1, z1 = x + math.random(-5, 5), 0, z + math.random(-5, 5)
        if TheWorld.Map:IsOceanAtPoint(x1, y1, z1) and TheWorld.Map:GetPlatformAtPoint(x1, z1) == nil then
            fx.Transform:SetPosition(x1, y1, z1)
        end
    end

    for i = 1, math.random(2, 4) do
        local x, y, z = inst.Transform:GetWorldPosition()
        if x == nil or y == nil or z == nil then
            break
        end
        local fx = SpawnPrefab("slow_steam_fx"..math.random(5))
        local x1, y1, z1 = x + math.random(-5, 5), 0, z + math.random(-5, 5)
        if TheWorld.Map:IsOceanAtPoint(x1, y1, z1) and TheWorld.Map:GetPlatformAtPoint(x1, z1) == nil then
            fx.Transform:SetPosition(x1, y1, z1)
        end
    end


    inst.count = inst.count + 1
    if inst.count > 10 then
        inst:Remove()
    else
        inst.bubbletask:Cancel()
        inst.bubbletask = nil
        inst.bubbletask = inst:DoTaskInTime(0.25+math.random(), DoBubbleFX)
    end
end

local function fn_spawner()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("CLASSIFIED")
    inst.count = 0
    inst.bubbletask = inst:DoTaskInTime(0.25+math.random(), DoBubbleFX)

    return inst
end

return Prefab("boiling_water", fn), Prefab("boiling_water_spawner", fn_spawner)
