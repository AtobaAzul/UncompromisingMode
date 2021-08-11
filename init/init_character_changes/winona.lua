-----------------------------------------------------------------
-- Only winona can power the generators
-- Relevant: upvaluehacker
-----------------------------------------------------------------

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local HUNGRY_THRESH_HIGH = 0.666

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

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function ActionHungerDrain(inst, data)
	local fast = inst.components.hunger:GetPercent() >= HUNGRY_THRESH_HIGH
	local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH
	local t = GetTime()

	if data.action.action == ACTIONS.CHOP or 
	data.action.action == ACTIONS.MINE or 
	data.action.action == ACTIONS.HAMMER or 
	data.action.action == ACTIONS.ROW or 
	data.action.action == ACTIONS.DIG or 
	data.action.action == ACTIONS.ATTACK or
	data.action.action == ACTIONS.PICK or
	data.action.action == ACTIONS.TILL then
		if fast then
			if inst._cdtask == nil then
				inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
				inst.hungryslowbuildtalktime = nil
				if inst.hungryfastbuildtalktime == nil or inst.hungryfastbuildtalktime + 10 < t then
					inst.hungryfastbuildtalktime = t + GetRandomMinMax(8, 12)
				elseif inst.hungryfastbuildtalktime < t then
					inst.hungryfastbuildtalktime = nil
					inst.components.talker:Say(GetString(inst, "ANNOUNCE_HUNGRY_FASTBUILD"))
				end
				if data.action.action == ACTIONS.ROW or data.action.action == ACTIONS.TILL or data.action.action == ACTIONS.PICK then
					inst.components.hunger:DoDelta(-0.20, true)
				elseif data.action.action == ACTIONS.CHOP then
					if data.action.target ~= nil then
						local snap = SpawnPrefab("impact")
						local x, y, z = inst.Transform:GetWorldPosition()
						local x1, y1, z1 = data.action.target.Transform:GetWorldPosition()
						local angle = -math.atan2(z1 - z, x1 - x)
						snap.Transform:SetPosition(x1, y1, z1)
						snap.Transform:SetRotation(angle * RADIANS)
						snap.Transform:SetScale(0.8, 0.8, 0.8)
					end
					
					inst.components.hunger:DoDelta(-0.333, true)
				elseif data.action.action == ACTIONS.MINE or
				data.action.action == ACTIONS.HAMMER then
					if data.action.target ~= nil then
						local snap = SpawnPrefab("impact")
						local x, y, z = inst.Transform:GetWorldPosition()
						local x1, y1, z1 = data.action.target.Transform:GetWorldPosition()
						local angle = -math.atan2(z1 - z, x1 - x)
						snap.Transform:SetPosition(x1, y1, z1)
						snap.Transform:SetRotation(angle * RADIANS)
						snap.Transform:SetScale(0.8, 0.8, 0.8)
					end
					
					inst.components.hunger:DoDelta(-0.5, true)
				elseif data.action.action == ACTIONS.DIG then
					inst.components.hunger:DoDelta(-0.5, true)
				else
					inst.components.hunger:DoDelta(-0.25, true)
				end
			end
		elseif slow then
			inst.hungryfastbuildtalktime = nil
			if (inst.hungryslowbuildtalktime or 0) < t then
				inst.hungryslowbuildtalktime = t + GetRandomMinMax(8, 16)
				inst.components.talker:Say(GetString(inst, "ANNOUNCE_HUNGRY_SLOWBUILD"))
			end
		else
			if inst._cdtask == nil then
				inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
				if data.action.action == ACTIONS.ROW or data.action.action == ACTIONS.TILL or data.action.action == ACTIONS.PICK then
					inst.components.hunger:DoDelta(-0.1, true)
				elseif data.action.action == ACTIONS.CHOP then
					inst.components.hunger:DoDelta(-0.15, true)
				elseif data.action.action == ACTIONS.MINE or
				data.action.action == ACTIONS.HAMMER then
					inst.components.hunger:DoDelta(-0.20, true)
				elseif data.action.action == ACTIONS.DIG then
					inst.components.hunger:DoDelta(-0.25, true)
				else
					inst.components.hunger:DoDelta(-0.125, true)
				end
			end
		end
	end
end

local function onhungerchange(inst, data)
	local fast = inst.components.hunger:GetPercent() >= HUNGRY_THRESH_HIGH
	local slow = inst.components.hunger:GetPercent() < TUNING.HUNGRY_THRESH

	if fast then
		inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   1.5, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   1.5, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 1.5, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.ROW, 1.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   0.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   0.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 0.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.DIG, 0.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 0.5, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.TILL,   0.5, "ohungy")
		inst.multiplierapplied = true
	elseif slow then
		inst.components.workmultiplier:AddMultiplier(ACTIONS.CHOP,   0.666, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.MINE,   0.666, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.HAMMER, 0.666, "ohungy")
		inst.components.workmultiplier:AddMultiplier(ACTIONS.ROW, 0.666, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.CHOP,   1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.MINE,   1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.HAMMER, 1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.DIG, 1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ATTACK, 1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.ROW,   1.333, "ohungy")
		inst.components.efficientuser:AddMultiplier(ACTIONS.TILL,   1.333, "ohungy")
		inst.multiplierapplied = true
	else
		if inst.multiplierapplied then
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.HAMMER, "ohungy")
			inst.components.workmultiplier:RemoveMultiplier(ACTIONS.ROW, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.CHOP, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.MINE, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.HAMMER, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.DIG, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.ATTACK, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.ROW, "ohungy")
			inst.components.efficientuser:RemoveMultiplier(ACTIONS.TILL, "ohungy")
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
	
	if TUNING.DSTU.WINONA_WORKER == true then
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
				return (inst.components.rider ~= nil and inst.components.rider:IsRiding() and "dolongaction")
					or (action.target ~= nil
					and action.target.components.pickable ~= nil
					and (   (action.target.components.pickable.jostlepick and "dojostleaction") or
							(action.target.components.pickable.quickpick and "doshortaction") or
							(inst:HasTag("fastpicker") and "doshortaction") or
							(inst:HasTag("quagmire_fasthands") or fast and "domediumaction") or
							(slow and "dohungrybuild") or
							"dolongaction"  ))
					or nil
			else
				return (inst.components.rider ~= nil and inst.components.rider:IsRiding() and "dolongaction")
					or (action.target ~= nil
					and action.target.components.pickable ~= nil
					and (   (action.target.components.pickable.jostlepick and "dojostleaction") or
							(action.target.components.pickable.quickpick and "doshortaction") or
							(inst:HasTag("fastpicker") and "doshortaction") or
							(inst:HasTag("quagmire_fasthands") and "domediumaction") or
							"dolongaction"  ))
					or nil
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