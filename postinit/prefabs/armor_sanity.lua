local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnTakeDamage(inst, damage_amount)
    local owner = inst.components.inventoryitem.owner
    if owner then
        local health = owner.components.health
        if health and not owner.components.health:IsDead() then
            local unsaneness = damage_amount * 0.05

	
            health:DoDelta(-unsaneness, false, "darkness")
			local sanity = owner.components.sanity
			if sanity then
            local unsaneness = damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY
            sanity:DoDelta(-unsaneness, false)
			end
        end
    end
end
env.AddPrefabPostInit("armor_sanity", function(inst)
	if not TheWorld.ismastersim then
		return
	end

if inst.components.armor ~= nil then
inst.components.armor:InitCondition(TUNING.ARMOR_SANITY, 1)
inst.components.armor.ontakedamage = OnTakeDamage
end
end)