local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function onlightningground(inst)
	local percent = inst.components.fueled:GetPercent()
	local refuelnumber = 0
	if percent + 0.33 > 1 then
		refuelnumber = 1
	else
		refuelnumber = percent + 0.33
	end
	inst.components.fueled:SetPercent(refuelnumber)
end

local function Strike(owner)
local fx = SpawnPrefab("electrichitsparks")
--onlightningground(inst)	
	if owner ~= nil then
		fx.entity:SetParent(owner.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
		--fx.Transform:SetScale(.66, .66, .66)
	end
end

local function onremovefire(fire)
    fire.nightstick._fire = nil
end

local function turnon(inst)
    if not inst.components.fueled:IsEmpty() then
		inst.components.weapon:SetElectric()
		inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
        inst.components.fueled:StartConsuming()

        local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
		
		if owner ~= nil then
			if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
			owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
			end
		end
		
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")
		
        if inst._fire == nil and not inst.components.fueled:IsEmpty() then
			inst._fire = SpawnPrefab("nightstickfire")
			inst._fire.nightstick = inst
			inst:ListenForEvent("onremove", onremovefire, inst._fire)
		end
		inst._fire.entity:SetParent(owner.entity)
    end
end

local function turnoff(inst)

    inst.components.weapon:RemoveElectric()
	
	local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
	if owner ~= nil then
		if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
			owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick_off", "swap_nightstick_off")
		end
	end
	
    inst.SoundEmitter:KillSound("torch")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
	
    if inst._fire ~= nil then
        if inst._fire:IsValid() then
			inst._fire:Remove()
        end
    end
end

local function ontakefuel(inst, owner)
    if inst.components.equippable:IsEquipped() then
		inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
        turnon(inst)
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
        inst.components.inventoryitem.owner:PushEvent("torchranout", data)
    else
        turnoff(inst)
    end
end 

local function onequip(inst, owner)
    inst.components.burnable:Ignite()
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    --inst.SoundEmitter:SetParameter("torch", "intensity", 1)

	if inst.components.fueled:IsEmpty() then
		owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick_off", "swap_nightstick_off")
    else
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")
		owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
        turnon(inst)
    end
	
	owner:AddTag("lightningrod")
	owner.lightningpriority = 0
	owner:ListenForEvent("lightningstrike", Strike, owner)
end

local function onunequip(inst, owner)
    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")

    turnoff(inst)
	
	owner:RemoveTag("lightningrod")
	owner.lightningpriority = nil
	owner:ListenForEvent("lightningstrike", nil)
	
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_TORCH_OUT",
                }
                turnoff(inst)
                owner:PushEvent("itemranout", data)
                return
            end
        end
        turnoff(inst)
    end
end

local function onattack(inst, attacker, target)
    if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() and inst.components.weapon.stimuli == "electric" then
        SpawnPrefab("electrichitsparks"):AlignToTarget(target, attacker, true)
    end
end

local function setcharged(inst, charges)
    if not inst.charged then
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.Light:Enable(true)
        inst:WatchWorldState("cycles", ondaycomplete)
        inst.charged = true
    end
    inst.chargeleft = math.max(inst.chargeleft or 0, charges)
    dozap(inst)
end

env.AddPrefabPostInit("nightstick", function(inst)
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetSectionCallback(onfuelchange)
		--inst.components.fueled.maxfuel = TUNING.NIGHTSTICK_FUEL / 2
		--inst.components.fueled:InitializeFuelLevel(TUNING.NIGHTSTICK_FUEL / 2)
		inst.components.fueled.rate = 2
		--inst.components.fueled:InitializeFuelLevel(TUNING.LANTERN_LIGHTTIME / 1.25)
		--inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION * 2, TUNING.TURNON_FULL_FUELED_CONSUMPTION * 2)

		inst.components.fueled:SetDepletedFn(nofuel)
		inst.components.fueled:SetTakeFuelFn(ontakefuel)
		inst.components.fueled.fueltype = FUELTYPE.BATTERYPOWER
		--inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
		if TUNING.DSTU.ELECTRICALMISHAP == false then
			inst.components.fueled.accepting = true
		else
			inst.components.fueled.rate = 1
			inst:AddTag("lightningrod")
			inst:ListenForEvent("lightningstrike", onlightningground)
		end
	end

	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
	end
	
	if inst.components.weapon ~= nil then
		inst.components.weapon:RemoveElectric()
		inst.components.weapon:SetOnAttack(onattack)
	end
	
end)
