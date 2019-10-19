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
-- Reduce seed spawn chance
-----------------------------------------------------------------
--TODO: this is not working
local RAND_TIME_MIN = FOOD_BIRD_SEED_SPAWN_MIN_RANDOM_TIME
local RAND_TIME_MAX = FOOD_BIRD_SEED_SPAWN_MAX_RANDOM_TIME
AddPrefabPostInit("crow", function(inst)
    if inst~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN,RAND_TIME_MAX)
    end
end)

AddPrefabPostInit("robin_winter", function(inst)
    if inst~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN,RAND_TIME_MAX)
    end
end)

AddPrefabPostInit("robin", function(inst)
    if inst~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN,RAND_TIME_MAX)
    end
end)


-----------------------------------------------------------------
-- Reduce butterfly spawn chance
-----------------------------------------------------------------
GLOBAL.TUNING.BUTTERFLY_SPAWN_TIME = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_SPAWN_TIME_INCREASE
--TODO: Fix, this doesn't work

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

local function SetBeardLord(inst)
    inst.beardlord = true
    if inst.clearbeardlordtask ~= nil then
        inst.clearbeardlordtask:Cancel()
    end
    inst.clearbeardlordtask = inst:DoTaskInTime(5, ClearBeardlord)
end

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function LootSetupFunction(lootdropper)
    if lootdropper.inst ~= nil then 
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
end

AddPrefabPostInit("bunnyman", LootSetupFunction, IsCrazyGuy, SetBeardLord)
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
-- Butterflies appearance rate depends on nr of players
-----------------------------------------------------------------
--TODO complicated but doable
--[[local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
AddClassPostConstruct("components/butterflyspawner", function(self)
    local _activeplayers = UpvalueHacker.GetUpvalue(self, "ScheduleSpawn", "_activeplayers")
    local _scheduledtasks = UpvalueHacker.GetUpvalue(self, "ScheduleSpawn", "_scheduledtasks")
    --Get the old functions using upvalue hacker
    local SpawnButterflyForPlayer = UpvalueHacker.GetUpvalue(self, "ScheduleSpawn", "SpawnButterflyForPlayer")
    local ScheduleSpawn = UpvalueHacker.GetUpvalue(self, "ScheduleSpawn", "ScheduleSpawn")
    

    local function ScheduleSpawn(player, initialspawn)
        if _scheduledtasks[player] == nil then
            local basedelay = initialspawn and 0.3 or 10
            _scheduledtasks[player] = player:DoTaskInTime(basedelay + math.random() * 10 * #_activeplayers, SpawnButterflyForPlayer, ScheduleSpawn)
                                                                                    --^ Here we lower chance based on player nr
        end
    end
    --Now replace the function with our modified one
    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.butterflyspawner.fn, ScheduleSpawn, "ScheduleSpawn")
end
AddPrefabPostInit("world", function(inst)
    
end)]]

-----------------------------------------------------------------
-- Bees don't drop honey no more
-----------------------------------------------------------------
local stinger_only = { "stinger" }
AddPrefabPostInit("bee", function(inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(stinger_only)
    end
end)

AddPrefabPostInit("killerbee", function(inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(stinger_only)
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
        inst.components.fueled:TakeFuelItem(GLOBAL.SpawnPrefab("pigtorch_fuel"))
        inst.components.spawner:ReleaseChild()
    end
end

AddPrefabPostInit("pigtorch", function(inst)
    if inst~= nil and inst.components.hauntable ~= nil then
        inst.components.hauntable:SetOnHauntFn(CustomTorchHaunt)
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
-- Gobblers drop only 1 leg
-----------------------------------------------------------------
local single_drumstick =
{
    "drumstick",
}
AddPrefabPostInit("perd", function(inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(single_drumstick)
    end
end)

-----------------------------------------------------------------
-- Koela drop only 4 meat (like beefalos)
-----------------------------------------------------------------
local loot_summer = {"meat","meat","meat","meat","trunk_summer"}
local loot_winter = {"meat","meat","meat","meat","trunk_winter"}
local loot_fire = {"meat","meat","meat","meat","trunk"}

local function lootsetfn(lootdropper)
    if lootdropper.inst.components.burnable ~= nil and lootdropper.inst.components.burnable:IsBurning() or lootdropper.inst:HasTag("burnt") then
        lootdropper:SetLoot(loot_fire)
    end
end

AddPrefabPostInit("koalefant_summer", function(inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLootSetupFn(lootsetfn)
        inst.components.lootdropper:SetLoot(loot_summer)
    end
end)

AddPrefabPostInit("koalefant_winter", function(inst)
    if inst ~= nil and inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLootSetupFn(lootsetfn)
        inst.components.lootdropper:SetLoot(loot_winter)
    end
end)