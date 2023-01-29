local env = env
GLOBAL.setfenv(1, GLOBAL)
---------------------------------------
local function Enrage2(inst, warning)
	if inst.components.health ~= nil then
		inst.components.health:SetPercent(1, 0.5, "enrage")
	end

	return inst._OldEnrage(inst, warning)
end

local function CheckForKrampSack(inst)
	if inst:IsUnchained() and inst.enraged then
		inst.components.lootdropper:AddChanceLoot("krampus_sack", 1)
	end
	if TUNING.DSTU.VETCURSE ~= "off" then
		inst.components.vetcurselootdropper.loot = "klaus_amulet"
	end
end

env.AddPrefabPostInit("klaus", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst._OldEnrage = inst.Enrage
	inst.Enrage = Enrage2
	
    if TUNING.DSTU.VETCURSE ~= "off" then
		inst:AddComponent("vetcurselootdropper")
	end
	
	inst:ListenForEvent("death", CheckForKrampSack)
--return inst
end)