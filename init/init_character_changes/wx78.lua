-----------------------------------------------------------------
-- WX damage changes during wet
-----------------------------------------------------------------


GLOBAL.TUNING.WX78_CHARGING_FOODS.zaspberry = 1
GLOBAL.TUNING.WX78_CHARGING_FOODS.zaspberryparfait = 1
GLOBAL.TUNING.WX78_CHARGING_FOODS.powercell = 1

local ModuleDefs = require("wx78_moduledefs")

--ModuleDefs.AddCreatureScanDataDefinition("dreadeye", "maxsanity", 3)
ModuleDefs.AddCreatureScanDataDefinition("creepingfear", "maxsanity", 6)
ModuleDefs.AddCreatureScanDataDefinition("trepidation", "maxsanity", 6)
ModuleDefs.AddCreatureScanDataDefinition("mock_dragonfly", "heat", 10)
ModuleDefs.AddCreatureScanDataDefinition("viperworm", "light", 6)
ModuleDefs.AddCreatureScanDataDefinition("shockworm", "light", 6)
ModuleDefs.AddCreatureScanDataDefinition("magmahound", "heat", 4)
ModuleDefs.AddCreatureScanDataDefinition("glacialhound", "cold", 4)
ModuleDefs.AddCreatureScanDataDefinition("lightninghound", "taser", 5)

--TODO, reimplement dorainsparks to do based on wetness from min to max damage
    --add rate too

local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnLightningStrike(inst)
    if inst.components.health ~= nil and not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
        if inst.components.inventory:IsInsulated() then
            inst:PushEvent("lightningdamageavoided")
        else
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            inst.components.upgrademoduleowner:AddCharge(1)
        end
    end
end

env.AddPrefabPostInit("wx78", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddTag("automaton")

    if TUNING.DSTU.WX78_CONFIG then
		if inst.components.playerlightningtarget ~= nil then
			inst.components.playerlightningtarget:SetOnStrikeFn(OnLightningStrike)
		end
    end
end)

-------------WX RE-WIRED CHANGES :]------------------
if TUNING.DSTU.WXLESS then --HI ATOBA :3 :3 <3 <3 
--btw I'm not sure if formatting translated correctly when I uploaded the file? It kinda gets messed up even if I copy pasted so sorry Atober if it ends up being converted into 4 spaces isntead of tab or smth :]

local module_definitions = require("um_wx78_moduledefs").module_definitions -- this is where things circuit definitions actually get loaded from
local UIAnim = require "widgets/uianim"
local easing = require("easing")
local CHARGEREGEN_TIMERNAME = "chargeregenupdate"
local CHARGEDEGEN_TIMERNAME = "chargedegenupdate"
	
local function on_module_removed(inst)
	--if inst.components.upgrademodule.target ~= nil then
    inst.components.fueled:StopConsuming()
    --end
	if inst.module_in_use ~= nil then inst.module_in_use = nil end
end

env.AddComponentPostInit("upgrademoduleowner", function(self)
	function self:UpdateActivatedModules(isloading)
		local remaining_charge = self.charge_level
		for _, module in ipairs(self.modules) do
			remaining_charge = remaining_charge - module.components.upgrademodule.slots
			if self.charge_level == 0 then
				module.components.upgrademodule:TryDeactivate()
			else
				module.components.upgrademodule:TryActivate(isloading)
				module:PushEvent("upgrademodule_moduleactivated")
				--self.inst:PushEvent("upgrademoduleowner_moduleactivated")-- not used currently -- I should probably comment it out then :]
			end
		end
	end
	
	function self:PopOneModule()
		local energy_cost = 0

		if #self.modules > 0 then
			local pre_remove_slotcount = self:UsedSlotCount()

			local popped_module = self:PopModule()

			-- If the module we just popped was charged, return that charge
			-- as the cost of this removal. -- do not.
			--[[if pre_remove_slotcount <= self.charge_level then
				energy_cost = popped_module.components.upgrademodule.slots
			end]]

			if self.ononemodulepopped then
				self.ononemodulepopped(self.inst, popped_module)
			end
		end

		return energy_cost
	end
end)

local function do_chargeregen_update(inst) --the name is a LIE it's actually charge DEGEN update!!!!
	if inst._chip_inuse ~= 0 and not inst.components.upgrademoduleowner:IsChargeEmpty() then
		--print(inst.components.upgrademoduleowner.charge_level)
		inst.components.upgrademoduleowner:AddCharge(-1)
		--print(inst.components.upgrademoduleowner.charge_level)
    end
end

local function OnTryRegenTimerStart(inst)
	if inst._chip_inuse == 0 then
		inst.components.timer:StopTimer(CHARGEDEGEN_TIMERNAME)
		inst.components.timer:StartTimer(CHARGEREGEN_TIMERNAME, TUNING.WX78_CHARGE_REGENTIME)
	else
		inst:DoTaskInTime(1, OnTryRegenTimerStart)
	end
end

--okay uhm so this determines if the meter should regen charge or degen it, and also determines how fast it should consume charge depending on the amount of slots currently occuppied
local function OnUpgradeModuleChargeChanged(inst, ispushed)
    -- That's a lota prints, kept them for easier future debugging since the system messed with my brain for a bit before
	inst.components.timer:StopTimer(CHARGEREGEN_TIMERNAME)
 
	if inst._chip_inuse ~= 0 and not inst.components.upgrademoduleowner:IsChargeEmpty() then
		local slotsinuse = inst._chip_inuse
		local oldslotsinuse = inst._old_chip_inuse
		if not ispushed then -- I don't actually think this ever triggers?..
			inst.components.timer:StopTimer(CHARGEDEGEN_TIMERNAME)
			inst.components.timer:StartTimer(CHARGEDEGEN_TIMERNAME, CHARGE_DEGENTIME[slotsinuse])
			--print("start degen at ")
			--print(inst.components.timer:GetTimeLeft(CHARGEDEGEN_TIMERNAME))
		elseif ispushed then
			local newtime = CHARGE_DEGENTIME[slotsinuse]
			local oldtime = CHARGE_DEGENTIME[oldslotsinuse] or 0
			local timedif = newtime - oldtime
			local oldtimeleft = inst.components.timer:GetTimeLeft(CHARGEDEGEN_TIMERNAME) or 0
			local newtimeleft = oldtimeleft + timedif
			--[[print("new module pushed, base time amount")
			print(newtime)
			print("time difference in charges")
			print(timedif)
			print("time left before")
			print(oldtimeleft)
			print("time left now")
			print(newtimeleft)]]
			if timedif == 0 then --if the amount of occupied slots is the same that means it was just an energy update
				newtimeleft = newtime 
				if inst._hunger_chips ~= nil and inst._hunger_chips ~= 0 then --this used to apply on any module equip/unequip, that caused problems
					newtimeleft = newtimeleft * (1.2^inst._hunger_chips)
					--print("hunger chip detected, increased time")
				end
				--print(newtimeleft)
			end 
			
			
			if inst.components.timer:TimerExists(CHARGEDEGEN_TIMERNAME) then
				inst.components.timer:SetTimeLeft(CHARGEDEGEN_TIMERNAME, newtimeleft)
			else 
				inst.components.timer:StartTimer(CHARGEDEGEN_TIMERNAME, newtimeleft)
			end
		end
		--[[print("slots in use before")
		print(oldslotsinuse)
		print("slots in use now")
		print(slotsinuse)]]
		
	else
		print("All modules *should* be gone")
		if inst._chip_inuse == 0 then
			inst.components.timer:StopTimer(CHARGEDEGEN_TIMERNAME)
			inst.components.timer:StartTimer(CHARGEREGEN_TIMERNAME, TUNING.WX78_CHARGE_REGENTIME)
		end
		--[[if inst.components.upgrademoduleowner:IsChargeEmpty() then -- not needed since it now listens every time module is pushed/popped
			OnTryRegenTimerStart(inst)
		end]]
    end
	inst._old_chip_inuse = inst._chip_inuse
end

-------This is circuit stuff--------
local function ondepleted(inst)
	if inst.components.upgrademodule.target ~= nil then
		local wx = inst.components.upgrademodule.target
		wx.components.upgrademoduleowner:PopAllModules()
		wx:PushEvent("upgrademoduleowner_popallmodules")
		wx.components.upgrademoduleowner.charge_level = 0
		wx.components.talker:Say("UPGRADE OVERHEAT DETECTED, REMOVING ALL")
		wx.sg:GoToState("hit")
		wx.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
	end
	if inst.components.fueled ~= nil then
		inst:Remove()
	end
end

--local circuit_durability = GetModConfigData("circ_dur") --yeah so since that it's not its own mod anymore it's just one value unless you feel like creating a new config ( I do not :] :P :) :D )
local seg_time = 30
local total_day_time = seg_time*16
local circuit_durability = total_day_time*20
local function ChangeModule(data) -- function to change every module, gets stuff from module definitions files and also changes how their durability work. Pretty cool if I do say so myself

		env.AddPrefabPostInit("wx78module_"..data.name, function(inst)
   
		if not TheWorld.ismastersim then
            return inst
        end
   
        inst.components.upgrademodule.onactivatedfn = data.activatefn
        inst.components.upgrademodule.ondeactivatedfn = data.deactivatefn
        inst.components.upgrademodule.onremovedfromownerfn = on_module_removed

        --------------------------------------------------------------------------
        inst:RemoveComponent("finiteuses")
		
		inst:AddComponent("fueled")
		--inst.components.fueled:SetSectionCallback(onfuelchange) --somehow only now I realized this nil thing exists??? How did I never got an error for it before?? How did that end up here????
		inst.components.fueled:InitializeFuelLevel(circuit_durability) -- considered giving different sizes different durability but idk
		inst.components.fueled:SetDepletedFn(ondepleted)
		--feel free to just make circuits refuelable with biodata since circuit box is still work in progress (mainly due to missing animations) so I'm not adding it to Uncomp just yet
		local function checkforconsume(inst)
			if inst.components.upgrademodule.target ~= nil and inst.components.fueled ~= nil and inst.module_in_use == nil and inst.components.upgrademodule.activated == true then
				inst.module_in_use = 1
				inst.components.fueled:StartConsuming()
			end
		end
		
		local function overheatwarn(inst)
			if inst.components.upgrademodule.target ~= nil and inst.components.fueled ~= nil and inst.components.upgrademodule.activated == true then
				local wx = inst.components.upgrademodule.target
				if inst.components.fueled:GetPercent() == 0.1 then
					wx.components.talker:Say("POTENTIAL OVERHEAT DETECTED, UPGRADE MODULES CHECK REQUIRED") --warnings are important since running out of durability unequips all modules
				elseif inst.components.fueled:GetPercent() == 0.05 or inst.components.fueled:GetPercent() == 0.04 or inst.components.fueled:GetPercent() == 0.03 or inst.components.fueled:GetPercent() == 0.02 then
					wx.components.talker:Say("MODULE OVERHEAT THREAD LEVEL HIGH, IMMEDIATE EXAMINATION REQUIRED")
				elseif inst.components.fueled:GetPercent() == 0.01 then
					wx.components.talker:Say("UPGRADE MODULE OVERHEAT INCOMING") --honestly maybe should come up with a different way to give warnings
				end
			end
		end
		
		inst:ListenForEvent	("upgrademodule_moduleactivated", checkforconsume)--I didn't know how to know when the module is equipped --UPDATE: added a new one myself, used to check every 0.5 seconds
		inst:ListenForEvent ("percentusedchange", overheatwarn)

		end)
		
end 

for _, def in ipairs(module_definitions) do
	ChangeModule(def)
end


---------------------------------------------------------------------

local function OnEatFun(inst, food) -- stuff for charges for food and reversing negative stats from hunger chips

	local charge_hungeramount
			
	--[[if food.components.edible:GetHunger(inst) >= 150 then charge_hungeramount = 4
	elseif food.components.edible:GetHunger(inst) >= 75 then charge_hungeramount = 3
	elseif food.components.edible:GetHunger(inst) >= 37.5 then charge_hungeramount = 2 
	elseif food.components.edible:GetHunger(inst) >= 25 then charge_hungeramount = 1 end]] --Gonna try a different system, keep it here if there's a sudden feeling to go back :P
	
	local hunger_to_charge = 37.5
	
	inst._hungercharge_stored = (inst._hungercharge_stored or 0) + (food.components.edible:GetHunger(inst) / hunger_to_charge)
	
	if inst._hungercharge_stored >= 1 then 
		local leftovers = inst._hungercharge_stored - math.floor(inst._hungercharge_stored)
		charge_hungeramount = math.floor(inst._hungercharge_stored + 0.5)
		inst._hungercharge_stored = leftovers
	end
			
	if charge_hungeramount ~= nil then
		inst.components.upgrademoduleowner:AddCharge(charge_hungeramount)
	end
	
	--[[if inst._hunger_chips ~= nil and inst._hunger_chips ~= 0 then
		if food.components.edible:GetHealth(inst) < 0 then
			local health = food.components.edible:GetHealth(inst) * HUNGER_TABLES[inst._hunger_chips + 1]
			inst.components.health:DoDelta(-health, false)
		end
		if food.components.edible:GetSanity(inst) < 0 then
			local sanity = food.components.edible:GetSanity(inst) * HUNGER_TABLES[inst._hunger_chips + 1]
			inst.components.sanity:DoDelta(-sanity, false)
		end
		if food.components.edible:GetHunger(inst) < 0 then
			local hunger = food.components.edible:GetHunger(inst) * HUNGER_TABLES[inst._hunger_chips + 1]
			inst.components.health:DoDelta(-hunger, false)
		end
	end]] -- moved to a separate function, keeping it here to basically remind myself that there's a better way to do custom food stats than events and deltas
end

local function stats_negate(inst, health_delta, hunger_delta, sanity_delta) --altered the system for UM specifically so it wouldn't cancel out negative stats with only one circuit

	if inst._hunger_chips ~= nil and inst._hunger_chips ~= 0 then
		if health_delta < 0 then
			health_delta = health_delta * HUNGER_TABLES[inst._hunger_chips]
		end
		if sanity_delta < 0 then
			sanity_delta = sanity_delta * HUNGER_TABLES[inst._hunger_chips]
		end
		if hunger_delta < 0 then
			hunger_delta = hunger_delta * HUNGER_TABLES[inst._hunger_chips ]
		end
	end
	
	return health_delta, hunger_delta, sanity_delta
end

------------------------------------------- have I said hi before? HI ATOBA :] :] :] --And everyone else too.... I guess..........

local function GetThermicTemperatureFn(inst, observer)
	--local heat_adjust = 25
	local emitting_temp = 0
	local current = inst.components.temperature.current
	if inst._temperature_modulelean > 0 then 
		--[[if current >= 50 then
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE * 2
		elseif current >= 37.5 then
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE * 1.5
		elseif current >= 25 then
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE
		end]] -- Let's try easing, again keeping it here since I hecking love comments
		
		emitting_temp = (current > 50 and TUNING.WX78_HEATERTEMPPERMODULE * 2) or 
		(current > 25 and easing.linear(current - 25, TUNING.WX78_HEATERTEMPPERMODULE, TUNING.WX78_HEATERTEMPPERMODULE, 25)) or 0
		
	elseif inst._temperature_modulelean < 0 then
		--[[if current <= 20 then 
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE * 2
		elseif current <= 32.5 then
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE * 1.5
		elseif current <= 45 then
			emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE
		end]]
		--emitting_temp = TUNING.WX78_HEATERTEMPPERMODULE + 10
		emitting_temp = (current < 20 and TUNING.WX78_HEATERTEMPPERMODULE * 2) or 
		(current < 45 and easing.linear(current - 20, TUNING.WX78_HEATERTEMPPERMODULE, TUNING.WX78_HEATERTEMPPERMODULE, 25)) or 0
	end
	--if emitting_temp < 0 then emitting_temp = 0 end
    return inst._temperature_modulelean * emitting_temp
end


local function ModuleBasedPreserverRateFn(inst, item)
    return (inst._temperature_modulelean > 0 and TUNING.WX78_PERISH_HOTRATE)
        or (inst._temperature_modulelean < 0 and TUNING.WX78_PERISH_COLDRATE/math.abs(inst._temperature_modulelean))
        or 1
end


local function OnTimerFinished(inst, data)
    if data.name == CHARGEDEGEN_TIMERNAME then
        do_chargeregen_update(inst)
	end
end


env.AddPrefabPostInit("wx78", function(inst)

	if not TheWorld.ismastersim then
        return inst
    end
		
	--[[if inst.components.eater ~= nil then
		inst.components.eater:SetOnEatFn(OnEatFun)
		inst.components.eater.custom_stats_mod_fn = stats_negate
	end]]
	
	if inst.components.eater ~= nil then
		local old_oneatfn = inst.components.eater.oneatfn
  
		inst.components.eater.oneatfn = function(inst, food)
			OnEatFun(inst, food)

			if old_oneatfn ~= nil then
				old_oneatfn(inst, food)
			end
		end
		
		inst.components.eater.custom_stats_mod_fn = stats_negate
	end
	
	
	if inst.components.heater ~= nil then
		inst.components.heater.heatfn = GetThermicTemperatureFn
	end
	
	if inst.components.preserver ~= nil then
		inst.components.preserver:SetPerishRateMultiplier(ModuleBasedPreserverRateFn)
	end
	
	inst:AddComponent("efficientuser") -- Both for the Heat Module
	inst:AddComponent("workmultiplier")
	
	inst._old_chip_inuse = 0
	
	if inst._onpusheddegen == nil then
        inst._onpusheddegen = function(inst)
            OnUpgradeModuleChargeChanged(inst, true)
        end
    end
	
	--[[if inst.components.upgrademoduleowner ~= nil then
		local old_onmoduleadded = inst.components.upgrademoduleowner.onmoduleadded
  
		inst.components.upgrademoduleowner.onmoduleadded = function(inst, module)
			if old_onmoduleadded ~= nil then
				old_onmoduleadded(inst, module)
			end
			
			inst:PushEvent("onmoduleadded")
		end
	end]] -- NOT NEEDED, exists due to my mistake with the way OnEat function was coded that would push 0 energy updates that would trigger "upgrademodulesdirty"
	
	inst:ListenForEvent("energylevelupdate", OnUpgradeModuleChargeChanged)
	inst:ListenForEvent("upgrademodulesdirty", inst._onpusheddegen)
	--inst:ListenForEvent("upgrademoduleowner_popallmodules", OnTryRegenTimerStart) --not needed
	--inst:ListenForEvent("onmoduleadded", inst._onpusheddegen) --not needed
	inst:ListenForEvent("timerdone", OnTimerFinished)
	--For some reason I have a habit of keeping commented out stuff, maybe seeing previous mistakes that you overcame just makes me feel good :] :]  feel free to delete the comments anyway :]
end)

local seg_time = 30
local total_day_time = seg_time*16

local day_segs = 10
local dusk_segs = 4
local night_segs = 2
local day_time = seg_time * day_segs
local dusk_time = seg_time * dusk_segs
local night_time = seg_time * night_segs

TUNING.WX78_MAXELECTRICCHARGE=8
TUNING.WX78_CHARGE_REGENTIME = 30
TUNING.WX78_HEALTH = 100
TUNING.WX78_HUNGER = 100
TUNING.WX78_SANITY = 100
CHARGE_DEGENTIME={300, 270, 240, 210, 180, 150, 120, 90}

TUNING.WX78_MINTEMPCHANGEPERMODULE = 20
TUNING.WX78_HEATERTEMPPERMODULE = 25
TUNING.WX78_MOVESPEED_CHIPBOOSTS={0.00, 4, 3, 2, 1}
TUNING.WX78_LIGHT_BASERADIUS = 4
TUNING.WX78_LIGHT_EXTRARADIUS = 6
TUNING.WX78_MAXHUNGER_SLOWPERCENT = 0.80
TUNING.WX78_MAXSANITY_DAPPERNESS = 100/(day_time*6)
TUNING.WX78_MUSIC_DAPPERNESS = 100/(day_time*3)
TUNING.WX78_BEE_TICKPERIOD = 5
TUNING.WX78_BEE_HEALTHPERTICK = 1
TUNING.WX78_COLD_ICEMOISTURE = 35
TUNING.WX78_PERISH_COLDRATE = 0.75
HUNGER_TABLES={0.25, 0.0, -0.25, -0.5}
TUNING.WX78_CHARGING_FOODS = 
{
    voltgoatjelly = 8,
    voltgoatjelly_spice_chili = 8,
    voltgoatjelly_spice_garlic = 8,
    voltgoatjelly_spice_sugar = 8,
    voltgoatjelly_spice_salt = 8,
    goatmilk = 6,
	zaspberry = 6,
	zaspberryparfait = 8,
	zaspberryparfait_spice_chili = 8,
	zaspberryparfait_spice_garlic = 8,
	zaspberryparfait_spice_sugar = 8,
	zaspberryparfait_spice_salt = 8,
	powercell = 6
} --Also added Uncomp foods here


-- stuff below is mainly ui elements. I really wanted to make those better but FUCK SPRITER I GUESS WHY WON'T IT COMPILE PROPERLY
-- I had to go out of my way to change it while also avoiding interacting with both Spriter and scml files as a whole, what the fuck
local OnUpgradeModulesListDirty = function(inst)
    if inst._parent ~= nil then
        local module1 = inst.upgrademodules[1]:value()
        local module2 = inst.upgrademodules[2]:value()
        local module3 = inst.upgrademodules[3]:value()
        local module4 = inst.upgrademodules[4]:value()
        local module5 = inst.upgrademodules[5]:value()
        local module6 = inst.upgrademodules[6]:value()
        local module7 = inst.upgrademodules[7]:value()
        local module8 = inst.upgrademodules[8]:value()

        if module1 == 0 and module2 == 0 and module3 == 0 and module4 == 0 and module5 == 0 and module6 == 0 and module7 == 0 and module8 == 0 then
            inst._parent:PushEvent("upgrademoduleowner_popallmodules")
        else
            inst._parent:PushEvent("upgrademodulesdirty", {module1, module2, module3, module4, module5, module6, module7, module8})
        end
    end
end

env.AddPrefabPostInit("player_classified",function(inst)
	for i=7,8,1 do
		table.insert(inst.upgrademodules,net_smallbyte(inst.GUID, "upgrademodules.mods"..i, "upgrademoduleslistdirty"))
	end

	if not TheWorld.ismastersim then
		inst.event_listeners["upgrademoduleslistdirty"]={}
	    inst.event_listening["upgrademoduleslistdirty"]={}
		inst:ListenForEvent("upgrademoduleslistdirty", OnUpgradeModulesListDirty)
	end
end)



env.AddClassPostConstruct("widgets/upgrademodulesdisplay",function(self, ...)

	--[[self.battery_frame = self:AddChild(UIAnim())
    self.battery_frame:GetAnimState():SetBank("um_status_wx")
    self.battery_frame:GetAnimState():SetBuild("um_status_wx")
    self.battery_frame:GetAnimState():PlayAnimation("frame")
    self.battery_frame:GetAnimState():AnimateWhilePaused(false)]] --I stretched it without altering default image teehee

    self.energy_backing = self:AddChild(UIAnim())
    self.energy_backing:GetAnimState():SetBank("um_status_wx")
    self.energy_backing:GetAnimState():SetBuild("um_status_wx")
    self.energy_backing:GetAnimState():PlayAnimation("energy3")
    self.energy_backing:GetAnimState():AnimateWhilePaused(false)

    self.energy_blinking = self:AddChild(UIAnim())
    self.energy_blinking:GetAnimState():SetBank("um_status_wx")
    self.energy_blinking:GetAnimState():SetBuild("um_status_wx")
    self.energy_blinking:GetAnimState():PlayAnimation("energy2")
    self.energy_blinking:GetAnimState():AnimateWhilePaused(false)

    self.anim = self:AddChild(UIAnim())
    self.anim:GetAnimState():SetBank("um_status_wx")
    self.anim:GetAnimState():SetBuild("um_status_wx")
    self.anim:GetAnimState():PlayAnimation("energy1")
    self.anim:GetAnimState():AnimateWhilePaused(false)
	
	for i = 1, 8 do
	    local chip_object = self:AddChild(UIAnim())
		--if chip_object ~= nil then print("bazinga") end
	    chip_object:GetAnimState():SetBank("um_status_wx")
	    chip_object:GetAnimState():SetBuild("um_status_wx")
	    chip_object:GetAnimState():AnimateWhilePaused(false)

	    chip_object:GetAnimState():Hide("plug_on")
	    chip_object._power_hidden = true

	    chip_object:MoveToBack()
	    chip_object:Hide()

	    table.insert(self.chip_objectpool, chip_object)
    end

    for i,v in ipairs(self.chip_objectpool) do
    	v:SetPosition(0, 0)
    end

    self.battery_frame:SetPosition(0, 22)
	self.battery_frame:SetScale(1, 1.4, 1)
--end)
	
--AddClassPostConstruct("widgets/upgrademodulesdisplay",function(self, ...)
function self:UpdateChipCharges(plugging_in) -- this part is to make it clearer that modules work as long as you have more than 0 charge
    if self.chip_poolindex <= 1 then
        return
    end

    local charge = self.energy_level

    for i = 1, self.chip_poolindex - 1 do
        local chip = self.chip_objectpool[i]

        --charge = charge - chip._used_modslots

        if charge <= 0 and not chip._power_hidden then
            if not plugging_in then
                chip:GetAnimState():PlayAnimation((self.reversed and "chip_off_reverse") or "chip_off")
                chip:HookCallback("animover", function(chip_ui_inst)
                    chip:GetAnimState():Hide("plug_on")
                    chip:UnhookCallback("animover")
                end)
            else
                chip:GetAnimState():Hide("plug_on")
            end
            chip._power_hidden = true

			--self.owner:DoTaskInTime(0.1, function(self)
			if TheFrontEnd ~= nil then
			TheFrontEnd:GetSound():PlaySound("WX_rework/tube/HUD_off")
			end
			--end)

        elseif charge > 0 and chip._power_hidden then
            -- In case we changed charge before the power off animation finished.
            chip:UnhookCallback("animover")

            chip:GetAnimState():Show("plug_on")
            if not plugging_in then
                chip:GetAnimState():PlayAnimation((self.reversed and "chip_on_reverse") or "chip_on")
            end
            chip._power_hidden = false

			--self.owner:DoTaskInTime(0.1, function(self)
			if TheFrontEnd ~= nil then
			TheFrontEnd:GetSound():PlaySound("WX_rework/tube/HUD_on")
			end
			--end)

        end
    end
end
	
end)

env.AddClassPostConstruct("widgets/secondarystatusdisplays",function(self, ...)     
	if self.upgrademodulesdisplay then
		self.upgrademodulesdisplay:SetPosition(self.column1,-150)
 	end

end)

local function OnAllUpgradeModulesRemoved(inst)
    SpawnPrefab("wx78_big_spark"):AlignToTarget(inst)

    inst:PushEvent("upgrademoduleowner_popallmodules")

    if inst.player_classified ~= nil then
        for i=1,8,1 do
        	inst.player_classified.upgrademodules[i]:set(0)
        end
    end
end

env.AddPrefabPostInit("wx78",function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.components.upgrademoduleowner.onallmodulespopped = OnAllUpgradeModulesRemoved
end)

end
