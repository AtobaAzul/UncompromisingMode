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
    --"BAD MONKEY MAN",
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
        local tauntnr = GLOBAL.math.floor(GLOBAL.GetRandomMinMax(1, GLOBAL.GetTableSize(taunts)))
        if inst and inst.components.talker then
            inst.components.talker:Say(taunts[tauntnr])
        end
    end
end

local function RetaliateAttacker(inst, attacker, taunts)
    if inst and attacker and inst.components.combat and not inst:HasTag("merm") then
        inst.components.combat:SuggestTarget(attacker)
    end
    if taunts ~= nil then TalkShit(inst, taunts) end
end

--Get the pig to attack the perpetrator of the crime against pig-kind
--TODO: Make pigs trashtalk in house too, now only bunnymen do that
---Should probably make this a hook -a
local function onworked_pighouse(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        if inst.lightson then
            inst.AnimState:PushAnimation("lit")
            if inst._window ~= nil then
                inst._window.AnimState:PlayAnimation("windowlight_hit")
                inst._window.AnimState:PushAnimation("windowlight_idle")
            end
            if inst._windowsnow ~= nil then
                inst._windowsnow.AnimState:PlayAnimation("windowsnow_hit")
                inst._windowsnow.AnimState:PushAnimation("windowsnow_idle")
            end
        else
            inst.AnimState:PushAnimation("idle")
        end
    end

    if inst.components.spawner ~= nil and inst.components.spawner.child then
        RetaliateAttacker(inst.components.spawner.child, worker, pigtaunts)
        local x, y, z = inst.Transform:GetWorldPosition()
        local guards = TheSim:FindEntities(x, y, z, 40, { "guard" }, {"merm"})
        for i, v in ipairs(guards) do
            if v.components.health ~= nil and v.components.combat ~= nil and not v.components.health:IsDead() then
                v.components.combat:SuggestTarget(worker)
            end
        end
        inst.components.spawner:ReleaseChild()
    end
end

if GetModConfigData("harder_pigs") then
    AddPrefabPostInit("pighouse", function(inst)
        if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
            inst.components.workable:SetOnWorkCallback(onworked_pighouse)
        end
    end)

    --Get the bunnyman to attack the perpetrator of the crime against bunny-kind
    local function onworked_rabbithouse(inst, worker)
        if not inst:HasTag("burnt") then
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("idle")

            if inst.glow_fx ~= nil then
                inst.glow_fx.AnimState:PlayAnimation("hit")
                inst.glow_fx.AnimState:PushAnimation("idle")
            end
        end

        if inst.components.spawner ~= nil and inst.components.spawner.child then
            RetaliateAttacker(inst.components.spawner.child, worker, bunnytaunts)
            inst.components.spawner:ReleaseChild()
        end
    end

    AddPrefabPostInit("rabbithouse", function(inst)
        if inst ~= nil and inst.components ~= nil and inst.components.workable ~= nil then
            inst.components.workable:SetOnWorkCallback(onworked_rabbithouse)
        end
    end)
end
-----------------------------------------------------------------
--Pengulls are now aggressive
-----------------------------------------------------------------
--[[
local function MakeTeam(inst, attacker)
    local leader = GLOBAL.SpawnPrefab("teamleader")
    leader:AddTag("penguin")
    leader.components.teamleader.threat = attacker
    leader.components.teamleader.radius = 10
    leader.components.teamleader:SetAttackGrpSize(5+math.random(1,3))
    leader.components.teamleader.timebetweenattacks = 0  -- first attack happens immediately
    leader.components.teamleader.attackinterval = 2  -- first attack happens immediately
    leader.components.teamleader.maxchasetime = 10
    leader.components.teamleader.min_team_size = 0
    leader.components.teamleader.max_team_size = 8
    leader.components.teamleader.team_type = inst.components.teamattacker.team_type
    leader.components.teamleader:NewTeammate(inst)
    leader.components.teamleader:BroadcastDistress(inst)
end

--TODO add penguin attack on ice picked
local function PenguinRetarget(inst)
    local ta = inst.components.teamattacker

    local newtarget = GLOBAL.FindEntity(inst, 3, function(guy)
            return inst.components.combat:CanTarget(guy)
            end,
            nil,
            {"penguin","penguin_protection"},
            {"character","monster","wall"}
            )

    if ta~=nil and newtarget and ta and not ta.inteam and not ta:SearchForTeam() then
        MakeTeam(inst, newtarget)
    end

    if ta~=nil and ta.inteam and not ta.teamleader:CanAttack() then
        return newtarget
    end

end

local function PenguinKeepTarget(inst, target)
    if not inst.components.teamattacker then
        return false
    end

    if (inst.components.teamattacker.teamleader and not inst.components.teamattacker.teamleader:CanAttack())
        or inst.components.teamattacker.orders == "ATTACK" then
        return true
    else
        return true
    end
end

AddPrefabPostInit("penguin", PenguinRetarget, MakeTeam)
AddPrefabPostInit("penguin", function (inst)
    if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
        inst.components.combat:SetRetargetFunction(2, PenguinRetarget) --penguins are aggressive
    end

	if inst ~= nil and inst.components ~= nil and inst.components.combat ~= nil then
		inst.components.combat:SetKeepTargetFunction(PenguinPenguinKeepTarget)
	end
end)

--]]
-----------------------------------------------------------------
--Clockworks will no longer panic while on fire or take damage -Axe
-----------------------------------------------------------------
AddPrefabPostInit("bishop", function(inst)
    inst:RemoveComponent("burnable")
end)
AddPrefabPostInit("knight", function(inst)
    inst:RemoveComponent("burnable")
end)
AddPrefabPostInit("rook", function(inst)
    inst:RemoveComponent("burnable")
end)
AddPrefabPostInit("bishop_nightmare", function(inst)
    inst:RemoveComponent("burnable")
end)
AddPrefabPostInit("knight_nightmare", function(inst)
    inst:RemoveComponent("burnable")
end)
AddPrefabPostInit("rook_nightmare", function(inst)
    inst:RemoveComponent("burnable")
end)
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

local KING_TAGS = { "king" }
local RETARGET_GUARD_MUST_TAGS = { "character" }
local RETARGET_GUARD_CANT_TAGS = { "guard", "INLIMBO" }
local RETARGET_GUARD_PLAYER_MUST_TAGS = { "player" }
local RETARGET_GUARD_LIMBO_CANT_TAGS = { "INLIMBO" }

local function GuardRetargetFn(inst)
    --defend the king, then the torch, then myself
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    local defendDist = GLOBAL.SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    local defenseTarget =
        GLOBAL.FindEntity(inst, defendDist, nil, KING_TAGS) or
        (home ~= nil and inst:IsNear(home, defendDist) and home) or
        inst

    if not defenseTarget.happy then
        local invader = GLOBAL.FindEntity(defenseTarget, GLOBAL.SpringCombatMod(TUNING.PIG_GUARD_TARGET_DIST), nil, RETARGET_GUARD_MUST_TAGS, RETARGET_GUARD_CANT_TAGS)
        if invader ~= nil and
            not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(invader)) and
            not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(invader)) then
            return invader
        end

        if not GLOBAL.TheWorld.state.isday and home ~= nil and home.components.burnable ~= nil and home.components.burnable:IsBurning() then
            local lightThief = GLOBAL.FindEntity(
                home,
                home.components.burnable:GetLargestLightRadius() or 4,
                function(guy)
                    return guy:IsInLight()
                        and not (defenseTarget.components.trader ~= nil and defenseTarget.components.trader:IsTryingToTradeWithMe(guy))
                        and not (inst.components.trader ~= nil and inst.components.trader:IsTryingToTradeWithMe(guy))
                end,
                RETARGET_GUARD_PLAYER_MUST_TAGS
            )
            if lightThief ~= nil then
                return lightThief
            end
        end
    end
	
    local wall = GLOBAL.FindEntity(defenseTarget, defendDist, AliveWall, { "wall" }, { "INLIMBO" })

	if wall ~= nil then
		return wall
	end
			
    local oneof_tags = {"monster"}
    if not inst:HasTag("merm") then
        table.insert(oneof_tags, "merm")
    end

    return GLOBAL.FindEntity(defenseTarget, defendDist, nil, {}, RETARGET_GUARD_LIMBO_CANT_TAGS, oneof_tags)
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

    local defendDist = not GLOBAL.GLOBAL.TheWorld.state.isday
                    and home.components.burnable ~= nil
                    and home.components.burnable:IsBurning()
                    and home.components.burnable:GetLargestLightRadius()
                    or GLOBAL.GLOBAL.SpringCombatMod(TUNING.PIG_GUARD_DEFEND_DIST)
    return target:IsNear(home, defendDist) and inst:IsNear(home, defendDist)
end
]]
AddPrefabPostInit("pigguard", GuardRetargetFn)
AddPrefabPostInit("pigguard", function(inst)
    if inst ~= nil and inst.components.combat ~= nil then
        --inst.components.combat:SetKeepTargetFunction(GuardKeepTargetFn)
        inst.components.combat:SetRetargetFunction(1, GuardRetargetFn, DeadWall)
    end
end)



-----------------------------------------------------------------
-- Beefalo herding buff - TODO: Increase range of aggro
-----------------------------------------------------------------

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

        if item.components.tradable.goldvalue > 0 or is_event_item then
            inst.sg:GoToState("cointoss")
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
