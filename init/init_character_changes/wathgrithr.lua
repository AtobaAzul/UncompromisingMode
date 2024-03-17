local env = env
GLOBAL.setfenv(1, GLOBAL)

if env.GetModConfigData("wathgrithr_rework_") ~= 0 then
	env.AddPrefabPostInit("wathgrithr", function(inst)
		
		if not TheWorld.ismastersim then
			return
		end

		if inst.components.battleborn ~= nil then
			inst.components.battleborn:SetClampMin(0.33 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
			inst.components.battleborn:SetClampMax(2 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT)
			inst.components.battleborn:SetBattlebornBonus(0.25 * TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_BONUS_MULT)
		end

		if env.GetModConfigData("wathgrithr_rework_") == 1 then inst:AddComponent("efficientuser") end
	end)
end

----------------------------------------------------------------------------------------------------------------------------------------------------
--
-- TUNING
--
----------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------
-- BASE STATS
--------------------------------------------------------------------------

TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_CLAMP_MULT = 0.33 -- This has an effect on small creatures only
TUNING.DSTU.WATHGRITHR_BASE_BATTLEBORN_BONUS_MULT = 0.66 -- This affects mainly big creatures

if env.GetModConfigData("wathgrithr_rework_") == 1 then -- Enabled only
TUNING.WATHGRITHR_BASE_INSPIRATION_GAIN_MULT = 1 

--------------------------------------------------------------------------
-- SHADOW HUNTRESS
--------------------------------------------------------------------------

TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_GAIN_MULT = 0 -- How fast it goes up per hit
TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_BUFFER_MULT = 1 -- How much time out of combatbefore it starts going down
TUNING.DSTU.WATHGRITHR_SHADOW_INSPIRATION_DRAIN_MULT = 1 -- How fast it ticks down

TUNING.DSTU.WATHGRITHR_SHADOW_BATTLEBORN_CLAMP_MULT = 1 -- This has an effect on small creatures only
TUNING.DSTU.WATHGRITHR_SHADOW_BATTLEBORN_BONUS_MULT = 1 -- This affects mainly big creatures
TUNING.DSTU.WATHGRITHR_SHADOW_HUNGER_MULT = 1.2
TUNING.DSTU.WATHGRITHR_MAXHEALTH_MULT = 1.25 -- 200 * value

--------------------------------------------------------------------------
-- LUNAR MELODIST
--------------------------------------------------------------------------

TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_GAIN_MULT = 1.5
TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_BUFFER_MULT = 5
TUNING.DSTU.WATHGRITHR_LUNAR_INSPIRATION_DRAIN_MULT = 0.15

TUNING.DSTU.WATHGRITHR_LUNAR_BATTLEBORN_MULT = 0 -- Currently not in use

-- Songs
--TUNING.BATTLESONG_LUNAR_DURABILITY_ARMOR_MULT_SINGER = 0.15
TUNING.DSTU.BATTLESONG_LUNAR_DURABILITY_MULT_SINGER = 0.9 -- We are multiplying 0.75 by this number
TUNING.DSTU.BATTLESONG_LUNAR_HEALTHGAIN_MULT_SINGER = 3 -- We are multiplying 0.5 by this number 
TUNING.DSTU.BATTLESONG_LUNAR_SANITYGAIN_MULT_SINGER = 1.5 -- We are multiplying 1 by this number
TUNING.DSTU.BATTLESONG_LUNAR_SANITYAURA_MULT_SINGER = 0.7 -- We are multiplying 0.5 by this number
end


--------------------------------------------------------------------------
-- WEAPON PERKS
--------------------------------------------------------------------------

if env.GetModConfigData("wathgrithr_arsenal") then -- Only with arsenal enabled
-- Spear
TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_USES = 1 -- Base cost of lunge
TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_ONHIT_USES = 0.5 -- Durability lost per mob hit
TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_LUNGE_MAX_HITS = 8 -- After this number of hits it will no longer drain durability

TUNING.SPEAR_WATHGRITHR_LIGHTNING_USES = 250 ---150 base
TUNING.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_USES = 250 -- 200 base
TUNING.DSTU.SPEAR_WATHGRITHR_LIGHTNING_CHARGED_LIGHTNINGREPAIR = 25 -- Uses

-- Shield
TUNING.DSTU.WATHGRITHR_SHIELD_DURABILITY_MULT = 1.3
--TUNUNG.WATHGRITHR_SHIELD_DAMAGE = wilson_attack * 1.5

TUNING.DSTU.WATHGRITHR_SHIELD_BASE_PARRY_EFFICIENCY = 0.6 --Parry durability loss = Hit damage * ( BASE_PARRY_EFFICIENCY - (UPGRADE_PARRY_EFFICIENCY * skil level))
TUNING.DSTU.WATHGRITHR_SHIELD_UPGRADE_PARRY_EFFICIENCY = 0.2 -- additive per upgrade with WATHGRITHR_SHIELD_BASE_PARRY_EFFICIENCY

-- Commander Helm
TUNING.BATTLEBORN_REPAIR_EQUIPMENT_MULT = 3.5 * 0.4
end

