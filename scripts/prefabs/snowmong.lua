require "stategraphs/SGsnowmong"
local easing = require("easing")
local brain = require "brains/snowmongbrain"

local assets =
{
	Asset("ANIM", "anim/snowmong.zip"),
}

SetSharedLootTable( 'snowmong',
{
    {'charcoal',            1.00},
	{'charcoal',            1.00},
	{'charcoal',            1.00},
	{'charcoal',            1.00},
    {'ice',  			 	1.00},
	{'ice',  			 	1.00},
	{'ice',  			 	1.00},
    {'iceboomerang',      	0.25},
	{'snowball_throwable',  1.00},
	{'snowball_throwable',  2.00},
	
})

SetSharedLootTable( 'snowmong_melting',
{
    {'charcoal',            1.00},
	{'charcoal',            1.00},
    {'ice',  			 	1.00},
	{'snowball_throwable',  1.00},
	
})

local SEE_VICTIM_DIST = 25

local function SetUnder(inst)
	inst.State = true
	inst:AddTag("notdrawable")
	inst:AddTag("INLIMBO")
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)
end

local function SetAbove(inst)
	inst.State = false
	inst:RemoveTag("INLIMBO")
	inst:RemoveTag("notdrawable")
	ChangeToCharacterPhysics(inst)
end

local function CanBeAttacked(inst, attacker)
	return inst.State == false
end

local function Retarget(inst)
    local targetDist = 30
    local notags = {"FX", "NOCLICK","INLIMBO", "playerghost", "shadowcreature","webbedcreature","wall","structure","companion","snowish"}
    return FindEntity(inst, targetDist, function(guy) return inst.components.combat:CanTarget(guy) and not guy.components.health:IsDead() end, nil, notags)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnSleep(inst)
    inst.SoundEmitter:KillAllSounds()
end

local function OnRemove(inst)
    inst.SoundEmitter:KillAllSounds()
end

local function SnowballBelch(inst, target)
	if target ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("snowball_throwable")
		projectile.Transform:SetPosition(x, y, z)
		local a, b, c = target.Transform:GetWorldPosition()
		local targetpos = target:GetPosition()
		targetpos.x = targetpos.x + math.random(-3,3)
		targetpos.z = targetpos.z + math.random(-3,3)
		local dx = a - x
		local dz = c - z
		local rangesq = dx * dx + dz * dz
		local maxrange = 15
		local bigNum = 10
		local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
		projectile:AddTag("canthit")
		projectile.components.complexprojectile:SetHorizontalSpeed(speed+math.random(4,9))
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end

local function DoSnowballBelch(inst)
	local maxsnow =  math.floor(math.random(8,12))
	for k = 1, maxsnow do
	   if inst.components.combat.target ~= nil then
		   local target = inst.components.combat.target
		   inst:DoTaskInTime(FRAMES+math.random()*0.1, SnowballBelch, target)
	   end
	end
end

local function melting(inst)
	if not TheWorld.state.iswinter then
		if not inst.components.health:IsDead() then
			inst.components.lootdropper:SetChanceLootTable('snowmong_melting')
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
			SpawnPrefab("washashore_puddle_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.components.health:DoDelta(-50)
		end
	else
		inst.components.lootdropper:SetChanceLootTable('snowmong')
	end
end

local function OnAttacked(inst, data)
	if data.attacker and data.attacker:IsValid() and data.attacker.components.health and not data.attacker.components.health:IsDead() then
        inst.components.combat:SetTarget(data.attacker)
    end
end

local function SetTier(inst,tier)
	if tier == 1 then

	end
	if tier == 2 then
	
	end
	if tier == 3 then
	
	end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.Transform:SetFourFaced()

	inst.Transform:SetScale(3, 3, 3)

	MakeCharacterPhysics(inst, 99999, 0.5)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.isunder = nil 
        return inst
    end

	inst.AnimState:SetBank("snowmong")
	inst.AnimState:SetBuild("snowmong")

	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("snowish")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 2

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(350)
	inst.components.health.murdersound = "dontstarve/rabbit/scream_short"
	inst.components.health.fire_damage_scale = 0

	inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('snowmong')

	inst:AddComponent("knownlocations")
	inst:DoTaskInTime(0, function() inst.components.knownlocations:RememberLocation("home", Point(inst.Transform:GetWorldPosition()), true) end)

    inst:AddComponent("groundpounder")
  	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 1
	inst.components.groundpounder.destructionRings = 0
	inst.components.groundpounder.numRings = 1

	inst.CanGroundPound = true

    inst:AddComponent("hauntable")
		
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(51)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRange(3, 3)
	inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat.canbeattackedfn = CanBeAttacked

	inst:SetStateGraph("SGsnowmong")
	inst:SetBrain(brain)
	inst.data = {}
	
	inst.seasontask = inst:DoPeriodicTask(3, melting)

	inst.attackUponSurfacing = false
	
	inst.DoSnowballBelch = DoSnowballBelch
	inst.OnEntitySleep = OnSleep
    inst.OnRemoveEntity = OnRemove
    inst:ListenForEvent("enterlimbo", OnRemove)
	
	SetUnder(inst)
	
    inst.SetUnder = SetUnder
	inst.SetAbove = SetAbove
	
	inst.SetTier = SetTier
    
	inst:ListenForEvent("attacked", OnAttacked) 

	return inst
end

return Prefab("snowmong", fn, assets)