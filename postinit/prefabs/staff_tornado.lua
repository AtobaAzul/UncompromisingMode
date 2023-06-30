local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("tornado", function(inst)
	inst:AddTag("um_tornado_redirector")

	if not TheWorld.ismastersim then
		return
	end
end)

env.AddPrefabPostInit("staff_tornado", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.spellcaster ~= nil then
		inst.components.spellcaster.canonlyuseonlocomotors = true
	end
end)