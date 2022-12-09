local env = env
GLOBAL.setfenv(1, GLOBAL)

local function NoFirePanic(self)
	table.remove(self.bt.root.children, 1)
end

env.AddBrainPostInit("spiderqueenbrain", NoFirePanic)


local function RemoveFireDamage(inst)
	if inst.components.health ~= nil then
		inst.components.health.vulnerabletoheatdamage = false
	end
end

env.AddPrefabPostInit("bishop", RemoveFireDamage)
env.AddPrefabPostInit("rook", RemoveFireDamage)
env.AddPrefabPostInit("knight", RemoveFireDamage)