local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("terrorbeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(3,4)
	end
end)

env.AddPrefabPostInit("nightmarebeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(3,4)
	end
end)

local easing = require("easing")

local function LaunchProjectile(inst)
	local theta = math.random() * 2 * PI
	local r = inst:GetPhysicsRadius(0) + 0.50 + math.sqrt(math.random()) * TUNING.WARG_GINGERBREAD_GOO_DIST_VAR
	local x, y, z = inst.Transform:GetWorldPosition()
	local dest_x, dest_z = math.cos(theta) * r + x, math.sin(theta) * r + z

	local goo = SpawnPrefab("shadow_goo")
    goo.Transform:SetPosition(x, y, z)
	goo.Transform:SetRotation(theta / DEGREES)
	goo._caster = inst

	Launch2(goo, inst, 1.5, 1, 3, .75)
end


env.AddPrefabPostInit("crawlinghorror", function(inst)
	inst:AddTag("crawlinghorror")

	if not TheWorld.ismastersim then
		return
	end
	
    inst.LaunchProjectile = LaunchProjectile
end)

env.AddPrefabPostInit("crawlingnightmare", function(inst)
	inst:AddTag("crawlinghorror")

	if not TheWorld.ismastersim then
		return
	end
	
    inst.LaunchProjectile = LaunchProjectile
end)