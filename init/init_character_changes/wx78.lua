-----------------------------------------------------------------
-- WX damage changes during wet
-----------------------------------------------------------------
--GLOBAL.TUNING.WX78_MIN_MOISTURE_DAMAGE= -.1 * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE, --Not even used in the code by Klei
GLOBAL.TUNING.WX78_MAX_MOISTURE_DAMAGE = (-0.5) * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE
GLOBAL.TUNING.WX78_MOISTURE_DRYING_DAMAGE = (-0.3) * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE

--TODO, reimplement dorainsparks to do based on wetness from min to max damage
    --add rate too
	
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onupdate(inst, dt)
    inst.charge_time = inst.charge_time - dt
    if inst.charge_time <= 0 then
        inst.charge_time = 0
        if inst.charged_task ~= nil then
            inst.charged_task:Cancel()
            inst.charged_task = nil
        end
        inst.SoundEmitter:KillSound("overcharge_sound")
        inst:RemoveTag("overcharge")
        inst.Light:Enable(false)
        inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED 
        inst.components.bloomer:PopBloom("overcharge")
        inst.components.temperature.mintemp = -20
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_DISCHARGE"))
    else
        local runspeed_bonus = .5
        local rad = 3
        if inst.charge_time < 60 then
            rad = math.max(.1, rad * (inst.charge_time / 60))
            runspeed_bonus = (inst.charge_time / 60)*runspeed_bonus
        end

        inst.Light:Enable(true)
        inst.Light:SetRadius(rad)
        --V2C: setting .runspeed does not stack with mount speed
        inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*(1+runspeed_bonus)
        inst.components.temperature.mintemp = 10
    end

end

local function startovercharge(inst, duration)
    inst.charge_time = duration

    inst:AddTag("overcharge")
    inst:PushEvent("ms_overcharge")

    inst.SoundEmitter:KillSound("overcharge_sound")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/charged", "overcharge_sound")
    inst.components.bloomer:PushBloom("overcharge", "shaders/anim.ksh", 50)

    if inst.charged_task == nil then
        inst.charged_task = inst:DoPeriodicTask(1, onupdate, nil, 1)
        onupdate(inst, 0)
    end
end

local function onlightingstrike(inst)
    if inst.components.health ~= nil and not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
        if inst.components.inventory:IsInsulated() then
            inst:PushEvent("lightningdamageavoided")
        else
            --inst.components.health:DoDelta(TUNING.HEALING_SUPERHUGE, false, "lightning")
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE"))

            startovercharge(inst, CalcDiminishingReturns(inst.charge_time, TUNING.TOTAL_DAY_TIME))
        end
    end
end

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

local function onlessercharge(inst)
    if inst.components.inventory:IsInsulated() then
        inst:PushEvent("lightningdamageavoided")
    else
        inst.components.sanity:DoDelta(-10)
        inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE"))
		if inst.charge_time < TUNING.TOTAL_DAY_TIME/2 then
			startovercharge(inst, CalcDiminishingReturns(inst.charge_time, TUNING.TOTAL_DAY_TIME/8))
		end
    end
end

local function dowetsparks(inst, dt)
    if inst.components.moisture ~= nil and inst.components.moisture:GetMoisture() > 0 then
        local t = GetTime()

        -- Raining, no moisture-giving equipment on head, and moisture is increasing. Pro-rate damage based on waterproofness.
        if inst.components.inventory:GetEquippedMoistureRate(EQUIPSLOTS.HEAD) <= 0 and inst.components.moisture:GetRate() > 0 then
            local waterproofmult =
                (   inst.components.sheltered ~= nil and
                    inst.components.sheltered.sheltered and
                    inst.components.sheltered.waterproofness or 0
                ) +
                (   inst.components.inventory ~= nil and
                    inst.components.inventory:GetWaterproofness() or 0
                )
            if waterproofmult < 1 and t > inst.wet_spark_time + inst.wet_spark_time_offset + waterproofmult * 7 then
                inst.components.health:DoDelta(TUNING.WX78_MAX_MOISTURE_DAMAGE, false, "water")
                inst.wet_spark_time_offset = 3 + math.random() * 2
                inst.wet_spark_time = t
                local x, y, z = inst.Transform:GetWorldPosition()
                SpawnPrefab("sparks").Transform:SetPosition(x, y + 1 + math.random() * 1.5, z)
            end
        elseif t > inst.wet_spark_time + inst.wet_spark_time_offset then -- We have moisture-giving equipment on our head or it is not raining and we are just passively wet (but drying off). Do full damage.
            inst.components.health:DoDelta(
                inst.components.moisture:GetRate() >= 0 and
                TUNING.WX78_MAX_MOISTURE_DAMAGE or
                TUNING.WX78_MOISTURE_DRYING_DAMAGE,
                false, "water")
            inst.wet_spark_time_offset = 3 + math.random() * 2
            inst.wet_spark_time = t
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("sparks").Transform:SetPosition(x, y + .25 + math.random() * 2, z)
        end
    end
	
end

local function OnMoistureDelta(inst)

	if inst.spark_task ~= nil then
		inst.spark_task:Cancel()
    end
		
    if inst.components.moisture ~= nil and inst.components.moisture:GetMoisturePercent() > 0 then
        if inst.wet_task == nil then
            inst.wet_task = inst:DoPeriodicTask(.1, dowetsparks, nil, .1)
        end
    elseif inst.wet_task ~= nil then
        inst.wet_task:Cancel()
        inst.wet_task = nil
    end
end


local function OnEat_Electric(inst, data)
    if data.food ~= nil then
		if data.food.prefab == "goatmilk" or data.food.prefab == "zaspberry" then
			inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE"))
			SpawnPrefab("electricchargedfx"):SetTarget(inst)
            inst.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)
			
			if inst.components.upgrademoduleowner ~= nil then
				inst.components.upgrademoduleowner:AddCharge(1)
			else
				startovercharge(inst, CalcDiminishingReturns(inst.charge_time, TUNING.TOTAL_DAY_TIME / 6))
			end
		elseif data.food.prefab == "zaspberryparfait" or 
		data.food.prefab == "voltgoatjelly" or
		data.food.prefab == "voltgoatjelly_spice_chili" or
		data.food.prefab == "voltgoatjelly_spice_garlic" or
		data.food.prefab == "voltgoatjelly_spice_salt" or
		data.food.prefab == "voltgoatjelly_spice_sugar" then
			inst.components.talker:Say(GetString(inst, "ANNOUNCE_CHARGE"))
			SpawnPrefab("electricchargedfx"):SetTarget(inst)
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
			
			if inst.components.upgrademoduleowner ~= nil then
				inst.components.upgrademoduleowner:AddCharge(1)
			else
				startovercharge(inst, CalcDiminishingReturns(inst.charge_time, TUNING.TOTAL_DAY_TIME / 4))
			end
		end
    end
end
if TUNING.DSTU.WX78_CONFIG then
    env.AddPrefabPostInit("wx78", function(inst)
	    if not TheWorld.ismastersim then
		    return
	    end

        inst.wet_task = nil
        inst.wet_spark_time = 0
        inst.wet_spark_time_offset = 3
	    inst:AddTag("automaton")
		
	    inst.OnLesserCharge = onlessercharge
		
		if inst.components.upgrademoduleowner ~= nil then
			if inst.components.playerlightningtarget ~= nil then
				inst.components.playerlightningtarget:SetOnStrikeFn(OnLightningStrike)
			end
		else
			inst:ListenForEvent("moisturedelta", OnMoistureDelta)
			
			if inst.components.playerlightningtarget ~= nil then
				inst.components.playerlightningtarget:SetOnStrikeFn(onlightingstrike)
			end
		end
		
        inst:ListenForEvent("oneat", OnEat_Electric)
    end)
end
