
local brain = require "brains/bightbrain"
local assets =
{

}
    
    
local prefabs =
{

}
SetSharedLootTable('bight',
{
    {'gears',     0.5},
    {'nightmarefuel',    0.6},
    {'thulecite_pieces', 0.5},
    {'trinket_6',      1.00},
    {'trinket_6',      0.55},
    {'trinket_1',      0.25},
    {'gears',          0.25},
    {'redgem',         0.25},
    {"greengem" ,      0.05},
    {"yellowgem",      0.05},
    {"purplegem",      0.05},
    {"orangegem",      0.05},
    {"thulecite",      0.01},
})

local SHARE_TARGET_DIST = 30

local function NormalRetarget(inst)
    local targetDist = 16
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = 16
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


local function OnAttacked(inst, data)
	if inst:HasTag("electrified") and data ~= nil and data.attacker ~= nil then
		if data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and
			(data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) then
		
			if data.attacker:HasTag("player") then
				if not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()) then
					if data.attacker.sg ~= nil and not data.attacker.sg:HasStateTag("nointerrupt") then
						data.attacker.sg:GoToState("electrocute")
					end
					
					local mult = not (data.attacker:HasTag("electricdamageimmune") or
						(data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()))
						and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (data.attacker.components.moisture ~= nil and data.attacker.components.moisture:GetMoisturePercent() or (data.attacker:GetIsWet() and 1 or 0))
						or 1
					
					local damage = -6.7 * mult
					
					print(damage)
					
					data.attacker.components.health:DoDelta(damage, nil, inst.prefab, nil, inst) --From the onhit stuff...
				end
			else
				if not inst:HasTag("electricdamageimmune") then
					local mult = not (data.attacker:HasTag("electricdamageimmune") or
						(data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()))
						and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (data.attacker.components.moisture ~= nil and data.attacker.components.moisture:GetMoisturePercent() or (data.attacker:GetIsWet() and 1 or 0))
						or 1
					
					local damage = -6.7 * mult
					
					print(damage)
						
					data.attacker.components.health:DoDelta(damage, nil, inst.prefab, nil, inst) --From the onhit stuff...
				end
			end
        end
    end
	
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("chess") and not dude.components.health:IsDead() end, 5)
end

local function Shockness(inst,x,y,z)
	x = x + math.random(-3,3)
	z = z + math.random(-3,3)
	
	SpawnPrefab("electricchargedfx").Transform:SetPosition(x, 0, z)
	
	local targets = TheSim:FindEntities(x,y,z,1,{"_health"},{"playerghost","chess"}) --Todo, make it shock other things?
	
	for k,v in pairs(targets) do
		if v:HasTag("player") and v.components.health ~= nil and not v.components.health:IsDead() then
			if not (v.components.inventory ~= nil and v.components.inventory:IsInsulated()) then
				if not inst:HasTag("electricdamageimmune") then
					if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") then
						v.sg:GoToState("electrocute")
					end
						
					local mult = not (v:HasTag("electricdamageimmune") or
						(v.components.inventory ~= nil and v.components.inventory:IsInsulated()))
						and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (v.components.moisture ~= nil and v.components.moisture:GetMoisturePercent() or (v:GetIsWet() and 1 or 0))
						or 1
						
					local damage = -6.7 * mult
						
					print(damage)
					
					v.components.health:DoDelta(damage, nil, inst.prefab, nil, inst) --From the onhit stuff...
				end
			end
		else
			if not inst:HasTag("electricdamageimmune") then
				if v.sg ~= nil and not v.sg:HasStateTag("nointerrupt") then
					v.sg:GoToState("electrocute")
				end
					
				local mult = not (v:HasTag("electricdamageimmune") or
					(v.components.inventory ~= nil and v.components.inventory:IsInsulated()))
					and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (v.components.moisture ~= nil and v.components.moisture:GetMoisturePercent() or (v:GetIsWet() and 1 or 0))
					or 1
					
				local damage = -6.7 * mult
					
				print(damage)
				
				v.components.health:DoDelta(damage, nil, inst.prefab, nil, inst) --From the onhit stuff...
			end
		end
	end
end
local function Spark(inst)
	if inst:HasTag("preelectrified") and not inst.sg:HasStateTag("dying")then
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local x1 = x + math.random(-0.5, 0.5)
	local z1 = z + math.random(-0.5, 0.5)
		SpawnPrefab("electricchargedfx").Transform:SetPosition(x1, 0, z1)
	
    SpawnPrefab("sparks").Transform:SetPosition(x1, 0 + 0.25 * math.random(), z1)
	if inst.count == 0 then
	if not inst:HasTag("electrified") then
	inst:AddTag("electrified")
	end
	for k = 1,3 do
	Shockness(inst,x,y,z)
	end
	else
	inst.count = inst.count - 1
	end
	end
end

local function OnTimerDone(inst, data)
if data ~= nil and data.name == "electrify" then
inst:AddTag("preelectrified")
inst.components.timer:StartTimer("unelectrify", TUNING.STALKER_FIRST_CHANNELERS_CD*2)
inst.count = 5 --The Count is supposed to give the players a warning before the aoe starts happenin
end
if data ~= nil and data.name == "unelectrify" then
inst:RemoveTag("preelectrified")
inst:RemoveTag("electrified")
inst.components.timer:StartTimer("electrify", TUNING.STALKER_FIRST_CHANNELERS_CD*2)
inst.count = 0
end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()	    
	inst.DynamicShadow:SetSize(3, 2)
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    --inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetSixFaced()
    inst.AnimState:SetBank("bight")
    inst.AnimState:SetBuild("bight")
    inst.AnimState:PlayAnimation("idle_loop",true)
	MakeCharacterPhysics(inst, 100, 0.5)
	--MakePoisonableCharacter(inst)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4
    inst.components.locomotor.runspeed = 4

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('bight')
    
    ---------------------            
    --MakeMediumBurnableCharacter(inst, "torso")
    MakeMediumFreezableCharacter(inst, "knight_spring")    
    --inst.components.burnable.flammability = 0.33
    ---------------------       
    
	
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("chess")
    inst:AddTag("bight")
	inst:AddTag("electricdamageimmune")
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(900)
    ------------------

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "knight_spring"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)    
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetAttackPeriod(3)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)
    inst.components.combat:SetHurtSound("dontstarve/sanity/creature1/death")
    inst.components.combat:SetRange(3, 3)
    ------------------
    
    ------------------
    
    inst:AddComponent("knownlocations")
    ------------------
    inst:AddComponent("sleeper")
    --inst.components.sleeper:SetWakeTest(ShouldWake)
    --inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetResistance(3)  
    
    ------------------
    
    inst:AddComponent("inspectable")

    ------------------
	inst:ListenForEvent("attacked", OnAttacked)    
    inst:SetStateGraph("SGbight")
    inst:SetBrain(brain)
	inst.sg:GoToState("waken")
	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)	
	inst.components.timer:StartTimer("electrify", TUNING.STALKER_FIRST_CHANNELERS_CD)
	inst:DoPeriodicTask(0.25,Spark)
	inst.count = 5
    return inst
end

return Prefab("bight", fn, assets, prefabs)