local assets =
{
    Asset("ANIM", "anim/snowball.zip"),
}

local prefabs =
{
    "splash_snow_fx",
}

local function OnHitFire(inst, attacker, target)
    SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	if math.random() > 0.5 then
		SpawnPrefab("magmafire").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 3, nil, { "shadow", "hound", "houndfriend", "INLIMBO" })
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v ~= inst and v:IsValid() and not v:IsInLimbo() then
				if v:IsValid() and not v:IsInLimbo() then
					if v.components.fueled == nil and
						v.components.burnable ~= nil and
						not v.components.burnable:IsBurning() and
						not v:HasTag("burnt") then
						v.components.burnable:Ignite(nil, attacker)
					end
				end
			end
		end
	end
	
	if inst.dragonflyspit then
		local spittle = SpawnPrefab("lavaspit")
		spittle.Transform:SetPosition(x, y, z)
		spittle.dragonflyspit = true
	end
	
    inst:Remove()
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("projectile")
	inst:AddTag("weapon")
	
	MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitFire)
	
    MakeSmallBurnable(inst, 6 + math.random() * 6)
    MakeSmallPropagator(inst)

    --Remove the default handlers that toggle persists flag
    inst.components.burnable:SetOnIgniteFn(nil)
    inst.components.burnable:SetOnExtinguishFn(inst.Remove)
    inst.components.burnable:Ignite()
    inst.components.burnable:SetOnBurntFn(inst.Remove)
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)

    return inst
end

return Prefab("fireball_throwable", fn, assets, prefabs)
