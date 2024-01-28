local assets =
{
	Asset("ANIM", "anim/bugzapper.zip"),
	Asset("ANIM", "anim/swap_bugzapper.zip"),
	Asset("SOUND", "sound/wilson.fsb"),
	Asset("INV_IMAGE", "lantern_lit"),
}

local function spark(inst)
	local fx = SpawnPrefab("electrichitsparks")

	local owner = inst.components.inventoryitem.owner

	if inst.components.equippable:IsEquipped() and owner ~= nil then
		fx.entity:SetParent(owner.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
		fx.Transform:SetScale(.66, .66, .66)
		if math.random() >= (inst.overcharged and 0 or 0.15) then
			inst.sparktask = inst:DoTaskInTime(math.random() * 0.5, spark)
		else
			inst.sparktask = inst:DoTaskInTime(math.random() + 5, spark)
		end
	else
		fx.entity:SetParent(inst.entity)
		--fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx.Transform:SetPosition(0, 1, 0)
		fx.Transform:SetScale(.66, .66, .66)
		--fx.Follower:FollowSymbol(inst.GUID, inst, 0, -150, 0)
		if math.random()  <= (inst.overcharged and 0 or 0.15) then
			inst.sparktask = inst:DoTaskInTime(math.random() * 0.5, spark)
		else
			inst.sparktask = inst:DoTaskInTime(math.random() + 5, spark)
		end
	end
end

local function turnon(inst)
	if not inst.components.fueled:IsEmpty() then
		inst.components.fueled:StartConsuming()

		inst.components.weapon:SetElectric()
		inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")

		if inst.sparktask == nil then
			inst.sparktask = inst:DoTaskInTime(math.random() + 3, spark)
		end
	end
end

local function turnoff(inst)
	if inst.components.fueled ~= nil then
		inst.components.weapon:RemoveElectric()
		inst.components.fueled:StopConsuming()
	end
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")

	if inst.sparktask ~= nil then
		inst.sparktask:Cancel()
	end
	inst.sparktask = nil
end

local function OnRemove(inst)
	if inst._light ~= nil then
		inst._light:Remove()
	end
	if inst._soundtask ~= nil then
		inst._soundtask:Cancel()
	end
end

local function ondropped(inst)
	if inst.sparktask ~= nil then
		inst.sparktask:Cancel()
	end

	turnoff(inst)
end

local function onremovefire(fire)
	fire.nightstick.fire = nil
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_bugzapper", "swap_bugzapper")

	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")

	if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
		turnon(inst)
	end
	owner:AddTag("batteryuser") -- from batteryuser component
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")

	if inst.sparktask ~= nil then
		inst.sparktask:Cancel()
	end
	inst.sparktask = nil

	if not owner.UM_isBatteryUser then
		local item = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		if item ~= nil then
			if not item:HasTag("electricaltool") and owner:HasTag("batteryuser") then
				owner:RemoveTag("batteryuser")
			end
		else
			if owner:HasTag("batteryuser") then
				owner:RemoveTag("batteryuser")
			end
		end
	end
end

local function nofuel(inst)
	if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
		local data =
		{
			prefab = inst.prefab,
			equipslot = inst.components.equippable.equipslot,
		}
		turnoff(inst)
	else
		turnoff(inst)
	end
end

local function ontakefuel(inst, owner)
	if inst.components.equippable:IsEquipped() then
		inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
		turnon(inst)
	end
end

--------------------------------------------------------------------------

local function onattack(inst, attacker, target)
	if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and
		not inst.components.fueled:IsEmpty() then
		if target:HasTag("insect") then
			if not target.components.health:IsDead() then
				target.components.combat:GetAttacked(attacker, 30, nil)
				--target.components.health:DoDelta(-30, false, attacker)
			end

			SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker, true)

			local x, y, z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 3.5, nil, { "INLIMBO", "player", "abigail" },
				{ "insect", "spider", "hoodedwidow" })

			for i, v in ipairs(ents) do
				if v ~= inst and v ~= target and v:IsValid() and not v:IsInLimbo() then
					if (v.components.health ~= nil and not v.components.health:IsDead()) and not v.sg:HasStateTag("noattack") then
						if not inst.overcharged then
							--v.components.health:DoDelta( -10, false, attacker, false, attacker)
							v.components.combat:GetAttacked(attacker, 5, nil)
						else
							v.components.combat:GetAttacked(attacker, 25, nil)
						end
						SpawnPrefab("electrichitsparks"):AlignToTarget(v, attacker, true)
					end
				end
			end

			return
		end

		if (target:HasTag("spider") or target:HasTag("hoodedwidow")) then
			if not target.components.health:IsDead() then
				target.components.combat:GetAttacked(attacker, 15, nil)
			end

			SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker, true)

			local x, y, z = target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 3.5, nil, { "INLIMBO", "player", "abigail" },
				{ "insect", "spider", "hoodedwidow" })

			for i, v in ipairs(ents) do
				if v ~= inst and v ~= target and v:IsValid() and not v:IsInLimbo() then
					if (v.components.health ~= nil and not v.components.health:IsDead()) and v.components.combat ~= nil and not v.sg:HasStateTag("noattack") then
						if not inst.overcharged then
							--v.components.health:DoDelta( -10, false, attacker, false, attacker)
							v.components.combat:GetAttacked(attacker, 5, nil)
						else
							v.components.combat:GetAttacked(attacker, 25, nil)
						end
						SpawnPrefab("electrichitsparks"):AlignToTarget(v, attacker, true)
					end
				end
			end

			return
		end
	end
end

local function OnOvercharge(inst, toggle)
	inst.overcharged = toggle
	inst.components.fueled.rate = toggle and 4 or 2
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("bugzapper")
	inst.AnimState:SetBuild("bugzapper")
	inst.AnimState:PlayAnimation("idle_off")

	inst:AddTag("light")
	inst:AddTag("electricaltool")
	inst:AddTag("overchargeable")

	MakeInventoryFloatable(inst, "med", 0.2, 0.65)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	--[[
	inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil]]
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(25)
	inst.components.weapon:SetOnAttack(onattack)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bugzapper.xml"

	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

	inst:AddComponent("equippable")

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.BATTERYPOWER
	inst.components.fueled.accepting = true

	--inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	--inst.components.fueled:InitializeFuelLevel(120)
	--inst.components.fueled.maxfuel = TUNING.NIGHTSTICK_FUEL / 2
	inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTSTICK_FUEL)
	inst.components.fueled.rate = 2
	inst.components.fueled:SetDepletedFn(nofuel)
	inst.components.fueled:SetTakeFuelFn(ontakefuel)
	inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

	inst._onownerequip = function(owner, data)
		if data.item ~= inst and
			(data.eslot == EQUIPSLOTS.HANDS or
			(data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
			) then
			turnoff(inst)
		end
	end

	inst._light = nil

	MakeHauntableLaunch(inst)

	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	inst.OnRemoveEntity = OnRemove

	inst:ListenForEvent("overcharged", OnOvercharge)

	inst.OnSave = function(inst, data)
		if data ~= nil then
			data.actual_fuel = inst.components.fueled:GetPercent()
		end
	end

	inst.OnLoad = function(inst, data)
		if data ~= nil and data.actual_fuel ~= nil then
			inst:DoTaskInTime(0, function() inst.components.fueled:SetPercent(data.actual_fuel) end)
		end
	end


	return inst
end

return Prefab("bugzapper", fn, assets)
