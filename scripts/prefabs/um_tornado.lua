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

        SendModRPCToClient(GetClientModRPC("UncompromisingSurvival", "ToggleLagCompOn"), nil)
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

local QUAKEDEBRIS_CANT_TAGS = { "quakedebris" }
local QUAKEDEBRIS_ONEOF_TAGS = { "INLIMBO" }
local SMASHABLE_TAGS = { "smashable", "_combat" }
local NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable" }
local HEAVY_SMASHABLE_TAGS = { "smashable", "quakedebris", "_combat", "_inventoryitem", "NPC_workable" }
local HEAVY_NON_SMASHABLE_TAGS = { "INLIMBO", "playerghost", "irreplaceable", "caveindebris", "outofreach" }

local function _GroundDetectionUpdate(debris, override_density)
    local x, y, z = debris.Transform:GetWorldPosition()
    if y <= .5 then
        debris.Transform:SetPosition(x, 0, z)
        debris.Physics:ClearMotorVelOverride()

        if not debris:IsOnValidGround() then
            debris:PushEvent("detachchild")
            debris:Remove()
        else
            local softbounce = false
            if debris:HasTag("heavy") then
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, HEAVY_NON_SMASHABLE_TAGS, HEAVY_SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v.components.combat ~= nil then
                            v.components.combat:GetAttacked(debris, 30, nil)
                        elseif v.components.inventoryitem ~= nil then
                            if v.components.mine ~= nil then
                                v.components.mine:Deactivate()
                            end
                            Launch(v, debris, TUNING.LAUNCH_SPEED_SMALL / 10)
                        end
                    end
                end
            else
                local ents = TheSim:FindEntities(x, 0, z, 2, nil, NON_SMASHABLE_TAGS, SMASHABLE_TAGS)
                for i, v in ipairs(ents) do
                    if v ~= debris and v:IsValid() and not v:IsInLimbo() then
                        softbounce = true
                        if v.components.combat ~= nil and not (v:HasTag("epic") or v:HasTag("wall")) then
                            v.components.combat:GetAttacked(debris, 20, nil)
                        end
                    end
                end
            end

            debris.Physics:SetDamping(.9)

            if softbounce then
                local speed = 3.2 + math.random()
                local angle = math.random() * 2 * PI
                debris.Physics:SetMotorVel(0, 0, 0)
                debris.Physics:SetVel(speed * math.cos(angle), speed * 2.3, speed * math.sin(angle))
            end

            if debris.shadow ~= nil then
                debris.shadow:Remove()
                debris.shadow = nil
            end
            if debris.updatetask ~= nil then
                debris.updatetask:Cancel()
                debris.updatetask = nil
            end
            local density = override_density or DENSITYRADIUS
            if density <= 0 or debris.prefab == "mole" or debris.prefab == "rabbit" or not (math.random() < .75 or #TheSim:FindEntities(x, 0, y, density, nil, QUAKEDEBRIS_CANT_TAGS, QUAKEDEBRIS_ONEOF_TAGS) > 1) then
                -- keep it

                debris.entity:SetCanSleep(true)
                if debris.components.inventoryitem then
                    debris.components.inventoryitem.canbepickedup = true
                end
                debris:PushEvent("stopfalling")
            elseif debris.components.inventoryitem then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
    elseif debris:GetTimeAlive() < 3 then
        if y < 2 then
            debris.Physics:SetMotorVel(0, 0, 0)
        end
        local scaleFactor = Lerp(.5, 1.5, y / 35)
        debris.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
        if debris.components.inventoryitem ~= nil then
            debris.components.inventoryitem.canbepickedup = true
        end
    elseif debris:IsInLimbo() then
        -- failsafe, but maybe we got trapped or picked up somehow, so keep it

        debris.entity:SetCanSleep(true)
        debris.shadow:Remove()
        debris.shadow = nil
        debris.updatetask:Cancel()
        debris.updatetask = nil
        if debris._restorepickup then
            debris._restorepickup = nil
            if debris.components.inventoryitem ~= nil then
                debris.components.inventoryitem.canbepickedup = true
            end
        end
        debris:PushEvent("stopfalling")
        if debris.components.inventoryitem ~= nil then
            debris.components.inventoryitem.canbepickedup = true
        end
    end
end


local function PickItem(item, inst)
    if item.components.inventoryitem ~= nil and item.prefab ~= "bullkelp_beachedroot" and item:IsValid() then
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
        local pickables = TheSim:FindEntities(x, y, z, 12, { "pickable" }, { "INLIMBO", "trap" })
        for k, v in ipairs(pickables) do
            if v.components.pickable:CanBePicked() then
                if not v:IsAsleep() and not config == "reduced" then
                    v.components.pickable:Pick(TheWorld)
                else
                    if v:IsAsleep() and config == "reduced" then
                        return
                    end
                    v.components.pickable:Pick(inst)
                end
            end
        end

        -- WORKING
        local workables = TheSim:FindEntities(x, y, z, 6, nil, { "irreplaceable", "INLIMBO", "trap" },
            { "DIG_workable", "CHOP_workable" })

        for k, v in ipairs(workables) do
            if v.components.workable ~= nil and v.components.pickable == nil then
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

        -- ITEM SUCKING - Especifically *after* pickables/workables because it then will capture the items produced.
        local items_suck = config == "reduced" and
            TheSim:FindEntities(x, y, z, 12, { "_inventoryitem" },
                { "irreplaceable", "tornado_nosucky", "trap", "INLIMBO" }) or
            TheSim:FindEntities(x, y, z, 40, { "_inventoryitem" },
                { "irreplaceable", "tornado_nosucky", "trap", "INLIMBO" })
        local ground = TheWorld.Map:IsOceanAtPoint(x, y, z)
        local angle_deviation = config == "reduced" and (66 * RADIANS) or 0
        for k, v in pairs(items_suck) do
            if v and v.Physics and v.components.inventoryitem and not v.components.inventoryitem:IsHeld() and v.replica.inventoryitem ~= nil and v.replica.inventoryitem:CanBePickedUp() and v.prefab ~= "bullkelp_beachedroot" then
                local _x, _y, _z = v:GetPosition():Get()
                local item_ground = TheWorld.Map:IsOceanAtPoint(_x, _y, _z)
                if ground == item_ground then
                    if not v:IsAsleep() and not config == "reduced" then
                        _y = .1
                        v.Physics:Teleport(_x, _y, _z)
                        local dir = v:GetPosition() - inst:GetPosition()
                        local angle = math.atan2(-dir.z, -dir.x) + angle_deviation
                        v.Physics:ClearMotorVelOverride()
                        v.Physics:SetMotorVelOverride(math.cos(angle) * 10, 0, math.sin(angle) * 10)
                    else
                        PickItem(v, inst) --skip all the steps above if you're just gonna do it off-screen.
                    end
                end
            else
                v:AddTag("tornado_nosucky")
                v:DoTaskInTime(5, function() v:RemoveTag("tornado_nosucky") end)
            end
        end

        -- ITEM PICKING
        local items_pick = TheSim:FindEntities(x, y, z, 4, { "_inventoryitem" },
            { "irreplaceable", "tornado_nosucky", "trap", "INLIMBO" })
        for k, v in ipairs(items_pick) do
            if v.components.inventoryitem ~= nil and v.prefab ~= "bullkelp_beachedroot" then
                if config == "reduced" and v:IsAsleep() then
                    return
                end
                PickItem(v, inst)
            end
        end
    end

    -- DAMAGING
    local AURA_EXCLUDE_TAGS = { "noclaustrophobia", "rabbit", "playerghost", "player", "ghost", "shadow",
        "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "trap" }

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

local function TornadoItemTossTask(inst)
    for i = 1, math.random(3, 5) do
        local targetplayers = {}
        local targetplayer
        local x, y, z

        for k, v in ipairs(AllPlayers) do
            if v:HasTag("under_the_weather") then
                table.insert(targetplayers, v)
            end
        end

        targetplayer = targetplayers[#targetplayers > 1 and math.random(#targetplayers) or 1]
        if targetplayer == nil or math.random() > 0.5 then
            x, y, z = inst.Transform:GetWorldPosition()
            x = x + math.random(-50, 50)
            z = z + math.random(-50, 50)
        else
            x, y, z = targetplayer.Transform:GetWorldPosition()
            x = x + math.random(-10, 10)
            z = z + math.random(-10, 10)
        end

        if #inst.components.inventory.itemslots ~= 0 and x ~= nil and TheWorld.Map:IsPassableAtPoint(x, 0, z) then
            local item =
                inst.components.inventory.itemslots
                [math.random(#inst.components.inventory.itemslots)]
            if item ~= nil and not item:IsValid() then
                --idk why and wehn this stupid crash started happening
                return
            end

            local random_item = inst.components.inventory:RemoveItem(item)

            if random_item ~= nil and random_item:IsValid() then
                random_item:AddTag("tornado_nosucky")

                random_item.entity:SetCanSleep(false)

                random_item:AddTag("quakedebris")
                if random_item.components.inventoryitem ~= nil and random_item.components.inventoryitem.canbepickedup then
                    random_item.components.inventoryitem.canbepickedup = false
                    random_item._restorepickup = true
                end

                if math.random() < .5 then
                    random_item.Transform:SetRotation(180)
                end

                random_item:DoTaskInTime(8, function(inst) inst:RemoveTag("tornado_nosucky") end)
                random_item.Physics:Teleport(x, 35, z)
                random_item.Physics:SetMotorVel(0, math.random(-50, -33), 0)
                random_item.shadow = SpawnPrefab("warningshadow")
                random_item.shadow:ListenForEvent("onremove", function(debris) debris.shadow:Remove() end, random_item)
                random_item.shadow.Transform:SetPosition(x, 0, z)

                local scaleFactor = Lerp(.5, 1.5, 1)
                random_item.shadow.Transform:SetScale(scaleFactor, scaleFactor, scaleFactor)
                random_item.updatetask = random_item:DoPeriodicTask(FRAMES, _GroundDetectionUpdate, nil, 5)

                random_item.updatetask_timeout = random_item:DoTaskInTime(30, function(inst)
                    inst.Physics:ClearMotorVelOverride()

                    if inst.updatetask ~= nil or inst.shadow ~= nil then
                        print("PANIC? FALLING ITEM TIMED OUT!")
                        inst.entity:SetCanSleep(true)

                        if inst.shadow ~= nil then
                            inst.shadow:Remove()
                            inst.shadow = nil
                        end

                        if inst.updatetask ~= nil then
                            inst.updatetask:Cancel()
                            inst.updatetask = nil
                        end

                        if inst._restorepickup then
                            inst._restorepickup = nil
                            if inst.components.inventoryitem ~= nil then
                                inst.components.inventoryitem.canbepickedup = true
                            end
                        end

                        inst:PushEvent("stopfalling")

                        if inst.components.inventoryitem ~= nil then
                            inst.components.inventoryitem.canbepickedup = true
                        end
                        local x, y, z = inst.Transform:GetWorldPosition()
                        inst.Transform:SetPosition(x, 0, z)
                    end
                end)
            end
        end
    end
end

local function TornadoTask(inst)
    if inst.startmoving then
        local x, y, z = inst.Transform:GetWorldPosition()
        local destination = TheSim:FindFirstEntityWithTag("um_tornado_destination")

        local players = TheSim:FindEntities(x, y, z, 300, nil, { "playerghost" }, { "player", "um_windturbine" })

        if math.random() > 0.9 then
            local lightning = SpawnPrefab("hound_lightning")
            lightning.Transform:SetPosition(x + math.random(-300, 300), 0, z + math.random(-300, 300))
            lightning.Delay = 1.5
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

            if not v:HasTag("um_windturbine") then
                if not v:HasTag("um_windturbine") then
                    if math.random() > 0.99 then
                        local lightning = SpawnPrefab("hound_lightning")
                        lightning.Transform:SetPosition(px + math.random(-5, 5), 0, pz + math.random(-5, 5))
                        lightning.Delay = 1.5
                    end

                    if v ~= nil and v:IsValid() and v:HasTag("player") and v.sg ~= nil and not v.sg:HasStateTag("gotgrabbed") and v:GetDistanceSqToInst(inst) < 300 or v.prefab ~= "bullkelp_beachedroot" and v.components.inventoryitem ~= nil and v:GetDistanceSqToInst(inst) < 600 and not v:HasTag("tornado_nosucky") or v.components.oceanfishable ~= nil and not v:HasTag("INLIMBO") then
                        local hat = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

                        if hat ~= nil then
                            v.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
                            v.components.inventory:DropItem(hat, true, true)
                            if hat.Physics ~= nil then
                                local x, y, z = hat.Transform:GetWorldPosition()
                                hat.Physics:Teleport(x, .3, z)

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

                        local dx, dy, dz = px + (((FRAMES * 5) * velx) / multiplierplayer) * inst.Transform:GetScale(), 0,
                            pz + (((FRAMES * 5) * velz) / multiplierplayer) * inst.Transform:GetScale()

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

            local x_dest2, y_dest2, z_dest2 = x + ((FRAMES * 3) * dest_velx), 0, z + ((FRAMES * 3) * dest_velz)

            if x_dest2 ~= nil then
                inst.Transform:SetPosition(x_dest2, y_dest2, z_dest2)
            end

            local ocean_anim = TheWorld.Map:IsOceanTileAtPoint(x_dest2, 0, z_dest2)
            local ground_anim = TheWorld.Map:IsPassableAtPoint(x_dest2, 0, z_dest2)

            if ground_anim then
                --inst.AnimState:OverrideSymbol("wormmovefx", "um_tornado", "wormmovefx")
            elseif ocean_anim then
                --inst.AnimState:OverrideSymbol("wormmovefx", "um_tornado", "wormmovefx_water")
            else
                --inst.AnimState:OverrideSymbol("wormmovefx", "um_tornado", "wormmovefx_void")
            end

            if inst.persists and (destination:IsValid() and inst:GetDistanceSqToInst(destination) < 50) --[[or (not TheWorld.Map:IsPassableAtPoint(x, 0, z) and not TheWorld.Map:IsOceanAtPoint(x, 0, z)))]] then
                inst.AnimState:PlayAnimation("tornado_pst", false)

                inst:ListenForEvent("animover", function()
                    inst.startmoving = false

                    for k, v in ipairs(inst.components.inventory.itemslots) do
                        local item = inst.components.inventory:RemoveItem(v)
                        local pos = getrandomposition(inst)
                        item.Transform:SetPosition(pos.x+math.random(-8,8), pos.y, pos.z+math.random(-8,8))
                    end

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
                        local item = inst.components.inventory:RemoveItem(v)
                        local pos = getrandomposition(inst)
                        item.Transform:SetPosition(pos.x+math.random(-8,8), pos.y, pos.z+math.random(-8,8))
                    end

                    inst.startmoving = false

                    inst:Remove()
                end)

                inst.persists = false
            end
        end

        if inst.whirlpool == nil and TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition()) then
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

    inst.Advance_Task = nil
    inst.is_full = false
    inst.danumber = 0

    inst:AddComponent("inspectable")
    inst:AddComponent("locomotor")

    inst.icon = SpawnPrefab("um_tornado_icon")
    inst.icon.entity:SetParent(inst.entity)

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(TornadoTask)

    inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true
    inst.components.inventory.maxslots = 100
    inst:DoTaskInTime(0, Init)

    --[[inst:DoPeriodicTask(30, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("um_tornado_destination_marker2").Transform:SetPosition(x, 0, z)
    end)]]

    if config ~= "minimal" then
        inst:DoPeriodicTask(5, TornadoItemTossTask)
    end
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

    if destination ~= nil then
        local x_dest, y_dest, z_dest = destination.Transform:GetWorldPosition()
        local dest_rad = math.rad(inst:GetAngleToPoint(x_dest, y_dest, z_dest))
        local dest_velx = math.cos(dest_rad)
        local dest_velz = -math.sin(dest_rad)

        local x_dest2, y_dest2, z_dest2 = x + ((FRAMES * 3) * dest_velx), 0, z + ((FRAMES * 3) * dest_velz)

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

    if x ~= nil then
        local ents = TheSim:FindEntities(x, y, z, 40, { "um_waterfall" })

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
    local x, y, z = inst.Transform:GetWorldPosition()

    x = x + math.random(-15, 15)
    z = z + math.random(-15, 15)

    if CanSpawnWaterfall(inst, x, y, z) then
        SpawnPrefab("um_waterfall_spawner").Transform:SetPosition(x, y, z)
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

    inst:AddComponent("updatelooper")
    inst.components.updatelooper:AddOnUpdateFn(CaveTornadoTask)

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
    --inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:AddTag("NOCLICK")
    inst:AddTag("NOBLOCK")
    inst:AddTag("um_tornado_destination")
    --inst.MiniMapEntity:SetIcon("redmooneye.png")

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
    --inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst.MiniMapEntity:SetIcon("greenmooneye.png")
    --inst.MiniMapEntity:SetCanUseCache(false)
    --inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    --[[inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)]]

    inst:DoTaskInTime(1920, inst.Remove)

    return inst
end

local function marker2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    -- inst.MiniMapEntity:SetIcon("yellowmooneye.png")
    -- inst.MiniMapEntity:SetCanUseCache(false)
    -- inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    --[[inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)]]

    inst:DoTaskInTime(1920, inst.Remove)

    return inst
end

local function marker3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --inst.MiniMapEntity:SetIcon("redmooneye.png")
    --inst.MiniMapEntity:SetCanUseCache(false)
    --inst.MiniMapEntity:SetDrawOverFogOfWar(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    --[[inst:DoTaskInTime(0, function(inst)
        inst.icon = SpawnPrefab("globalmapicon")
        inst.icon:TrackEntity(inst)
        inst.icon.persists = false

        inst.icon:DoTaskInTime(1920, inst.icon.Remove)
    end)]]

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
