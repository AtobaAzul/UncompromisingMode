local assets=
{
	Asset("ANIM", "anim/lava_vomit.zip"),
}

local AURA_EXCLUDE_TAGS = { "player", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible" }

local function OnLoad(inst, data)
	inst:Remove()
end

local function GetStatus(inst, viewer)
    if inst.cooled then return "COOL" end
    return "HOT"
end

local INTENSITY = .8

local function fade_in(inst)
    inst.components.fader:StopAll()
    inst.Light:Enable(true)
    inst.components.fader:Fade(0, INTENSITY, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end)
end

local function fade_out(inst)
    inst.components.fader:StopAll()
    inst.components.fader:Fade(INTENSITY, 0, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end, function() inst.Light:Enable(false) end)
end

local function TrySlowdown(inst, target)
	local debuffkey = inst.prefab
		
	if target._lavavomit_speedmulttask ~= nil then
		target._lavavomit_speedmulttask:Cancel()
	end
	target._lavavomit_speedmulttask = target:DoTaskInTime(0.6, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._lavavomit_speedmulttask = nil end)

	target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, 0.3)
	
	if inst.components.propagator ~= nil and target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
		target.components.health:DoDelta(-2)
		if inst.lobber ~= nil then
			target.components.combat:SuggestTarget(inst.lobber)
		end
		SpawnPrefab("halloween_firepuff_1").Transform:SetPosition(target.Transform:GetWorldPosition())
	end
end

local function DoAreaSlow(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, AURA_EXCLUDE_TAGS)
    for i, v in ipairs(ents) do
		if v.components ~= nil and v.components.locomotor ~= nil then
			TrySlowdown(inst, v)
		end
    end
end

local function fn(Sim)--Sim
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lava_vomit")
    inst.AnimState:SetBuild("lava_vomit")
    inst.Transform:SetFourFaced()

    -- inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    -- inst.AnimState:SetLayer( LAYER_BACKGROUND )
    -- inst.AnimState:SetSortOrder( 3 )
    
    inst:AddComponent("fader")
    local light = inst.entity:AddLight()
    light:SetFalloff(.5)
    light:SetIntensity(INTENSITY)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(200/255, 100/255, 170/255)
    fade_in(inst)
	
    inst.AnimState:PlayAnimation("dump")
    inst.AnimState:PushAnimation("idle_loop")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst.Transform:SetScale(1.1, 1.1, 1.1)
	
    inst.entity:SetPristine()
	--[[]]
    if not TheWorld.ismastersim then
        return inst
    end

    MakeLargePropagator(inst)
    inst.components.propagator.heatoutput = 24
    inst.components.propagator.decayrate = 0
    inst.components.propagator:Flash()
    inst.components.propagator:StartSpreading()
	
	inst.coolingtime = 5
		
    inst.cooltask = inst:DoTaskInTime(inst.coolingtime, function(inst) 
    	inst.AnimState:PushAnimation("cool", false)
    	fade_out(inst)
        inst:DoTaskInTime(4*FRAMES, function(inst)
            inst.AnimState:ClearBloomEffectHandle()
        end)
    end)
	
     inst.cooltask2 = inst:DoTaskInTime(inst.coolingtime, function(inst)
   		inst.AnimState:SetPercent("cool", 1)
        if inst.components.propagator then 
            inst.components.propagator:StopSpreading()
            inst:RemoveComponent("propagator") 
        end
        inst.cooled = true
		
		if not inst.components.colortweener then
			inst:AddComponent("colourtweener")
		end
		
		inst.cooltask3 = inst:DoTaskInTime(4, function(inst)
			inst:RemoveComponent("unevenground")
			inst._spoiltask = nil
		end)
		
		
        inst.components.colourtweener:StartTween({0,0,0,0}, 7, function(inst) inst:Remove() end)
    end)
	
    --[[inst:ListenForEvent("animqueueover", function(inst)
   		inst.AnimState:SetPercent("cool", 1)
        if inst.components.propagator then 
            inst.components.propagator:StopSpreading()
            inst:RemoveComponent("propagator") 
        end
        inst.cooled = true
        inst:AddComponent("colourtweener")
        inst.components.colourtweener:StartTween({0,0,0,0}, 7, function(inst) inst:Remove() end)
    end)]]
      
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
	
    inst.slowed_objects = {}
	
    inst:AddComponent("unevenground")
    inst.components.unevenground.radius = 2
	
    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 0.6
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)

    inst._spoiltask = inst:DoPeriodicTask(inst.components.aura.tickperiod, DoAreaSlow, inst.components.aura.tickperiod * .5)

    inst.cooled = false

    inst.OnLoad = OnLoad

    return inst
end

local function slobberfn()
    local inst = fn()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.lobber = nil
	
	inst.coolingtime = 8

    return inst
end

local function OnHitInk(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()
	local lavaspit = SpawnPrefab("lavaspit_slobber")
	lavaspit.Transform:SetPosition(x, 0, z)
	lavaspit.lobber = inst.lobber
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y <= inst:GetPhysicsRadius() + 0.001 then
		OnHitInk(inst, other)
	end
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:SetBank("lava_spitball")
    inst.AnimState:SetBuild("lava_spitball")
    inst.AnimState:PlayAnimation("spin_loop", true)

	inst.Transform:SetScale(1.1, 1.1, 1.1)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:SetCapsule(0.02, 0.02)
	
    inst.Physics:SetCollisionCallback(oncollide)
end

local function projectilefn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, 1 )

    inst.AnimState:SetBank("lava_spitball")
    inst.AnimState:SetBuild("lava_spitball")
    inst.AnimState:PlayAnimation("spin_loop")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.lobber = nil

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-20)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitInk)
    inst.components.complexprojectile.usehigharc = false

    inst.persists = false

    inst:AddComponent("locomotor")

	--inst:DoTaskInTime(0.1, function(inst) inst:DoPeriodicTask(0, TestProjectileLand) end)

    return inst
end

local function projectiletargetfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

return Prefab( "lavaspit", fn, assets),
		Prefab( "lavaspit_slobber", slobberfn, assets),
		Prefab("lavaspit_projectile", projectilefn),
		Prefab("lavaspit_target", projectiletargetfn)