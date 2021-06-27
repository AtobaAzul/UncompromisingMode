local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
		print(inst.sanityreward)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil and v.components.sanity:IsInsane() then
				v.components.sanity:DoDelta(inst.sanityreward / 2 or TUNING.SANITY_SMALL / 2)
			end
		end
    end
	
	return inst.Oldonkilledbyother(inst, attacker)
end

env.AddPrefabPostInit("terrorbeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
	end
	
    --inst.sanityreward = TUNING.SANITY_LARGE * 0.8
	
	if inst.components.combat ~= nil then
        inst.Oldonkilledbyother = inst.components.combat.onkilledbyother
		inst.components.combat.onkilledbyother = onkilledbyother
	end
end)

env.AddPrefabPostInit("nightmarebeak", function(inst)
	inst:AddTag("terrorbeak")

	if not TheWorld.ismastersim then
		return
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
	
    --inst.sanityreward = TUNING.SANITY_SMALL
	
	if inst.components.combat ~= nil then
        inst.Oldonkilledbyother = inst.components.combat.onkilledbyother
		inst.components.combat.onkilledbyother = onkilledbyother
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