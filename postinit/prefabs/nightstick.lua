local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function Strike(owner)
local fx = SpawnPrefab("electrichitsparks")
	
	if owner ~= nil then
		fx.entity:SetParent(owner.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -145, 0)
		--fx.Transform:SetScale(.66, .66, .66)
	end
end

local function onremovefire(fire)
    fire.nightstick.fire = nil
end

local function onequip(inst, owner)
    inst.components.burnable:Ignite()
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightstick", "swap_nightstick")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/morningstar", "torch")
    --inst.SoundEmitter:SetParameter("torch", "intensity", 1)

    if inst.fire == nil then
        inst.fire = SpawnPrefab("nightstickfire")
        inst.fire.nightstick = inst
        inst:ListenForEvent("onremove", onremovefire, inst.fire)
    end
    inst.fire.entity:SetParent(owner.entity)
	
	owner:AddTag("lightningrod")
	owner.lightningpriority = 0
	owner:ListenForEvent("lightningstrike", Strike, owner)
end

local function onunequip(inst, owner)
    if inst.fire ~= nil then
        inst.fire:Remove()
    end

    inst.components.burnable:Extinguish()
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")
	
	owner:RemoveTag("lightningrod")
	owner.lightningpriority = nil
	owner:ListenForEvent("lightningstrike", nil)
end

local function ontakefuel(inst)
    if not inst.SoundEmitter:PlayingSound("loop") then
		inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
    end
end
    

env.AddPrefabPostInit("nightstick", function(inst)
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.fueled ~= nil then
    inst.components.fueled:SetTakeFuelFn(ontakefuel)
		inst.components.fueled.fueltype = FUELTYPE.BATTERYPOWER
		inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
		inst.components.fueled.accepting = true
	end

	if inst.components.equippable ~= nil then
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
	end

end)
