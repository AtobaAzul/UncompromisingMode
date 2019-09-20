
AddPrefabPostInit("bearger", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 125})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

AddPrefabPostInit("dragonfly", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 75})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

AddPrefabPostInit("leif", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 75})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

AddPrefabPostInit("minotaur", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 200})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

AddPrefabPostInit("rook", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 150})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)

-- Starting from 100, you can run away from getting kicked in a loop, so 150 is a safety.
AddPrefabPostInit("krampus", function (inst)
	local function OnHitOther(inst, other)
		if other ~= nil then
			other:PushEvent("knockback", {knocker = inst, radius = 150})
		end
	end
	
	inst.components.combat.onhitotherfn = OnHitOther
end)