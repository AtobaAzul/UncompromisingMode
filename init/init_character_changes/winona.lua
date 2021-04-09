-----------------------------------------------------------------
-- Only winona can power the generators
-- Relevant: upvaluehacker
-----------------------------------------------------------------

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local HUNGRY_THRESH_HIGH = 0.666

local function ItemTradeTest(inst, item, giver)
    if item == nil then
        return false
    elseif string.sub(item.prefab, -3) ~= "gem" then
        return false, "NOTGEM"
    elseif string.sub(item.prefab, -11, -4) == "precious" then
        return false, "WRONGGEM"
    end
	
	if giver:HasTag("handyperson") then
		return true
	else
		return false, "WINONAGEN"
	end
end

env.AddPrefabPostInit("winona_battery_high", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
	
end)

local function ItemTradeTestLow(inst, item, giver)
	if giver:HasTag("handyperson") then
		return item.prefab == "nitre"
	else
		return false, "WINONAGEN"
	end
end

local NUM_LEVELS = 6

local PERIOD = .5

local function DoAddBatteryPower(inst, node)
    node:AddBatteryPower(PERIOD + math.random(2, 6) * FRAMES)
end

local function OnBatteryTask(inst)
    inst.components.circuitnode:ForEachNode(DoAddBatteryPower)
end

local function StartBattery(inst)
    if inst._batterytask == nil then
        inst._batterytask = inst:DoPeriodicTask(PERIOD, OnBatteryTask, 0)
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
            inst.components.fueled.rate = math.max(load, TUNING.WINONA_BATTERY_MIN_LOAD) * TUNING.WINONA_BATTERY_LOW_FUEL_RATE_MULT
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

local function UpdateSoundLoop(inst, level)
    if inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:SetParameter("loop", "intensity", 1 - level / NUM_LEVELS)
    end
end

local function StartSoundLoop(inst)
    if not inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:PlaySound("dontstarve/common/together/battery/on_LP", "loop")
        UpdateSoundLoop(inst, inst.components.fueled:GetCurrentSection())
    end
end

local function OnHitAnimOver(inst)
    inst:RemoveEventCallback("animover", OnHitAnimOver)
    if inst.AnimState:IsCurrentAnimation("hit") then
        if inst.components.fueled:IsEmpty() then
            inst.AnimState:PlayAnimation("idle_empty")
        else
            inst.AnimState:PlayAnimation("idle_charge", true)
        end
    end
end

local function PlayHitAnim(inst)
    inst:RemoveEventCallback("animover", OnHitAnimOver)
    inst:ListenForEvent("animover", OnHitAnimOver)
    inst.AnimState:PlayAnimation("hit")
end

local function OnFuelGiven(inst, giver, item)
	local delta = inst.components.fueled.maxfuel / 2
	if inst.components.fueled:IsEmpty() then
        --prevent battery level flicker by subtracting a tiny bit from initial fuel
        delta = delta - .000001
    --[[else
        local final = inst.components.fueled.currentfuel + delta
        local amtpergem = inst.components.fueled.maxfuel / 2
        local curgemamt = final - math.floor(final / amtpergem) * amtpergem
        if curgemamt < 3 then
            --prevent new gem from shattering within 3 seconds of socketing
            delta = delta + 3 - curgemamt
        end]]
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

	inst:PushEvent("dohitanim")
    PlayHitAnim(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/together/battery/up")
	
end

env.AddPrefabPostInit("winona_battery_low", function(inst)
	if not TheWorld.ismastersim then
		return
	end
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTestLow)
    inst.components.trader.onaccept = OnFuelGiven
	
end)

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function ActionHungerDrain(inst, data)
	local fast = inst.components.hunger:GetPercent() > HUNGRY_THRESH_HIGH
	local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH
	local t = GetTime()
	
	if data.action.action == ACTIONS.CHOP or 
	data.action.action == ACTIONS.MINE or 
	data.action.action == ACTIONS.HAMMER or 
	data.action.action == ACTIONS.ROW or 
	data.action.action == ACTIONS.DIG or 
	data.action.action == ACTIONS.ATTACK then
			if fast then
				inst.hungryslowbuildtalktime = nil
				if inst.hungryfastbuildtalktime == nil or inst.hungryfastbuildtalktime + 10 < t then
					inst.hungryfastbuildtalktime = t + GetRandomMinMax(8, 12)
				elseif inst.hungryfastbuildtalktime < t then
					inst.hungryfastbuildtalktime = nil
					inst.components.talker:Say(GetString(inst, "ANNOUNCE_HUNGRY_FASTBUILD"))
				end
				if data.action.action == ACTIONS.ROW then
					inst.components.hunger:DoDelta(-0.15)
					print("row")
				elseif data.action.action == ACTIONS.CHOP or
				data.action.action == ACTIONS.MINE or
				data.action.action == ACTIONS.HAMMER or
				data.action.action == ACTIONS.DIG then
					inst.components.hunger:DoDelta(-0.25)
					print("work")
				else
					inst.components.hunger:DoDelta(-0.2)
					print("attack")
				end
			elseif slow then
				inst.hungryfastbuildtalktime = nil
				if (inst.hungryslowbuildtalktime or 0) < t then
					inst.hungryslowbuildtalktime = t + GetRandomMinMax(8, 16)
					inst.components.talker:Say(GetString(inst, "ANNOUNCE_HUNGRY_SLOWBUILD"))
				end
			end
	end
end

local function onhungerchange(inst, data)
	local fast = inst.components.hunger:GetPercent() > HUNGRY_THRESH_HIGH
	local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH
	
	if fast then
		inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   1.33, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   1.33, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.33, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.DIG, 1.33, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.ROW, 1.33, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   0.75, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   0.75, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 0.75, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.DIG, 0.75, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 0.75, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ROW,   0.75, "ohungy")
		inst.multiplierapplied = true
	elseif slow then
		inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   0.66, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   0.66, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 0.66, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.DIG, 0.66, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.ROW, 0.66, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   1.25, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   1.25, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 1.25, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.DIG, 1.25, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 1.25, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ROW,   1.25, "ohungy")
		inst.multiplierapplied = true
	else
		if inst.multiplierapplied then
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.DIG, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.ROW, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.CHOP, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.MINE, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.HAMMER, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.DIG, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.ATTACK, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.ROW, "ohungy")
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
	if not TheWorld.ismastersim then
		return
	end
	
	inst.multiplierapplied = false
	
    inst:ListenForEvent("performaction", ActionHungerDrain)
	inst:ListenForEvent("hungerdelta", onhungerchange)
	
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)
	
	if inst.components.efficientuser == nil then
		inst:AddComponent("efficientuser")
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