local env = env
GLOBAL.setfenv(1, GLOBAL)

--Night Armor is handled in its own postinit, since we had to add the hitstun effect too.

--Dark Sword
local function CalcDappernessNightSword(inst, owner)
if owner:HasTag("Funny_Words_Magic_Man") then
    return TUNING.CRAZINESS_MED/4 -- This ends up being about -5/min + 3.3/min from the hat itself instead of -20/min + 3.3/min
else
	return TUNING.CRAZINESS_MED
end
end
env.AddPrefabPostInit("nightsword", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
if inst.components.equippable ~= nil then
inst.components.equippable.dapperfn = CalcDappernessNightSword
end
--return inst
end)

--Fire Staff
env.AddPrefabPostInit("firestaff", function(inst)
	if not TheWorld.ismastersim then
		return
	end
local _redonattack = inst.components.weapon.onattack	

local function RedOnAttack(inst, attacker, target, skipsanity)
if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil and attacker:HasTag("Funny_Words_Magic_Man") then	
attacker.components.sanity:DoDelta(TUNING.SANITY_SUPERTINY)	--Counter the sanity drain					
end
_redonattack(inst, attacker, target, skipsanity)
end
inst.components.weapon:SetOnAttack(RedOnAttack)

end)

--Ice Staff
env.AddPrefabPostInit("icestaff", function(inst)
	if not TheWorld.ismastersim then
		return
	end
local _blueonattack = inst.components.weapon.onattack	

local function BlueOnAttack(inst, attacker, target, skipsanity)
if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil and attacker:HasTag("Funny_Words_Magic_Man") then	
attacker.components.sanity:DoDelta(TUNING.SANITY_SUPERTINY)	--Counter the sanity drain					
end
_blueonattack(inst, attacker, target, skipsanity)
end
inst.components.weapon:SetOnAttack(BlueOnAttack)

end)

--Tele Staff
env.AddPrefabPostInit("telestaff", function(inst)
	if not TheWorld.ismastersim then
		return
	end
local _teleport_func = inst.components.spellcaster.spell	

local function TeleFunction(inst, target)
_teleport_func(inst,target)

local caster = inst.components.inventoryitem.owner or target
if target == nil then
target = caster
end

if caster.components.sanity ~= nil and caster:HasTag("Funny_Words_Magic_Man") then
caster.components.sanity:DoDelta(TUNING.SANITY_HUGE/2) --Cut the sanity loss in half
end

end
inst.components.spellcaster:SetSpellFn(TeleFunction)

end)


--Bat Bat
env.AddPrefabPostInit("batbat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
local _onattack = inst.components.weapon.onattack

local function OnAttackBatBat(inst, owner, target)
_onattack(inst, owner, target)
if owner.components.sanity ~= nil and owner:HasTag("Funny_Words_Magic_Man") and owner.components.health:GetPercent() < 1 then
owner.components.sanity:DoDelta(0.25 * TUNING.BATBAT_DRAIN)
end
end

inst.components.weapon.onattack = OnAttackBatBat

end)