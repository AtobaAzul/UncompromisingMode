local env = env
GLOBAL.setfenv(1, GLOBAL)

--------------------------------------------------------------------------
-- OnParry
--------------------------------------------------------------------------

local function OnParry(inst, doer, attacker, damage)
    doer:ShakeCamera(CAMERASHAKE.SIDE, 0.1, 0.03, 0.3)

    if inst.components.rechargeable:GetPercent() < TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION then
        inst.components.rechargeable:SetPercent(TUNING.WATHGRITHR_SHIELD_COOLDOWN_ONPARRY_REDUCTION)
    end

    if doer.components.skilltreeupdater ~= nil and doer.components.skilltreeupdater:IsActivated("wathgrithr_arsenal_shield_3") then
        inst._lastparrytime = GetTime()

        local tuning = TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE
        local scale =  TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_BONUS_DAMAGE_SCALE

		
        inst._bonusdamage = math.clamp(damage * scale, tuning.min, tuning.max)
    end

	-- Parries lose durability
	
	local parryMult = 1
	local skill_level = 2 -- If the rework is disabled it will always use the max value, as it's otherwise unusable

	if env.GetModConfigData("wathgrithr_rework") == 1 then 
		skill_level = doer.components.skilltreeupdater:CountSkillTag("parryefficiency") -- Parryefficiency doesn't exist without the tree
	end
		
	if skill_level > 0 then 
		parryMult = TUNING.DSTU.WATHGRITHR_SHIELD_BASE_PARRY_EFFICIENCY - (TUNING.DSTU.WATHGRITHR_SHIELD_UPGRADE_PARRY_EFFICIENCY * skill_level)
	else
		parryMult = TUNING.DSTU.WATHGRITHR_SHIELD_BASE_PARRY_EFFICIENCY
	end

	--Temporary Fix
	-- For some reason durability loss is being applied twice, so the 0.5 negates that
	local damageFix = 0.5

	inst.components.armor:TakeDamage(damage*parryMult*damageFix)
end

--------------------------------------------------------------------------
-- OnAttackFn
--------------------------------------------------------------------------

local function OnAttackFn(inst, attacker, target)
    inst._lastparrytime = nil
    inst._bonusdamage = nil

    inst.components.armor:TakeDamage(TUNING.WATHGRITHR_SHIELD_USEDAMAGE * TUNING.DSTU.WATHGRITHR_SHIELD_DURABILITY_MULT)
end

env.AddPrefabPostInit("wathgrithr_shield", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.components.armor:InitCondition(TUNING.WATHGRITHR_SHIELD_ARMOR * TUNING.DSTU.WATHGRITHR_SHIELD_DURABILITY_MULT, TUNING.WATHGRITHR_SHIELD_ABSORPTION)

	inst.components.parryweapon:SetOnParryFn(OnParry)

	inst.components.weapon:SetOnAttack(OnAttackFn)
end)