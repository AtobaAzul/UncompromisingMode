-- Wicker Books
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe
RECIPETABS = GLOBAL.RECIPETABS
Ingredient = GLOBAL.Ingredient
AllRecipes = GLOBAL.AllRecipes
STRINGS = GLOBAL.STRINGS
TECH = GLOBAL.TECH
CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

if TUNING.DSTU.WICKERNERF_TENTACLES then
    local function newtentacles(inst, reader)
        if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
            local pt = reader:GetPosition()
            local numtentacles = 3

            reader:StartThread(function()
                for k = 1, numtentacles do
                    local theta = math.random() * 2 * PI
                    local radius = math.random(3, 8)

                    local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                        local pos = pt + offset
                        -- NOTE: The first search includes invisible entities
                        return #TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0 and
                            TheWorld.Map:IsPassableAtPoint(pos:Get()) and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
                    end)

                    if result_offset ~= nil then
                        local x, z = pt.x + result_offset.x, pt.z + result_offset.z
                        local tentacle = SpawnPrefab("wicker_tentacle")
                        tentacle.Transform:SetPosition(x, 0, z)
                        tentacle.sg:GoToState("attack_pre")

                        -- need a better effect
                        SpawnPrefab("shadow_puff").Transform:SetPosition(x, 0, z)
                        ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, reader, 40)
                    end

                    Sleep(.33)
                end
            end)
            return true
        else
            return false
        end
    end

    env.AddPrefabPostInit("book_tentacles", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.components.book:SetReadSanity(-TUNING.SANITY_LARGE)

        if inst.components.book ~= nil then
            inst.components.book.onread = newtentacles
        end
    end)
end

if TUNING.DSTU.WICKERBUFF_LIGHT then
    local function newlight(inst, reader)
        TheWorld:PushEvent("ms_forcequake")
        local x, y, z = reader.Transform:GetWorldPosition()
        local light = SpawnPrefab("booklight")
        light.Transform:SetPosition(x, y, z)
        light:SetDuration(TUNING.TOTAL_DAY_TIME * 2)
        return true
    end

    perusefn = function(inst, reader)
        if reader.peruse_light then
            reader.peruse_light(reader)
        end
        reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_LIGHT"))
        return true
    end

    env.AddPrefabPostInit("book_light", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.book ~= nil then
            inst.components.book.onread = newlight
        end
    end)

    local function newupgradedlight(inst, reader)
        TheWorld:PushEvent("ms_forcequake")
        local x, y, z = reader.Transform:GetWorldPosition()
        local light = SpawnPrefab("booklight")
        light.Transform:SetPosition(x, y, z)
        light:SetDuration(TUNING.TOTAL_DAY_TIME * 6)
        return true
    end
    perusefn = function(inst, reader)
        if reader.peruse_light_upgraded then
            reader.peruse_light_upgraded(reader)
        end
        reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_LIGHT_UPGRADED"))
        return true
    end

    env.AddPrefabPostInit("book_light_upgraded", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.book ~= nil then
            inst.components.book.onread = newupgradedlight
        end
    end)
end

if TUNING.DSTU.WICKERBUFF_HORTICULTURE then
    local HORTICULTURE_ONEOF_TAGS = { "plant", "lichen", "oceanvine", "mushroom_farm", "kelp" }
    local HORTICULTURE_CANT_TAGS = { "magicgrowth", "player", "FX", "leif", "pickable", "stump", "withered", "barren",
        "INLIMBO", "silviculture", "tree", "winter_tree" }

    local function MaximizePlant(inst)
        if inst.components.farmplantstress ~= nil then
            if inst.components.farmplanttendable then
                inst.components.farmplanttendable:TendTo()
            end

            inst.magic_tending = true
            local _x, _y, _z = inst.Transform:GetWorldPosition()
            local x, y = TheWorld.Map:GetTileCoordsAtPoint(_x, _y, _z)

            local nutrient_consumption = inst.plant_def.nutrient_consumption
            TheWorld.components.farming_manager:AddTileNutrients(x, y, nutrient_consumption[1] * 6,
                nutrient_consumption[2] * 6, nutrient_consumption[3] * 6)
        end
    end

    local function trygrowth(inst, maximize)
        if not inst:IsValid() or inst:IsInLimbo() or (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then
            return false
        end

        if inst:HasTag("leif") then
            inst.components.sleeper:GoToSleep(1000)
            return true
        end

        if maximize then
            MaximizePlant(inst)
        end

        if inst.components.growable ~= nil then
            -- If we're a tree and not a stump, or we've explicitly allowed magic growth, do the growth.
            if inst.components.growable.magicgrowable or ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) then
                if inst.components.simplemagicgrower ~= nil then
                    inst.components.simplemagicgrower:StartGrowing()
                    return true
                elseif inst.components.growable.domagicgrowthfn ~= nil then
                    -- The upgraded horticulture book has a delayed start to make sure the plants get tended to first
                    inst.magic_growth_delay = maximize and 2 or nil
                    inst.components.growable:DoMagicGrowth()

                    return true
                else
                    return inst.components.growable:DoGrowth()
                end
            end
        end

        if inst.components.pickable ~= nil then
            if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
                return false
            end
            if inst.components.pickable:FinishGrowing() then
                inst.components.pickable:ConsumeCycles(1) -- magic grow is hard on plants
                return true
            end
        end

        if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
            if inst.components.crop:DoGrow(1 / inst.components.crop.rate, true) then
                return true
            end
        end

        if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
            if inst.components.harvestable:IsMagicGrowable() then
                inst.components.harvestable:DoMagicGrowth()
                return true
            else
                if inst.components.harvestable:Grow() then
                    return true
                end
            end
        end

        return false
    end

    local function GrowNext(spell)
        while #spell._targets > 0 do
            local target = table.remove(spell._targets, 1)
            if target:IsValid() and trygrowth(target, spell._maximize) then
                if spell._count > 1 then
                    spell._count = spell._count - 1
                    spell:DoTaskInTime(0.1 + 0.3 * math.random(), GrowNext)
                    return
                end
                break
            end
        end
        spell:Remove()
    end

    local function do_book_horticulture_spell(x, z, max_targets, maximize)
        local ents = TheSim:FindEntities(x, 0, z, 30, nil, HORTICULTURE_CANT_TAGS, HORTICULTURE_ONEOF_TAGS)
        local targets = {}
        for i, v in ipairs(ents) do
            if v.components.pickable ~= nil or v.components.crop ~= nil or v.components.growable ~= nil or v.components.harvestable ~= nil then
                table.insert(targets, v)
            end
        end

        if #targets == 0 then
            return false, "NOHORTICULTURE"
        end

        local spell = SpawnPrefab("book_horticulture_spell")
        spell.Transform:SetPosition(x, 0, z)
        spell._targets = targets
        spell._count = max_targets
        spell._maximize = maximize

        GrowNext(spell)

        return true
    end

    local function newupgradedhorticulture(inst, reader)
        local x, y, z = reader.Transform:GetWorldPosition()
        return do_book_horticulture_spell(x, z, TUNING.BOOK_GARDENING_UPGRADED_MAX_TARGETS + 5, true)
    end

    perusefn = function(inst, reader)
        if reader.peruse_horticulture_upgraded then
            reader.peruse_horticulture_upgraded(reader)
        end
        reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_HORTICULTURE_UPGRADED"))
        return true
    end

    env.AddPrefabPostInit("book_horticulture_upgraded", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.book ~= nil then
            inst.components.book.onread = newupgradedhorticulture
        end
    end)
end

if TUNING.DSTU.WICKERNERF_MOONBOOK then
    -- just a little convinience thing for me
    env.AddComponentPostInit("werebeast", function(self)
        if self.inst ~= nil then
            self.inst:AddTag("werebeast")
        end
    end)

    local function OnRead_moon(inst, reader)
        local x, y, z = reader.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 8, nil, { "player", "playerghost", "INLIMBO", "dead" },
            { "halloweenmoonmutable", "werebeast" })
        local woodies = TheSim:FindEntities(x, y, z, 8, { "wereness" }, { "playerghost", "INLIMBO", "dead" })
        local found = false

        for k, v in ipairs(ents) do
            x, y, z = v.Transform:GetWorldPosition()

            if v.components.halloweenmoonmutable ~= nil then
                v.components.halloweenmoonmutable:Mutate()
                local fx = SpawnPrefab("halloween_moonpuff")
                fx.Transform:SetPosition(x, y, z)
            end -- should this be an elseif?

            if v.components.werebeast ~= nil and not v.components.werebeast:IsInWereState() then
                v.components.werebeast:SetWere(1)
                local fx = SpawnPrefab("halloween_moonpuff")
                fx.Transform:SetPosition(x, y, z)
            end

            found = true
        end

        for k, v in ipairs(woodies) do
            x, y, z = v.Transform:GetWorldPosition()

            local pct = v.components.wereness:GetPercent()
            if pct > 0 then
                v.components.wereness:SetPercent(1)
                local fx = SpawnPrefab("halloween_moonpuff")
                fx.Transform:SetPosition(x, y, z)
            else
                v.components.wereness:SetPercent(1, true)
                v.components.wereeater:ForceTransformToWere()
                local fx = SpawnPrefab("halloween_moonpuff")
                fx.Transform:SetPosition(x, y, z)
            end
            found = true
        end

        if found then
            return true
        end
    end

    local function OnPerUse_moon(inst, reader)
        -- if reader.peruse_moon then
        --    reader.peruse_moon(reader)
        -- end
        -- reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_MOON"))
        return true
    end

    env.AddPrefabPostInit("book_moon", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.components.book:SetReadSanity(-TUNING.SANITY_HUGE)

        if inst.components.book ~= nil then
            inst.components.book:SetOnRead(OnRead_moon)
            inst.components.book:SetOnPeruse(OnPerUse_moon)
        end

        if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:SetMaxUses(3)
            inst.components.finiteuses:SetUses(3)
        end
    end)
end

local function OnRead_bees(inst, reader)
    local x, y, z = reader.Transform:GetWorldPosition()
    local beeboxes = TheSim:FindEntities(x, y, z, 16, nil, nil, { "beebox", "beebox_hermit" }, { "burnt", "INLIMBO" })
    local found = false

    for k, v in ipairs(beeboxes) do
        if k > 10 then
            break
        end
        local x, y, z = v.Transform:GetWorldPosition()

        if (v.components.harvestable.maxproduce - v.components.harvestable.produce) ~= 0 and not TheWorld.state.iswinter and not TheWorld.state.isdusk and not TheWorld.state.isnight then
            v.components.harvestable:Grow(1)
            local fx = SpawnPrefab("fx_book_bees")
            fx.Transform:SetPosition(x, y, z)
            found = true
        end
    end

    if found then
        return true
    end
end

if TUNING.DSTU.WICKERNERF_BEEBOOK then
    env.AddPrefabPostInit("book_bees", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst.components.book:SetReadSanity(-TUNING.SANITY_HUGE)

        if inst.components.book ~= nil then
            inst.components.book:SetOnRead(OnRead_bees)
        end

        if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:SetMaxUses(5)
            inst.components.finiteuses:SetUses(5)
        end
    end)
end

local function WickerCaresForHerBooks(inst)
    for k, v in pairs(inst.components.inventory.itemslots) do
        if v:HasTag("book") and v.components.finiteuses then
            local percent = v.components.finiteuses:GetPercent()
            if percent < 1 then
                v.components.finiteuses:SetPercent(math.min(1, percent + 0.01))
            end
        end
    end
end


if TUNING.DSTU.WICKER_INV_REGEN == "inv" then
    env.AddPrefabPostInit("wickerbottom", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        inst:DoPeriodicTask(TUNING.BOOKSTATION_RESTORE_TIME, WickerCaresForHerBooks)
    end)
end

PROTOTYPER_DEFS.wickerbottom = { icon_atlas = "images/crafting_menu_avatars.xml", icon_image = "avatar_wickerbottom.tex", action_str = "WICKERBOTTOM", is_crafting_station = false }
STRINGS.ACTIONS.OPEN_CRAFTING.WICKERBOTTOM = "Learn with"

env.AddPrefabPostInit("wickerbottom", function(inst)
    inst:AddTag("prototyper")

    if not TheWorld.ismastersim then
        return
    end
    inst:AddComponent("prototyper")
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SCIENCEMACHINE
    inst.components.prototyper.restrictedtag = "notwickerbottom"
end)

if TUNING.DSTU.WICKER_INV_REGEN ~= "vanilla" then
    env.AddPrefabPostInit("bookstation", function(inst)
        if not TheWorld.ismastersim then return end

        inst:ListenForEvent("itemget", function(inst)
            inst:DoTaskInTime(0, function()
                if inst.RestoreTask ~= nil then
                    inst.RestoreTask:Cancel()
                end
                inst.RestoreTask = nil
            end)
        end)
    end)
end

env.AddPrefabPostInit("book_rain", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local _OnRead = inst.components.book.onread

    inst.components.book.onread = function(inst, reader)
        if reader:HasTag("under_the_weather") then
            local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")
            local tornado = TheSim:FindFirstEntityWithTag("um_tornado")

            if destination ~= nil then
                if destination.danumber ~= nil then
                    tornado.danumber = destination.danumber

                    if tornado.resetdanumber_task ~= nil then
                        tornado.resetdanumber_task:Cancel()
                    end

                    tornado.resetdanumber_task = nil

                    tornado.resetdanumber_task = tornado:DoTaskInTime(30, function()
                        if tornado.resetdanumber_task ~= nil then
                            tornado.resetdanumber_task:Cancel()
                        end

                        tornado.resetdanumber_task = nil
                        tornado.danumber = 0
                    end)
                end
            end

            reader:DoTaskInTime(1, function(inst)
                inst.components.talker:Say("This should steer the extreme weather away from here.")
            end)

            return true
        end
        if _OnRead ~= nil then
            return _OnRead(inst, reader)
        end
    end
end)


env.AddPlayerPostInit(function (inst)
    if inst.prefab ~= "wickerbottom" then
        inst:AddTag("notwickerbottom")
    end
end)