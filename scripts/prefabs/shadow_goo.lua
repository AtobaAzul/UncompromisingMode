
local projectile_assets =
{
    Asset("ANIM", "anim/warg_gingerbread_bomb.zip"),
    Asset("ANIM", "anim/goo_icing.zip"),
}

local projectile_prefabs =
{
    "icing_splat_fx",
    "icing_splash_fx_full",
    "icing_splash_fx_med",
    "icing_splash_fx_low",
    "icing_splash_fx_melted",
}

local splashfxlist =
{
    "icing_splash_fx_full",
    "icing_splash_fx_med",
    "icing_splash_fx_low",
    "icing_splash_fx_melted",
}

local function DoSplatFx(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local goo = SpawnPrefab("shadow_puff")
	goo.Transform:SetPosition(x, 0, z)
end

local function doprojectilehit(inst, other)
    local caster = (inst._caster ~= nil and inst._caster:IsValid()) and inst._caster or nil

	local other = other or FindEntity(inst, TUNING.WARG_GOO_RADIUS, nil, { "_combat"  }, { "INLIMBO", "fire", "burnt", "gingerbread" })
	if other ~= nil and other ~= caster and other.components.combat ~= nil  then
        if other.components.sanity ~= nil and (other.components.health == nil or not other.components.health:IsDead()) and other.components.sanity:IsInsane() and other.components.inkable then
			DoSplatFx(other.components.pinnable.stuck and inst or other)
            other.components.inkable:Ink()
			other.components.combat:GetAttacked(caster, TUNING.WARG_GOO_DAMAGE/2)
		elseif other.components.inkable then
            other.components.inkable:Ink()
			DoSplatFx(inst)
        end
	else
		DoSplatFx(inst)
	end

    inst:Remove()
end
--[[
local function doprojectilehit(inst)
    SpawnPrefab("ink_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    if inst:IsOnOcean() then
        SpawnPrefab("ink_puddle_water").Transform:SetPosition(inst.Transform:GetWorldPosition())
    else
        SpawnPrefab("ink_puddle_land").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 1)
    for i,ent in ipairs(ents) do
        if ent.components.inkable then
            ent.components.inkable:Ink()
        end
    end

    inst:Remove()
end
--]]
local function TestProjectileLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.05 then
		doprojectilehit(inst)
		inst:Remove()
	end
end

local function oncollide(inst, other)
    -- If there is a physics collision, try to do some damage to that thing.
    -- This is so you can't hide forever behind walls etc.

	if other ~= nil and other:IsValid() and other:HasTag("_combat") and not other:HasTag("gingerbread") then
		doprojectilehit(inst, other)
	end
end

local function projectilefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(10)
	inst.Physics:SetFriction(.1)
	inst.Physics:SetDamping(0)
	inst.Physics:SetRestitution(.5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetSphere(0.25)

    inst.AnimState:SetBank("warg_gingerbread_bomb")
    inst.AnimState:SetBuild("warg_gingerbread_bomb")
    inst.AnimState:PlayAnimation("spin_loop", true)
	
	inst.AnimState:SetMultColour(0, 0, 0, 0.4)
	
    --inst:AddComponent("transparentonsanity")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.Physics:SetCollisionCallback(oncollide)

    inst.persists = false

    inst:AddComponent("locomotor")

	inst:DoPeriodicTask(0, TestProjectileLand)

    return inst
end

return Prefab("shadow_goo", projectilefn, projectile_assets, projectile_prefabs)
