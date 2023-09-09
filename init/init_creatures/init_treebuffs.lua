-------------------------------------------------------------------------------------------------------------------------------------
-- Add root attack to Totally Normal Trees when chopped (similar to deciduous poison birchnut root)
-- Prefabs: deciduous_root, livingtree
-- Art: tree_leaf_spike, tree_leaf_spike_lt
-------------------------------------------------------------------------------------------------------------------------------------
-- Copied from DeciduousTreeUpdater:OnUpdate in deciduoustreeupdater.lua
local function spawn_root_attack(inst, chopper)
	if chopper ~= nil then
		local root = GLOBAL.SpawnPrefab("deciduous_root")
		local x, y, z = chopper.Transform:GetWorldPosition()
		local mx, my, mz = inst.Transform:GetWorldPosition()
		local mdistsq = inst:GetDistanceSqToInst(chopper)
		local possition_variance_x = (GLOBAL.math.random() - 0.5) * TUNING.DECID_MONSTER_ROOT_ATTACK_RADIUS
		local possition_variance_z = (GLOBAL.math.random() - 0.5) * TUNING.DECID_MONSTER_ROOT_ATTACK_RADIUS
		local rootpos = GLOBAL.Vector3(mx + possition_variance_x, 0, mz + possition_variance_z)
		local angle = inst:GetAngleToPoint(rootpos) * GLOBAL.DEGREES

		-- TODO: Make spawn faster, to make the attack harder

		root.AnimState:SetBuild("tree_leaf_spike_lt")
		root.Transform:SetPosition(x + 1.75 * math.cos(angle), 0, z - 1.75 * math.sin(angle))
		root:PushEvent("givetarget", {target = chopper, targetpos = rootpos, targetangle = angle, owner = inst})
	end
end

local function livingtree_postinit(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	local _onworked = inst.components.workable.onwork

	local function OnWorked(inst, chopper, workleft)
		if chopper ~= nil and not chopper:HasTag("playerghost") then
			spawn_root_attack(inst, chopper)
			if _onworked then
				_onworked(inst,chopper,workleft)
			end
		end
	end
	-- Change the onworked callback to the above
	if inst.components.workable ~= nil then
		inst.components.workable:SetOnWorkCallback(OnWorked)
	end
end

AddPrefabPostInit("livingtree", livingtree_postinit)
AddPrefabPostInit("livingjungletree", livingtree_postinit)
AddPrefabPostInit("livingtree_halloween", livingtree_postinit)
