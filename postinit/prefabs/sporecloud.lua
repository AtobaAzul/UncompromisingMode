local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local AURA_EXCLUDE_TAGS_NEW = { "toadstool", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible", "toadling", "has_gasmask" }

env.AddPrefabPostInit("sporecloud", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.aura ~= nil then
		inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS_NEW
	end

end)
