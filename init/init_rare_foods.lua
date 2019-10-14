------------------------------------------------------------------------------------
-- Rarer foods - Decreases in frequency and yield of various food sources
------------------------------------------------------------------------------------
local seg_time = 30

local day_segs = 10
local dusk_segs = 4
local night_segs = 2

local day_time = seg_time * day_segs
local total_day_time = seg_time * 16

local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs

-----------------------------------------------------------------
-- stone fruits increased duration
-----------------------------------------------------------------
GLOBAL.TUNING.ROCK_FRUIT_REGROW =
{
    EMPTY = { BASE = 2*day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time },
    PREPICK = { BASE = seg_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 0 },
    PICK = { BASE = 3*day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time },
    CRUMBLE = { BASE = day_time*GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2*seg_time }
}

-----------------------------------------------------------------
-- No grow in winter
-----------------------------------------------------------------
-- Relevant: MakeNoGrowInWinter in standardcomponents.lua

-- Stone fruits bushs
AddPrefabPostInit("rock_avocado_bush", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Cactus
AddPrefabPostInit("cactus", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Oasis Cactus
AddPrefabPostInit("oasis_cactus", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-- Spiky twigs
AddPrefabPostInit("marsh_bush", function(inst)
    if inst~= nil and inst.components.pickable ~= nil then
        GLOBAL.MakeNoGrowInWinter(inst)
    end
end)

-----------------------------------------------------------------
-- Bunnies don't drop carrots anymore
-----------------------------------------------------------------
local beardlordloot = { "beardhair", "beardhair", "monstermeat" }
local regularloot = { }

local function LootSetupFunction(lootdropper)
    local guy = lootdropper.inst.causeofdeath
    if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        -- beard lord
        lootdropper:SetLoot(beardlordloot)
    else
        -- regular loot
        lootdropper:SetLoot(regularloot)
        lootdropper:AddRandomLoot("meat", 3)
        lootdropper:AddRandomLoot("manrabbit_tail", 1)
        lootdropper.numrandomloot = 1
    end
end
AddPrefabPostInit("bunnyman", function (inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then 
        inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
        LootSetupFunction(inst.components.lootdropper)
    end
end)

-----------------------------------------------------------------
-- Bunny huts respawn bunnies as often as pigs now
-----------------------------------------------------------------
AddPrefabPostInit("rabbithouse", function (inst)
    if inst ~= nil and inst.components.spawner ~= nil then 
        inst.components.spawner:Configure("bunnyman", GLOBAL.TUNING.TOTAL_DAY_TIME*4)
    end
end)

-----------------------------------------------------------------
-- Carrots and berry bushs are rare now
-- Relevant: regrowthmanager.lua, RabbitArea, RabbitTown,
-- RabbitCity, MooseGooseBreedingGrounds, moose_nest.lua, 
-- carrot_planted
-----------------------------------------------------------------
AddRoomPreInit("BGGrass", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.carrot_planted = 0.05 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
        room.contents.dsitributeprefabs.berrybush = 0.05 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
        room.contents.dsitributeprefabs.berrybush_juicy = 0.025 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.025
    end
end)

AddRoomPreInit("RabbitArea", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.carrot_planted = 0.15 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("RabbitTown", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.carrot_planted = 0.15 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("RabbitSinkhole", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.carrot_planted = 0.1 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("MooseGooseBreedingGrounds", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.carrot_planted = 0.1 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

-----------------------------------------------------------------
-- Mushrooms are rarer now, with exception of red ones
-----------------------------------------------------------------
--blue mushrooms
AddRoomPreInit("BlueMushForest", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.2 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("BlueMushMeadow", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.5 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("BlueSpiderForest", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.5 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("DropperDesolation", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.35 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("FungusNoiseForest", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.2 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)


AddRoomPreInit("FungusNoiseMeadow", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.5 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)


AddRoomPreInit("MagicalDeciduous", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.blue_mushroom = 0.5 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

--green mushrooms
AddRoomPreInit("GreenMushMeadow", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.green_mushroom = 1 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("GreenMushNoise", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.green_mushroom = 1 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)

AddRoomPreInit("MagicalDeciduous", function(room) 
    if room ~= nil and room.contents.dsitributeprefabs ~= nil then
        room.contents.dsitributeprefabs.green_mushroom = 1 * GLOBAL.TUNING.DSTU.FOOD_CARROT_PLANTED_APPEARANCE_PERCENT  -- Original rate is 0.05
    end
end)


-----------------------------------------------------------------
-- Bee box levels are 0,1,2,4 honey (from 0,1,3,6)
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
-- Haunting pig torches only creates the pig with 10% chance
-----------------------------------------------------------------
local function CustomTorchHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_RARE then
        inst.components.fueled:TakeFuelItem(SpawnPrefab("pigtorch_fuel"))
        inst.components.spawner:ReleaseChild()
    end
end

AddPrefabPostInit("pigtorch", function(inst)
    if inst~= nil and inst.components.hauntable ~= nil then
        --TODO fix AddHauntableCustomReaction(inst, CustomTorchHaunt, true, nil, true)
    end
end)

-----------------------------------------------------------------
-- Tree growth is slower
-----------------------------------------------------------------
local xc = GLOBAL.TUNING.DSTU.TREE_GROWTH_TIME_INCREASE

GLOBAL.TUNING.EVERGREEN_GROW_TIME =
{
    {base=1.5*day_time*xc, random=0.5*day_time},   --short
    {base=5*day_time*xc, random=2*day_time},   --normal
    {base=5*day_time*xc, random=2*day_time},   --tall
    {base=1*day_time*xc, random=0.5*day_time}   --old
}

GLOBAL.TUNING.TWIGGY_TREE_GROW_TIME =
{
    {base=1.5*day_time*xc, random=0.5*day_time},   --short
    {base=3*day_time*xc, random=1*day_time},   --normal
    {base=3*day_time*xc, random=1*day_time},   --tall
    {base=5*day_time*xc, random=0.5*day_time}   --old
}

GLOBAL.TUNING.PINECONE_GROWTIME = {base=0.75*day_time*xc, random=0.25*day_time}

GLOBAL.TUNING.DECIDUOUS_GROW_TIME =
{
    {base=1.5*day_time*xc, random=0.5*day_time},   --short
    {base=5*day_time*xc, random=2*day_time},   --normal
    {base=5*day_time*xc, random=2*day_time},   --tall
    {base=1*day_time*xc, random=0.5*day_time}   --old
}

-----------------------------------------------------------------
-- TODO:carrots sometimes are other veggies
-----------------------------------------------------------------