local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("birdcage", function (inst)

local invalid_foods =
{
    "bird_egg",
    "bird_egg_cooked",
    "rottenegg",
    "monstermeat"
}

local function ShouldAcceptItem(inst, item)
    local seed_name = string.lower(item.prefab .. "_seeds")

    local can_accept = item.components.edible
        and (Prefabs[seed_name] 
        or item.prefab == "seeds"
        or item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT)

    if table.contains(invalid_foods, item.prefab) then
        can_accept = false
    end

    return can_accept
end
end)

-----------------------------------------------------------------
-- Bird dies if fed too much monster meat
-----------------------------------------------------------------
--TODO: Shorten functions here, and overwrite only (maybe use upvalue hacker)

env.AddPrefabPostInit("birdcage", function(inst)

local function OnBirdStarve(inst, bird)
    if inst.AnimationTask then
        inst.AnimationTask:Cancel()
        inst.AnimationTask = nil
    end
    inst.CAGE_STATE = "_death"

    inst.AnimState:PlayAnimation("death")
    inst.AnimState:PushAnimation("idle"..inst.CAGE_STATE, false)
    --PushStateAnim(inst, "idle", false)

    --Put loot on "shelf"
    local loot = GLOBAL.SpawnPrefab("smallmeat")
    inst.components.inventory:GiveItem(loot)
    inst.components.shelf:PutItemOnShelf(loot)

    --remove sleep tests, it's already dead
    inst.components.sleeper:SetSleepTest(nil)
    inst.components.sleeper:SetWakeTest(nil)
end

local function DigestFood(inst, food)
    if food == nil then return false end
    if food.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT then
        --If the food is meat:
            --Spawn an egg.
        inst.components.lootdropper:SpawnLootPrefab("bird_egg")
    else
        local seed_name = string.lower(food.prefab .. "_seeds")
        if Prefabs[seed_name] ~= nil then
            --If the food has a relavent seed type:
                --Spawn 1 or 2 of those seeds.
            local num_seeds = math.random(2)
            for k = 1, num_seeds do
                inst.components.lootdropper:SpawnLootPrefab(seed_name)
            end
                --Spawn regular seeds on a 50% chance.
            if math.random() < 0.5 then
                inst.components.lootdropper:SpawnLootPrefab("seeds")
            end
        else
            --Otherwise...
                --Spawn a poop 1/3 times.
            if math.random() < 0.33 then
                local loot = inst.components.lootdropper:SpawnLootPrefab("guano")
                loot.Transform:SetScale(.33, .33, .33)
            end
        end
    end

    --Refill bird stomach.
    local bird = (inst.components.occupiable and inst.components.occupiable:GetOccupant()) or nil
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)

        if food.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT then
            if  food.components.edible:GetHealth(inst) < 0 then --monster meat is currently the only negative health meat item
                if bird.monsterbelly ~= nil and bird.monsterbelly ~= 0 then 
                    bird.monsterbelly = bird.monsterbelly + 1
                else
                    bird.monsterbelly = 1
                end
            else
                if bird.monsterbelly ~= nil and bird.monsterbelly > 0 then
                    --If bird is fed meat, she reduces her monsterbelly
                    bird.monsterbelly = bird.monsterbelly - 1
                end
            end

            if bird.monsterbelly ~= nil and bird.monsterbelly >= 4 then
                -- After 4 monster meat, bird dies
                OnBirdStarve(inst, bird) 
            end
        end 
    end
end

local function OnGetItem(inst, giver, item)
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item~=nil and item.components.edible ~= nil and item.components.edible.foodtype ~= nil and
        (   item.components.edible.foodtype == GLOBAL.FOODTYPE.MEAT
            or item.prefab == "seeds"
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        inst.AnimState:PushAnimation("idle"..inst.CAGE_STATE, true)
        inst:DoTaskInTime(60 * GLOBAL.FRAMES, DigestFood, item)
    end
end


end)
--[[
env.AddPrefabPostInit("birdcage", function (inst)
    if inst ~= nil and inst.components.trader ~= nil then
        
    end
end)
--]]