--This file is pretty much copy pasted from official one except for definitions since those are the only ones getting called anyway

local module_definitions = {}
local scandata_definitions = {}
local easing = require("easing")

-- Add a new creature/module/scandata combination for the scanner.
--      prefab_name -   The prefab name of the object to scan in the world.
--      module_name -   The type name of the module that will be produced by the scan (without the "wx78module_" prefix)
--      maxdata -       The maximum amount of data that will build up on the scannable prefab; see "dataanalyzer.lua"
-- Calling this function using a prefab name that has already been added will overwrite that prefab's prior entry.
local function AddCreatureScanDataDefinition(prefab_name, module_name, maxdata)
    scandata_definitions[prefab_name] = {
        maxdata = maxdata or 1,
        module = module_name,
    }
end

-- Given a creature prefab, return any module/data information for it, if it exists.
local function GetCreatureScanDataDefinition(prefab_name)
    return scandata_definitions[prefab_name]
end

---------------------------------------------------------------
local function maxhealth_change(inst, wx, amount, isloading)
    if wx.components.health ~= nil then
        local current_health_percent = wx.components.health:GetPercent()

        wx.components.health.maxhealth = wx.components.health.maxhealth + amount

        if not isloading then
            wx.components.health:SetPercent(current_health_percent)

            -- We want to force a badge pulse, but also maintain the health percent as much as we can.
            local badgedelta = (amount > 0 and 0.01) or -0.01
            wx.components.health:DoDelta(badgedelta, false, nil, true)
        end
    end
end

local function maxhealth_activate(inst, wx, isloading)
    maxhealth_change(inst, wx, TUNING.WX78_MAXHEALTH_BOOST, isloading)
	wx.components.health:SetAbsorptionAmount(wx.components.health.absorb + 0.075)
end

local function maxhealth_deactivate(inst, wx)
    maxhealth_change(inst, wx, -TUNING.WX78_MAXHEALTH_BOOST)
	wx.components.health:SetAbsorptionAmount(wx.components.health.absorb - 0.075)
end


local MAXHEALTH_MODULE_DATA =
{
    name = "maxhealth",
    slots = 1,
    activatefn = maxhealth_activate,
    deactivatefn = maxhealth_deactivate,
}
table.insert(module_definitions, MAXHEALTH_MODULE_DATA)

AddCreatureScanDataDefinition("spider", "maxhealth", 2)

---------------------------------------------------------------
local function maxsanity1_activate(inst, wx, isloading)
    if wx.components.sanity ~= nil then
        local current_sanity_percent = wx.components.sanity:GetPercent()

		wx.components.sanity.dapperness = wx.components.sanity.dapperness + TUNING.DAPPERNESS_TINY
        wx.components.sanity:SetMax(wx.components.sanity.max + TUNING.WX78_MAXSANITY1_BOOST)
		wx.components.sanity.neg_aura_modifiers:SetModifier(inst, 0.9)

        if not isloading then
            wx.components.sanity:SetPercent(current_sanity_percent, false)
        end
    end
end

local function maxsanity1_deactivate(inst, wx)
    if wx.components.sanity ~= nil then
        local current_sanity_percent = wx.components.sanity:GetPercent()
		wx.components.sanity.dapperness = wx.components.sanity.dapperness - TUNING.DAPPERNESS_TINY
		wx.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
        wx.components.sanity:SetMax(wx.components.sanity.max - TUNING.WX78_MAXSANITY1_BOOST)
        wx.components.sanity:SetPercent(current_sanity_percent, false)
    end
end

local MAXSANITY1_MODULE_DATA =
{
    name = "maxsanity1",
    slots = 1,
    activatefn = maxsanity1_activate,
    deactivatefn = maxsanity1_deactivate,
}
table.insert(module_definitions, MAXSANITY1_MODULE_DATA)

AddCreatureScanDataDefinition("butterfly", "maxsanity1", 1)
AddCreatureScanDataDefinition("moonbutterfly", "maxsanity1", 1)

---------------------------------------------------------------
local function maxsanity_activate(inst, wx, isloading)
    if wx.components.sanity ~= nil then
        local current_sanity_percent = wx.components.sanity:GetPercent()

        wx.components.sanity.dapperness = wx.components.sanity.dapperness + TUNING.WX78_MAXSANITY_DAPPERNESS
        wx.components.sanity:SetMax(wx.components.sanity.max + TUNING.WX78_MAXSANITY_BOOST)
		wx.components.sanity.neg_aura_modifiers:SetModifier(inst, 0.75)

        if not isloading then
            wx.components.sanity:SetPercent(current_sanity_percent, false)
        end
    end
end

local function maxsanity_deactivate(inst, wx)
    if wx.components.sanity ~= nil then
        local current_sanity_percent = wx.components.sanity:GetPercent()

        wx.components.sanity.dapperness = wx.components.sanity.dapperness - TUNING.WX78_MAXSANITY_DAPPERNESS
        wx.components.sanity:SetMax(wx.components.sanity.max - TUNING.WX78_MAXSANITY_BOOST)
		wx.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
        wx.components.sanity:SetPercent(current_sanity_percent, false)
    end
end

local MAXSANITY_MODULE_DATA =
{
    name = "maxsanity",
    slots = 2,
    activatefn = maxsanity_activate,
    deactivatefn = maxsanity_deactivate,
}
table.insert(module_definitions, MAXSANITY_MODULE_DATA)

AddCreatureScanDataDefinition("crawlinghorror", "maxsanity", 3)
AddCreatureScanDataDefinition("crawlingnightmare", "maxsanity", 6)
AddCreatureScanDataDefinition("terrorbeak", "maxsanity", 3)
AddCreatureScanDataDefinition("nightmarebeak", "maxsanity", 6)
AddCreatureScanDataDefinition("oceanhorror", "maxsanity", 3)

---------------------------------------------------------------
local function collidelikerookandstuff(wx, other) --This system has gone under so much changes

	local accradius = 200
	local knockbackstrength = 1.5 - TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1]*0.25
	local collidedamage = 17 * (9 - TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1])
	
	
	if not (other ~= nil and other:IsValid() and wx:IsValid()) then return end
	
	local CANTCOLLIDETAGS = {"player", "companion", "abigail", "NOCLICK", "INLIMBO", "wall"}
	
	local function iscollidable(other) --Honestly at this point since there are no more proper objects collision might as well replace the entire thing with finding entities in range
		for _, v in ipairs(CANTCOLLIDETAGS) do
			if other:HasTag(v) then 
				return false
			end
		end
		return true
	end

	local function collideknocking(wx)
		if other and other:IsValid() and iscollidable(other) then
		if wx.accelarate_speed > 8.5 and not (other.components.health and other.components.health.maxhealth < 150) then 
			wx.accelarate_speed = TUNING.WILSON_RUN_SPEED
			wx:PushEvent("knockback", {knocker = other, radius = accradius, strengthmult = knockbackstrength})
			wx.components.combat:GetAttacked(other, collidedamage * 0.15)
		elseif not other:HasTag("prey") and (other.components.health and other.components.health.maxhealth < 150) then
			wx.accelarate_speed = TUNING.WILSON_RUN_SPEED
			wx.components.combat:GetAttacked(other, collidedamage * 0.1)
		elseif other:HasTag("prey") and (other.components.health and other.components.health.maxhealth < 150) then
			wx.accelarate_speed = 8.35 --just enough to prevent double hitting but still keeping the somewhat high speed
		end
		wx.SoundEmitter:PlaySound("dontstarve/characters/woodie/moose/bounce")
		SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
		ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, wx, 10)
		end
	end
	
	
	if not other:IsValid() then
        return
    --[[elseif other:HasTag("smashable") and other.components.health ~= nil then
        other.components.combat:GetAttacked(wx, collidedamage)
		collideknocking(wx)
    elseif other.components.workable ~= nil
        and other.components.workable:CanBeWorked()
        and other.components.workable.action ~= ACTIONS.NET then
		if other.components.workable:GetWorkAction() == ACTIONS.CHOP then
			other.components.workable:WorkedBy(wx, 30/TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1])
			collideknocking(wx)
		elseif other.components.workable:GetWorkAction() == ACTIONS.MINE then
			other.components.workable:WorkedBy(wx, 12/TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1])
			collideknocking(wx)
		elseif other.components.workable:GetWorkAction() == ACTIONS.HAMMER and not other.components.health then
			other.components.workable:WorkedBy(wx, 4/TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1])
			collideknocking(wx)
		end]]
		
    elseif other.components.health ~= nil and not other.components.health:IsDead() and iscollidable(other) then
        wx.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
		collideknocking(wx)
        other.components.combat:GetAttacked(wx, collidedamage)
    end
	
	wx.Physics:SetCollisionCallback(nil)
end

local function accelaratefn(wx, inst)

	local accelarate_limit = 12 - TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1]
	--local accelarate_increase = 0.025 * (1.2 - TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1] * 0.08) --why this? math --I think too much math causes the game to crash sometimes wth
	--No seriously it stopped crashing after I changed it to static value, was this really the reason? Sad cause I wanted it to be faster the more modules you have
	if wx.components.locomotor ~= nil and not wx.components.rider:IsRiding() and wx.sg:HasStateTag("running") and wx.accelarate_speed ~= nil and wx.components.locomotor:GetTimeMoving() >= (TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1] - 1) then
		if wx.accelarate_speed <= accelarate_limit then 
			wx.accelarate_speed = wx.accelarate_speed + 0.015
		end
	--print(wx.accelarate_speed)
		if wx.accelarate_speed >= 9 then
			if wx.rooksoundtask == nil then
				wx.rooksoundtask = wx:DoPeriodicTask(0.33, function(wx)
					SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(wx.Transform:GetWorldPosition())
					wx.SoundEmitter:PlaySound("dontstarve/creatures/rook/steam") --in original mod there's a config option to turn this sound off, feel free to just comment it out if it becomes annoying I guess
				end)
			end
			wx.Physics:SetCollisionCallback(collidelikerookandstuff)
		else
			wx.Physics:SetCollisionCallback(nil)
		end
		
	else
		wx.accelarate_speed = TUNING.WILSON_RUN_SPEED
		if wx.rooksoundtask ~= nil then
			wx.rooksoundtask:Cancel()
			wx.rooksoundtask = nil
		end
		wx.Physics:SetCollisionCallback(nil)
	end
	wx.components.locomotor.runspeed = wx.accelarate_speed
end

local function movespeed_activate(inst, wx)

	if inst.accelarate == nil then
        inst.accelarate = function(owner, inst)
            accelaratefn(owner, inst)
        end
    end

    wx._movespeed_chips = (wx._movespeed_chips or 0) + 1
	wx.accelarate_speed = TUNING.WILSON_RUN_SPEED
	wx:ListenForEvent("locomote", inst.accelarate, wx) --Listenning on WX just to not cause any real troubles with multiple modules
    --wx.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * (1 + TUNING.WX78_MOVESPEED_CHIPBOOSTS[wx._movespeed_chips + 1])
end

local function movespeed_deactivate(inst, wx)
    wx._movespeed_chips = math.max(0, wx._movespeed_chips - 1)
	wx.accelarate_speed = TUNING.WILSON_RUN_SPEED
    wx.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
	wx.Physics:SetCollisionCallback(nil)
	if wx.rooksoundtask ~= nil then
		wx.rooksoundtask:Cancel()
		wx.rooksoundtask = nil
	end
	
	wx:RemoveEventCallback("locomote", inst.accelarate, wx)
end

local MOVESPEED_MODULE_DATA =
{
    name = "movespeed",
    slots = 6,
    activatefn = movespeed_activate,
    deactivatefn = movespeed_deactivate,
}
table.insert(module_definitions, MOVESPEED_MODULE_DATA)

AddCreatureScanDataDefinition("rabbit", "movespeed", 2)

---------------------------------------------------------------

local MOVESPEED2_MODULE_DATA =
{
    name = "movespeed2",
    slots = 2,
    activatefn = movespeed_activate,
    deactivatefn = movespeed_deactivate,
}
table.insert(module_definitions, MOVESPEED2_MODULE_DATA)

AddCreatureScanDataDefinition("minotaur", "movespeed2", 6)
AddCreatureScanDataDefinition("rook", "movespeed2", 3)
AddCreatureScanDataDefinition("rook_nightmare", "movespeed2", 3)

---------------------------------------------------------------
local EXTRA_DRYRATE = 0.1

local affected_actions = 
{
	ACTIONS.CHOP,
	ACTIONS.MINE,
	ACTIONS.HAMMER
}

local function heater_cooldown(inst)
    inst._heatcdtask = nil
end

local function ontemperaturechange(wx, data, inst)
	local deltatemp = data.new - data.last
	local cur = wx.components.temperature.current
	local workmult = 1
	local extraheat_bonus = wx._heat_chips - 1
	
	if deltatemp > 0 and inst._heatcdtask == nil then
        inst._heatcdtask = inst:DoTaskInTime(0.05, heater_cooldown) 
		wx.components.temperature:SetTemperature(cur + deltatemp*4)
	end
	
	--[[if cur >= 50 then
		workmult = 2.5 + extraheat_bonus
	elseif cur >= 35 then
		workmult = 2 + extraheat_bonus
	elseif cur >= 20 then
		workmult = 1.5 + extraheat_bonus
	end]]
	
	workmult = (cur > 60 and 2.5+extraheat_bonus) or (cur > 20 and easing.linear(cur-20, 1, 2.5+extraheat_bonus - 1, 40)) or 1
	
	for _, act in ipairs(affected_actions) do
		wx.components.efficientuser:AddMultiplier(act, workmult, inst)
		wx.components.workmultiplier:AddMultiplier(act, workmult, inst)
	end
end

local function onworkingwarmup(wx, data, inst, isattack)
	local cur = wx.components.temperature.current
	local tempmult = (cur >= 60 and 0.33) or (cur >= 50 and 0.66) or 1
	
	if not isattack then
		wx.components.temperature:SetTemperature(cur + 0.3*tempmult)
	elseif isattack == true then
		wx.components.temperature:SetTemperature(cur + 0.1*tempmult)
	end
end

local function heat_activate(inst, wx)
    -- A higher mintemp means that it's harder to freeze.-- You mean impossible, sir?
    --wx.components.temperature.mintemp = wx.components.temperature.mintemp + TUNING.WX78_MINTEMPCHANGEPERMODULE
    --wx.components.temperature.maxtemp = wx.components.temperature.maxtemp + TUNING.WX78_MINTEMPCHANGEPERMODULE


	if wx._ontempmodulechange == nil then
        wx._ontempmodulechange = function(owner, data)
            ontemperaturechange(owner, data, inst)
        end
    end

	if wx._onworktemp == nil then
        wx._onworktemp = function(owner, data)
            onworkingwarmup(owner, data, inst)
        end
    end
	
	if wx._onattacktemp == nil then
		wx._onattacktemp = function(owner, data)
			onworkingwarmup(owner, data, inst, true)
		end
	end

	wx._heat_chips = (wx._heat_chips or 0) + 1

	inst:ListenForEvent("temperaturedelta", wx._ontempmodulechange, wx)
	inst:ListenForEvent("working", wx._onworktemp, wx)
	inst:ListenForEvent("onattackother", wx._onattacktemp, wx)

	
    wx.components.moisture.maxDryingRate = wx.components.moisture.maxDryingRate + EXTRA_DRYRATE
    wx.components.moisture.baseDryingRate = wx.components.moisture.baseDryingRate + EXTRA_DRYRATE
	
	wx.components.temperature.inherentinsulation = wx.components.temperature.inherentinsulation + TUNING.INSULATION_MED

    if wx.AddTemperatureModuleLeaning ~= nil then
        wx:AddTemperatureModuleLeaning(1)
    end
end

local function heat_deactivate(inst, wx)
    --wx.components.temperature.mintemp = wx.components.temperature.mintemp - TUNING.WX78_MINTEMPCHANGEPERMODULE
   -- wx.components.temperature.maxtemp = wx.components.temperature.maxtemp - TUNING.WX78_MINTEMPCHANGEPERMODULE
	
	--[[if wx._heat_chips == 1 then
		wx.components.temperature:RemoveModifier("1_heat_module_warm")
	elseif wx._heat_chips == 2 then
		wx.components.temperature:RemoveModifier("2_heat_module_warm")
		wx.components.temperature:SetModifier("1_heat_module_warm", 60)
	end]]
	
	wx._heat_chips = math.max(0, wx._heat_chips - 1)
	
	for _, act in ipairs(affected_actions) do
		wx.components.efficientuser:RemoveMultiplier(act, inst)
		wx.components.workmultiplier:RemoveMultiplier(act, inst)
	end
	
	inst:RemoveEventCallback("temperaturedelta", wx._ontempmodulechange, wx)
	inst:RemoveEventCallback("working", wx._onworktemp, wx)
	inst:RemoveEventCallback("onattackother", wx._onattacktemp, wx)

    wx.components.moisture.maxDryingRate = wx.components.moisture.maxDryingRate - EXTRA_DRYRATE
    wx.components.moisture.baseDryingRate = wx.components.moisture.baseDryingRate - EXTRA_DRYRATE
	
	wx.components.temperature.inherentinsulation = wx.components.temperature.inherentinsulation - TUNING.INSULATION_MED

    if wx.AddTemperatureModuleLeaning ~= nil then
        wx:AddTemperatureModuleLeaning(-1)
    end
end

local HEAT_MODULE_DATA =
{
    name = "heat",
    slots = 3,
    activatefn = heat_activate,
    deactivatefn = heat_deactivate,
}
table.insert(module_definitions, HEAT_MODULE_DATA)

AddCreatureScanDataDefinition("firehound", "heat", 4)
AddCreatureScanDataDefinition("dragonfly", "heat", 10)

---------------------------------------------------------------
local function nightvision_onworldstateupdate(wx)
    wx:SetForcedNightVision(TheWorld.state.isnight and not TheWorld.state.isfullmoon)
end

local function nightvision_activate(inst, wx)
    wx._nightvision_modcount = (wx._nightvision_modcount or 0) + 1

    if wx._nightvision_modcount == 1 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
        if TheWorld:HasTag("cave") then
            wx:SetForcedNightVision(true)
        else
            wx:WatchWorldState("isnight", nightvision_onworldstateupdate)
            wx:WatchWorldState("isfullmoon", nightvision_onworldstateupdate)
            nightvision_onworldstateupdate(wx)
        end
    end
end

local function nightvision_deactivate(inst, wx)
    wx._nightvision_modcount = math.max(0, wx._nightvision_modcount - 1)

    if wx._nightvision_modcount == 0 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
        if TheWorld:HasTag("cave") then
            wx:SetForcedNightVision(false)
        else
            wx:StopWatchingWorldState("isnight", nightvision_onworldstateupdate)
            wx:StopWatchingWorldState("isfullmoon", nightvision_onworldstateupdate)
            wx:SetForcedNightVision(false)
        end
    end
end

local NIGHTVISION_MODULE_DATA =
{
    name = "nightvision",
    slots = 4,
    activatefn = nightvision_activate,
    deactivatefn = nightvision_deactivate,
}
table.insert(module_definitions, NIGHTVISION_MODULE_DATA)

AddCreatureScanDataDefinition("mole", "nightvision", 4)

---------------------------------------------------------------
local function cold_activate(inst, wx)
    -- A lower maxtemp means it's harder to overheat.
    --wx.components.temperature.maxtemp = wx.components.temperature.maxtemp - TUNING.WX78_MINTEMPCHANGEPERMODULE
    --wx.components.temperature.mintemp = wx.components.temperature.mintemp - TUNING.WX78_MINTEMPCHANGEPERMODULE
	
	--[[if wx._oncoldstop == nil then
        wx._oncoldstop = function(owner, data)
            StopAddFreeze(owner, data, inst)
        end
    end
	
	if wx._oncoldmove == nil then
        wx._oncoldmove = function(owner, data)
            MoveStopFreeze(owner, data, inst)
        end
    end]]
	
	if inst.stoppedfreezetask == nil then
		inst.stoppedfreezetask = wx:DoPeriodicTask(0.5, function(wx)
			if wx.sg:HasStateTag("idle") then 
				--print("hi :3 :3 :3 :3 ") --I am going insane
				wx.components.freezable:AddColdness(0.3, 5)
				wx.components.temperature:DoDelta(-1.25)
			end
		end)
	end
	
	if inst.icemakertask == nil then
		inst.icemakertask = wx:DoPeriodicTask(25, function(wx)
			local x, y, z = wx.Transform:GetWorldPosition()
			--for i = 1, TUNING.WX78_COLD_ICECOUNT do
				local ice = SpawnPrefab("ice")
				ice.Transform:SetPosition(x, y, z)
				Launch(ice, wx, 1.5)
			--end
		end)
	end
	
	--wx:ListenForEvent("onreachdestination", wx._oncoldstop, wx)
	--inst:ListenForEvent("locomote", wx._oncoldmove, wx)
	
    if wx.AddTemperatureModuleLeaning ~= nil then
        wx:AddTemperatureModuleLeaning(-1)
    end
	
	--local modvalue = 40 * wx._temperature_modulelean
	--wx.components.temperature:SetModifier("wx78module_cold", modvalue)
end

local function cold_deactivate(inst, wx)
    --wx.components.temperature.maxtemp = wx.components.temperature.maxtemp + TUNING.WX78_MINTEMPCHANGEPERMODULE
    --wx.components.temperature.mintemp = wx.components.temperature.mintemp + TUNING.WX78_MINTEMPCHANGEPERMODULE

    if wx.AddTemperatureModuleLeaning ~= nil then
        wx:AddTemperatureModuleLeaning(1)
    end
	
	--local modvalue = 45 * wx._temperature_modulelean
	
	if inst.stoppedfreezetask ~= nil then
		inst.stoppedfreezetask:Cancel()
		inst.stoppedfreezetask = nil
	end
	
	if inst.icemakertask ~= nil then
		inst.icemakertask:Cancel()
		inst.icemakertask = nil
	end
	
	--inst:RemoveEventCallback("locomote", wx._oncoldmove, wx)
	--[[wx.components.temperature:RemoveModifier("wx78module_cold")
	if modvalue ~= 0 then
		wx.components.temperature:SetModifier("wx78module_cold", modvalue)
	end]]
end

local COLD_MODULE_DATA =
{
    name = "cold",
    slots = 3,
    activatefn = cold_activate,
    deactivatefn = cold_deactivate,
}
table.insert(module_definitions, COLD_MODULE_DATA)

AddCreatureScanDataDefinition("icehound", "cold", 4)
AddCreatureScanDataDefinition("deerclops", "cold", 10)

---------------------------------------------------------------
local function taser_cooldown(inst)
    inst._cdtask = nil
end


local function taser_onblockedorattacked(wx, data, inst)
    if (data ~= nil and data.attacker ~= nil and not data.redirected) and inst._cdtask == nil then
        inst._cdtask = inst:DoTaskInTime(0.3, taser_cooldown)

        if data.attacker.components.combat ~= nil
                and (data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead())
                and (data.attacker.components.inventory == nil or not data.attacker.components.inventory:IsInsulated())
                and (data.weapon == nil or 
                        (data.weapon.components.projectile == nil
                        and (data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil))
                ) then

            SpawnPrefab("electrichitsparks"):AlignToTarget(data.attacker, wx, true)

            local damage_mult = 1
            if not (data.attacker:HasTag("electricdamageimmune") or
                    (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated())) then
                damage_mult = TUNING.ELECTRIC_DAMAGE_MULT

                local wetness_mult = (data.attacker.components.moisture ~= nil and data.attacker.components.moisture:GetMoisturePercent())
                    or (data.attacker:GetIsWet() and 1)
                    or 0
                damage_mult = damage_mult + wetness_mult
            end

            data.attacker.components.combat:GetAttacked(wx, damage_mult * TUNING.WX78_TASERDAMAGE, nil, "electric")
			
			--local function tasedamaged(data)
				
			--end
			
			local tased_duration = wx._taser_chips/1.5
			
			if data.attacker.sg ~= nil and not data.attacker.sg.statemem.devoured then
				data.attacker.sg:GoToState("hit")
				if data.attacker.tased_stunlocktask == nil then
				data.attacker.tased_stunlocktask = data.attacker:DoPeriodicTask(0.15, function()
					if data.attacker ~= nil and not data.attacker.components.health:IsDead() then
						--print("WORKS TOTALLY")
						if data.attacker:HasTag("spider") then
							data.attacker.sg:GoToState("hit_stunlock")
						else
							data.attacker.sg:GoToState("hit")
							if data.attacker.components.combat.hurtsound ~= nil then
								data.attacker.SoundEmitter:PlaySound(data.attacker.components.combat.hurtsound)
							end
						end
						SpawnPrefab("electrichitsparks"):AlignToTarget(data.attacker, wx, true)
					end
				end)
				end
				data.attacker:DoTaskInTime(tased_duration, function()
					if data.attacker.tased_stunlocktask ~= nil then
						data.attacker.tased_stunlocktask:Cancel()
						data.attacker.tased_stunlocktask = nil
					end
				end)
			end
        end
    end
end

local function taser_onattackother(wx, data, inst)
	wx._taserchip_attackcounter = wx._taserchip_attackcounter + 1
	if wx._taserchip_attackcounter >= 12 then
		wx._taserchip_attackcounter = 0
		wx.components.upgrademoduleowner:AddCharge(1)
	end
end

local function taser_activate(inst, wx)
    if inst._onblocked == nil then
        inst._onblocked = function(owner, data)
            taser_onblockedorattacked(owner, data, inst)
        end
    end
	
	if inst._onattackelec == nil then
		inst._onattackelec = function(owner, data)
			taser_onattackother(owner, data, inst)
		end
	end
	
	wx._taserchip_attackcounter = 0
	
	wx._taser_chips = (wx._taser_chips or 0) + 1
	
    inst:ListenForEvent("blocked", inst._onblocked, wx)
    inst:ListenForEvent("attacked", inst._onblocked, wx)
	inst:ListenForEvent("onattackother", inst._onattackelec, wx)

    if wx.components.inventory ~= nil then
        wx.components.inventory.isexternallyinsulated:SetModifier(inst, true)
    end
end

local function taser_deactivate(inst, wx)
	wx._taser_chips = math.max(0, wx._taser_chips - 1)

    inst:RemoveEventCallback("blocked", inst._onblocked, wx)
    inst:RemoveEventCallback("attacked", inst._onblocked, wx)
	inst:RemoveEventCallback("onattackother", inst._onattackelec, wx)

    if wx.components.inventory ~= nil then
        wx.components.inventory.isexternallyinsulated:RemoveModifier(inst)
    end
end

local TASER_MODULE_DATA =
{
    name = "taser",
    slots = 2,
    activatefn = taser_activate,
    deactivatefn = taser_deactivate,

    extra_prefabs = { "electrichitsparks", },
}
table.insert(module_definitions, TASER_MODULE_DATA)

AddCreatureScanDataDefinition("lightninggoat", "taser", 5)

---------------------------------------------------------------
local LIGHT_R, LIGHT_G, LIGHT_B = 235 / 255, 121 / 255, 12 / 255
local function light_activate(inst, wx)
    wx._light_modules = (wx._light_modules or 0) + 1

    wx.Light:SetRadius(TUNING.WX78_LIGHT_BASERADIUS + (wx._light_modules - 1) * TUNING.WX78_LIGHT_EXTRARADIUS)
    
    -- If we had 0 before, set up the light properties.
    if wx._light_modules == 1 then
        wx.Light:SetIntensity(0.90)
        wx.Light:SetFalloff(0.50)
        wx.Light:SetColour(LIGHT_R, LIGHT_G, LIGHT_B)

        wx.Light:Enable(true)
    end
end

local function light_deactivate(inst, wx)
    wx._light_modules = math.max(0, wx._light_modules - 1)

    if wx._light_modules == 0 then
        -- Reset properties to the electrocute light properties, since that's the player_common default.
        wx.Light:SetRadius(0.5)
        wx.Light:SetIntensity(0.8)
        wx.Light:SetFalloff(0.65)
        wx.Light:SetColour(255 / 255, 255 / 255, 236 / 255)

        wx.Light:Enable(false)
    else
        wx.Light:SetRadius(TUNING.WX78_LIGHT_BASERADIUS + (wx._light_modules - 1) * TUNING.WX78_LIGHT_EXTRARADIUS)
    end
end

local LIGHT_MODULE_DATA =
{
    name = "light",
    slots = 3,
    activatefn = light_activate,
    deactivatefn = light_deactivate,
}
table.insert(module_definitions, LIGHT_MODULE_DATA)

AddCreatureScanDataDefinition("squid", "light", 6)
AddCreatureScanDataDefinition("worm", "light", 6)
AddCreatureScanDataDefinition("lightflier", "light", 6)

---------------------------------------------------------------

--local function stats_negate(wx, health_delta, hunger_delta, sanity_delta)

--end

local function maxhunger_activate(inst, wx, isloading)
    if wx.components.hunger ~= nil then
        local current_hunger_percent = wx.components.hunger:GetPercent()

        wx.components.hunger:SetMax(wx.components.hunger.max + TUNING.WX78_MAXHUNGER_BOOST)

        if not isloading then
            wx.components.hunger:SetPercent(current_hunger_percent, false)
        end
		
		wx._hunger_chips = (wx._hunger_chips or 0) + 1
		
		--[[if wx.components.eater.custom_stats_mod_fn == nil then
			wx.components.eater.custom_stats_mod_fn = stats_negate
		end]]

        -- Tie it to the module instance so we don't have to think too much about removing them.
        wx.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.WX78_MAXHUNGER_SLOWPERCENT)
    end
end

local function maxhunger_deactivate(inst, wx)
    if wx.components.hunger ~= nil then
        local current_hunger_percent = wx.components.hunger:GetPercent()

        wx.components.hunger:SetMax(wx.components.hunger.max - TUNING.WX78_MAXHUNGER_BOOST)
        wx.components.hunger:SetPercent(current_hunger_percent, false)
		
		wx._hunger_chips = math.max(0, wx._hunger_chips - 1)

        wx.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
end

local MAXHUNGER_MODULE_DATA =
{
    name = "maxhunger",
    slots = 2,
    activatefn = maxhunger_activate,
    deactivatefn = maxhunger_deactivate,
}
table.insert(module_definitions, MAXHUNGER_MODULE_DATA)

AddCreatureScanDataDefinition("bearger", "maxhunger", 6)
AddCreatureScanDataDefinition("slurper", "maxhunger", 3)

---------------------------------------------------------------
local function maxhunger1_activate(inst, wx, isloading)
    if wx.components.hunger ~= nil then
        local current_hunger_percent = wx.components.hunger:GetPercent()

        wx.components.hunger:SetMax(wx.components.hunger.max + TUNING.WX78_MAXHUNGER1_BOOST)

        if not isloading then
            wx.components.hunger:SetPercent(current_hunger_percent, false)
        end
		
		wx.components.hunger.burnratemodifiers:SetModifier(inst, 0.95)
    end
end

local function maxhunger1_deactivate(inst, wx)
    if wx.components.hunger ~= nil then
        local current_hunger_percent = wx.components.hunger:GetPercent()

        wx.components.hunger:SetMax(wx.components.hunger.max - TUNING.WX78_MAXHUNGER1_BOOST)
        wx.components.hunger:SetPercent(current_hunger_percent, false)
		
		wx.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
end

local MAXHUNGER1_MODULE_DATA =
{
    name = "maxhunger1",
    slots = 1,
    activatefn = maxhunger1_activate,
    deactivatefn = maxhunger1_deactivate,
}
table.insert(module_definitions, MAXHUNGER1_MODULE_DATA)

AddCreatureScanDataDefinition("hound", "maxhunger1", 2)

---------------------------------------------------------------
local function music_sanityaura_fn(wx, observer)
    local num_modules = wx._music_modules or 1
    return TUNING.WX78_MUSIC_SANITYAURA * num_modules
end

local function music_sanityfalloff_fn(inst, observer, distsq)
    return 1
end

local MUSIC_TENDINGTAGS_MUST = {"farm_plant"}
local function music_update_fn(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.WX78_MUSIC_TENDRANGE, MUSIC_TENDINGTAGS_MUST)
    for _, v in ipairs(ents) do
        if v.components.farmplanttendable ~= nil then
            v.components.farmplanttendable:TendTo(inst)
        end
    end

    SpawnPrefab("wx78_musicbox_fx").Transform:SetPosition(x, y, z)
end

local function music_activate(inst, wx)
    wx._music_modules = (wx._music_modules or 0) + 1

    -- Sanity auras don't affect their owner, so add dapperness to also give WX sanity regen.
    wx.components.sanity.dapperness = wx.components.sanity.dapperness + TUNING.WX78_MUSIC_DAPPERNESS

    if wx._music_modules == 1 then
        if wx.components.sanityaura == nil then
            wx:AddComponent("sanityaura")
            wx.components.sanityaura.aurafn = music_sanityaura_fn
            wx.components.sanityaura.fallofffn = music_sanityfalloff_fn

            wx.components.sanityaura.max_distsq = TUNING.WX78_MUSIC_AURADSQ
        end

        if wx._tending_update == nil then
            wx._tending_update = wx:DoPeriodicTask(TUNING.WX78_MUSIC_UPDATERATE, music_update_fn, 1)
        end

        wx.SoundEmitter:PlaySound("WX_rework/module/musicmodule_lp", "music_sound")
    elseif wx._music_modules == 2 then
        wx.SoundEmitter:SetParameter("music_sound", "wathgrithr_intensity", 1)
    end
end

local function music_deactivate(inst, wx)
    wx._music_modules = math.max(0, wx._music_modules - 1)

    wx.components.sanity.dapperness = wx.components.sanity.dapperness - TUNING.WX78_MUSIC_DAPPERNESS

    wx.components.sanityaura.max_distsq = (wx._music_modules * TUNING.WX78_MUSIC_TENDRANGE) * (wx._music_modules * TUNING.WX78_MUSIC_TENDRANGE)

    if wx._music_modules == 0 then
        wx:RemoveComponent("sanityaura")

        if wx._tending_update ~= nil then
            wx._tending_update:Cancel()
            wx._tending_update = nil
        end

        wx.SoundEmitter:KillSound("music_sound")
    elseif wx._music_modules == 1 then
        wx.SoundEmitter:SetParameter("music_sound", "wathgrithr_intensity", 0)
    end
end

local MUSIC_MODULE_DATA =
{
    name = "music",
    slots = 3,
    activatefn = music_activate,
    deactivatefn = music_deactivate,

    scannable_prefabs = { "crabking", },
}
table.insert(module_definitions, MUSIC_MODULE_DATA)

AddCreatureScanDataDefinition("crabking", "music", 8)
AddCreatureScanDataDefinition("hermitcrab", "music", 4)

---------------------------------------------------------------
local function bee_tick(wx, inst)
    if wx._bee_modcount and wx._bee_modcount > 0 and wx.components.inventory ~= nil then
        local health_tick = wx._bee_modcount * TUNING.WX78_BEE_HEALTHPERTICK
        wx.components.health:DoDelta(health_tick, false, inst, true)
    end
end

local function bee_activate(inst, wx, isloading)
    wx._bee_modcount = (wx._bee_modcount or 0) + 1

    if wx._bee_modcount == 1 then
        if wx._bee_regentask ~= nil then
            wx._bee_regentask:Cancel()
        end
        wx._bee_regentask = wx:DoPeriodicTask(TUNING.WX78_BEE_TICKPERIOD, bee_tick, nil, inst)
    end

    maxsanity_activate(inst, wx, isloading)
end

local function bee_deactivate(inst, wx)
    wx._bee_modcount = math.max(0, wx._bee_modcount - 1)

    if wx._bee_modcount == 0 then
        if wx._bee_regentask ~= nil then
            wx._bee_regentask:Cancel()
            wx._bee_regentask = nil
        end
    end

    maxsanity_deactivate(inst, wx)
end

local BEE_MODULE_DATA =
{
    name = "bee",
    slots = 3,
    activatefn = bee_activate,
    deactivatefn = bee_deactivate,
}
table.insert(module_definitions, BEE_MODULE_DATA)

AddCreatureScanDataDefinition("beequeen", "bee", 10)

---------------------------------------------------------------
-- We calculate the boost locally becuase it's slightly nicer
-- if mods want to change the tuning values.
local function maxhealth2_activate(inst, wx, isloading)
    local maxhealth2_boost = TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT
    maxhealth_change(inst, wx, maxhealth2_boost, isloading)
	wx.components.health:SetAbsorptionAmount(wx.components.health.absorb + 0.2)
end

local function maxhealth2_deactivate(inst, wx)
    local maxhealth2_boost = TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT
    maxhealth_change(inst, wx, -maxhealth2_boost)
	wx.components.health:SetAbsorptionAmount(wx.components.health.absorb - 0.2)
end

local MAXHEALTH2_MODULE_DATA =
{
    name = "maxhealth2",
    slots = 2,
    activatefn = maxhealth2_activate,
    deactivatefn = maxhealth2_deactivate,
}
table.insert(module_definitions, MAXHEALTH2_MODULE_DATA)

AddCreatureScanDataDefinition("spider_healer", "maxhealth2", 4)

---------------------------------------------------------------
local module_netid = 1
local module_netid_lookup = {}

-- Add a new module definition table, passing a table with the following properties:
--      name -          The type-name of the module (without the "wx78module_" prefix)
--      slots -         How many energy slots the module requires to be plugged in & activated
--      activatefn -    The function that runs whenever the module is activated [signature (module instance, owner instance)]. This can run during loading.
--      deactivatefn -  The function that runs whenever the module is deactivated [signature (module instance, owner instance)]
--      extra_prefabs - Additional prefabs to be imported alongside the module, such as fx prefabs
--
--      returns a net id for the module, to send for UI purposes; also adds that net id (as module_netid) to the passed definition.
local function AddNewModuleDefinition(module_definition)
    assert(module_netid < 64, "To support additional WX modules, player_classified.upgrademodules must be updated")

    module_definition.module_netid = module_netid
    module_netid_lookup[module_netid] = module_definition
    module_netid = module_netid + 1

    return module_definition.module_netid
end

-- Given a module net id, get the definition table of that module.
local function GetModuleDefinitionFromNetID(netid)
    return (netid ~= nil and module_netid_lookup[netid])
        or nil
end

for _, definition in ipairs(module_definitions) do
    AddNewModuleDefinition(definition)
end

---------------------------------------------------------------

return {
    module_definitions = module_definitions,
    AddNewModuleDefinition = AddNewModuleDefinition,
    GetModuleDefinitionFromNetID = GetModuleDefinitionFromNetID,

    AddCreatureScanDataDefinition = AddCreatureScanDataDefinition,
    GetCreatureScanDataDefinition = GetCreatureScanDataDefinition,
}
