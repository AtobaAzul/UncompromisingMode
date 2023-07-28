local env = env
GLOBAL.setfenv(1, GLOBAL)


env.AddPrefabPostInit("shadow_knight", function(inst)
	if not TheWorld.ismastersim then
        return
    end
	local function OnHitOther(inst, other)
		if inst.sg.currentstate.name ~= "pound" then
			if other:HasTag("creatureknockbackable") then
				other:PushEvent("knockback", {knocker = inst, radius = 75, strengthmult = inst.level/2})
			else
				if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and 
				--Don't knockback if you wear marble
				(other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
					other:PushEvent("knockback", {knocker = inst, radius = 75, strengthmult = inst.level/2})
				end
			end
		end
	end
	
	
	if inst.components.combat ~= nil then
		inst.components.combat.onhitotherfn = OnHitOther
	end
end)