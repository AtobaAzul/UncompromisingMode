local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local health = owner.components.health
        if health and not owner.components.health:IsDead() then
			local sanity = owner.components.sanity
			if sanity then
            local unsaneness = damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY
			if owner:HasTag("Funny_Words_Magic_Man") then
			unsaneness = unsaneness/2 -- Cutting it by this much because of the fact that you're giving up your headslot, which is usually VERY important for using night armor so you can extend its small durability.
			end
            sanity:DoDelta(-unsaneness, false)
			end
        end
    end
end
local function CalcDapperness(inst, owner)
if owner:HasTag("Funny_Words_Magic_Man") then
    return TUNING.CRAZINESS_SMALL/2 -- This ends up being about -5/min + 3.3/min from the hat itself, willing to cut it more for this one
else
	return TUNING.CRAZINESS_SMALL
end
end
env.AddPrefabPostInit("armor_sanity", function(inst)
	if not TheWorld.ismastersim then
		return
	end

if inst.components.armor ~= nil then
inst.components.armor.ontakedamage = OnTakeDamage
end
if inst.components.equippable ~= nil then
inst.components.equippable.dapperfn = CalcDapperness
end
end)