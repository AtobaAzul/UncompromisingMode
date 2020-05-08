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


env.AddPrefabPostInit("wx78", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.playerlightningtarget ~= nil then
		inst.components.playerlightningtarget:SetOnStrikeFn(onlightingstrike)
	end
end)