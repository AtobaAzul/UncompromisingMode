require "brains/fruitbatbrain"
require "stategraphs/SGfruitbat"

SetSharedLootTable( 'fruitbat',
{
    {'giant_blueberry',1},
})



local MAX_TARGET_SHARES = 100
local SHARE_TARGET_DIST = 100
--Thanks for these functions scrimbles


local function OnEat(inst, data) --Data is actually the thing being eaten...
end

local function OnWingDown(inst)
    inst.SoundEmitter:PlaySound("UCSounds/vampirebat/flap")
end

local function OnWingDownShadow(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/vampire_bat/distant_flap")
end
local function OnSleepGoHome(inst)
    inst._hometask = nil
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    if home ~= nil and home:IsValid() and home.components.childspawner ~= nil then
        home.components.childspawner:GoHome(inst)
    end
end

local function OnIsNight(inst, isnight)
    if isnight then
        if inst._hometask == nil then
            inst._hometask = inst:DoTaskInTime(10 + math.random(), OnSleepGoHome)
        end
    elseif inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StopWatchingNight(inst)
    inst:StopWatchingWorldState("isnight", OnIsNight)
    if inst._hometask ~= nil then
        inst._hometask:Cancel()
        inst._hometask = nil
    end
end

local function StartWatchingNight(inst)
    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)
end

local function OnEntitySleep(inst)
    inst:ListenForEvent("enterlimbo", StopWatchingNight)
    inst:ListenForEvent("exitlimbo", StartWatchingNight)
    if not inst:IsInLimbo() then
        StartWatchingNight(inst)
    end
end

local function OnEntityWake(inst)
    inst:RemoveEventCallback("enterlimbo", StopWatchingNight)
    inst:RemoveEventCallback("exitlimbo", StartWatchingNight)
    if not inst:IsInLimbo() then
        StopWatchingNight(inst)
    end
end

-- TEAM ATTACKER STUFF



local function OnAttacked(inst, data)
    local attacker = data and data.attacker
	if attacker and (attacker:HasTag("insect") or attacker:HasTag("spider")) and not attacker:HasTag("player") then
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("fruitbat") end, MAX_TARGET_SHARES)
	end
end



local function OnWaterChange(inst, onwater)
    if onwater then
        inst.onwater = true
    else
        inst.onwater = false        
    end
end

local function onsave(inst, data)    
    if inst:HasTag("batfrenzy") then
        data.batfrenzy = true
    end
    if inst.sg:HasStateTag("sleeping") then
        data.forcesleep = true
    end

end

local function onload(inst, data)
  if data then
    if data.batfrenzy then
        inst:AddTag("batfrenzy")
    end
    if data.forcesleep then
        inst.sg:GoToState("forcesleep")
        inst.components.sleeper.hibernate = true
        inst.components.sleeper:GoToSleep()
    end
  end
end

local function OnPreLoad(inst, data)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y > 0 then
		inst.Transform:SetPosition(x, 0, z)
	end
end

local RETARGET_CANT_TAGS = {"bat","EPIC","player"}
local RETARGET_ONEOF_TAGS = {"insect","spider"}
local function Retarget(inst)
    local newtarget = FindEntity(inst, 2*TUNING.BAT_TARGET_DIST, function(guy)
            return inst.components.combat:CanTarget(guy)
        end,
        nil,
        RETARGET_CANT_TAGS,
        RETARGET_ONEOF_TAGS
    )
    return newtarget
end

local function KeepTarget(inst, target)
    return true
end

local function OnAttackOther(inst, data)
	if data.target and data.target.components.health and not data.target.components.health:IsDead() and data.target:HasTag("aphid") then
		inst.food_baby = data.target
		if inst.food_baby.brain then
			inst.food_baby.brain:Stop()
			inst.food_baby.sg:Stop()
		end
		inst.sg:GoToState("eat_loop")
	end
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5,.75)
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
    inst.Transform:SetFourFaced()

	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(0.9, 0.9, 0.9)
	MakeFlyingCharacterPhysics(inst, 1, .5)

   
    inst:AddTag("animal")
	inst:AddTag("fruitbat")
	inst:AddTag("animal")
    inst:AddTag("scarytoprey")
    inst:AddTag("flying")
    inst:AddTag("veggie")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst.AnimState:SetBank("fruitbat")
    inst.AnimState:SetBuild("fruitbat")
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 10

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
    inst.components.health.destroytime = 4



    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    inst:SetStateGraph("SGfruitbat")
 
    local brain = require "brains/fruitbatbrain"
    inst:SetBrain(brain)

    inst:AddComponent("lootdropper")

    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
    
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()), true) end)
    
    inst:ListenForEvent("wingdown", OnWingDown)
    inst:ListenForEvent("attacked", OnAttacked)  
	
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "fruitbat_body"
    inst.components.combat:SetAttackPeriod(TUNING.BAT_ATTACK_PERIOD)
    inst.components.combat:SetDefaultDamage(20)--give it damage, since it can target spiders now.
    inst.components.combat:SetRange(TUNING.BAT_ATTACK_DIST)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst:ListenForEvent("onattackother", OnAttackOther)

	MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "fruitbat_body")
    MakeMediumFreezableCharacter(inst, "fruitbat_body")
	
	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
    inst.OnPreLoad = OnPreLoad

    inst.OnSave = onsave 
    inst.OnLoad = onload 

    inst.cavebat = false
    
    return inst
end

return Prefab("fruitbat", fn)

