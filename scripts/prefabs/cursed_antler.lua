local assets =
{
    Asset("ANIM", "anim/cursed_antler.zip"),
    Asset("ANIM", "anim/swap_cursed_antler.zip"),
}

local function charged(inst)
	local fx = SpawnPrefab("dr_warm_loop_1")
	
	local owner = inst.components.inventoryitem.owner
	
	if inst.components.equippable:IsEquipped() and owner ~= nil then
		fx.entity:SetParent(owner.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -275, 0)
		fx.Transform:SetScale(1.33, 1.33, 1.33)
	else
		fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 2.35, 0)
		fx.Transform:SetScale(1.33, 1.33, 1.33)
	end
end

local function OnCharged(inst)
  local fx = SpawnPrefab("dr_warm_loop_1")
  
  local owner = inst.components.inventoryitem.owner
  
  if inst.components.equippable:IsEquipped() and owner ~= nil then
    fx.entity:SetParent(owner.entity)
    fx.entity:AddFollower()
    fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -275, 0)
    fx.Transform:SetScale(1.33, 1.33, 1.33)
  else
    fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 2.35, 0)
    fx.Transform:SetScale(1.33, 1.33, 1.33)
  end
      inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/charge")
      inst.SoundEmitter:PlaySound("dontstarve/creatures/deerclops/taunt_howl", nil, .4)    
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

end

local function onequip(inst, owner)
	if not owner:HasTag("vetcurse") then
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if tool ~= nil and owner ~= nil then
				owner.components.inventory:Unequip(EQUIPSLOTS.HANDS)
				owner.components.inventory:DropItem(tool)
				owner.components.inventory:GiveItem(inst)
				owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
				
				if owner.sg ~= nil then
					owner.sg:GoToState("hit")
				end
			end
		end)
	else
		if inst.skinname ~= nil then
			owner.AnimState:OverrideSymbol("swap_object", "swap_twisted_antler", "swap_twisted_antler")
		else

			owner.AnimState:OverrideSymbol("swap_object", "swap_cursed_antler", "swap_cursed_antler")
		end
		
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
    end

end


local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and attacker:HasTag("vetcurse") and inst.components.rechargeable:IsCharged() then
		local x1, y1, z1 = inst.Transform:GetWorldPosition()
		
		local owner = inst.components.inventoryitem.owner

		for i, v in pairs(TheSim:FindEntities(x1, y1, z1, 3, { "cursedantler" })) do
			if v ~= inst then
				local vowner = v.components.inventoryitem.owner
				if vowner ~= nil then
					if vowner == owner or vowner.components.inventoryitem ~= nil and vowner.components.inventoryitem.owner ~= nil and vowner.components.inventoryitem.owner == owner then
						v.components.rechargeable:Discharge(5)
						

					end
				end
			end
		end
		
		inst.components.rechargeable:Discharge(5)        
	
		local x, y, z = target.Transform:GetWorldPosition()
		for i = 1, 4 do
			local icefx = SpawnPrefab("icespike_fx_"..i)
			icefx.Transform:SetPosition(x + math.random(-1.5, 1.5), 0, z + math.random(-1.5, 1.5))
		end

		if target.components.freezable ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
			target.components.freezable:AddColdness(1)
            target.components.freezable:SpawnShatterFX()
        end
		
		if target.components.health ~= nil and not target.components.health:IsDead() and target.components.combat ~= nil then
			--target.components.health:DoDelta(-66 * 200, false, attacker, false, attacker)
			target.components.combat:GetAttacked(attacker, 66, nil)
		end
		
		local ents = TheSim:FindEntities(x, y, z, 2.5, nil, { "INLIMBO", "player", "companion" })
		for i, v in ipairs(ents) do
			if v ~= inst and v ~= target and v:IsValid() and not v:IsInLimbo() then
				if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
					v.components.combat:GetAttacked(attacker, 34, nil)
						
					if v.components.freezable ~= nil and target.components.health ~= nil and not v.components.health:IsDead() and not v.components.freezable:IsFrozen() then
						v.components.freezable:AddColdness(0.5)
						v.components.freezable:SpawnShatterFX()
					end
				end
			end
		end

    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cursed_antler")
    inst.AnimState:SetBuild("cursed_antler")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("cursedantler")

    MakeInventoryFloatable(inst, "med", 0.2, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetOnAttack(onattack)
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cursed_antler.xml"

    inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
    inst:AddComponent("rechargeable")
    inst.components.rechargeable:SetOnChargedFn(OnCharged)

    MakeHauntableLaunch(inst)

    return inst
end

local function antler_skin()
	local inst = fn()
	
    inst.AnimState:SetBank("twisted_antler")
    inst.AnimState:SetBuild("twisted_antler")
	
	inst.skinname = "twisted_antler"
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/twisted_antler.xml"
	end

	return inst
end

return Prefab("cursed_antler", fn, assets),
	CreateModPrefabSkin("twisted_antler",
	{
		assets = {
			Asset("ANIM", "anim/twisted_antler.zip"),
		},
		base_prefab = "cursed_antler",
		fn = antler_skin, -- This is our constructor!
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "twisted_antler",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})