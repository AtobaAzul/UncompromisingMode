local function ClearTrees(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local tree = TheSim:FindEntities(x, y, z, 12, {"tree"}, {"canopy"})
    for i, v in ipairs(tree) do
        v:Remove()
    end
    inst:Remove() --Finished spawning, now go delete yourself
end

local function SpawnWidowWeb(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local web = SpawnPrefab("widowweb")
    web.Transform:SetPosition(x, y, z)
end

local function TrySpawnCocoon(x, z)
    local xi = x + math.random(-12, 12)
    local zi = z + math.random(-12, 12)
    if #TheSim:FindEntities(xi, 0, zi, 1.5, {"webbedcreature"}) == 0 and
       #TheSim:FindEntities(xi, 0, zi, 3, {"webbedcreature"}) < 2 and
       #TheSim:FindEntities(xi, 0, zi, 5, {"webbedcreature"}) < 6 then
        local cocoon = SpawnPrefab("webbedcreature")
        cocoon.Transform:SetPosition(xi, 0, zi)
    else
        TrySpawnCocoon(x, z)
    end
end

local function SpawnCocoon(inst)
    local cap = math.random(8, 10)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 1, cap do
        TrySpawnCocoon(x, z)
    end
end

local function TrySpawnDecor(x, z, type)
    local xi = x + math.random(-12, 12)
    local zi = z + math.random(-12, 12)
    if #TheSim:FindEntities(xi, 0, zi, 1.5, {"webbedcreature", "webdecor"}) == 0 and
       #TheSim:FindEntities(xi, 0, zi, 3, {"webbedcreature", "webdecor"}) < 2 and
       #TheSim:FindEntities(xi, 0, zi, 5, {"webbedcreature", "webdecor"}) < 6 and
       math.abs(xi) > 6 and math.abs(zi) > 6 then
        local cocoon = SpawnPrefab("widowdecor")
        cocoon.Transform:SetPosition(xi, 9, zi)
        cocoon.category = type
        cocoon.AnimState:PlayAnimation(type)
    else
        TrySpawnDecor(x, z, type)
    end
end

local function SpawnDecor(inst)
    local cap = 4
    local x, y, z = inst.Transform:GetWorldPosition()
    for j = 1, math.random(3, 4) do
        for i = 1, cap do
            local type = i
            TrySpawnDecor(x, z, type)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --inst:AddTag("CLASSIFIED")

    inst:DoTaskInTime(0, SpawnWidowWeb)
    inst:DoTaskInTime(0, SpawnCocoon)
    inst:DoTaskInTime(0, SpawnDecor)
    inst:DoTaskInTime(0.1, ClearTrees)

    return inst
end

return Prefab("widowwebspawner", fn)
