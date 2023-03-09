local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


local function OnDismantle_catapult(inst)
    local item = SpawnPrefab("winona_catapult_item")
    local fx = SpawnPrefab("collapse_small")

    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    item.components.finiteuses:SetPercent(inst.components.health:GetPercent())

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.SoundEmitter:PlaySound("dontstarve/common/together/catapult/destroy")
    inst:Remove()
end

local function OnDismantle_spotlight(inst)
    local item = SpawnPrefab("winona_spotlight_item")
    local fx = SpawnPrefab("collapse_small")

    item.Transform:SetPosition(inst.Transform:GetWorldPosition())

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/destroy")
    inst:Remove()
end

local function OnDismantle_low(inst)
    local item = SpawnPrefab("winona_battery_low_item")
    local fx = SpawnPrefab("collapse_small")

    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    item.components.finiteuses:SetPercent(inst.components.fueled:GetPercent())

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")


    inst:Remove()
end

local function OnDismantle_high(inst)
    local item = SpawnPrefab("winona_battery_high_item")
    local fx = SpawnPrefab("collapse_small")

    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    if #inst._gems > 0 then
        item.generator = inst:GetSaveRecord()
    end

    item.components.finiteuses:SetPercent(inst.components.fueled:GetPercent())

    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")

    inst:Remove()
end

--I'll admit it, I got lazy on this. But was 11pm and I wanted to go to bed.

local NUM_LEVELS = 6
local GEMSLOTS = 3
local LEVELS_PER_GEM = 2

local function GetGemSymbol(slot)
    return "gem" .. tostring(GEMSLOTS - slot + 1)
end

local function SetGem(inst, slot, gemname)
    inst.AnimState:OverrideSymbol(GetGemSymbol(slot), "gems", "swap_" .. gemname)
end

local function UnsetGem(inst, slot, gemname)
    local symbol = GetGemSymbol(slot)
    inst.AnimState:ClearOverrideSymbol(symbol)
    if not POPULATING then
        local fx = SpawnPrefab("winona_battery_high_shatterfx")
        fx.entity:AddFollower():FollowSymbol(inst.GUID, symbol, 0, 0, 0)
        local anim = gemname .. "_shatter"
        if not fx.AnimState:IsCurrentAnimation(anim) then
            fx.AnimState:PlayAnimation(anim)
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    end
end

local function UpdateSoundLoop(inst, level)
    if inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:SetParameter("loop", "intensity", 1 - level / NUM_LEVELS)
    end
end

local function ShatterGems(inst, keepnumgems)
    local i = #inst._gems
    if i > keepnumgems then
        if i == GEMSLOTS then
            inst.components.trader:Enable()
        end
        while i > keepnumgems do
            UnsetGem(inst, i, table.remove(inst._gems))
            i = i - 1
        end
    end
end

local function UpdateCircuitPower(inst)
    inst._circuittask = nil
    if inst.components.fueled ~= nil then
        if inst.components.fueled.consuming then
            local load = 0
            inst.components.circuitnode:ForEachNode(function(inst, node)
                local batteries = 0
                node.components.circuitnode:ForEachNode(function(node, battery)
                    if battery.components.fueled ~= nil and battery.components.fueled.consuming then
                        batteries = batteries + 1
                    end
                end)
                load = load + 1 / batteries
            end)
            inst.components.fueled.rate = math.max(load, TUNING.WINONA_BATTERY_MIN_LOAD)
        else
            inst.components.fueled.rate = 0
        end
    end
end

local function NotifyCircuitChanged(inst, node)
    node:PushEvent("engineeringcircuitchanged")
end

local function BroadcastCircuitChanged(inst)
    --Notify other connected nodes, so that they can notify their connected batteries
    inst.components.circuitnode:ForEachNode(NotifyCircuitChanged)
    if inst._circuittask ~= nil then
        inst._circuittask:Cancel()
    end
    UpdateCircuitPower(inst)
end

local function DoIdleChargeSound(inst)
    local t = inst.AnimState:GetCurrentAnimationFrame()
    if (t == 0 or t == 3 or t == 17 or t == 20) and inst._lastchargeframe ~= t then
        inst._lastchargeframe = t
        inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/electricity", nil, GetRandomMinMax(.2, .5))
    end
end

local function StartIdleChargeSounds(inst)
    if inst._lastchargeframe == nil then
        inst._lastchargeframe = -1
        inst.components.updatelooper:AddOnUpdateFn(DoIdleChargeSound)
    end
end

local function OnLoad_high(inst, data)
    if data ~= nil then
        if data.gems ~= nil and #inst._gems < GEMSLOTS then
            for i, v in ipairs(data.gems) do
                table.insert(inst._gems, v)
                SetGem(inst, #inst._gems, v)
                if #inst._gems >= GEMSLOTS then
                    inst.components.trader:Disable()
                    break
                end
            end
            ShatterGems(inst, math.ceil(inst.components.fueled:GetCurrentSection() / LEVELS_PER_GEM))
        end
        if data.burnt then
            inst.components.burnable.onburnt(inst)
        elseif not inst.components.fueled:IsEmpty() then
            if not inst.components.fueled.consuming then
                inst.components.fueled:StartConsuming()
                BroadcastCircuitChanged(inst)
            end
            inst.AnimState:PlayAnimation("idle_charge", true)
            if not inst:IsAsleep() then
                StartIdleChargeSounds(inst)
            end
            local frame = inst.AnimState:GetCurrentAnimationNumFrames() ~= nil and
                inst.AnimState:GetCurrentAnimationNumFrames() ~= 0 and
                math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1 or 1
            inst.AnimState:SetFrame(frame) --THIS. Current animation can be non-existant, so this would result in a crash (bad argument #1 to 'random' (interval is empty))
        end
    end
end

local function StopBattery(inst)
    if inst._batterytask ~= nil then
        inst._batterytask:Cancel()
        inst._batterytask = nil
    end
end

local function OnFuelEmpty(inst)
    if inst.components.fueled.accepting then
        inst.components.fueled:StopConsuming()
        BroadcastCircuitChanged(inst)
        StopBattery(inst)
        inst.SoundEmitter:KillSound("loop")
        inst.AnimState:OverrideSymbol("m2", "winona_battery_low", "m1")
        inst.AnimState:OverrideSymbol("plug", "winona_battery_low", "plug_off")
        if inst.AnimState:IsCurrentAnimation("idle_charge") then
            inst.AnimState:PlayAnimation("idle_empty")
        end
        if not POPULATING then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/battery/down")
        end
    end
end

local function OnLoad_low(inst, data, ents)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    elseif inst.components.fueled:IsEmpty() then
        OnFuelEmpty(inst)
    else
        UpdateSoundLoop(inst, inst.components.fueled:GetCurrentSection())
        if inst.AnimState:IsCurrentAnimation("idle_charge") then
            local frame = inst.AnimState:GetCurrentAnimationNumFrames() ~= nil and
                inst.AnimState:GetCurrentAnimationNumFrames() ~= 0 and
                math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1 or 1

			inst.AnimState:SetFrame(frame)
        end
    end
end


env.AddPrefabPostInit("winona_catapult", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle_catapult)
end)

env.AddPrefabPostInit("winona_spotlight", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle_spotlight)
end)

env.AddPrefabPostInit("winona_battery_low", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.OnLoad = OnLoad_low

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle_low)
end)


env.AddPrefabPostInit("winona_battery_high", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst.OnLoad = OnLoad_high

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(OnDismantle_high)
end)