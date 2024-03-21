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
-- TODO: this is not working
--[[
local RAND_TIME_MIN = FOOD_BIRD_SEED_SPAWN_MIN_RANDOM_TIME
local RAND_TIME_MAX = FOOD_BIRD_SEED_SPAWN_MAX_RANDOM_TIME
AddPrefabPostInit("crow", function(inst)
    if inst ~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN, RAND_TIME_MAX)
    end
end)

AddPrefabPostInit("robin_winter", function(inst)
    if inst ~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN, RAND_TIME_MAX)
    end
end)

AddPrefabPostInit("robin", function(inst)
    if inst ~= nil and inst.components.periodicspawner ~= nil then
        inst.components.periodicspawner:SetRandomTimes(RAND_TIME_MIN, RAND_TIME_MAX)
    end
end)]]

-----------------------------------------------------------------
-- Butterflies appearance rate depends on nr of players
-----------------------------------------------------------------
-- TODO complicated
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
GLOBAL.TUNING.BUTTERFLY_SPAWN_TIME = GLOBAL.TUNING.DSTU.FOOD_BUTTERFLY_SPAWN_TIME_INCREASE
-- TODO: Fix, this doesn't work

-----------------------------------------------------------------
-- stone fruits increased duration
-----------------------------------------------------------------
GLOBAL.TUNING.ROCK_FRUIT_REGROW = {
    EMPTY = { BASE = 2 * day_time * GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2 * seg_time },
    PREPICK = { BASE = seg_time * GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 0 },
    PICK = { BASE = 3 * day_time * GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2 * seg_time },
    CRUMBLE = { BASE = day_time * GLOBAL.TUNING.DSTU.STONE_FRUIT_GROWTH_INCREASE, VAR = 2 * seg_time } }

-----------------------------------------------------------------
-- No grow in winter
-----------------------------------------------------------------
-- Relevant: MakeNoGrowInWinter in standardcomponents.lua

local function ToggleGrowable(inst, iswinter)
    if iswinter then
        if inst.components.growable ~= nil then
            inst.components.growable:Pause()
        end

        if inst.components.pickable ~= nil then
            inst.components.pickable:Pause()
        end
    else
        if inst.components.growable ~= nil then
            inst.components.growable:Resume()
        end

        if inst.components.pickable ~= nil then
            inst.components.pickable:Resume()
        end
    end
end

local _MakeNoGrowInWinter = GLOBAL.MakeNoGrowInWinter

function GLOBAL.MakeNoGrowInWinter(inst)
    inst:WatchWorldState("iswinter", ToggleGrowable)
    ToggleGrowable(inst, GLOBAL.TheWorld.state.iswinter)
    _MakeNoGrowInWinter(inst)
end

if GetModConfigData("no_winter_growing") then
    -- Stone fruits bushs
    AddPrefabPostInit("rock_avocado_bush", function(inst)
        if inst ~= nil and inst.components.pickable ~= nil then
            GLOBAL.MakeNoGrowInWinter(inst)
        end
    end)

    -- cherry tomatos
    AddPrefabPostInit("cherrytomato_planted", function(inst)
        if inst ~= nil and inst.components.pickable ~= nil then
            GLOBAL.MakeNoGrowInWinter(inst)
        end
    end)

    -- Cactus
    AddPrefabPostInit("cactus", function(inst)
        if inst ~= nil and inst.components.pickable ~= nil then
            GLOBAL.MakeNoGrowInWinter(inst)
        end
    end)

    -- Oasis Cactus
    AddPrefabPostInit("oasis_cactus", function(inst)
        if inst ~= nil and inst.components.pickable ~= nil then
            GLOBAL.MakeNoGrowInWinter(inst)
        end
    end)

    -- Bullkelp
    AddPrefabPostInit("bullkelp_plant", function(inst)
        if inst ~= nil and inst.components.pickable ~= nil then
            GLOBAL.MakeNoGrowInWinter(inst)
        end
    end)

    -- Farm Crops
    local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
    for k, v in pairs(PLANT_DEFS) do
        AddPrefabPostInit(v.prefab, function(inst)
            inst:WatchWorldState("iswinter", ToggleGrowable)
            ToggleGrowable(inst, GLOBAL.TheWorld.state.iswinter)
        end)
    end

    -- Weeds
    local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
    for k, v in pairs(WEED_DEFS) do
        AddPrefabPostInit(v.prefab, function(inst)
            inst:WatchWorldState("iswinter", ToggleGrowable)
            ToggleGrowable(inst, GLOBAL.TheWorld.state.iswinter)
        end)
    end

    -- Banana Bushes
    AddPrefabPostInit("bananabush", function(inst)
        inst:WatchWorldState("iswinter", ToggleGrowable)
        ToggleGrowable(inst, GLOBAL.TheWorld.state.iswinter)
    end)

    -- Extra check for Farm Crops, Banana Bushes, and Stone Fruit
    AddComponentPostInit("growable", function(self)
        local _OldResume = self.Resume

        function self:Resume()
            if (self.inst:HasTag("farm_plant") or self.inst:HasTag("bananabush") or self.inst.prefab == "rock_avocado_bush") and GLOBAL.TheWorld.state.iswinter then
				return false
            else
                return _OldResume(self)
            end
        end

        local _OldStartGrowing = self.StartGrowing

        function self:StartGrowing(time)
            if (self.inst:HasTag("bananabush") or self.inst.prefab == "rock_avocado_bush") and GLOBAL.TheWorld.state.iswinter then
				return false
            else
                return _OldStartGrowing(self, time)
            end
        end
    end)

	AddComponentPostInit("pickable", function(self)
		local _OldResume = self.Resume

		function self:Resume()
			if (self.inst:HasTag("bananabush") or self.inst.prefab == "rock_avocado_bush") and GLOBAL.TheWorld.state.iswinter then
				return false
			else
				return _OldResume(self)
			end
		end
	end)

    PLANT_DEFS.potato.good_seasons = { autumn = true, spring = true }
    PLANT_DEFS.carrot.good_seasons = { autumn = true, spring = true, summer = true }
    PLANT_DEFS.pumpkin.good_seasons = { autumn = true, summer = true }
    PLANT_DEFS.asparagus.good_seasons = { spring = true, autumn = true }
end
-----------------------------------------------------------------
-- Bunnies don't drop carrots anymore
-----------------------------------------------------------------
local beardlordloot = { "beardhair", "beardhair", "monstermeat" }

local function SetBeardLord(inst)
    inst.beardlord = true
    if inst.clearbeardlordtask ~= nil then
        inst.clearbeardlordtask:Cancel()
    end
    inst.clearbeardlordtask = inst:DoTaskInTime(5, ClearBeardlord)
end

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and
    sanity:GetPercentNetworked() <=
    (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end
--[[
local function LootSetupFunction(lootdropper)
    if lootdropper.inst ~= nil then
        local guy = lootdropper.inst.causeofdeath

        if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
            -- beard lord
            lootdropper:SetLoot(beardlordloot)
        else
            -- regular loot
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
]]
local rabbitloot = { "smallmeat" }
local forced_beardlingloot = { "nightmarefuel" }

local function SetRabbitLoot(lootdropper)
    if lootdropper.loot ~= rabbitloot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(rabbitloot)
    end
end

local function SetBeardlingLoot(lootdropper)
    if lootdropper.loot == rabbitloot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(nil)
        lootdropper:AddRandomLoot("beardhair", .5)
        lootdropper:AddRandomLoot("monstersmallmeat", 1)
        lootdropper:AddRandomLoot("nightmarefuel", 1)
        lootdropper.numrandomloot = 1
    end
end

local function SetForcedBeardlingLoot(lootdropper)
    if not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(forced_beardlingloot)
        if math.random() < .5 then
            lootdropper:AddRandomLoot("beardhair", .5)
            lootdropper:AddRandomLoot("monstersmallmeat", 1)
            lootdropper.numrandomloot = 1
        end
    end
end

local function IsForcedNightmare(inst) return inst.components.timer:TimerExists("forcenightmare") end

local function LootSetupFunction_jack(lootdropper)
    local guy = lootdropper.inst.causeofdeath
    if IsForcedNightmare(lootdropper.inst) then
        SetForcedBeardlingLoot(lootdropper)
    elseif IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        SetBeardlingLoot(lootdropper)
    else
        SetRabbitLoot(lootdropper)
    end
end
if GetModConfigData("monstersmallmeat") then
    AddPrefabPostInit("rabbit", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end
        if inst ~= nil and inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SetLootSetupFn(LootSetupFunction_jack)
            LootSetupFunction_jack(inst.components.lootdropper)
        end
    end)
end
-----------------------------------------------------------------
-- Bunny huts respawn bunnies not as often
-----------------------------------------------------------------
--[[
AddPrefabPostInit("rabbithouse", function (inst)
    if inst ~= nil and inst.components.spawner ~= nil then
        inst.components.spawner:Configure("bunnyman", GLOBAL.TUNING.TOTAL_DAY_TIME*GLOBAL.TUNING.DSTU.BUNNYMAN_RESPAWN_TIME_DAYS)
    end
end)]]

-----------------------------------------------------------------
-- Bees don't drop honey no more
-----------------------------------------------------------------
local stinger_only = { "stinger" }
AddPrefabPostInit("bee", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(stinger_only)
    end
end)

AddPrefabPostInit("killerbee", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot(stinger_only)
    end
end)

-----------------------------------------------------------------
-- Bee box levels are 0,1,2,4 honey (from 0,1,3,6)
-----------------------------------------------------------------
local HONEY_PER_STAGE = GLOBAL.TUNING.DSTU.FOOD_HONEY_PRODUCTION_PER_STAGE

levels = {
    { amount = HONEY_PER_STAGE[4], idle = "honey3",    hit = "hit_honey3" },
    { amount = HONEY_PER_STAGE[3], idle = "honey2",    hit = "hit_honey2" },
    { amount = HONEY_PER_STAGE[2], idle = "honey1",    hit = "hit_honey1" },
    { amount = HONEY_PER_STAGE[1], idle = "bees_loop", hit = "hit_idle" },
}

local function setlevel(inst, level)
    if not inst:HasTag("burnt") then
        if inst.anims == nil then
            inst.anims = { idle = level.idle, hit = level.hit }
        else
            inst.anims.idle = level.idle
            inst.anims.hit = level.hit
        end
        inst.AnimState:PlayAnimation(inst.anims.idle)
    end
end

local function updatelevel(inst)
    if not inst:HasTag("burnt") then
        for k, v in pairs(levels) do
            if inst.components.harvestable.produce >= v.amount then
                setlevel(inst, v)
                break
            end
        end
    end
end

local function onharvest(inst, picker, produce)
    if not inst:HasTag("burnt") then
        updatelevel(inst)
		if (picker ~= nil and picker.components.skilltreeupdater ~= nil and picker.components.skilltreeupdater:IsActivated("wormwood_bugs")) then
			if inst.components.childspawner ~= nil and not GLOBAL.TheWorld.state.iswinter and not GLOBAL.TheWorld.state.isdusk and not GLOBAL.TheWorld.state.isnight then
				inst.components.childspawner:ReleaseAllChildren()
			end
		end
        
		if not (picker ~= nil and picker.components.skilltreeupdater ~= nil and picker.components.skilltreeupdater:IsActivated("wormwood_bugs")) then
			if inst.components.childspawner ~= nil and not GLOBAL.TheWorld.state.iswinter then
				inst.components.childspawner:ReleaseAllChildren(picker)
			end
		end
	end
end

if GetModConfigData("beebox_nerf") then
    AddPrefabPostInit("beebox", function(inst)
        -- TODO, test this
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        if inst.components.harvestable ~= nil then
            inst.components.harvestable:SetUp("honey", HONEY_PER_STAGE[4], nil, onharvest, updatelevel)
        end
		
		inst:ListenForEvent("onharvest", onharvest)

        updatelevel(inst)
    end)

    AddPrefabPostInit("beebox_hermit", function(inst)
        -- TODO, test this
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        if inst.components.harvestable ~= nil then
            inst.components.harvestable:SetUp("honey", HONEY_PER_STAGE[4], nil, onharvest, updatelevel)
        end
		
		inst:ListenForEvent("onharvest", onharvest)

        updatelevel(inst)
    end)
end
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
    if inst ~= nil and inst.components.hauntable ~= nil then
        inst.components.hauntable:SetOnHauntFn(CustomTorchHaunt)
    end
end)

-----------------------------------------------------------------
-- Tree growth is slower
-----------------------------------------------------------------
local xc = GLOBAL.TUNING.DSTU.TREE_GROWTH_TIME_INCREASE

GLOBAL.TUNING.EVERGREEN_GROW_TIME = {
    { base = 1.5 * day_time * xc, random = 0.5 * day_time }, -- short
    { base = 5 * day_time * xc,   random = 2 * day_time }, -- normal
    { base = 5 * day_time * xc,   random = 2 * day_time }, -- tall
    { base = 1 * day_time * xc,   random = 0.5 * day_time } -- old
}

GLOBAL.TUNING.TWIGGY_TREE_GROW_TIME = {
    { base = 1.5 * day_time * xc, random = 0.5 * day_time }, -- short
    { base = 3 * day_time * xc,   random = 1 * day_time }, -- normal
    { base = 3 * day_time * xc,   random = 1 * day_time }, -- tall
    { base = 5 * day_time * xc,   random = 0.5 * day_time } -- old
}

GLOBAL.TUNING.PINECONE_GROWTIME = { base = 0.75 * day_time * xc, random = 0.25 * day_time }

GLOBAL.TUNING.DECIDUOUS_GROW_TIME = {
    { base = 1.5 * day_time * xc, random = 0.5 * day_time }, -- short
    { base = 5 * day_time * xc,   random = 2 * day_time }, -- normal
    { base = 5 * day_time * xc,   random = 2 * day_time }, -- tall
    { base = 1 * day_time * xc,   random = 0.5 * day_time } -- old
}   
