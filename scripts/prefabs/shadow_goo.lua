
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
	local goo
	if inst.prefab == "shadow_goo" then -- A special different ground anim for our fancy goo
		goo = SpawnPrefab("shadow_puff")
	elseif inst.organ then
		goo = SpawnPrefab("minotaur_organ")
	else
		goo = SpawnPrefab("guardian_splat")
		if inst.tentacle then
			local tent = SpawnPrefab("bigshadowtentacle")
			tent.Transform:SetPosition(x,0,z)
			tent:PushEvent("arrive")
			goo:DoTaskInTime(0,function(goo) goo:ListenForEvent("animover",function(goo) goo:Remove() end) end)
		end
	end
	goo.Transform:SetPosition(x, 0, z)
end

local function doprojectilehit(inst, other)
	DoSplatFx(inst)
    local caster = (inst._caster ~= nil and inst._caster:IsValid()) and inst._caster or nil
	local x,y,z = inst.Transform:GetWorldPosition()
	local others = TheSim:FindEntities(x,y,z,1.5,{ "_combat", "player" }, { "INLIMBO", "shadow","minotaur" }) --I messed around with the funni goo, its range is actually a bit small, so I bumped it up a tad.
	for i,other in ipairs(others) do
		if other ~= nil and other ~= caster and other.components.combat ~= nil  then
			if inst.prefab == "shadow_goo" then
				if other.components.sanity ~= nil and other.components.health ~= nil and not other.components.health:IsDead() and other.components.sanity:IsInsane() and other.components.inkable and not other:HasTag("shadowdominant") then
					other.components.inkable:Ink()
					other.components.combat:GetAttacked(caster, TUNING.WARG_GOO_DAMAGE/2)
				elseif other.components.sanity ~= nil and not other:HasTag("shadowdominant") then
					other.components.sanity:DoDelta(-5)
				end
			end
			if inst.prefab == "guardian_goo" and other.components.combat then --Guardian goo does the effect even if the player isn't insane, and does meaningful damage.
				if other.components.inkable then
					other.components.inkable:Ink()
				end
				other.components.combat:GetAttacked(caster, 50)
				if other.components.sanity then
					other.components.sanity:DoDelta(-5)
				end
			end
		end
	end
    inst:Remove()
end

local function TestProjectileLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.05 then
		doprojectilehit(inst)
		inst:Remove()
	end
end

local function oncollide(inst, other)
	if other ~= nil and other:IsValid() and other:HasTag("_combat") and not other:HasTag("shadow") and not other:HasTag("minotaur") then
		doprojectilehit(inst, other)
	end
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function mainprojectilefn(anim)
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
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetBank(anim)
	inst.AnimState:SetBuild(anim)
	inst.AnimState:PushAnimation("spin_loop", true)
	inst.AnimState:SetMultColour(0, 0, 0, 0.4)		
    inst.Physics:SetCollisionCallback(oncollide)

    inst.persists = false
    inst:AddComponent("locomotor")

	inst:DoPeriodicTask(0, TestProjectileLand)

    return inst
end

local function shadow_goofn(inst)
	return mainprojectilefn("warg_gingerbread_bomb")
end

local function guardian_goo()
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
	inst.AnimState:SetBank("squid_watershoot")
	inst.AnimState:SetBuild("squid_watershoot")
	inst.AnimState:PlayAnimation("spin_loop",true)
    inst:AddComponent("locomotor")
	inst.AnimState:SetMultColour(1, 1, 1, .5)
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(40)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(doprojectilehit)
	inst.tentacle = false
	inst.organ = false
	inst:Hide()
	inst:DoTaskInTime(0.2,function(inst) inst:Show() end)	
	
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)

    return inst
end

local function guardiansplat()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
	inst:AddTag("FX")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst.AnimState:SetMultColour(1, 1, 1, .5)
	inst.Transform:SetScale(0.7,0.7,0.7)
	inst.AnimState:SetBank("guardian_splat")
	inst.AnimState:SetBuild("guardian_splat")
	inst.AnimState:PlayAnimation("land")
	inst.AnimState:PushAnimation("go away",false) --crap, forgot the "_" will fix later :sleep:
	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
	
	inst:ListenForEvent("animqueueover",function(inst) inst:Remove() end)
    return inst
end
return Prefab("shadow_goo", shadow_goofn, projectile_assets, projectile_prefabs),
Prefab("guardian_goo", guardian_goo),
Prefab("guardian_splat", guardiansplat)
