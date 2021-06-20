local assets =
{
    Asset("ANIM", "anim/hound_basic.zip"),
    Asset("ANIM", "anim/hound_basic_water.zip"),
    Asset("ANIM", "anim/hound.zip"),
    Asset("ANIM", "anim/hound_ocean.zip"),
    Asset("ANIM", "anim/hound_red.zip"),
    Asset("ANIM", "anim/hound_red_ocean.zip"),
    Asset("ANIM", "anim/hound_ice.zip"),
    Asset("ANIM", "anim/hound_ice_ocean.zip"),
    Asset("ANIM", "anim/hound_mutated.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeLargeBurnable(inst, 6 + math.random() * 6)
    MakeLargePropagator(inst)

    --Remove the default handlers that toggle persists flag
    inst.components.burnable:SetOnIgniteFn(nil)
    inst.components.burnable:SetOnExtinguishFn(inst.Remove)
    inst.components.burnable:Ignite()
    inst.components.burnable:SetOnBurntFn(inst.Remove)

    return inst
end

local function OnIgniteFn(inst)
	inst.SoundEmitter:KillSound("hiss")
	local firesplash = SpawnPrefab("firesplash_fx")
	firesplash.Transform:SetPosition(inst.Transform:GetWorldPosition())
	firesplash.Transform:SetScale(0.5, 0.5, 0.5)
	inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo", 0.5)
		
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 1.5, nil, { "INLIMBO", "shadow", "ghost" })

	for i, v in ipairs(ents) do
		if v ~= inst and v:IsValid() and not v:IsInLimbo() then
			--Recheck valid after work
			if v:IsValid() and not v:IsInLimbo() then
				if v.components.fueled == nil and
					v.components.burnable ~= nil and
					not v.components.burnable:IsBurning() and
					not v:HasTag("burnt") then
					v.components.burnable:Ignite()
				end
					
				if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
					local dmg = 15
					if v.components.explosiveresist ~= nil then
						dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
						v.components.explosiveresist:OnExplosiveDamage(dmg, inst)
					end
					v.components.combat:GetAttacked(inst, dmg, nil)
				end
			end
		end
	end
end

local function smallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	MakeSmallBurnable(inst, 4+ math.random()*4)
    MakeSmallPropagator(inst)

    --Remove the default handlers that toggle persists flag
    inst.components.burnable:SetOnIgniteFn(nil)
	
	if TUNING.DSTU.FIRELOOT ~= nil and TUNING.DSTU.FIRELOOT == 3 then
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
	else
		inst.components.burnable:SetOnIgniteFn(nil)
	end
	
    inst.components.burnable:SetOnExtinguishFn(inst.Remove)
    inst.components.burnable:Ignite()
    inst.components.burnable:SetOnBurntFn(inst.Remove)

    return inst
end

local function magmafn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    MakeSmallBurnable(inst, 1)
    MakeSmallPropagator(inst)

    --Remove the default handlers that toggle persists flag
    inst.components.burnable:SetOnIgniteFn(nil)
    inst.components.burnable:SetOnExtinguishFn(inst.Remove)
    inst.components.burnable:Ignite()
    inst.components.burnable:SetOnBurntFn(inst.Remove)

	inst:DoTaskInTime(1+math.random(), function(inst) inst.components.burnable:Extinguish() end)

    return inst
end

return Prefab("firedrop", fn, assets),
		Prefab("fireloot", smallfn, assets),
		Prefab("magmafire", magmafn, assets)
		