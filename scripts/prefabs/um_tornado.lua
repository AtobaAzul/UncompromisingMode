require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/Bigspin.zip"),
}

local prefabs = { "collapse_small", "nightlight_flame" }
local config = TUNING.DSTU.STORMS_PERFORMANCE

local function Advance_Full(inst)
    if inst.Advance_Task ~= nil then
        inst.Advance_Task:Cancel()
    end
    inst.Advance_Task = nil

    inst.startmoving = true

    inst.AnimState:PlayAnimation("tornado_loop", true)
end

local function Init(inst)
    inst.SoundEmitter:PlaySound("UCSounds/um_tornado/um_tornado_loop", "spinLoop")

    if not inst.is_full then
        -- TheWorld:PushEvent("ms_forceprecipitation", true)
        inst.AnimState:PlayAnimation("tornado_pre")

        inst.Advance_Task = inst:ListenForEvent("animover", Advance_Full)

        --SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "ToggleLagCompOn"), nil)
        inst.is_full = true
    else
        Advance_Full(inst)
    end
end

local function teleport_end(teleportee, locpos, inst)
    if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then
        teleportee.components.inventory:DropItem(teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY), true, true)
    end

    if teleportee:HasTag("player") then
        teleportee:ShowHUD(true)
        teleportee.sg.statemem.teleport_task = nil
        teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "um_tornado_wakeup")
    else
        teleportee:Show()
        if teleportee.DynamicShadow ~= nil then
            teleportee.DynamicShadow:Enable(true)
        end
        if teleportee.components.health ~= nil then
            teleportee.components.health:SetInvincible(false)
        end
        teleportee:PushEvent("teleported")
    end
end

local function getrandomposition(caster)
    local centers = {}

    for i, node in ipairs(TheWorld.topology.nodes) do
        -- local antimoonnode = TheWorld.Map:FindNodeAtPoint(node.x, 0, node.z)

        if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom and not (node ~= nil and node.tags ~= nil and (table.contains(node.tags, "lunacyarea") or table.contains(node.tags, "not_mainland"))) then
            table.insert(centers, { x = node.x, z = node.y })
        end
    end
    if #centers > 0 then
        local pos = centers[math.random(#centers)]
        return Point(pos.x, 0, pos.z)
    else
        return caster:GetPosition()
    end
end

local function teleport_continue(teleportee, locpos, inst)
    local ground = TheWorld
    if teleportee.Physics ~= nil then
        teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
    else
        teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
    end

    if teleportee:HasTag("player") then
        teleportee:SnapCamera()
        teleportee:ScreenFade(true, 2)
        teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3,
            function() teleport_end(teleportee, locpos, inst) end)
    else
        teleport_end(teleportee, locpos, inst)
    end
end



local destroy_prefabs = {
    "log",
    "cutgrass",
    "pinecone",
    "twigs",
    "spoiledfood",
    "poop",
}

local function PickItem(item, inst)
    if item.components.inventoryitem ~= nil and item.prefab ~= "bullkelp_beachedroot" and item:IsValid() and not item:HasTag("heavy") then
        if item.Physics ~= nil then item.Physics:Stop() end
        inst.components.inventory:GiveItem(item)
        local stacksize = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1

        if item.components.health ~= nil then
            -- NOTES(JBK): Push the events before spawning any giving any loot.
            item:PushEvent("murdered", { victim = item, stackmult = stacksize })
            item:PushEvent("killed", { victim = item, stackmult = stacksize })

            if item.components.lootdropper ~= nil then
                item.causeofdeath = inst
                for i = 1, stacksize do
                    local loots = item.components.lootdropper:GenerateLoot()
                    for k, _loot in pairs(loots) do
                        local loot = SpawnPrefab(_loot)
                        if loot ~= nil and loot:IsValid() then
                            inst.components.inventory:GiveItem(loot)
                        else
                            loot:Remove()
                        end
                    end
                end
            end

            if item ~= nil and item.components.inventory and item:HasTag("drop_inventory_onmurder") then
                item.components.inventory:TransferInventory(inst)
            end

            item:Remove()
        end
    end
end

local function TornadoEnviromentTask(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    if config ~= "minimal" then
        -- if GetClosestInstWithTag("player", inst, PLAYER_CAMERA_SEE_DISTANCE * 1.125) ~= nil then -- tornado doesn't sleep. Using alt distance-based check.
        -- PICKABLES
        local pickables = TheSim:FindEntities(x, y, z, 12, nil, {"prototyper", "INLIMBO", "trap", "flower","heavy",  "tornado_nosucky" }, { "pickable", "HACK_workable" })
        for k, v in ipairs(pickables) do
            local _x, _y, _z = v.Transform:GetWorldPosition()
            if v.components.pickable ~= nil and v.components.pickable:CanBePicked() and not IsUnderRainDomeAtXZ(_x, _z) then
                if not v:IsAsleep() and not config == "reduced" then
                    v.components.pickable:Pick(TheWorld)
                else
                    if v:IsAsleep() and config == "reduced" then
                        return
                    end

                    v.components.pickable:Pick(inst)
                end
            elseif v.components.hackable and v.components.hackable:CanBeHacked() then
                if not v:IsAsleep() and not config == "reduced" then
                    v.components.hackable:Hack(TheWorld, 1)
                else
                    if v:IsAsleep() and config == "reduced" then
                        return
                    end

                    v.components.hackable:Hack(inst, 1)
                end
            end
        end

        -- WORKING
        local workables = TheSim:FindEntities(x, y, z, 6, nil, { "heavy", "irreplaceable", "INLIMBO", "trap", "winter_tree", "farm_plant", "_inventory", "sign", "drawable", "tornado_nosucky" },
            { "DIG_workable", "CHOP_workable" })

        for k, v in ipairs(workables) do
            local _x, _y, _z = v.Transform:GetWorldPosition()

            if v.components.workable ~= nil and not v.components.pickable and not v.components.hackable and not string.match(v.prefab, "oceantree") and not v.components.spawner and not IsUnderRainDomeAtXZ(_x, _z) then
                if not v:IsAsleep() then
                    if v.components.workable.action == ACTIONS.DIG then
                        local fx = SpawnPrefab("shovel_dirt")
                        local x1, y1, z1 = v.Transform:GetWorldPosition()
                        fx.Transform:SetPosition(x1, y1, z1)
                    end
                    v.components.workable:WorkedBy(inst, 2.5)
                else
                    if config == "reduced" then
                        return
                    end
                    v.components.workable:Destroy(inst)
                end
            end
        end

        -- ITEM PICKING
        local items_pick = TheSim:FindEntities(x, y, z, 6, { "_inventoryitem" }, --no dome check because dome component adds nosucky tag.
            { "irreplaceable", "tornado_nosucky", "trap", "INLIMBO", "heavy", "backpack" })
        for k, v in ipairs(items_pick) do
            if v.components.inventoryitem ~= nil and v.prefab ~= "bullkelp_beachedroot" then
                if config == "reduced" and v:IsAsleep() then
                    return
                end
                if table.contains(destroy_prefabs, v.prefab) and math.random() > 0.5 then
                    v:Remove()
                else
                    PickItem(v, inst)
                end
            end
        end
    end

    -- DAMAGING
    local AURA_EXCLUDE_TAGS = { "noclaustrophobia", "rabbit", "playerghost", "player", "ghost", "shadow",
        "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "trap", "tornado_nosucky" }

    local targets = TheSim:FindEntities(x, y, z, 4, nil, AURA_EXCLUDE_TAGS, { "_combat", "um_tornado_redirector" })

    for k, v in ipairs(targets) do
        if v.components.health ~= nil and not v.components.health:IsDead() then
            v.components.combat:GetAttacked(inst, 2.5)
        elseif v:HasTag("um_tornado_redirector") then
            local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")
            if destination ~= nil then
                if destination.danumber ~= nil then
                    inst.danumber = destination.danumber

                    if inst.resetdanumber_task ~= nil then
                        inst.resetdanumber_task:Cancel()
                    end

                    inst.resetdanumber_task = nil

                    inst.resetdanumber_task = inst:DoTaskInTime(30, function()
                        if inst.resetdanumber_task ~= nil then
                            inst.resetdanumber_task:Cancel()
                        end

                        inst.resetdanumber_task = nil
                        inst.danumber = 0
                    end)
                end
            end
        end
    end
end

local function TornadoTask(inst)
    if inst.startmoving then
        local x, y, z = inst.Transform:GetWorldPosition()
        local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")
        local players = TheSim:FindEntities(x, y, z, 300, nil, { "playerghost" }, { "player", "um_windturbine" })

        if math.random() > 0.99 and config ~= "minimal" then
            local _x, _y, _z = x + math.random(-150, 150), 0, z + math.random(-150, 150)

            if not IsUnderRainDomeAtXZ(_x, _z) then
                local lightning = SpawnPrefab("hound_lightning")

                lightning.Transform:SetPosition(_x, _y, _z)
                lightning.NoTags = { "INLIMBO", "shadow", "structure", "wall", "companion", "abigail", "bird", "prey" }
                lightning.Delay = 1.25 + math.random() / 2
            end
        end

        for k, v in pairs(players) do
            local px, py, pz = v.Transform:GetWorldPosition()
            if v:HasTag("player") or v:HasTag("um_windturbine") then
                v:AddTag("under_the_weather")

                if v.um_tornado_weathertask ~= nil then
                    v.um_tornado_weathertask:Cancel()
                    v.um_tornado_weathertask = nil
                end

                v.um_tornado_weathertask = v:DoTaskInTime(1, function()
                    v:RemoveTag("under_the_weather")

                    v.um_tornado_weathertask = nil
                end)
            end
            if not IsUnderRainDomeAtXZ(px, pz) then
                if not v:HasTag("um_windturbine") then
                    local rand = math.random()
                    local px, py, pz = v.Transform:GetWorldPosition()
                    if (v.prefab == "wes" and rand > 0.95 or rand > 0.99) then
                        local lightning_targeted = SpawnPrefab("hound_lightning")
                        lightning_targeted.Transform:SetPosition(px + math.random(-5, 5), 0, pz + math.random(-5, 5))
                        lightning_targeted.NoTags = { "INLIMBO", "shadow", "structure", "wall", "companion", "abigail", "bird",
                            "prey" }
                        lightning_targeted.Delay = 1.5
                    end

                    if v ~= nil and v:IsValid() and v:HasTag("player") and v.sg ~= nil and not v.sg:HasStateTag("gotgrabbed") and v:GetDistanceSqToInst(inst) < 300 or v.prefab ~= "bullkelp_beachedroot" and v.components.inventoryitem ~= nil and v:GetDistanceSqToInst(inst) < 600 and not v:HasTag("tornado_nosucky") or v.components.oceanfishable ~= nil and not v:HasTag("INLIMBO") then
                        local hat = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

                        if hat ~= nil and not hat:HasTag("gotgrabbed") then
                            hat:AddTag("tornado_nosucky")
                            hat:AddTag("gotgrabbed")

                            hat:DoTaskInTime(1.5, function(inst)
                                hat:RemoveTag("tornado_nosucky")
                            end)

                            hat:DoTaskInTime(3.5, function(inst)
                                hat:RemoveTag("gotgrabbed")
                            end)

                            v.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
                            v.components.inventory:DropItem(hat, true, true)
                            if hat.Physics ~= nil then
                                local x, y, z = hat.Transform:GetWorldPosition()
                                hat.Physics:Teleport(x, .8, z)

                                local angle = (math.random() * 20 - 10) * DEGREES
                                if inst ~= nil and inst:IsValid() then
                                    x, y, z = v.Transform:GetWorldPosition()
                                    local x1, y1, z1 = inst.Transform:GetWorldPosition()
                                    angle = angle + (
                                        (x1 == x and z1 == z and math.random() * 2 * PI) or
                                        math.atan2(z1 - z, x1 - x)
                                    )
                                else
                                    angle = angle + math.random() * 2 * PI
                                end
                                local speed = 3 + math.random() * 2
                                hat.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
                            end
                        end

                        local rad = math.rad(v:GetAngleToPoint(x, y, z))
                        local velx = math.cos(rad)
                        local velz = -math.sin(rad)

                        local multiplierplayer = inst:GetDistanceSqToPoint(px, py, pz)

                        multiplierplayer = multiplierplayer / 60

                        if multiplierplayer < .4 then
                            multiplierplayer = .4

                            if v.components.health ~= nil and not v.components.health:IsDead() and v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") and not v.components.health:IsInvincible() and v:HasTag("player") then
                                local locpos = getrandomposition(v)
                                v.sg:GoToState("um_tornado_teleport")
                                v.sg.statemem.teleport_task = v:DoTaskInTime(3,
                                    function() teleport_continue(v, locpos, inst) end)
                            end
                        end

                        local dx, dy, dz = px + (((.1 * 5) * velx) / multiplierplayer) * inst.Transform:GetScale(), 0,
                            pz + (((.1 * 5) * velz) / multiplierplayer) * inst.Transform:GetScale()

                        local ground = TheWorld.Map:IsOceanTileAtPoint(dx, dy, dz) -- changed to IsOceanTile for better ocean support, don't want tornado scuking things into the void.
                        local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
                        local p_ground = TheWorld.Map:IsOceanTileAtPoint(px, py, pz)

                        if dx ~= nil and (ground == p_ground or boat) then
                            v.Transform:SetPosition(dx, dy, dz)
                        end
                    end
                end
            end
        end

        if destination ~= nil then
            local x_dest, y_dest, z_dest = destination.Transform:GetWorldPosition()
            local dest_rad = math.rad(inst:GetAngleToPoint(x_dest, y_dest, z_dest) + inst.danumber)
            local dest_velx = math.cos(dest_rad)
            local dest_velz = -math.sin(dest_rad)

            local x_dest2, y_dest2, z_dest2 = x + ((.1 * 3) * dest_velx), 0, z + ((.1 * 3) * dest_velz)

            if x_dest2 ~= nil then
                inst.Transform:SetPosition(x_dest2, y_dest2, z_dest2)
            end

            local ocean_anim = TheWorld.Map:IsOceanTileAtPoint(x_dest2, 0, z_dest2)
            local ground_anim = TheWorld.Map:IsPassableAtPoint(x_dest2, 0, z_dest2)

            if inst.persists and (destination:IsValid() and inst:GetDistanceSqToInst(destination) < 50) --[[or (not TheWorld.Map:IsPassableAtPoint(x, 0, z) and not TheWorld.Map:IsOceanAtPoint(x, 0, z)))]] then
                inst.AnimState:PlayAnimation("tornado_pst", false)

                inst:ListenForEvent("animover", function()
                    inst.startmoving = false


                    local inv = TheWorld.components.garbagepatch_manager:GetInventory()
                    inst.components.inventory:TransferInventory(inv)

                    TheWorld.components.garbagepatch_manager:SpawnPatch()
                    if destination ~= nil then
                        destination:Remove()
                    end

                    inst:Remove()
                end)

                inst.persists = false

                if destination ~= nil then
                    destination.persists = false
                end
            end
        else
            if inst.persists then
                inst.AnimState:PlayAnimation("tornado_pst", false)

                inst:ListenForEvent("animover", function()
                    for k, v in ipairs(inst.components.inventory.itemslots) do
                        local item = inst.components.inventory:RemoveItem(v, true)
                        local pos = getrandomposition(inst)
                        item.Transform:SetPosition(pos.x + math.random(-8, 8), pos.y, pos.z + math.random(-8, 8))
                    end

                    inst.startmoving = false

                    inst:Remove()
                end)

                inst.persists = false
            end
        end

        if inst.whirlpool == nil and TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition()) and not TestForIA() then
            inst.whirlpool = SpawnPrefab("um_whirlpool")
            inst.whirlpool.entity:SetParent(inst.entity)
            inst.whirlpool.Transform:SetPosition(0, 0, 0)
            inst.whirlpool.Transform:SetScale(2, 2, 2)
        elseif inst.whirlpool ~= nil and not TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition()) then
            inst.whirlpool.components.timer:StartTimer("kill_whirlpool", 1)
            inst.whirlpool = nil
        end
    end
end

local function OnSave(inst, data) data.is_full = inst.is_full end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.is_full = data.is_full
    end
end

local function OnRemoveEntity(inst)
    inst.icon:Remove()
end

local function fn()
    local inst = CreateEntity()
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("scarytoprey")

    inst.AnimState:SetBank("tornado_weather")
    inst.AnimState:SetBuild("tornado_weather")

    inst:AddTag("um_tornado")

    inst.AnimState:SetMultColour(1, 1, 1, .8)
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    if not TUNING.DSTU.STORMS then
        inst:DoTaskInTime(0, inst.Remove)
    end

    inst.ForceEnding = function()
        local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")

        inst.AnimState:PlayAnimation("tornado_pst", false)

        inst:ListenForEvent("animover", function()
            inst.startmoving = false

            inst.components.inventory:TransferInventory(TheWorld.components.garbagepatch_manager:GetInventory())

            TheWorld.components.garbagepatch_manager:SpawnPatch()

            if destination ~= nil then
                destination:Remove()
            end

            inst:Remove()
        end)

        inst.persists = false

        if destination ~= nil then
            destination.persists = false
        end
    end

    inst.Advance_Task = nil
    inst.is_full = false
    inst.danumber = 0

    inst:AddComponent("inspectable")
    inst:AddComponent("locomotor")

    inst.icon = SpawnPrefab("um_tornado_icon")
    inst.icon.entity:SetParent(inst.entity)

    inst:DoPeriodicTask(.1, TornadoTask)

    --inst:AddComponent("updatelooper")
    -- inst.components.updatelooper:AddOnUpdateFn(TornadoTask)

    inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true
    inst.components.inventory.maxslots = 100
    inst:DoTaskInTime(0, Init)

    --[[inst:DoPeriodicTask(30, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("um_tornado_destination_marker2").Transform:SetPosition(x, 0, z)
    end)]]

    inst:DoPeriodicTask(0.25, TornadoEnviromentTask)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst.OnRemoveEntity = OnRemoveEntity

    return inst
end

local function iconfn()
    local inst = CreateEntity()

    inst.entity:SetCanSleep(false)

    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("um_tornado_map.tex")
    inst.MiniMapEntity:SetPriority(15)
    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)
    inst.MiniMapEntity:SetRestriction("nightmaretracker")

    inst:AddTag("CLASSIFIED")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("maprevealable")
    inst.components.maprevealable:AddRevealSource(inst, "um_tornadotracker")
    inst.components.maprevealable:SetIconPriority(15)
    --inst.MiniMapEntity:SetRestriction("")
    inst.components.maprevealable:Start()

    inst.persists = false

    return inst
end

local function CaveTornadoTask(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")

    if math.random() > 0.96 then
        SpawnPrefab("cavein_debris").Transform:SetPosition(x, 0, z)
    end

    if destination ~= nil and TheWorld.state.isspring then
        local x_dest, y_dest, z_dest = destination.Transform:GetWorldPosition()
        local dest_rad = math.rad(inst:GetAngleToPoint(x_dest, y_dest, z_dest))
        local dest_velx = math.cos(dest_rad)
        local dest_velz = -math.sin(dest_rad)

        local x_dest2, y_dest2, z_dest2 = x + ((.1 * 3) * dest_velx), 0, z + ((.1 * 3) * dest_velz)

        if x_dest2 ~= nil then
            inst.Transform:SetPosition(x_dest2, y_dest2, z_dest2)
        end

        if destination:IsValid() and inst:GetDistanceSqToInst(destination) < 50 then
            destination:Remove()
            inst:Remove()
        end
    else
        inst:Remove()
    end
end

local function CanSpawnWaterfall(inst, x, y, z)
    local is_valid_tile = true

    if TheWorld.state.isspring and x ~= nil then
        local ents = TheSim:FindEntities(x, y, z, 50, { "um_waterfall" })

        if ents ~= nil and #ents > 0 then
            is_valid_tile = false
        end

        local offs = { { -2, -2 }, { -1, -2 }, { 0, -2 }, { 1, -2 }, { 2, -2 }, { -2, -1 }, { 2, -1 }, { -2, 0 },
            { 2,  0 },
            { -2, 1 }, { 2, 1 }, { -2, 2 }, { -1, 2 }, { 0, 2 }, { 1, 2 }, { 2, 2 }, { -2, -2 }, { -2, -3 }, { 0, -3 },
            { 2, -3 }, { 3, -3 }, { -3, -2 }, { 3, -2 }, { -3, 0 }, { 3, 0 }, { -3, 1 }, { 3, 2 }, { -3, 3 }, { -2, 3 },
            { 0, 3 }, { 2, 3 }, { 3, 3 } }

        for i = 1, #offs, 1 do
            local curoff = offs[i]
            local offx, offz = curoff[1], curoff[2]

            if not TheWorld.Map:IsPassableAtPoint(x + offx, y, z + offz) then
                is_valid_tile = false
            end
        end
    else
        is_valid_tile = false
    end

    return is_valid_tile
end

local function TrySpawnWaterfall(inst, x, z)
    if not TheWorld.state.isspring then
        inst.persists = false
        inst:Remove()
    else
        local x, y, z = inst.Transform:GetWorldPosition()

        x = x + math.random(-15, 15)
        z = z + math.random(-15, 15)

        if CanSpawnWaterfall(inst, x, y, z) then
            SpawnPrefab("um_waterfall_spawner").Transform:SetPosition(x, y, z)
        end
    end
end

local function cavefn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoPeriodicTask(.1, CaveTornadoTask)
    --inst:AddComponent("updatelooper")
    --inst.components.updatelooper:AddOnUpdateFn(CaveTornadoTask)

    inst:DoPeriodicTask(5, TrySpawnWaterfall)

    --[[inst:DoPeriodicTask(30, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("um_tornado_destination_marker2").Transform:SetPosition(x, 0, z)
    end)]]

    return inst
end

local function MoveDestination(inst)
    if inst.dest_can_move then
        if not inst.components.timer:TimerExists("stop_moving") then
            inst.components.timer:StartTimer("stop_moving", (TheWorld.state.springlength / 7) * 480)
            --inst.components.timer:StartTimer("stop_moving", 10)
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        local theta = (inst:GetAngleToPoint(0, 0, 0) + inst.danumber) * DEGREES

        x = x + 7.5 * math.cos(theta)
        z = z - 7.5 * math.sin(theta)

        inst.Transform:SetPosition(x, 0, z)
    end

    if not inst.components.timer:TimerExists("delete_destination") then
        inst.components.timer:StartTimer("delete_destination", (TheWorld.state.springlength / 4.5) * 480)
        --inst.components.timer:StartTimer("delete_destination", 30)
    end


    if not TheWorld.state.isspring then
        inst.persists = false
        inst:Remove()
    end
end

local function OnSave_Dest(inst, data) data.danumber = inst.danumber end

local function OnLoad_Dest(inst, data)
    if data ~= nil then
        inst.danumber = data.danumber
    end
end

local function StopDestinationMoving(inst, data)
    if data.name == "stop_moving" then
        inst.dest_can_move = false
    elseif data.name == "delete_destination" then
        inst.persists = false
        inst:Remove()
    end
end

local function destfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("um_tornado_destination")
    inst.MiniMapEntity:SetIcon("redmooneye.png")

    inst.entity:SetCanSleep(false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", StopDestinationMoving)

    inst.danumber = 90
    inst.marker = "um_tornado_destination_marker"
    inst.dest_can_move = true

    inst:DoPeriodicTask(1, MoveDestination)

    --[[inst:DoPeriodicTask(30, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab(inst.marker).Transform:SetPosition(x, 0, z)
    end)]]

    inst.OnSave = OnSave_Dest
    inst.OnLoad = OnLoad_Dest

    return inst
end

local function marker()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("greenmooneye.png")
    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)

    inst:DoTaskInTime(1920, inst.Remove)

    return inst
end

local function marker2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("yellowmooneye.png")
    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)

    inst:DoTaskInTime(1920, inst.Remove)

    return inst
end

local function marker3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("redmooneye.png")
    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)

    inst:DoTaskInTime(1920, inst.Remove)

    return inst
end

return Prefab("um_tornado", fn, assets, prefabs),
    Prefab("um_tornado_icon", iconfn, assets, prefabs),
    Prefab("um_cavetornado", cavefn, assets, prefabs),
    Prefab("um_tornado_destination", destfn, assets, prefabs),
    Prefab("um_tornado_destination_marker", marker, assets, prefabs),
    Prefab("um_tornado_destination_marker2", marker2, assets, prefabs),
    Prefab("um_tornado_destination_marker3", marker3, assets, prefabs)
