local brain = require "brains/swilsonbrain"
local assets =
{

}
    
    
local prefabs =
{

}

SetSharedLootTable('rneskeleton',
{
    {'boneshard',     1.0},
	{'boneshard',     1.0},
})

local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 30
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 32
    end
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character") or guy:HasTag("pig")
            end
    end)
end


local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
end
local function TellOthersTo(inst,dance)
local x,y,z = inst.Transform:GetWorldPosition()
local ents = TheSim:FindEntities(x, 0, z, 50, {"rneskeleton"})
	for k,v in pairs(ents) do
	v.decided = true
	if dance == true then
	v.sg:GoToState("dance")
	else
	--v.sg:GoToState("idle") Doesn't seem to get them to stop dancing
	end
end
end
local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("rneskeleton") and not dude.components.health:IsDead() end, 5)
	TellOthersTo(inst,false)
	v.sg:GoToState("idle")
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
end
local function CheckIfNearPlayer(inst)
local bozo =FindEntity(inst, 7, 
    function(guy) 
            if inst.components.combat:CanTarget(guy) then
                return guy:HasTag("character")
            end
    end)
	if bozo ~= nil and inst.decided == false then
		inst.decided = true
		if math.random() > 0.5 then
			inst.sg:GoToState("dance")
			TellOthersTo(inst,true)
		else
			TellOthersTo(inst,false)
		end
	end
end
local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 1.5, .5 )
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 10, .5)
	
	inst:AddTag("plant")
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("wilton")
    inst.AnimState:PlayAnimation("idle",true)
	
	-- Gear handler
    inst.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    inst.AnimState:Show("ARM_carry")
    inst.AnimState:Hide("ARM_normal")
        inst.AnimState:OverrideSymbol("swap_hat", "hat_football", "swap_hat")
        inst.AnimState:Show("HAT")
        inst.AnimState:Show("HAIR_HAT")
        inst.AnimState:Hide("HAIR_NOHAT")
        inst.AnimState:Hide("HAIR")

	
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 3

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('rneskeleton')
	
    inst:AddTag("rneskeleton") 
	inst:AddTag("notraptrigger")

    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(34)
    inst.components.combat:SetAttackPeriod(4)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/sanity/creature1/death")
    inst.components.combat:SetRange(2, 2)
    ------------------
    
    ------------------
    
    inst:AddComponent("knownlocations")
    ------------------
    
    
    ------------------
    
    inst:AddComponent("inspectable")
    inst:ListenForEvent("attacked", OnAttacked)

    ------------------
	SpawnPrefab("maxwell_smoke")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
    inst.decided = false
    inst:SetStateGraph("SGrneskeletons")
    inst:SetBrain(brain)
	inst:DoPeriodicTask(1,CheckIfNearPlayer)
	
	inst:WatchWorldState("isday", function() 
		inst.sg:GoToState("grounded")
	end)
	
	inst.sg:GoToState("enter")
	
	inst:DoTaskInTime(0,function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("maxwell_smoke")
		despawnfx.Transform:SetPosition(x, y, z)
	end)
    return inst
end

return Prefab( "rneskeleton", fn, assets, prefabs)