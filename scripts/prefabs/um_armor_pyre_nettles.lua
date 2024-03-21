local prefabs = {
	"um_armor_pyre_nettles_fx",
	"umdebuff_pyre_toxin"
}


local DebuffDuration = 6 -- Length of Pyre Toxin on struck target; 6 is the debuff's default.
local DebuffDurationBonus = 10
local DebuffDurationWearer = 3


local function OnBlocked(owner, data, inst)
	owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
	
	if data ~= nil and data.attacker ~= nil
	and not data.redirected
	and not data.attacker:HasTag("thorny")
	and not data.attacker:HasTag("HASHEATER") -- Prevents any damage to the armor from nearby fires and lava.
	then
		if owner:IsValid()
		and not owner:HasTag("INLIMBO")
		and not owner:HasTag("noattack")
		then
			owner:AddDebuff("umdebuff_pyre_toxin_armor_wearer", "umdebuff_pyre_toxin", DebuffDurationWearer)
		end
		
		if data.attacker:IsValid()
		and not data.attacker:HasTag("INLIMBO")
		and not data.attacker:HasTag("noattack")
		and (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil))
		then
			data.attacker:AddDebuff("umdebuff_pyre_toxin_armor", "umdebuff_pyre_toxin", DebuffDuration)
			
			if owner:HasTag("pyromaniac") then
				data.attacker:DoTaskInTime(FRAMES * 1, function()
					data.attacker:AddDebuff("umdebuff_pyre_toxin_armor_bonus", "umdebuff_pyre_toxin", DebuffDurationBonus) -- Willow applies the debuff a second time.
				end)
			end
		end
		
		if data.stimuli ~= "fire" or (data.weapon ~= nil and data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli ~= "fire") then
			if data.damage ~= nil then
				local armorperish = data.damage * 0.001 -- 1% of the blocked attack's damage...
				inst.components.perishable:ReducePercent(armorperish) -- ...becomes the percentage that we 'spoil' the armor when hit.
			else
				inst.components.perishable:ReducePercent(0.01) -- If no damage info is available, still remove 1% durability to prevent cheese.
			end
		end
	end
end

-- For Wormwood's Bramble Husk skill.
-- Every few attacks, Wormwood applies a special stack of Pyre Toxin, able to continuously stack.
local function OnAttackOther(owner, data, inst)
	if checknumber(inst._hitcount) then
		inst._hitcount = inst._hitcount + 1

		if inst._hitcount >= TUNING.WORMWOOD_ARMOR_BRAMBLE_RELEASE_SPIKES_HITCOUNT then
			if data ~= nil and data.target ~= nil
			and data.target:IsValid()
			and not data.target:HasTag("INLIMBO")
			and not data.target:HasTag("noattack")
			then
				data.target:AddDebuff("umdebuff_pyre_toxin_armor_bonus_"..math.random(100), "umdebuff_pyre_toxin", DebuffDuration)
			end
		end
	end
end


local function bumpcheck(owner, inst)
	local bumpradius = 2
	local x, y, z = owner.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, bumpradius, nil, { "PyreToxinImmune", "companion", "FX", "INLIMBO", "invisible", "notarget", "noattack", "player", "playerghost" }, { "_combat", "_health" })
	
	if #ents > 0 then
		for i, v in pairs(ents) do
			if v ~= nil and v:IsValid() then
				v:AddDebuff("umdebuff_pyre_toxin_armor", "umdebuff_pyre_toxin", DebuffDuration)
				
				if owner:HasTag("pyromaniac") then
					v:DoTaskInTime(FRAMES * 3, function()
						v:AddDebuff("umdebuff_pyre_toxin_armor_bonus", "umdebuff_pyre_toxin", DebuffDurationBonus) -- Willow applies the debuff a second time.
					end)
				end
			end
		end
	end
	
	if TheNet:GetPVPEnabled() then
		local ents = TheSim:FindEntities(x, y, z, bumpradius, { "player" } , { "PyreToxinImmune", "plantkin", "INLIMBO", "noattack", "spawnprotection", "playerghost" })
		
		if #ents > 0 then
			for i, v in pairs(ents) do
				if v ~= nil and v:IsValid() then
					v.AddDebuff("umdebuff_pyre_toxin_armor", "umdebuff_pyre_toxin", DebuffDuration)
					
					if owner:HasTag("pyromaniac") then
						v:DoTaskInTime(FRAMES * 3, function()
							v:AddDebuff("umdebuff_pyre_toxin_armor_bonus", "umdebuff_pyre_toxin", DebuffDurationBonus) -- Willow applies the debuff a second time.
						end)
					end
				end
			end
		end
	end
end


local function OnEquip(inst, owner)
	owner:AddTag("PyreToxinImmune")
	owner:AddTag("SmolderSporeAvoid")
	owner:AddTag("MagmaCaveFriend")
	
	owner.AnimState:OverrideSymbol("swap_body", "um_armor_pyre_nettles", "swap_body") -- Check what this even does in this case...
	if inst.fx ~= nil then
		inst.fx:Remove()
	end
	inst.fx = SpawnPrefab("um_armor_pyre_nettles_fx")
	inst.fx:AttachToOwner(owner)
	
	inst:ListenForEvent("blocked", inst._onblocked, owner)
	inst:ListenForEvent("attacked", inst._onblocked, owner)
	
	-- Add fire protection.
	if owner.components.health ~= nil then
		owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 0.33) -- Fire does 1/3 damage.
	end
	
	-- Activate area debuff.
	inst.bump_task = inst:DoPeriodicTask((FRAMES * 3), inst._bumpcheck, FRAMES * 1, owner)
	
	-- Debuff wearer when equipped.
	if owner:IsValid()
	and not owner:HasTag("INLIMBO")
	and not owner:HasTag("noattack")
	then
		owner:AddDebuff("umdebuff_pyre_toxin_armor_wearer", "umdebuff_pyre_toxin", DebuffDurationWearer)
		inst.components.perishable:ReducePercent(0.05)
	end
	
	-- Wormwood's Bramble Husk skill also works on this armor.
	inst._hitcount = 0
	if owner.components.skilltreeupdater ~= nil and owner.components.skilltreeupdater:IsActivated("wormwood_armor_bramble") then
		inst:ListenForEvent("onattackother", inst._onattackother, owner)
	end
end

local function OnUnequip(inst, owner)
	owner:RemoveTag("PyreToxinImmune")
	owner:RemoveTag("SmolderSporeAvoid")
	owner:RemoveTag("MagmaCaveFriend")
	
	owner.AnimState:ClearOverrideSymbol("swap_body") -- Check what this even does in this case...
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
	end
	
	inst:RemoveEventCallback("blocked", inst._onblocked, owner)
	inst:RemoveEventCallback("attacked", inst._onblocked, owner)
	
	-- Remove fire protection.
	if owner.components.health ~= nil then
		owner.components.health.externalfiredamagemultipliers:RemoveModifier(inst)
	end
	
	-- Remove area debuff.
	if inst.bump_task ~= nil then
		inst.bump_task:Cancel()
	end
	
	-- Remove the interraction with Wormwood's Bramble Husk skill.
	inst:RemoveEventCallback("onattackother", inst._onattackother, owner)
	inst._hitcount = nil
end


local function OnPerish(inst)
	if inst.components.inventoryitem.owner ~= nil then
		local wearer = inst.components.inventoryitem.owner
		
		wearer:PushEvent("armorbroke", { armor = inst })
		SpawnPrefab("spoiled_food").Transform:SetPosition(wearer.Transform:GetWorldPosition())
	else
		SpawnPrefab("spoiled_food").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	
	inst:Remove()
end


local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("um_armor_pyre_nettles")
	inst.AnimState:SetBuild("um_armor_pyre_nettles")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("grass") -- Changes hitsound.
	inst.foleysound = "dontstarve/movement/foley/grassarmour"
	
	local swap_data = { bank = "um_armor_pyre_nettles", anim = "anim" }
	MakeInventoryFloatable(inst, "small", 0.2, 0.80, nil, nil, swap_data)
	
	inst:AddTag("show_spoilage")
	inst:AddTag("hide_percentage")
	inst:AddTag("icebox_valid")
	
	inst:AddTag("waterproofer")
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._hitcount = nil
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("burnable")
	inst.components.burnable:AddBurnFX("character_fire", Vector3(0, 0, 0))
	inst.components.burnable:SetFXLevel(1)
	inst.components.burnable:SetBurnTime(3)
	inst.components.burnable:SetOnBurntFn(nil)
	MakeSmallPropagator(inst)
	
	inst:AddComponent("armor")
	inst.components.armor:InitIndestructible(TUNING.ARMORGRASS_ABSORPTION)
	inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME * 5)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(OnPerish)
	
	MakeHauntableLaunch(inst)
	
	inst._onblocked = function(owner, data) OnBlocked(owner, data, inst) end
	inst._bumpcheck = function(owner, data) bumpcheck(owner, inst) end
	inst._onattackother = function(owner, data) OnAttackOther(owner, data, inst) end
	
	return inst
end


-- What the hell is this, you ask?
-- The normal armor swap symbol causes positioning issues when swapping in the Pyre Mantle armor.
-- So...I just copied Void Robe's homework!
-- If there's a simpler way of solving that problem, I'm unaware of it. This seems to work well though.
-- Mara :D
----------------------
--- BEGIN ARMOR FX ---
----------------------
local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	--[[Non-networked entity]]
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("um_armor_pyre_nettles")
	inst.AnimState:SetBuild("um_armor_pyre_nettles")
	inst.AnimState:PlayAnimation("idle"..tostring(i), false)
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function fx_OnUpdate(inst)
	local moving = inst.owner:HasTag("moving")
	if moving ~= inst.wasmoving then
		inst.wasmoving = moving
		if not moving then
			for i, v in ipairs(inst.fx) do
				v.AnimState:PlayAnimation("idle"..tostring(i), false)
			end
		end
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.wasmoving = false
	inst.fx = {}
	local frame
	for i = 1, 9 do
		local fx = CreateFxFollowFrame(i)
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "swap_body", nil, nil, nil, true, nil, i - 1)
		fx.components.highlightchild:SetOwner(owner)
		table.insert(inst.fx, fx)
	end
	if owner:HasTag("locomotor") then
		inst:AddComponent("updatelooper")
		inst.components.updatelooper:AddOnUpdateFn(fx_OnUpdate)
	end
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner ~= nil then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	--Dedicated server does not need to spawn the local fx
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end


local function fxfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		
		return inst
	end
	
	inst.AttachToOwner = fx_AttachToOwner
	inst.persists = false
	
	return inst
end
--------------------
--- END ARMOR FX ---
--------------------


return Prefab("um_armor_pyre_nettles", fn, nil, prefabs),
	Prefab("um_armor_pyre_nettles_fx", fxfn)
	