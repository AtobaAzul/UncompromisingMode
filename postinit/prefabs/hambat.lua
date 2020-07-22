local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------------------------------------------------------------------------

local function UpdateDamage(inst)
    if inst.components.perishable and inst.components.weapon then
        local dmg = TUNING.HAMBAT_DAMAGE * inst.components.perishable:GetPercent()
        dmg = Remap(dmg, 0, TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_MIN_DAMAGE_MODIFIER/2*TUNING.HAMBAT_DAMAGE, TUNING.HAMBAT_DAMAGE)
        inst.components.weapon:SetDamage(dmg)
    end
end

env.AddPrefabPostInit("hambat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.HORRIBLE
    inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	
	if inst.components.perishable ~= nil then
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	end
	
	if inst.components.weapon ~= nil then
		inst.components.weapon:SetOnAttack(UpdateDamage)
	end
	
end)