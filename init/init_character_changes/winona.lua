-----------------------------------------------------------------
-- Only winona can power the generators
-- Relevant: upvaluehacker
-----------------------------------------------------------------

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
        if giver:HasTag("handyperson") then 

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
            if giver.components.talker == nil then
                giver:AddComponent("talker")
            end
            
            giver.components.talker:Say(GLOBAL.GetString(giver, "ANNOUNCE_WINONAGEN"))
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