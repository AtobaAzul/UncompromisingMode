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
--Fire/Ice Hounds have fire/ice damage
-----------------------------------------------------------------
local function OnHitOtherFreeze(inst, data)
    local other = data.target
    --Ice hounds
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.freezable ~= nil then
                other.components.freezable:AddColdness(2)
            end
            if other.components.temperature ~= nil then
                local mintemp = math.max(other.components.temperature.mintemp, 0)
                local curtemp = other.components.temperature:GetCurrent()
                if mintemp < curtemp then
                    other.components.temperature:DoDelta(math.max(-5, mintemp - curtemp))
                end
            end
        end
        if other.components.freezable ~= nil then
            other.components.freezable:SpawnShatterFX()
        end
    end
end

local function OnHitOtherBurn(inst, data)
    local other = data.target
    --Fire hounds
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.burnable ~= nil then
                other.components.burnable:Ignite(nil, inst)
            end
        end
    end
end


AddPrefabPostInit("icehound", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
        inst:ListenForEvent("onhitother", OnHitOtherFreeze)
    end
end)

AddPrefabPostInit("firehound", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
        inst:ListenForEvent("onhitother", OnHitOtherBurn)
    end
end)


-----------------------------------------------------------------
--McTusk Changes
--Relevant: walrus.lua prefab, walrusbrain, leash.lua
-----------------------------------------------------------------
AddPrefabPostInit("walrus", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH*GLOBAL.TUNING.DSTU.MONSTER_MCTUSK_HEALTH_INCREASE)
    end

    NUM_HOUNDS = GLOBAL.TUNING.DSTU.MONSTER_MCTUSK_HOUND_NUMBER
end)

--Remove running away useless behavior by reversing Home Leash priority and chase priority
local function WalrusLeashFix(brain)
    if brain ~= nil and brain.bt.root.children ~= nil then
        run = brain.bt.root.children[3]
        leash = brain.bt.root.children[2]
        brain.bt.root.children[2] = run
        brain.bt.root.children[3] = leash
    end
end
AddBrainPostInit("walrusbrain", WalrusLeashFix)

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
    "HOUSE!",
    "BEGONE!",
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
--Pengulls are now aggressive
-----------------------------------------------------------------
local function PenguinRetarget(inst)

    local ta = inst.components.teamattacker

    local newtarget = FindEntity(inst, 3, function(guy)
            return inst.components.combat:CanTarget(guy)
            end,
            nil,
            {"penguin"},
            {"character","monster","wall"}
            )

    if newtarget and ta and not ta.inteam and not ta:SearchForTeam() then
        MakeTeam(inst, newtarget)
    end

    if ta.inteam and not ta.teamleader:CanAttack() then
        return newtarget
    end

end

AddPrefabPostInit("penguin", PenguinRetarget)
AddPrefabPostInit("penguin", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
        inst.components.combat:SetRetargetFunction(2, PenguinRetarget) --penguins are aggressive
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

-----------------------------------------------------------------
--Pig guards now target walls
--Relevant: pigman.lua, GuardRetargetFn, GuardKeepTargetFn
-----------------------------------------------------------------
local function AliveWall(wall, targetter)
    if wall ~= nil and wall.components.health ~= nil then
        return not wall.components.health:IsDead()
    end 
    return nil
end

local function GuardRetargetFn(inst)
    --defend the king, then the torch, then myself
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    local defendDist = GLOBAL.SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    local defenseTarget =
        GLOBAL.FindEntity(inst, defendDist, nil, { "king" }) or
        (home ~= nil and inst:IsNear(home, defendDist) and home) or
        inst

    local wall =  GLOBAL.FindEntity(defenseTarget, defendDist, AliveWall, {"wall"}, { "INLIMBO" })
    local monster = GLOBAL.FindEntity(defenseTarget, defendDist, nil, {"monster"}, { "INLIMBO" })
    if monster ~= nil then 
        target = monster 
    else 
        if wall ~= nil then 
            target = wall
        end 
    end

    if not defenseTarget.happy then
        local invader = GLOBAL.FindEntity(defenseTarget, defendDist, nil, { "character" }, { "guard", "INLIMBO" })
        if invader ~= nil and
            not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(invader)) and
            not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(invader)) then
                target = invader
        else
            if not GLOBAL.TheWorld.state.isday and home ~= nil and home.components.burnable ~= nil and home.components.burnable:IsBurning() then
                local lightThief = GLOBAL.FindEntity(
                    home,
                    home.components.burnable:GetLargestLightRadius(),
                    function(guy)
                        return guy.LightWatcher:IsInLight()
                            and not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(guy))
                            and not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(guy))
                    end,
                    { "player" }
                )
                if lightThief ~= nil then

                    print("largest radius is "..home.components.burnable:GetLargestLightRadius())
                    target = lightThief
                end
            end
        end
    end
    
    print(target)
    print(AliveWall(target))
    return target
end

--[[
local function GuardKeepTargetFn(inst, target)
    
    if not inst.components.combat:CanTarget(target) or
        (target.sg ~= nil and target.sg:HasStateTag("transform")) or
        (target:HasTag("guard") and target:HasTag("pig")) then
        return false
    end

    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home == nil then
        return true
    end

    local defendDist = not GLOBAL.TheWorld.state.isday
                    and home.components.burnable ~= nil
                    and home.components.burnable:IsBurning()
                    and home.components.burnable:GetLargestLightRadius()
                    or GLOBAL.SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    return target:IsNear(home, defendDist) and inst:IsNear(home, defendDist)
end
]]

AddPrefabPostInit("pigguard", GuardRetargetFn)
AddPrefabPostInit("pigguard", function (inst)
    if inst ~= nil and inst.components.combat ~= nil then 
        --inst.components.combat:SetKeepTargetFunction(GuardKeepTargetFn)
        inst.components.combat:SetRetargetFunction(1, GuardRetargetFn, DeadWall)
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
-- Eyeplant buff
-----------------------------------------------------------------
GLOBAL.TUNING.EYEPLANT_HEALTH = 100,
GLOBAL.TUNING.EYEPLANT_ATTACK_PERIOD = 0.7,

-----------------------------------------------------------------
--Pig guards don't hit players if pig king is happy
--Relevant: pigman.lua, GuardRetargetFn, GuardKeepTargetFn
-----------------------------------------------------------------
--TODO: make it work

--[[
AddPrefabPostInit("pigking", function (inst)
    function makeUnhappy(inst)
        inst.happy = false
    end
    
    
    function ontradeforgold(inst, item, giver)
        print("ongold")
        print(inst)
        if inst.launchitem ~= nil then
            print(inst.launchitem)
        else
            print("else")
        end
        --launchitem = inst.launchitem

        GLOBAL.AwardPlayerAchievement("pigking_trader", giver)
    
        local x, y, z = inst.Transform:GetWorldPosition()
        y = 4.5
    
        local angle
        if giver ~= nil and giver:IsValid() then
            angle = 180 - giver:GetAngleToPoint(x, 0, z)
        else
            local down = GLOBAL.TheCamera:GetDownVec()
            angle = GLOBAL.math.atan2(down.z, down.x) / DEGREES
            giver = nil
        end
    
        for k = 1, item.components.tradable.goldvalue do
            local nug = GLOBAL.SpawnPrefab("goldnugget")
            nug.Transform:SetPosition(x, y, z)
            --launchitem(nug, angle)
        end
    
        if item.components.tradable.tradefor ~= nil then
            for _, v in pairs(item.components.tradable.tradefor) do
                local item = GLOBAL.SpawnPrefab(v)
                if item ~= nil then
                    item.Transform:SetPosition(x, y, z)
                    --launchitem(item, angle)
                end
            end
        end
    
        if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
            -- pick out up to 3 types of candies to throw out
            local candytypes = { GLOBAL.math.random(NUM_HALLOWEENCANDY), GLOBAL.math.random(NUM_HALLOWEENCANDY), GLOBAL.math.random(NUM_HALLOWEENCANDY) }
            local numcandies = (item.components.tradable.halloweencandyvalue or 1) + GLOBAL.math.random(2) + 2
    
            -- only people in costumes get a good amount of candy!
            if giver ~= nil and giver.components.skinner ~= nil then
                for _, item in pairs(giver.components.skinner:GetClothing()) do
                    if GLOBAL.DoesItemHaveTag(item, "COSTUME") then
                        numcandies = numcandies + GLOBAL.math.random(4) + 2
                        break
                    end
                end
            end
    
            for k = 1, numcandies do
                local candy = GLOBAL.SpawnPrefab("halloweencandy_"..GetRandomItem(candytypes))
                candy.Transform:SetPosition(x, y, z)
                --launchitem(candy, angle)
            end
        end
    end
    
    function OnGetItemFromPlayer(inst, giver, item)
        local is_event_item = GLOBAL.IsSpecialEventActive(GLOBAL.SPECIAL_EVENTS.HALLOWED_NIGHTS) and item.components.tradable.halloweencandyvalue and item.components.tradable.halloweencandyvalue > 0
    
        print(ok)
        print(item.goldvalue)

        if item.components.tradable.goldvalue > 0 or is_event_item then
            inst.sg:GoToState("cointoss")
            print(item.goldvalue)
            inst:DoTaskInTime(2 / 3, ontradeforgold, item, giver)
        elseif item.prefab == "pig_token" then
            StartMinigame(inst)
        end
    
        --inst.happy = true --make pig king happy
        --inst.last_gift_time = GLOBAL.GetTime()
    end

    if inst ~= nil and inst.components.trader ~= nil then
        inst.components.trader.onaccept = OnGetItemFromPlayer
    end
end)
]]
