------------------------------------------------------------------------------------
-- Value changes of foods
-- Modify them through AddPrefabPostInit with these components inside:
--  inst.components.edible.hungervalue = X
--  inst.components.edible.healthvalue = X
--  inst.components.edible.sanityvalue = X
--  inst.components.perishable:SetPerishTime(ONE_DAY * X)
-- Note: For crocpot food changes, use the require "cooking" module and change cooking.recipes.cookpot
------------------------------------------------------------------------------------

-----------------------------------------------------------------
-- Food attribute changes
-----------------------------------------------------------------
local require = GLOBAL.require
local cooking = require "cooking"
local recipes = cooking.recipes.cookpot

recipes.perogies.perishtime = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_PEROGI_PERISH -- Changed to 10 days, down from 20
recipes.meatballs.hunger = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_MEATBALL_HUNGER -- Changed to 50, down from 62.5

-----------------------------------------------------------------
-- Bee box levels are 0,1,2,4 (from 0,1,3,6)
-----------------------------------------------------------------
AddPrefabPostInit("beebox", function (inst)
    levels =
    {
        { amount=3, idle="honey3", hit="hit_honey3" },
        { amount=2, idle="honey2", hit="hit_honey2" },
        { amount=1, idle="honey1", hit="hit_honey1" },
        { amount=0, idle="bees_loop", hit="hit_idle" },
    }
end)


-----------------------------------------------------------------
-- Prevent cooked eggs birdcage infinite loop
-----------------------------------------------------------------
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

AddPrefabPostInit("birdcage", function (inst)
    if inst ~= nil and inst.components ~= nil then
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    end
end)

-----------------------------------------------------------------
-- Bird dies if fed too much monster meat
-----------------------------------------------------------------
--TODO: Shorten functions here, and overwrite only

local function DigestFood(inst, food)
    if food.components.edible.foodtype == FOODTYPE.MEAT then
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
    local bird = GetBird(inst)
    if bird and bird:IsValid() and bird.components.perishable then
        bird.components.perishable:SetPercent(1)
    end

    --TODO:Bird dies if too much meat is given
    if food.components.edible.foodtype == FOODTYPE.MEAT and 
       food.components.edible:GetHealth(inst) < 0 then --monster meat is currently the only negative health meat item
        OnBirdStarve()
    end    
end

local function OnGetItem(inst, giver, item)
    --If you're sleeping, wake up.
    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    if item.components.edible ~= nil and
        (   item.components.edible.foodtype == FOODTYPE.MEAT
            or item.prefab == "seeds"
            or Prefabs[string.lower(item.prefab .. "_seeds")] ~= nil
        ) then
        --If the item is edible...
        --Play some animations (peck, peck, peck, hop, idle)
        inst.AnimState:PlayAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("peck")
        inst.AnimState:PushAnimation("hop")
        PushStateAnim(inst, "idle", true)
        --Digest Food in 60 frames.
        inst:DoTaskInTime(60 * FRAMES, DigestFood, item)
    end
end

AddPrefabPostInit("birdcage", DigestFood)
AddPrefabPostInit("birdcage", OnGetItem)
AddPrefabPostInit("birdcage", function (inst)
    if inst ~= nil and inst.components.trader ~= nil then
        inst.components.trader.onaccept = OnGetItem
    end
end)

-----------------------------------------------------------------
-- butterfly health reduced (5)
-----------------------------------------------------------------
AddPrefabPostInit("butterflywings", function (inst)
    if inst ~= nil and inst.components.edible ~= nil then
        inst.components.edible.healthvalue = GLOBAL.TUNING.DSTU.RECIPE_CHANGE_BUTTERFLY_WING_HEALTH
    end
end)