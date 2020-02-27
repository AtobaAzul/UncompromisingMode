require "stategraphs/SGleechswarm"
local brain = require "brains/leechswarmbrain"
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
    local notags = {"FX", "NOCLICK","INLIMBO", "playerghost", "shadowcreature"}
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy and target.components.health:IsDead())
               and not (inst.components.follower and inst.components.follower.leader == GetPlayer() and guy:HasTag("companion")) and (guy:HasTag("infestable")) then
                return not (guy:HasTag("leechswarm"))
            end
    end, nil, notags)
end

local function bite(inst)
	if inst.components.infester.target then
		inst.bufferedaction = BufferedAction(inst, inst.components.infester.target, ACTIONS.ATTACK)
		inst:PushEvent("doattack")
	end
end

local function stopinfesttest(inst)

end

local function fn()
	local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 3.5)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	----------
	

    MakeFlyingCharacterPhysics(inst, 1, .5)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBuild("gnat")

	------------
	
	inst.AnimState:SetBank("gnat")
	inst.AnimState:PlayAnimation("idle_loop")
	--inst.AnimState:SetRayTestOnBB(true);

	------------
	
	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 12

	inst:SetStateGraph("SGleechswarm")
	---------------------------------
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	------------------
	inst:AddTag("leechswarm")
	inst:AddTag("flying")
	inst:AddTag("insect")
	inst:AddTag("animal")	
	inst:AddTag("smallcreature")
	inst:AddTag("avoidonhit")	
	--inst:AddTag("no_durability_loss_on_hit")
    inst:AddTag("hostile")	


    inst:AddTag("burnable") -- needs this to be frozen by flingomatic

    inst:AddTag("lastresort") -- for auto attacking

	--MakePoisonableCharacter(inst)
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(300)
	inst.components.health.invincible = true

	------------------
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "fx_puff"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)

    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)    

	------------------

	--inst:AddComponent("knownlocations")
	------------------

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_TINY * 2

    ------------------

	MakeTinyFreezableCharacter(inst, "fx_puff")

	------------------
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"laitleech"})
	-----------------

	inst:AddComponent("infester")
	inst.components.infester.bitefn = bite
	inst.components.infester.stopinfesttestfn = stopinfesttest
	------------------
	

	------------------



	------------------

	inst:ListenForEvent("freeze", function()
		if inst.components.freezable then
			inst.components.health.invincible =false
		end
	end)    

	inst:ListenForEvent("unfreeze", function() 
		if inst.components.freezable then
			inst.components.health.invincible =true
		end
	end)
	--inst:ListenForEvent("killed", function() inst.components.infester.Uninfest() end)
	--inst.special_action = makehome
	inst:SetBrain(brain)

	--inst.findlight = findlight

	return inst
end

return Prefab( "leechswarm", fn, assets, prefabs)
