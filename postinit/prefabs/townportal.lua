local env = env
GLOBAL.setfenv(1, GLOBAL)

local function StartSoundLoop(inst)
    if not inst.playingsound then
        inst.playingsound = true
        OnEntityWake(inst)
    end
end

---ORANGE
local ORANGE_PICKUP_MUST_TAGS = { "_inventoryitem", "plant", "witherable", "kelp", "structure", "lureplant", "mush-room",
    "waterplant", "oceanvine", "lichen", "pickable" }

--from simutil.lua @l 356
local PICKUP_CANT_TAGS = {
    -- Items
    "INLIMBO", "NOCLICK", "irreplaceable", "knockbackdelayinteraction", "event_trigger",
    "minesprung", "mineactive", "catchable",
    "fire", "light", "spider", "cursed", "paired", "bundle",
    "heatrock", "deploykititem", "boatbuilder", "singingshell",
    "archive_lockbox", "simplebook", "furnituredecor",
    -- Pickables
    "flower", "gemsocket", --"structure",
    -- Either
    "donotautopick",
    "moonglass_geode",
    "engineeringbatterypowered"
}

local function pickup(inst, channeler)
    if channeler == nil or channeler.components.inventory == nil then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.FIRE_DETECTOR_RANGE * 1.1, nil, PICKUP_CANT_TAGS,
        ORANGE_PICKUP_MUST_TAGS)
    for i, v in ipairs(ents) do
        print("what the fuck")
        if v.components.inventoryitem ~= nil and --Inventory stuff
            v.components.inventoryitem.canbepickedup and
            v.components.inventoryitem.cangoincontainer and
            not v.components.inventoryitem:IsHeld() and
            channeler.components.inventory:CanAcceptCount(v, 1) > 0 then
            if channeler.components.minigame_participator ~= nil then
                local minigame = channeler.components.minigame_participator:GetMinigame()
                if minigame ~= nil then
                    minigame:PushEvent("pickupcheat", { cheater = channeler, item = v })
                end
            end

            --Amulet will only ever pick up items one at a time. Even from stacks.
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())


            local v_pos = v:GetPosition()
            if v.components.stackable ~= nil then
                v = v.components.stackable:Get()
            end

            if v.components.trap ~= nil and v.components.trap:IsSprung() then
                v.components.trap:Harvest(channeler)
            else
                channeler.components.inventory:GiveItem(v, nil, v_pos)
            end
            return
        end


        if v.components.crop ~= nil and v.components.crop.matured then --Farmplots/Wild Crops
            v.components.crop:Harvest(channeler)
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.5) --Can't take too much sanity if the purpose is to use in large farms
            return
        end
        if v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() then -- and v:HasTag("mushroom_farm") then --Mushroom Farms
            v.components.harvestable:Harvest(channeler)
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.25) --Can't take too much sanity if the purpose is to use in large farms
            return
        end
        if v.components.stewer ~= nil and v.components.stewer:IsDone() then --Crockpot dishes, not sure who's gonna do this though lol
            v.components.stewer:Harvest(channeler)
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.25) --Can't take too much sanity if the purpose is to use in large farms
            return
        end
        if v.components.pickable ~= nil and v.components.pickable:CanBePicked() and v.prefab ~= "flower" then --Pickable stuff
            channeler:AddTag("channelingpicker")
            v.components.pickable:Pick(channeler)
            channeler:RemoveTag("channelingpicker")
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.25) --Can't take too much sanity if the purpose is to use in large farms
            return
        end
        if v.components.dryer ~= nil and v.components.dryer:IsDone() then --Drying racks
            v.components.dryer:Harvest(channeler)
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.25)
            return
        end
        if v.components.shelf ~= nil and v.components.shelf.itemonshelf ~= nil and not TheWorld.state.iswinter then --Lureplants
            v.components.shelf:TakeItem(channeler)
            SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            inst.channeler.components.sanity:DoDelta(-0.25)
            return
        end
    end
end

local function OnStartChanneling(inst, channeler)
    inst.AnimState:PlayAnimation("turn_on")
    inst.AnimState:PushAnimation("idle_on_loop")
    StartSoundLoop(inst)
    TheWorld:PushEvent("townportalactivated", inst)
    inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD / 1.2, pickup, nil, channeler)

    inst.MiniMapEntity:SetIcon("townportalactive.png")
    inst.MiniMapEntity:SetPriority(20)

    if inst.icon ~= nil then
        inst.icon.MiniMapEntity:SetIcon("townportalactive.png")
        inst.icon.MiniMapEntity:SetPriority(20)
        inst.icon.MiniMapEntity:SetDrawOverFogOfWar(true)
    end

    inst.channeler = channeler.components.sanity ~= nil and channeler or nil
    if inst.channeler ~= nil then
        inst.channeler.components.sanity:DoDelta(-TUNING.SANITY_MED)
        inst.channeler.components.sanity.externalmodifiers:SetModifier(inst, -TUNING.DAPPERNESS_SUPERHUGE)
    end
end

local function OnStopChanneling(inst, aborted)
    TheWorld:PushEvent("townportaldeactivated")

    inst.MiniMapEntity:SetIcon("townportal.png")
    inst.MiniMapEntity:SetPriority(0)

    if inst.icon ~= nil then
        inst.icon.MiniMapEntity:SetIcon("townportal.png")
        inst.icon.MiniMapEntity:SetPriority(0)
    end

    if inst.channeler ~= nil and inst.channeler:IsValid() and inst.channeler.components.sanity ~= nil then
        inst.channeler.components.sanity.externalmodifiers:RemoveModifier(inst)
    end
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

env.AddPrefabPostInit("townportal", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.components.channelable:SetChannelingFn(OnStartChanneling, OnStopChanneling)
    --return inst
end)
