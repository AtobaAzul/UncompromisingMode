require("stategraphs/commonstates")

-- Copied from mine.lua to emulate its mine test.
local mine_test_fn = function(target, inst)
    return not (target.components.health ~= nil and target.components.health:IsDead())
        and (target.components.combat ~= nil and target.components.combat:CanBeAttacked(inst))
end

local mine_test_tags = { "monster", "character", "animal" }
local mine_must_tags = { "_combat" }
local mine_no_tags = { "notraptrigger", "flying", "ghost", "playerghost", "snapdragon" }

local function FxAppear(inst)
    SpawnPrefab("blueberryexplosion").Transform:SetPosition(inst.Transform:GetWorldPosition())
    SpawnPrefab("blueberrypuddle").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function Explode(inst)
    inst.SoundEmitter:PlaySound("turnoftides/creatures/together/starfishtrap/trap")
    FxAppear(inst)

    local x, y, z = inst.Transform:GetWorldPosition()
    local target_ents = TheSim:FindEntities(x, y, z, 1.1 * TUNING.STARFISH_TRAP_RADIUS, mine_must_tags, mine_no_tags,
        mine_test_tags)
    for i, target in ipairs(target_ents) do
        if target ~= inst and target.entity:IsVisible() and mine_test_fn(target, inst) then
            target.components.combat:GetAttacked(inst, TUNING.STARFISH_TRAP_DAMAGE)
        end
    end

    local otherbombs = TheSim:FindEntities(x, y, z, 3 * TUNING.STARFISH_TRAP_RADIUS, { "blueberrybomb" }, mine_no_tags)
    for i, target in ipairs(otherbombs) do
        if target ~= inst and target.components.mine and not target.components.mine.issprung and not target.froze then
            target.components.mine:SetRadius(TUNING.STARFISH_TRAP_RADIUS * 12)
        end
    end
end

local function FoodBabyAnimation(inst)
    if inst.food_baby and inst.food_baby.AnimState then
        if inst.food_baby:HasTag("butterfly") then
            inst.food_baby.AnimState:PlayAnimation("idle", false)
        end
        if inst.food_baby:HasTag("bee") then
            inst.food_baby.AnimState:PushAnimation("land_idle", true)
        end
    end
end

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "flybackup"),
    ActionHandler(ACTIONS.PICKUP, "eat")
}

local events =
{
    EventHandler("fly_back", function(inst, data)
        inst.sg:GoToState("flyback")
    end),
    CommonHandlers.OnLocomote(false, true),
    CommonHandlers.OnFreeze(),
    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("eat")
        end
    end),
    CommonHandlers.OnAttacked(),
    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    CommonHandlers.OnSleep(),
}


local states =
{
    State {

        name = "idle",
        tags = { "idle", "canrotate" },
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/breath")  end ),
            TimeEvent(13 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State {

        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("fly_loop", true)
            inst:PerformBufferedAction()
        end,
        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        }
    },

    State {
        name = "flyback",
        tags = { "flight", "busy" },
        onenter = function(inst)
            inst.Physics:Stop()

            inst.DynamicShadow:Enable(false)
            inst.components.health:SetInvincible(true)

            inst.AnimState:PlayAnimation("fly_back_loop", true)

            local x, y, z = inst.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, 10, z)
            inst.Physics:SetMotorVel(0, -25 + math.random() * 2, 0)
        end,

        onupdate = function(inst)
            inst.Physics:SetMotorVel(0, -25 + math.random() * 2, 0)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y <= .1 or inst:IsAsleep() then
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x, pt.y, pt.z)
                inst.DynamicShadow:Enable(true)
                inst.components.health:SetInvincible(false)
                inst.sg:GoToState("idle", "fly_back_pst")
            end
        end,

        timeline = {
            TimeEvent(3 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(14 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(24 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(34 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(41 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

    },

    State {
        name = "flybackup",
        tags = { "flight", "busy" },
        onenter = function(inst)
            inst.Physics:Stop()
            inst.DynamicShadow:Enable(false)
            inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("fly_back_loop", true)
            inst.Physics:SetMotorVel(0, 25 + math.random() * 2, 0)
        end,

        onupdate = function(inst)
            inst.Physics:SetMotorVel(0, 25 + math.random() * 2, 0)
            local pt = Point(inst.Transform:GetWorldPosition())
            local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
            if pt.y >= 10 then
                if home ~= nil and home:IsValid() and home.components.lootdropper ~= nil then
                    home:DoTaskInTime(1 + math.random(), function(home)
                        home.AnimState:PlayAnimation("spit")
                        home.AnimState:PushAnimation("swinglong")
                        home:DoTaskInTime(0.3, function(home) home.components.lootdropper:DropLoot(pt) end) --Drop loot only once every time it goes home.
                    end)
                    inst.bugcount = inst.bugcount - 3
                end
                inst:PerformBufferedAction()
            end
        end,

        timeline = {
            TimeEvent(3 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(14 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(24 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(34 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(41 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

    },

    State {
        name = "eat",
        tags = { "busy", "attack" },

        onenter = function(inst)
            --inst.Physics:Stop()
            inst:PerformBufferedAction()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("eat_pre", false)
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("UCSounds/vampirebat/bite")
                inst.components.combat:DoAttack()
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) if not inst.food_baby then inst.sg:GoToState("idle") end end)
        },
    },

    State {
        name = "eat_loop",
        tags = { "busy", "noattack", "nosleep", "flying" },

        onenter = function(inst)
            inst.DynamicShadow:Enable(false)
            if inst.food_baby then
                inst.food_baby.entity:AddFollower():FollowSymbol(inst.GUID, "food_baby", 0, 7, 0)
            end
            FoodBabyAnimation(inst)
            inst.AnimState:PlayAnimation("eat_pst", true)
            inst.AnimState:PushAnimation("take_food_baby", true)
        end,

        timeline =
        {
            TimeEvent(7 * FRAMES,
                function(inst)
                    inst:PushEvent("wingdown")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/chew")
                end),
            TimeEvent(17 * FRAMES,
                function(inst)
                    inst:PushEvent("wingdown")
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/bat/chew")
                end),
        },
        onupdate = function(inst)
            inst.Physics:SetMotorVelOverride(0, 25, 0)
            local x, y, z = inst.Transform:GetWorldPosition()
            if y > 50 then
                inst.food_baby:Remove()
                inst.food_baby = nil
                inst.sg:GoToState("digest")
            end
        end,
        events =
        {
        },
    },

    State {
        name = "digest",
        tags = { "busy", "noattack", "nosleep", "flying" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.sg:SetTimeout(10)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("glide")
            if math.random() > 0.33 then
                local pitcherplant = FindClosestEntity(inst, 80, true, { "pitcherplant" }) --probably overkill radius.
                if pitcherplant ~= nil and pitcherplant.components.lootdropper ~= nil then
                    pitcherplant.components.lootdropper:DropLoot()
                end
            end
        end,

        timeline =
        {
            TimeEvent(10, function(inst)
                inst.sg:GoToState("glide")
            end)
        },
        events =
        {
        },
    },
    State {
        name = "glide",
        tags = { "idle", "flying", "busy", "noattack" },
        onenter = function(inst)
            inst.DynamicShadow:Enable(false)
            inst.AnimState:PlayAnimation("glide", true)
            inst.Physics:ClearMotorVelOverride()
            inst.Physics:Stop()
            inst.Physics:SetMotorVelOverride(0, -50, 0)
        end,

        onupdate = function(inst)
            local pt = inst:GetPosition()
            if pt.y <= .1 then
                inst.Physics:ClearMotorVelOverride()
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x, pt.y, pt.z)
                --    inst.AnimState:PlayAnimation("land")
                inst.DynamicShadow:Enable(true)

                --   inst.sg:GoToState("idle")
                inst.sg:GoToState("land")
            end
        end,

        onexit = function(inst)
            if inst:GetPosition().y > 0 then --I hate this, but this is for some reason the only way this stupid thing works!!!
                inst.Physics:ClearMotorVelOverride()
                inst.Physics:Stop()
                local pos = inst:GetPosition()
                pos.y = 0
                inst.Transform:SetPosition(pos:Get())
            end
            -- inst.components.knownlocations:RememberLocation("landpoint", inst:GetPosition())
        end,
    },

    State {
        name = "land",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("land", false)
            --inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/vampire_bat/land")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State {
        name = "boop",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("boop", false)
            --inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/vampire_bat/land")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        },
    },
}

local walkanims =
{
    startwalk = "move_pre",
    walk = "move",
    stopwalk = "move_pst",
}

CommonStates.AddWalkStates(states,
    {
        starttimeline =
        {
            TimeEvent(1 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

        walktimeline =
        {
            TimeEvent(7 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/breath")  end ),
            TimeEvent(17 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

        endtimeline =
        {
            TimeEvent(1 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

    }, walkanims, true)


CommonStates.AddSleepStates(states,
    {
        starttimeline =
        {
            TimeEvent(7 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            --TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/breath")  end ),
            TimeEvent(17 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

        sleeptimeline =
        {
            TimeEvent(23 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/breath") end),
        },

        endtimeline =
        {
            TimeEvent(13 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },
    })

CommonStates.AddCombatStates(states,
    {
        hittimeline =
        {
            TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/hurt") end),
            TimeEvent(3 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
        },

        deathtimeline =
        {
            TimeEvent(1 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("UCSounds/vampirebat/death") end),
            TimeEvent(4 * FRAMES, function(inst) inst:PushEvent("wingdown") end),
            TimeEvent(45 * FRAMES, Explode),
        },
    })

CommonStates.AddFrozenStates(states)


return StateGraph("fruitbat", states, events, "boop", actionhandlers)
