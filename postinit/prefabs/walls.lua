local env = env
GLOBAL.setfenv(1, GLOBAL)

local anims =
{
    { threshold = 0,    anim = "broken" },
    { threshold = 0.4,  anim = "onequarter" },
    { threshold = 0.5,  anim = "half" },
    { threshold = 0.99, anim = "threequarter" },
    { threshold = 1,    anim = { "fullA", "fullB", "fullC" } },
}
local all_walls =
{
    "wall_stone",
    "wall_hay",
    "wall_wood",
    "wall_moonrock",
    "wall_ruins",
    "wall_dreadstone",
    "fence",
    "fence_gate",
}
local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
    inst:AddTag("wall")
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
    inst:RemoveTag("wall")
end

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            if type(v.anim) == "table" then
                -- get a stable animation, by basing it on world position
                local x, y, z = inst.Transform:GetWorldPosition()
                local x = math.floor(x)
                local z = math.floor(z)
                local q1 = #v.anim + 1
                local q2 = #v.anim + 4
                local t = (((x % q1) * (x + 3) % q2) + ((z % q1) * (z + 3) % q2)) % #v.anim + 1
                return v.anim[t]
            else
                return v.anim
            end
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
    if new_percent > 0 then
        if old_percent <= 0 then
            makeobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play .. "_hit")
        inst.AnimState:PushAnimation(anim_to_play, false)
    else
        if old_percent > 0 then
            clearobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play)
    end
end

env.AddPrefabPostInit("wall_stone", function(inst) --what's this for??
    if not TheWorld.ismastersim then
        return
    end

    if inst.components.health ~= nil then
        inst.components.health.ondelta = onhealthchange
        inst.components.health.nofadeout = true
    end
end)

for k, v in ipairs(all_walls) do
    env.AddPrefabPostInit(v, function(inst)
        inst:AddTag("snowpileblocker") --so snowpiles don't spread through walls
    end)
end

local thresholds = {
    0.3,
    0.5,
    0.9,
    1,
}

function NearestValue(table, number)
    local smallestSoFar, smallestIndex
    for i, y in ipairs(table) do
        if not smallestSoFar or (math.abs(number-y) < smallestSoFar) then
            smallestSoFar = math.abs(number-y)
            smallestIndex = i
        end
    end
    
    return table[smallestIndex]
end

local function DoRegen(inst)
    inst.components.workable:SetWorkLeft(5)
    inst.components.health:DoDelta(25)
    SpawnPrefab("shadow_teleport_in").Transform:SetPosition(inst.Transform:GetWorldPosition())
    --Remove sanity aura once we reach the reinforced portion
    if inst.components.health ~= nil and inst.components.health:GetPercent() > NearestValue(thresholds, inst.components.health:GetPercent()) and inst.components.sanityaura ~= nil then
        inst:RemoveComponent("sanityaura")
        if inst._regentask ~= nil then
        inst._regentask:Cancel()
        inst._regentask = nil
        end
    end
end

local function ToggleOrRestartRegen(inst, delay)
    print("toggle")
    --This will also reset the timer
    if inst._regentask ~= nil then
        inst._regentask:Cancel()
        inst._regentask = nil
        inst.OnLongUpdate = nil
    end

    if inst.components.health ~= nil and inst.components.health:GetPercent() < NearestValue(thresholds, inst.components.health:GetPercent()) then
        inst._regentask = inst:DoPeriodicTask(TUNING.SUPPORT_PILLAR_DREADSTONE_REGEN_PERIOD * 0.0125, DoRegen, delay or TUNING.SUPPORT_PILLAR_DREADSTONE_REGEN_PERIOD * 0.0125 + math.random())
    end
    --Sanity aura only when repairing the non-reinforced portion
    if inst._regentask ~= nil and inst.components.health ~= nil and inst.components.health:GetPercent() < NearestValue(thresholds, inst.components.health:GetPercent()) then
        if inst.components.sanityaura == nil then
            inst:AddComponent("sanityaura")
            inst.components.sanityaura.max_distsq = TUNING.SUPPORT_PILLAR_DREADSTONE_AURA_RADIUS * TUNING.SUPPORT_PILLAR_DREADSTONE_AURA_RADIUS
            inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
        end
    elseif inst.components.sanityaura ~= nil then
        inst:RemoveComponent("sanityaura")
    end
end


env.AddPrefabPostInit("wall_dreadstone", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    ToggleOrRestartRegen(inst)
    inst.components.health:SetAbsorptionAmountFromPlayer(0)
    inst:AddComponent("planarentity")
    inst:ListenForEvent("healthdelta", function(inst) ToggleOrRestartRegen(inst) end)
end)
