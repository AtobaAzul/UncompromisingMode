local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

--Behold the mind of the sleep-deprived college student! (Don't push me till we know that klei doesn't change AG and mess this up, though I did make sure to do everything as compat friendly as possible, more than any other piece of work I've done before, for sure.)
local easing = require("easing")
local UpvalueHacker = require("tools/upvaluehacker")

local function Health_And_Combat_Check(inst,percent)
	if inst.components.combat and inst.components.combat.target and inst.components.health and not inst.components.health:IsDead() and (percent == nil or (percent and inst.components.health:GetPercent() < percent)) then
		return true
	end
end

local function CheckForceJump(inst,data) -- Secondary means to force the leap if for some reason the player isn't in a position for it to happen naturally
	if data.name == "forceleapattack" and Health_And_Combat_Check(inst) then
		inst.forceleap = true
	elseif data.name == "forceleapattack" or not inst.components.timer:TimerExists("forceleapattack") then
		inst.components.timer:StartTimer("forceleapattack", math.random(30,45))
	end
	
	--This is actually the only way the belch happens
	if data.name == "forcebelch" and Health_And_Combat_Check(inst,0.6) then
		if Health_And_Combat_Check(inst,0.3) and not inst:HasTag("forcefield") then
			inst.have_a_heart = true --AG Must give some love
		end
		inst.forcebelch = true
	elseif data.name == "forcebelch" or not inst.components.timer:TimerExists("forcebelch") then
		inst.components.timer:StartTimer("forcebelch", math.random(30,45))
	end
end

local function ShootProjectile(inst)
	local target = inst.belchtarget
	if target ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local projectile = SpawnPrefab("guardian_goo")
		if inst.tentbelch then
			inst.tentbelch = false
			projectile.tentacle = true
		end
		if inst.have_a_heart then -- This one's an organ!
			projectile.AnimState:SetBank("minotaur_organ")
			projectile.AnimState:SetBuild("minotaur_organ")
			projectile.AnimState:PlayAnimation("spin_loop",true)	
			inst.have_a_heart = false
			projectile.organ = true
		end
		local targetpos = target:GetPosition()
		projectile.Transform:SetPosition(x, y, z)
		local a, b, c = target.Transform:GetWorldPosition()
		local targetpos = target:GetPosition()
		targetpos.x = targetpos.x + math.random(-4,4)
		targetpos.z = targetpos.z + math.random(-4,4)
		local dx = a - x
		local dz = c - z
		local rangesq = dx * dx + dz * dz
		local maxrange = 20
		local bigNum = 15
		local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange * 2)
		projectile:AddTag("canthit")
		projectile.components.complexprojectile:SetHorizontalSpeed(speed+math.random(4,9))
		projectile.components.complexprojectile:Launch(targetpos, inst, inst)
	end
end
	
local function DeactivateShield(inst)
	inst.have_a_heart = true
    if inst:HasTag("forcefield") then
		inst:RemoveTag("forcefield")
        if inst._fx ~= nil then
            inst._fx:kill_fx()
            inst._fx = nil
        end
    end
end

local function ActivateShield(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst:AddTag("forcefield")
		if inst._fx ~= nil then
			inst._fx:kill_fx()
		end
		inst._fx = SpawnPrefab("forcefieldfx")
		inst._fx.entity:SetParent(inst.entity)
		inst._fx.Transform:SetPosition(0, -0.2, 0)
		inst._fx.Transform:SetScale(2.5,2.5,2.5)
		inst._fx.AnimState:SetMultColour(0, 0, 0, 1)
        inst._fx.entity:AddFollower()
        inst._fx.Follower:FollowSymbol(inst.GUID, "innerds", 0, 250, 0)
	end
end

local function nodmgshielded(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return inst:HasTag("forcefield") and amount <= 0 and not ignore_absorb or afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function OrganUpdate(inst)
	local organ = TheSim:FindFirstEntityWithTag("minotaur_organ")
	if organ and organ.components.health and not organ.components.health:IsDead() then
		if not inst:HasTag("forcefield") then
			ActivateShield(inst)
		end
	else
		if inst:HasTag("forcefield") then
			DeactivateShield(inst)
		end
	end
end

local function HomeCheck(inst)
	if inst.spawnlocation then
		local dist = math.sqrt(inst:GetDistanceSqToPoint(inst.spawnlocation:Get()))
		if dist > 32 then
			inst.sg:GoToState("arena_return_pre")
		end
	end
end

env.AddPrefabPostInit("minotaur", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.forceleap = false
	inst.forcebelch = false
	inst.tentbelch = true
	inst.have_a_heart = false
	
	inst.combo = 0
	inst.components.timer:StartTimer("forceleapattack", math.random(30,45))
	inst.components.timer:StartTimer("forcebelch", math.random(30,45))
	
	inst:ListenForEvent("timerdone", CheckForceJump)
	
	local _OnAttacked = UpvalueHacker.GetUpvalue(Prefabs.minotaur.fn, "OnAttacked")
	local function OnAttacked(inst, data)
		if not inst.sg:HasStateTag("newbuild") then
			_OnAttacked(inst,data)
		end
	end
	inst:RemoveEventCallback("attacked",_OnAttacked)
	UpvalueHacker.SetUpvalue(Prefabs.minotaur.fn, OnAttacked,"OnAttacked")
	
	inst:ListenForEvent("attacked",OnAttacked)
	
	inst.LaunchProjectile = ShootProjectile
	
	inst.ActivateShield = ActivateShield
	inst.DeactivateShield = DeactivateShield
	
	inst.OrganUpdate = OrganUpdate
	
	inst.components.health.redirect = nodmgshielded
	
	inst:AddComponent("healthtrigger")
	inst.components.healthtrigger:AddTrigger(0.4, function(inst)
		inst.forcebelch = true
		--inst.have_a_heart = true
	end)
	
	inst:DoPeriodicTask(5,HomeCheck)
end)
