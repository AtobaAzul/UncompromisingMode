-----------------------------------------------------------------
--Generic mob stat changes
-----------------------------------------------------------------
--Catcoon extra health
AddPrefabPostInit("catcoon", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(GLOBAL.TUNING.DSTU.MONSTER_CATCOON_HEALTH_CHANGE)
    end
end)

-----------------------------------------------------------------
--Bats come in higher numbers
-----------------------------------------------------------------
--TODO: Test behavior with multiple bats
AddPrefabPostInit("cave_entrance", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.childspawner ~= nil then
        --inst.components.childspawner:SetRegenPeriod(60)
        inst.components.childspawner:SetSpawnPeriod(.1/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        inst.components.childspawner:SetMaxChildren(6*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        --inst.components.childspawner.childname = "bat"
    end
end)

AddPrefabPostInit("batcave", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.childspawner ~= nil then
        --inst.components.childspawner:SetRegenPeriod(TUNING.BATCAVE_REGEN_PERIOD)
        inst.components.childspawner:SetSpawnPeriod(TUNING.BATCAVE_SPAWN_PERIOD/GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        inst.components.childspawner:SetMaxChildren(TUNING.BATCAVE_MAX_CHILDREN*GLOBAL.TUNING.DSTU.MONSTER_BAT_CAVE_NR_INCREASE)
        --inst.components.childspawner.childname = "bat"
    end
end)

-----------------------------------------------------------------
--Pigs and bunnies defend their turf if their home is destroyed
-----------------------------------------------------------------
local pigtaunts = 
{
    "GET OFF LAWN",
    "LEAVE HOUSE ALONE",
    "NO SMASH HOUSE",
    "DO NOT HIT",
    "NO KILL HOUSE",
    "BAD MONKEY MAN",
    "NO BREAK THINGS",
    "YOU STOP THAT",
    "STOP RIGHT THERE"
}

local bunnytaunts = 
{
    "INVADER!",
    "CRIMINAL!",
    "SCUM!",
    "AGGRESSOR!",
    "NO!",
    "MINE!",
    "HOUSE!"
}

local function TalkShit(inst, taunts) 
    if taunts ~= nil then 
        local tauntnr = GLOBAL.math.floor(GLOBAL.GetRandomMinMax(1,GLOBAL.GetTableSize(taunts)))
        if inst ~= nil and inst.components.talker ~= nil then
            inst.components.talker:Say(taunts[tauntnr])
        end
    end
end

local function RetaliateAttacker(inst,attacker,taunts) 
    if inst ~= nil and inst.components.combat ~= nil then
        inst.components.combat:SetTarget(attacker) 
    end
    if taunts ~= nil then TalkShit(inst,taunts) end
end

--Get the pig to attack the perpetrator of the crime against pig-kind
--TODO: Make pigs trashtalk in house too, now only bunnymen do that
local function onworked_pighouse(inst, worker)
    if inst.components.spawner ~= nil and inst.components.spawner.child then
        RetaliateAttacker(inst.components.spawner.child, worker, pigtaunts)
    end
end

AddPrefabPostInit("pighouse", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetOnWorkCallback(onworked_pighouse)
    end
end)

--Get the bunnyman to attack the perpetrator of the crime against bunny-kind
local function onworked_rabbithouse(inst, worker)
    if inst.components.spawner ~= nil and inst.components.spawner.child then
        RetaliateAttacker(inst.components.spawner.child, worker, bunnytaunts)
    end
end

AddPrefabPostInit("rabbithouse", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
        inst.components.workable:SetOnWorkCallback(onworked_rabbithouse)
    end
end)

-----------------------------------------------------------------
--Bishop will now run away from player between attacks -Axe
-----------------------------------------------------------------
--TODO: Change stun threshold to be tighter
local function Bishrun(brain)
    kite =     GLOBAL.WhileNode( function() return brain.inst.components.combat.target and brain.inst.components.combat:InCooldown() end, "Dodge",
                    GLOBAL.RunAway(brain.inst, function() return brain.inst.components.combat.target end, 5, 8) )
    table.insert(brain.bt.root.children, 1, kite)
end
AddBrainPostInit("bishopbrain", Bishrun)
--BeeQueen now has AOE -Axe
AddPrefabPostInit("beequeen", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
		local function isnotbee(ent)
			if ent ~= nil and not ent:HasTag("bee") and not ent:HasTag("hive") then -- fix to friendly AOE: refer for later AOE mobs -Axe
				return true
			end
		end
        inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE/2, TUNING.DEERCLOPS_AOE_SCALE, isnotbee) -- you can edit these values to your liking -Axe
    end                                     
end)