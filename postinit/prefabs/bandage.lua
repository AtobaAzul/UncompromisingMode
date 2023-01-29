local env = env
GLOBAL.setfenv(1, GLOBAL)

local function OnUse(inst, target)
	if target.components.debuffable ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
		target.configheal = 10
		target.components.debuffable:AddDebuff("confighealbuff", "confighealbuff")
	end
end


env.AddPrefabPostInit("bandage", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.components.healer.onhealfn = OnUse
end)
