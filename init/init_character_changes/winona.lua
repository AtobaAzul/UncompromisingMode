-----------------------------------------------------------------
-- Only winona can power the generators
-- Relevant: upvaluehacker
-----------------------------------------------------------------

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local HUNGRY_THRESH_HIGH = 0.666

if TUNING.DSTU.WINONA_GEN and not TUNING.DSTU.UPDATE_CHECK then
    local function ItemTradeTest(inst, item, giver)
        if giver:HasTag("handyperson") then
            return inst._OldItemTradeTest(inst, item)
        else
            return false, "WINONAGEN"
        end
    end

    env.AddPrefabPostInit("winona_battery_high", function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if inst.components.trader ~= nil then
            inst._OldItemTradeTest = inst.components.trader.abletoaccepttest
            inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
        end
    end)

    local function ItemTradeTestLow(inst, item, giver)
        if giver:HasTag("handyperson") and item.prefab == "nitre" then
            return true
        else
            return false, "WINONAGEN"
        end
    end

    local function OnFuelGiven(inst, giver, item)
        inst.components.fueled:TakeFuelItem(item, giver)
    end

    env.AddPrefabPostInit("winona_battery_low", function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddComponent("trader")
        inst.components.trader:SetAbleToAcceptTest(ItemTradeTestLow)
        inst.components.trader.onaccept = OnFuelGiven
    end)
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function ActionHungerDrain(inst, data)
    if inst.components.rider ~= nil and inst.components.rider:IsRiding() then
        return
    end

    local burnrate = inst.components.hunger.burnratemodifiers:Get()
    local fast = inst.components.hunger:GetPercent() >= HUNGRY_THRESH_HIGH
    local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH
    local t = GetTime()

    local actions = { ACTIONS.CHOP, ACTIONS.MINE, ACTIONS.HAMMER, ACTIONS.ROW, ACTIONS.DIG, ACTIONS.ATTACK, ACTIONS.PICK, ACTIONS.TILL }

    if ACTIONS.HACK then
        table.insert(actions, ACTIONS.HACK)
    end

    if not table.contains(actions, data.action.action) then
        return
    end

    if fast then
        if inst._cdtask == nil then
            inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
            if inst.hungryfastbuildtalktime == nil or inst.hungryfastbuildtalktime + 10 < t then
                inst.hungryfastbuildtalktime = t + GetRandomMinMax(12, 24)
            elseif inst.hungryfastbuildtalktime < t then
                inst.hungryfastbuildtalktime = nil
                if not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) then
                    inst.components.talker:Say(GetString(inst, "ANNOUNCE_HUNGRY_FASTBUILD"))
                end
            end
            if data.action.action == ACTIONS.ROW or data.action.action == ACTIONS.TILL or
                data.action.action == ACTIONS.PICK and not (inst.components.rider ~= nil and inst.components.rider:IsRiding()) then
                inst.components.hunger:DoDelta(-0.1 * burnrate, true) --.2
            elseif data.action.action == ACTIONS.CHOP then
                if data.action.target ~= nil then
                    local snap = SpawnPrefab("impact")
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local x1, y1, z1 = data.action.target.Transform:GetWorldPosition()
                    if z1 ~= nil then
                        local angle = -math.atan2(z1 - z, x1 - x)
                        snap.Transform:SetPosition(x1, y1, z1)
                        snap.Transform:SetRotation(angle * RADIANS)
                        snap.Transform:SetScale(0.8, 0.8, 0.8)
                    end
                end

                inst.components.hunger:DoDelta(-0.2 * burnrate, true) --.333
            elseif data.action.action == ACTIONS.MINE or
                data.action.action == ACTIONS.HAMMER or
                ACTIONS.HACK ~= nil and data.action.action == ACTIONS.HACK then
                if data.action.target ~= nil then
                    local snap = SpawnPrefab("impact")
                    local x, y, z = inst.Transform:GetWorldPosition()
                    local x1, y1, z1 = data.action.target.Transform:GetWorldPosition()
                    if z1 ~= nil then
                        local angle = -math.atan2(z1 - z, x1 - x)
                        snap.Transform:SetPosition(x1, y1, z1)
                        snap.Transform:SetRotation(angle * RADIANS)
                        snap.Transform:SetScale(0.8, 0.8, 0.8)
                    end
                end

                inst.components.hunger:DoDelta(-0.333 * burnrate, true) --.5
            elseif data.action.action == ACTIONS.DIG then
                inst.components.hunger:DoDelta(-0.5 * burnrate, true)
            else
                inst.components.hunger:DoDelta(-0.15 * burnrate, true) --.25
            end
        end
    elseif not fast and not slow then
        if inst._cdtask == nil then
            inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
            if data.action.action == ACTIONS.ROW or data.action.action == ACTIONS.TILL or data.action.action == ACTIONS.PICK then
                inst.components.hunger:DoDelta(-0.05 * burnrate, true)
            elseif data.action.action == ACTIONS.CHOP then
                inst.components.hunger:DoDelta(-0.1 * burnrate, true)
            elseif data.action.action == ACTIONS.MINE or
                data.action.action == ACTIONS.HAMMER or
                ACTIONS.HACK ~= nil and data.action.action == ACTIONS.HACK then
                inst.components.hunger:DoDelta(-0.166 * burnrate, true)
            elseif data.action.action == ACTIONS.DIG then
                inst.components.hunger:DoDelta(-0.25 * burnrate, true)
            else
                inst.components.hunger:DoDelta(-0.1 * burnrate, true)
            end
        end
    end
end

local function onhungerchange(inst, data)
    local fast = inst.components.hunger:GetPercent() >= HUNGRY_THRESH_HIGH
    local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH

    local workiplier_actions = { ACTIONS.CHOP, ACTIONS.MINE, ACTIONS.HAMMER, ACTIONS.ROW }
    local efficient_actions = { ACTIONS.CHOP, ACTIONS.MINE, ACTIONS.HAMMER, ACTIONS.DIG, ACTIONS.ATTACK, ACTIONS.ROW, ACTIONS.TILL }

    if ACTIONS.HACK then
        table.insert(workiplier_actions, ACTIONS.HACK)
        table.insert(efficient_actions, ACTIONS.HACK)
    end

    if fast then
        for i, v in pairs(workiplier_actions) do
            inst.components.workmultiplier:AddMultiplier(v, 1.5, "ohungy")
        end

        for i, v in pairs(efficient_actions) do
            inst.components.efficientuser:AddMultiplier(v, 0.5, "ohungy")
        end

        inst.multiplierapplied = true
    elseif slow then
        for i, v in pairs(workiplier_actions) do
            inst.components.workmultiplier:AddMultiplier(v, 0.666, "ohungy")
        end

        for i, v in pairs(efficient_actions) do
            inst.components.efficientuser:AddMultiplier(v, 1.333, "ohungy")
        end
        inst.multiplierapplied = true
    else
        if inst.multiplierapplied then
            for i, v in pairs(workiplier_actions) do
                inst.components.workmultiplier:RemoveMultiplier(v, "ohungy")
            end

            for i, v in pairs(efficient_actions) do
                inst.components.efficientuser:RemoveMultiplier(v, "ohungy")
            end

            inst.multiplierapplied = false
        end
    end
end

local function onbecamehuman(inst, data)
    inst:ListenForEvent("performaction", ActionHungerDrain)
    inst:ListenForEvent("hungerdelta", onhungerchange)
    onhungerchange(inst, nil)
end

local function onbecameghost(inst, data)
    inst:ListenForEvent("performaction", ActionHungerDrain)
    inst:RemoveEventCallback("hungerdelta", onhungerchange)
end

env.AddPrefabPostInit("winona", function(inst)
    inst:AddTag("electrical_upgradeuser")

    if not TheWorld.ismastersim then
        return
    end

    if TUNING.DSTU.WINONA_WORKER then
        inst.multiplierapplied = false

        inst:ListenForEvent("performaction", ActionHungerDrain)
        inst:ListenForEvent("hungerdelta", onhungerchange)

        inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
        inst:ListenForEvent("ms_becameghost", onbecameghost)

        if inst.components.efficientuser == nil then
            inst:AddComponent("efficientuser")
        end

        local _PickActionOld = inst.sg.sg.actionhandlers[ACTIONS.PICK].deststate
        inst.sg.sg.actionhandlers[ACTIONS.PICK].deststate = function(inst, action)
            local fast = inst.components.hunger:GetPercent() >= HUNGRY_THRESH_HIGH
            local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH
            if inst:HasTag("hungrybuilder") then
                return not (inst.components.rider ~= nil and inst.components.rider:IsRiding())
                    and action.target ~= nil
                    and not action.target:HasTag("noquickpick")
                    and action.target.components.pickable ~= nil
                    and not action.target.components.pickable.jostlepick
                    and not action.target.components.pickable.quickpick
                    and (fast and "domediumaction" or slow and "dohungrybuild")
                    or _PickActionOld(inst, action)
            else
                return _PickActionOld(inst, action)
            end
        end
    end
end)

local function onrepaired(inst)
    --inst.SoundEmitter:PlaySound(data.buildsound) --If desired, can attach build sound here later.
end

local function ValidRepairFn(inst)
    if inst.Physics:IsActive() then
        return true
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsAboveGroundAtPoint(x, y, z) then
        return true
    end

    if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
        for i, v in ipairs(TheSim:FindEntities(x, 0, z, 1, PLAYER_TAGS)) do
            if v ~= inst and
                v.entity:IsVisible() and
                v.components.placer == nil and
                v.entity:GetParent() == nil then
                local px, _, pz = v.Transform:GetWorldPosition()
                if math.floor(x) == math.floor(px) and math.floor(z) == math.floor(pz) then
                    return false
                end
            end
        end
    end
    return true
end

env.AddPrefabPostInit("winona_catapult", function(inst)
    if TUNING.DSTU.WINONA_WACKCATS then
        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = "stone"
        inst.components.repairable.onrepaired = onrepaired
        --inst.components.repairable.testvalidrepairfn = ValidRepairFn
    end
end)

if TUNING.DSTU.WINONA_WACKCATS then
    TUNING.WINONA_CATAPULT_HEALTH = 300
    TUNING.WINONA_CATAPULT_HEALTH_REGEN = 0
end

env.AddPrefabPostInit("winona_catapult_projectile", function(inst)
    if TUNING.DSTU.WINONA_WACKCATS and inst.components.combat ~= nil then
        inst.components.combat:SetDefaultDamage(34)
    end
end)

env.AddPrefabPostInit("sewing_tape", function(inst)
    if TUNING.DSTU.WINONA_WACKCATS then
        inst:AddComponent("repairer")
        inst.components.repairer.healthrepairvalue = 200
        inst.components.repairer.repairmaterial = MATERIALS.STONE
    end
end)

env.AddComponentPostInit("repairable", function(self)
    if TUNING.DSTU.WINONA_WACKCATS then
        local _Repair = self.Repair
        function self:Repair(doer, repair_item)
            if repair_item:HasTag("tape") then
                self.inst.components.health:DoDelta(repair_item.components.repairer.healthrepairvalue)
                if repair_item.components.stackable ~= nil then
                    repair_item.components.stackable:Get():Remove()
                else
                    repair_item:Remove()
                end
                return true
            else
                return _Repair(self, doer, repair_item)
            end
        end
    end
end)

--[[

local GEMSLOTS = 3
local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

AddPrefabPostInit("world", function(inst)
    --Get the old functions using upvalue hacker
    local SetGem = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, "OnGemGiven", "SetGem")
    local BroadcastCircuitChanged = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, "OnGemGiven", "BroadcastCircuitChanged")
    local StartBattery = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, "OnGemGiven", "StartBattery")
    local StartSoundLoop = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, "OnGemGiven", "StartSoundLoop")
    local PlayHitAnim = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, "OnGemGiven", "PlayHitAnim")

    --Using gemerator is hard unless you are a handyman/woman
    local function OnGemGiven(inst, giver, item)
        if giver:HasTag("handyperson") or giver:HasTag("tinkerer") then  --Hornet: Just casually putting support for wagstaff in ham characters, dont mind me

            if #inst._gems < GEMSLOTS then
                table.insert(inst._gems, item.prefab)
                SetGem(inst, #inst._gems, item.prefab)
                if #inst._gems >= GEMSLOTS then
                    inst.components.trader:Disable()
                end
                inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
            end

            local delta = inst.components.fueled.maxfuel / GEMSLOTS
            if inst.components.fueled:IsEmpty() then
                --prevent battery level flicker by subtracting a tiny bit from initial fuel
                delta = delta - .000001
            else
                local final = inst.components.fueled.currentfuel + delta
                local amtpergem = inst.components.fueled.maxfuel / GEMSLOTS
                local curgemamt = final - math.floor(final / amtpergem) * amtpergem
                if curgemamt < 3 then
                    --prevent new gem from shattering within 3 seconds of socketing
                    delta = delta + 3 - curgemamt
                end
            end
            inst.components.fueled:DoDelta(delta)

            if not inst.components.fueled.consuming then
                inst.components.fueled:StartConsuming()
                BroadcastCircuitChanged(inst)
                if inst.components.circuitnode:IsConnected() then
                    StartBattery(inst)
                end
                if not inst:IsAsleep() then
                    StartSoundLoop(inst)
                end
            end

            PlayHitAnim(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/together/battery/up")
        else
            if giver.components.talker then
				giver.components.talker:Say(GLOBAL.GetString(giver, "ANNOUNCE_WINONAGEN"))
			end
        end
    end
    --Now replace the function with our modified one
    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.winona_battery_high.fn, OnGemGiven, "OnGemGiven")

    --Get the old functions using upvalue hacker
    local BroadcastCircuitChanged = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_low.fn, "OnAddFuel", "BroadcastCircuitChanged")
    local StartBattery = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_low.fn, "OnAddFuel", "StartBattery")
    local StartSoundLoop = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_low.fn, "OnAddFuel", "StartSoundLoop")
    local PlayHitAnim = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.winona_battery_low.fn, "OnAddFuel", "PlayHitAnim")

    local function OnAddFuel(inst)
        local guy = GLOBAL.FindEntity(inst, 40, nil, { "character" })
        if guy ~= nil and guy:HasTag("handyperson") then
            if inst.components.fueled.accepting and not inst.components.fueled:IsEmpty() then
                if not inst.components.fueled.consuming then
                    inst.components.fueled:StartConsuming()
                    BroadcastCircuitChanged(inst)
                    if inst.components.circuitnode:IsConnected() then
                        StartBattery(inst)
                    end
                    if not inst:IsAsleep() then
                        StartSoundLoop(inst)
                    end
                end
                PlayHitAnim(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/together/battery/up")
            end
        else
            if guy ~= nil and guy.components.talker == nil then
                guy:AddComponent("talker")
            end

            guy.components.talker:Say(GLOBAL.GetString(guy, "ANNOUNCE_WINONAGEN"))
        end
    end

    --Now replace the function with our modified one
    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.winona_battery_low.fn, OnAddFuel, "OnAddFuel")
end)

--TODO: add some fail effects

--]]

if not TUNING.DSTU.UPDATE_CHECK then
    TUNING.WINONA_SPOTLIGHT_RADIUS    = TUNING.WINONA_SPOTLIGHT_RADIUS * 2
    TUNING.WINONA_SPOTLIGHT_MAX_RANGE = PLAYER_CAMERA_SEE_DISTANCE * 1.1
local holoitems = {
    "winona_machineparts_1",
    "winona_machineparts_2",
    "winona_holotelepad",
    "winona_holotelebrella",
    "winona_recipescanner",
}

for i, v in ipairs(holoitems) do
    env.AddPrefabPostInit(v, function(inst)
        inst:AddTag("holoitem")

        if not TheWorld.ismastersim then return end

        inst.components.inventoryitem.canonlygoinpocket = false --stupidiest thing ever. I hate it.
    end)
end

