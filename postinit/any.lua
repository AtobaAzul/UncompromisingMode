local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Remove pathing collision exploit by making objects noclip
-----------------------------------------------------------------
local IMPASSABLES = {
    ["sunkenchest"] = true,
    ["oceantreenut"] = true,
    ["shell_cluster"] = true,
    ["cavein_boulder"] = true,
    ["glassspike_short"] = true,
    ["glassspike_med"] = true,
    ["glassspike_tall"] = true,
    ["potatosack"] = true,
    ["endtable"] = true,
    ["fossil_stalker"] = true, -- Hornet: Why are we making the stalkers passable nocliped?
    ["homesign"] = true,
    ["statueharp"] = true,
    ["statue_marble"] = true,
    ["gravestone"] = true,
    ["arrowsign_post"] = true,
    ["lureplant"] = true,
    ["spiderden"] = true,
    ["spiderden_2"] = true,
    ["spiderden_3"] = true,
    ["klaus_sack"] = true,
    ["skeleton"] = true,
    ["skeleton_player"] = true,
}

if TUNING.DSTU.IMPASSBLES then
    env.AddPrefabPostInitAny(function(inst)
        if (IMPASSABLES[inst.prefab] or string.find(inst.prefab, "chesspiece_") or string.find(inst.prefab, "oversized")) and inst.Physics ~= nil then
            RemovePhysicsColliders(inst)
        end
        if (IMPASSABLES[inst.prefab] or string.find(inst.prefab, "chesspiece_") or string.find(inst.prefab, "oversized")) and inst.Physics ~= nil and inst.components.heavyobstaclephysics ~= nil then
            RemovePhysicsColliders(inst)
            inst.components.heavyobstaclephysics:SetRadius(0)
        end
    end)
end

env.AddPrefabPostInitAny(function(inst)
    if TheWorld and TheWorld.shard == inst then
        -- inst:AddComponent("shard_acidmushrooms")
    end
end)

-- hornet; i dont care enough to know where to put this
env.AddReplicableComponent("hayfever")
env.AddReplicableComponent("adrenaline")

-- I don't know where else to put this
env.AddPrefabPostInit("aphid", function(inst)
    if TestForIA() then
        inst:AddComponent("appeasement")
        inst.components.appeasement.appeasementvalue = TUNING.TOTAL_DAY_TIME
    end
end)

-- for the super spawner tags
env.AddPrefabPostInitAny(function(inst)
    local old_OnSave = inst.OnSave

    inst.OnSave = function(inst, data, ...)
        if inst.umss_tags then
            data.umss_tags = inst.umss_tags
        end

        if old_OnSave ~= nil then
            return old_OnSave(inst, data, ...)
        end
    end

    local old_OnLoad = inst.OnLoad
    inst.OnLoad = function(inst, data, ...)
        if data ~= nil and data.umss_tags ~= nil then
            for k, v in ipairs(data.umss_tags) do
                inst:AddTag("umss_" .. v)
            end
        end

        if old_OnLoad ~= nil then
            return old_OnLoad(inst, data, ...)
        end
    end
end)

local function FullHide(inst)
    inst.um_visibilityclient = 0
    inst:Hide()
    inst.AnimState:SetMultColour(1, 1, 1, 0)
    if inst.DynamicShadow then inst.DynamicShadow:Enable(false) end
end

local function AdjustVisibility(inst, distance, angle)
    local maintaindistance = 32
    if angle > -0.4 and angle < 0.4 then
        inst.um_visibilityclient = -(maintaindistance - distance) * 1e-3 + inst.um_visibilityclient
        if inst.um_visibilityclient > 1 then inst.um_visibilityclient = 1 end
    elseif angle > -0.6 and angle < 0.6 then
        inst.um_visibilityclient = -(maintaindistance - distance) * 1e-3 + inst.um_visibilityclient
        if inst.um_visibilityclient > 1 then inst.um_visibilityclient = 1 end
        inst.um_visibilityclient = inst.um_visibilityclient * math.abs(1 / angle)
    end
    local seebehinddistance = 1.5
    if distance < seebehinddistance then
        inst.um_visibilityclient = -(seebehinddistance - distance) + inst.um_visibilityclient
        if inst.um_visibilityclient > 1 then inst.um_visibilityclient = 1 end
    end
    print("distance ", distance)
    print("visclient ", inst.um_visibilityclient)
    if inst.um_visibilityclient <= 0 then
        FullHide(inst)
    else
        inst:Show()
        inst.AnimState:SetMultColour(1, 1, 1, inst.um_visibilityclient)
    end
    if inst.um_visibilityclient > 0.5 and inst.DynamicShadow then inst.DynamicShadow:Enable(true) end
end

local visradsmall = 0.6
local visradlarge = 0.8
local function AdjustVisibility(inst, distance, angle)
    local maintaindistance = 32
    local mindistance = 1.5
    if angle < visradsmall then
        inst.um_visibilityclient = 5e-2 + inst.um_visibilityclient
    elseif angle < visradlarge then
        inst.um_visibilityclient = 1e-4 + inst.um_visibilityclient
        if inst.um_visibilityclient > 1 then inst.um_visibilityclient = 1 end
        inst.um_visibilityclient = inst.um_visibilityclient * math.abs(1 / angle)
    elseif angle > visradlarge and distance > mindistance and inst.um_visibilityclient ~= 0 then
        inst.um_visibilityclient = -5e-2 + inst.um_visibilityclient
    end

    if distance < mindistance then
        inst.um_visibilityclient = (mindistance - distance) + inst.um_visibilityclient
        if inst.um_visibilityclient > 1 then inst.um_visibilityclient = 1 end
    end
    if inst.um_visibilityclient <= 0 then
        FullHide(inst)
    else
        inst:Show()
        inst.AnimState:SetMultColour(1, 1, 1, inst.um_visibilityclient)
    end
    if inst.um_visibilityclient > 0.5 and inst.DynamicShadow then inst.DynamicShadow:Enable(true) end
end

local function UpdateVisibility(inst)
    print("hello")
    --if ThePlayer and ThePlayer:HasTag("um_darkwood") then
    local distance = math.sqrt(ThePlayer:GetDistanceSqToInst(inst))
    local x, y, z = inst.Transform:GetWorldPosition()
    local x1, y1, z1 = ThePlayer.Transform:GetWorldPosition()
    local x2, z2
    if ThePlayer.um_mouseposition_x then
        x2 = ThePlayer.um_mouseposition_x
    else
        x2 = x1 + 1
    end
    if ThePlayer.um_mouseposition_z then
        z2 = ThePlayer.um_mouseposition_z
    else
        z2 = z1 + 1
    end
    local angle1 = -math.atan2((z2 - z1), (x2 - x1))
    local angle2 = -math.atan2(z - z1, x - x1)
    local angle = math.abs(angle1 - angle2)
    print("Adjusting")
    print("Distance")
    if distance > 20 then
        FullHide(inst)
    else
        AdjustVisibility(inst, distance, angle)
    end
    --end
end

local function PrepareVisibility(inst)
    inst:ListenForEvent("entitywake", function(inst)
        inst.um_visibilitycheck = inst:DoPeriodicTask(FRAMES, UpdateVisibility)
        inst.um_visibilityclient = 0
        FullHide(inst)
    end)
    inst:ListenForEvent("entitysleep", function(inst)
        inst.um_visibilitycheck:Cancel()
        inst.um_visibilitycheck = nil
        inst.um_visibilityclient = 0
        FullHide(inst)
    end)
end

env.AddPrefabPostInitAny(function(inst)
    if TheWorld.ismastersim then return inst end
    if ThePlayer ~= inst and (inst.entity or inst.replica.inventoryitem) and (inst:HasTag("monster") or inst:HasTag("smallcreature") or inst:HasTag("EPIC") or inst:HasTag("animal") or inst:HasTag("largecreature") or inst:HasTag("character") or inst.prefab == "carrot_planted" or inst.prefab == "red_mushroom" or inst.prefab == "green_mushroom" or inst.prefab == "blue_mushroom" or inst.prefab == "lichen" or inst:HasTag("oceanfishinghookable")) then
        -- if inst.prefab == "shadowheart" then
        --PrepareVisibility(inst)
    end
end)

local _AddPlatformFollower = EntityScript.AddPlatformFollower
--local _RemovePlatformFollower = EntityScript.RemovePlatformFollower

function EntityScript:AddPlatformFollower(child)
    if child ~= nil then
        _AddPlatformFollower(self, child)
    end
    if child ~= nil and child:HasTag("structure") then --probably a bad assumption, but i'm assuming structures cant/wont leave the boat - yell at me if this messes anything.
        RemovePhysicsColliders(child)                  --altough removing the structure collision instead of the player's seems like a more reasonable idea.
    end
end
