require "stategraphs/SGleechswarm"
local brain = require "brains/pollenmitesbrain"

local assets=
{
	Asset("ANIM", "anim/gnat.zip"),
}
	
local prefabs =
{

}

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
          and not (inst.components.follower and inst.components.follower.leader == target)
          and not (inst.components.follower and inst.components.follower.leader == GetPlayer() and target:HasTag("companion"))
end

local function NormalRetarget(inst)
    local targetDist = 5
    local notags = {"FX", "NOCLICK","INLIMBO", "playerghost", "shadowcreature", "pollenmites", "pollenmiteden"}
    --local notags = {"FX", "NOCLICK", "companion", "abigail", "ghost", "epic", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible"}
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy and target.components.health:IsDead())
               and not (inst.components.follower and inst.components.follower.leader == GetPlayer() and guy:HasTag("companion")) and (guy:HasTag("infestable")) then
                return (guy:HasTag("_combat") and not guy:HasTag("pollenmites"))
            end
    end, nil, notags)
end

local function bite(inst)
	--[[if inst.components.infester.target:HasTag("playerghost") then
		inst.components.infester.Uninfest()
	else]]
	if inst.components.infester.target:HasTag("playerghost") then
		inst.components.health:Kill()
	end
	
	if inst.components.infester.target then
		if inst.components.infester.target:HasTag("player") and not inst.components.infester.target:HasTag("playerghost") then
			inst.bufferedaction = BufferedAction(inst, inst.components.infester.target, ACTIONS.ATTACK)
			inst:PushEvent("doattack")
			--inst.components.infester.target:PushEvent("attacked", {attacker = inst, damage = 1, weapon = nil})
			inst:DoTaskInTime(0.6, function(inst) if inst.components.infester.target then inst.components.infester.target.components.health:DoDelta(-1) end end)
			if inst.components.infester.target.components.hayfever ~= nil and inst.components.infester.target.components.hayfever.enabled and inst.components.infester.target.components.hayfever:CanSneeze() then
				inst:DoTaskInTime(0.6, function(inst) if inst.components.infester.target then inst.components.infester.target.components.hayfever:DoDelta(-5) end end)
			end
		elseif inst.components.infester.target then
			inst.bufferedaction = BufferedAction(inst, inst.components.infester.target, ACTIONS.ATTACK)
			inst:PushEvent("doattack")
			inst:DoTaskInTime(0.6, function(inst) if inst.components.infester.target then inst.components.infester.target:PushEvent("attacked", {attacker = nil, damage = 1, weapon = nil}) end end)
		end
	end
end

local function findlight(inst)
    local targetDist = 15
    local notags = {"FX", "NOCLICK","INLIMBO"}
	local light = FindEntity(inst, targetDist, 
        function(guy) 
            if guy.Light and guy.Light:IsEnabled() then
                return true
            end
    end, nil, notags)

    return light
end

local function stopinfesttest(inst)
	if  TheWorld.state.isdusk or TheWorld.state.isnight then
		local target = findlight(inst)
		if target and inst:GetDistanceSqToInst(target) > 5*5 then
			return target
		end
	end
end

local function deathtimer(inst)
    inst:DoTaskInTime(60 *  math.random(0.5,0.8) , function() inst.components.health:Kill() end)
end

local function OnAttacked(inst, data)
    if data ~= nil and data.attacker ~= nil then
        if data.stimuli == "electric" or (data.weapon ~= nil and data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric") and not inst.components.health:IsDead() then
            SpawnPrefab("electrichitsparks").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.components.health:DoDelta(-50)
		end
    end
end

local function OnIgniteFn(inst)
	inst:DoTaskInTime(0.1, function()
		if not inst.components.health:IsDead() then
			inst.SoundEmitter:KillSound("hiss")
			SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
			--inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
			inst.components.health:Kill()
			
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO" })

			for i, v in ipairs(ents) do
				if v ~= inst and v:IsValid() and not v:IsInLimbo() then
					if v:IsValid() and not v:IsInLimbo() then
						if v.components.fueled == nil and
							v.components.burnable ~= nil and
							not v.components.burnable:IsBurning() and
							not v:HasTag("burnt") then
							v.components.burnable:Ignite()
						end
					end
				end
			end
			
		end
	end)
end

local function fn()
	local inst = CreateEntity()
    --local shadow = inst.entity:AddDynamicShadow()
    --shadow:SetSize(6, 3.5)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	----------
	
	--MakeCharacterPhysics(inst, 1, .25)
    MakeFlyingCharacterPhysics(inst, 1, .5)
	inst.Transform:SetFourFaced()
	RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
	
	

	------------
	inst.AnimState:SetBuild("pollenmites")
	inst.AnimState:SetBank("gnat")
	inst.AnimState:PlayAnimation("idle_loop")
	--inst.AnimState:SetRayTestOnBB(true);

	---------------------------------
	
	inst:AddTag("pollenmites")
	inst:AddTag("flying")
	inst:AddTag("insect")
	inst:AddTag("animal")	
	inst:AddTag("smallcreature")
	inst:AddTag("avoidonhit")
	inst:AddTag("no_durability_loss_on_hit")
    inst:AddTag("hostile")
	inst:AddTag("soulless")
    inst:AddTag("noember")
    inst:AddTag("burnable") -- needs this to be frozen by flingomatic

    inst:AddTag("lastresort") -- for auto attacking
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 12

	--MakePoisonableCharacter(inst)
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(500)
    inst.components.health.fire_damage_scale = 100
	--inst.components.health.invincible = false

	------------------
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "fx_puff"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)

    --inst.components.combat:SetDefaultDamage(1)
    inst.components.combat:SetAttackPeriod(5)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)    

	inst:AddComponent("burnable")
	inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
	------------------

	inst:AddComponent("knownlocations")
	
	------------------

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_TINY * 2

    ------------------

    --MakeMediumBurnableCharacter(inst, "fx_puff")
	MakeTinyFreezableCharacter(inst, "fx_puff")

	------------------
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	
	-----------------

	inst:AddComponent("infester")
	inst.components.infester.bitefn = bite
	inst.components.infester.stopinfesttestfn = stopinfesttest
	------------------
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.INSECT
	
    MakeMediumPropagator(inst)
	
	--[[
	inst:ListenForEvent("freeze", function()
		if inst.components.freezable then
			inst.components.health.invincible = false
		end
	end)    

	inst:ListenForEvent("unfreeze", function() 
		if inst.components.freezable then
			inst.components.health.invincible = false
		end
	end)
	]]
	--inst.special_action = makehome
	inst:SetStateGraph("SGleechswarm")
	inst:SetBrain(brain)

	inst.findlight = findlight
	
	inst:DoTaskInTime(60, function() inst.components.health:Kill() end)
	
    inst:ListenForEvent("attacked", OnAttacked)
    inst.OnLoad = deathtimer

	return inst
end

return Prefab( "pollenmites", fn, assets, prefabs)
