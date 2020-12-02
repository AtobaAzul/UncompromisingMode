local assets =
{
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip"),
}

local easing = require("easing")

local function LaunchProjectile(inst, value)
	for i = 1, 4 do
		local theta = math.random() * 2 * PI
		local r = inst:GetPhysicsRadius(0) + 0.25 + math.sqrt(math.random()) * TUNING.WARG_GINGERBREAD_GOO_DIST_VAR
		local x, y, z = inst.Transform:GetWorldPosition()
		local dest_x, dest_z = math.cos(theta) * r + x, math.sin(theta) * r + z

		local goo = SpawnPrefab("amulet_health_orb_projectile")
		goo.Transform:SetPosition(x, y, z)
		goo.Transform:SetRotation(theta / DEGREES)
		goo._caster = inst
		goo.healthvalue = value / 4

		Launch2(goo, inst, 4, 1, 4, 1)
	end
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function onequip_blue(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "redamulet")

    inst.orbfn = function(attacked, data)
        if data and data.attacker and data.damage then
			if inst._cdtask == nil and data ~= nil then
				inst._cdtask = inst:DoTaskInTime(1, OnCooldown)
				
				inst.healthvalue = data.damage
				inst.components.finiteuses:Use(1)
				print(inst.healthvalue)
				
				LaunchProjectile(owner, data.damage)
			end
        end 
    end

    inst:ListenForEvent("attacked", inst.orbfn, owner)

end

local function onunequip_blue(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    inst:RemoveEventCallback("attacked", inst.orbfn, owner)
end

local function ancient_red_amulet_fn(anim, tag, should_sink)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulets")
    inst.AnimState:SetBuild("amulets")
    inst.AnimState:PlayAnimation("redamulet")

    inst:AddTag("resurrector")

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("inventoryitem")
	
    inst.components.equippable:SetOnEquip(onequip_blue)
    inst.components.equippable:SetOnUnequip(onunequip_blue)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(TUNING.REDAMULET_USES)
    inst.components.finiteuses:SetUses(TUNING.REDAMULET_USES)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)

    return inst
end

return Prefab("ancient_amulet_red", ancient_red_amulet_fn, assets)
