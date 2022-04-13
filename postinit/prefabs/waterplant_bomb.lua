local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddPrefabPostInit("waterplant_bomb", function(inst)
	local NO_TAGS_PVP =     { "INLIMBO", "ghost", "playerghost", "FX", "NOCLICK", "DECOR", "notarget", "companion", "shadowminion" }
	
	local BOMB_MUSTHAVE_TAGS = { "_combat" }
	local function do_bomb_noleak(inst, thrower, target, no_hit_tags, damage, break_boats)
		local bx, by, bz = inst.Transform:GetWorldPosition()

		-- Find anything nearby that we might want to interact with
		local entities = TheSim:FindEntities(bx, by, bz, TUNING.WATERPLANT.ATTACK_AOE * 1.5, BOMB_MUSTHAVE_TAGS, no_hit_tags)

		-- If we have a thrower with a combat component, we need to do some manipulation to become a proper combat target.
		if thrower ~= nil and thrower.components.combat ~= nil and thrower:IsValid() then
			thrower.components.combat.ignorehitrange = true
		else
			thrower = nil
		end

		local hit_a_target = false
		for i, v in ipairs(entities) do
			if v:IsValid() and v.entity:IsVisible() and inst.components.combat:CanTarget(v) then
				hit_a_target = true

				if thrower ~= nil and v.components.combat.target == nil then
					v.components.combat:GetAttacked(thrower, damage, inst)
				else
					inst.components.combat:DoAttack(v)
				end

				if not v.components.health:IsDead() and v:HasTag("stunnedbybomb") then
					v:PushEvent("stunbomb")
				end
			end
		end

		if thrower ~= nil then
			thrower.components.combat.ignorehitrange = false
		end
	end
	
	local function new_on_inventory_hit(inst, attacker, target)
		if TheNet:GetPVPEnabled() then
			local x, y, z = inst.Transform:GetWorldPosition()

			if not TheWorld.Map:IsPassableAtPoint(x, y, z) then
				SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
			end

			SpawnPrefab("waterplant_burr_burst").Transform:SetPosition(x, y, z)
		
			do_bomb_noleak(inst, attacker, target, NO_TAGS_PVP, TUNING.WATERPLANT.ITEM_DAMAGE)
			
			inst:Remove()
		else
			return inst._Oldon_inventory_hit(inst, attacker, target)
		end
	end

	if inst.components.complexprojectile ~= nil then
		inst._Oldon_inventory_hit = inst.components.complexprojectile.onhitfn
		inst.components.complexprojectile:SetOnHit(new_on_inventory_hit)
	end
end)