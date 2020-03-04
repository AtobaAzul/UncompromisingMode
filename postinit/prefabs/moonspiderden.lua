local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function fucko()
print("asdadssada")
end
env.AddPrefabPostInit("moonspiderden", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst:DoTaskInTime(1, fucko)
	inst:AddTag("moonspiderden")

end)
