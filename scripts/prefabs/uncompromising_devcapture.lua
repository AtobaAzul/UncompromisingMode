require "prefabutil"

local io = require("io")

local function CheckValidEntities(inst, capture)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.range, nil, {"DEVBEHOLDER", "player", "bird", "NOCLICK", "CLASSIFIED", "FX", "INLIMBO", "smalloceancreature", "DECOR", "walkingplank"})
    local itemsinside = inst.components.container:GetAllItems()

    inst.range = 0

    for i, v in ipairs(itemsinside) do
        if v.prefab == "log" then
            inst.range = inst.range + v.components.stackable:StackSize()
        end -- since each log is 1, 4 logs = 1 tile!
        if v.prefab == "boards" then
            inst.range = inst.range + (v.components.stackable:StackSize() * TILE_SCALE)
        end
        v:AddTag("DEVBEHOLDER")
    end

    if capture then
        return ents
    else
        for k, v in ipairs(ents) do
            if v.AnimState ~= nil then
                local r, g, b, a = v.AnimState:GetMultColour()
                v.previous_rgba = {}
                v.previous_rgba.r, v.previous_rgba.g, v.previous_rgba.b, v.previous_rgba.a = r, g, b, a
                v.AnimState:SetMultColour(0, 1, 0, a)
            end
        end
    end
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end

    CheckValidEntities(inst)
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end

    CheckValidEntities(inst)
end

local function onhammered(inst, worker) inst:Remove() end

local function onhit(inst, worker) inst:Remove() end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function OnStopChanneling(inst) inst.channeler = nil end

local function Capture(inst)
    local rotation = nil

    local x, y, z = inst.Transform:GetWorldPosition()
    local itemsinside = inst.components.container:GetAllItems()

    for i, v in ipairs(itemsinside) do
        if v.prefab == "log" then
            inst.range = inst.range + v.components.stackable:StackSize()
        end -- since each log is 1, 4 logs = 1 tile!
        if v.prefab == "boards" then
            inst.range = inst.range + (v.components.stackable:StackSize() * TILE_SCALE)
        end
        v:AddTag("DEVBEHOLDER")
    end

    local ents = TheSim:FindEntities(x, y, z, inst.range, nil, {"DEVBEHOLDER", "player", "bird", "NOCLICK", "CLASSIFIED", "FX", "INLIMBO", "smalloceancreature", "DECOR"})
    local totaltable_number = tostring(math.random(1000))
    local tableName = string.gsub(inst.components.writeable.text, " ", "_") or not inst.components.writeable.text and "returnedTable" .. totaltable_number
    local totaltable = tableName .. " = { \n	"

    if inst.components.writeable.text then
        totaltable = totaltable .. "	name = \"" .. inst.components.writeable.text .. "\","
    else
        totaltable = totaltable .. "	name = \"returnedTable" .. totaltable_number .. "\","
    end

    totaltable = totaltable .. " rotate = true, tile_centered = true, \n		content = {"
    for i, v in ipairs(ents) do
        if v.previous_rgba ~= nil then
            local rgb = v.previous_rgba
            v.AnimState:SetMultColour(rgb.r, rgb.g, rgb.b, rgb.a)
        end

        local px, py, pz = v.Transform:GetWorldPosition()
        local vx = px - x
        local vy = py - y
        local vz = pz - z
        totaltable = totaltable .. "	{x = " .. vx .. ", z = " .. vz .. ", prefab = \"" .. v.prefab .. "\""

        if v.components.pickable and v.components.pickable:IsBarren() then
            totaltable = totaltable .. ", barren = true"
        end

        if v.components.witherable and v.components.witherable:IsWithered() then
            totaltable = totaltable .. ", withered = true"
        end

        if TheWorld.Map:IsOceanAtPoint(px, py, pz) then -- Not in use currently
            totaltable = totaltable .. ", ocean = true"
        else
            totaltable = totaltable .. ", ocean = false"
        end

        if (v.prefab == "umdc_tileflag" and TheWorld.Map:GetTileAtPoint(px, py, pz)) then
            totaltable = totaltable .. ", tile = " .. tostring(TheWorld.Map:GetTileAtPoint(px, py, pz)) -- flags always get tiles, regardless of tile setting.
        end

        if v.components.health ~= nil and not v.components.health:IsDead() then
            totaltable = totaltable .. ", health = " .. tostring(v.components.health:GetPercent())
        end

        if v:HasTag("burnt") then
            totaltable = totaltable .. ", burnt = true"
        end

        if v.components.container ~= nil and not v.components.container:IsEmpty() then
            -- totaltable = totaltable..", contents = "..tostring(v.components.container:GetAllItems())
            -- this results in a table.
            -- not sure how I'd do this. I know scenarios can insert loot into chests, so that might work instead. But does limit what loot we have inside.
        end

        if v.components.finiteuses ~= nil then
            totaltable = totaltable .. ", uses = " .. tostring(v.components.finiteuses:GetUses())
        end

        if v.components.fueled ~= nil then
            totaltable = totaltable .. ", fuel = " .. tostring(v.components.fueled:GetPercent())
        end

        if v.components.scenariorunner ~= nil and v.components.scenariorunner.scriptname ~= nil then
            totaltable = totaltable .. ", scenario = " .. tostring(v.components.scenariorunner.scriptname)
        end

        if v:HasTag("fence") or v.prefab == "fast_farmplot" or v.prefab == "slow_farmplot" then
            totaltable = totaltable .. ", rotation = " .. tostring(v.Transform:GetRotation())
        end

        totaltable = totaltable .. "},"
    end

    totaltable = totaltable .. "},\n	},\n"

    local file_name = TUNING.DSTU.MODROOT .. "scripts/umss_tables.lua"

   
   

    local file = io.open(file_name, "r+")
    if file then
        local file_string = file:read("*a")
        file_string = string.gsub(file_string, "} return UMSS_TABLES", "")
        totaltable = file_string .. "\n    " .. totaltable .. "} return UMSS_TABLES"
        file:close()
        file = io.open(file_name, "w")
        local data = file:write(totaltable)
        file:close()
        TheNet:Announce("Successfully captured!") -- TODO: AUTO ADD UMSS PREFAB STUFF TOO!
        inst:Remove()
        return data
    else
        TheNet:Announce("Failed to write: file invalid!")
    end
    -- now supports ludicrously sized setpieces!
    -- had to write the result on a new file, print can only fit so much.
    -- now self writing!!!
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("structure")
    inst:AddTag("chest")
    inst:AddTag("DEVBEHOLDER")

    inst.AnimState:SetBank("chest")
    inst.AnimState:SetBuild("treasure_chest")
    inst.AnimState:PlayAnimation("closed")

    inst:AddTag("_writeable")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.range = 0

    inst:AddTag("_writeable")

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("um_devcapture")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(Capture, OnStopChanneling)
    inst.components.channelable.use_channel_longaction_noloop = true
    -- inst.components.channelable.skip_state_stopchanneling = true
    inst.components.channelable.skip_state_channeling = true

    inst:DoTaskInTime(0, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
        inst.Transform:SetPosition(tile_x, tile_y, tile_z)
    end)

    inst:DoPeriodicTask(1, CheckValidEntities, 0)
    inst:ListenForEvent("itemlose", CheckValidEntities)
    inst:ListenForEvent("itemget", CheckValidEntities)

    return inst
end

local function OnDropped(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local tile_x, tile_y, tile_z = TheWorld.Map:GetTileCenterPoint(x, 0, z)
    if tile_x ~= nil and tile_y ~= nil and tile_z ~= nil then
        inst.Transform:SetPosition(tile_x, tile_y, tile_z)
    end
end

local function TileFlag(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("gridplacer")
    inst.AnimState:SetBuild("gridplacer")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst.AnimState:SetMultColour(math.random(5, 10) / 10, math.random(5, 10) / 10, 0, 1)

    inst:AddTag("DYNLAYOUT_FLAG")

    -- MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 60

    inst:DoTaskInTime(0, OnDropped)
    inst.OnEntityWake = OnDropped

    return inst
end

return Prefab("um_devcapture", fn), -- Version 1.0
Prefab("umdc_tileflag", TileFlag)
