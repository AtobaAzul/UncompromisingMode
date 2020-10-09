local prefabs =
{
	"spider",
    "spider_warrior",
    "silk",
    "spidereggsack",
    "spiderqueen",
}

local assets =
{
    Asset("ANIM", "anim/spider_cocoon.zip"),
	Asset("SOUND", "sound/spider.fsb"),
}


local function SetStage(inst, stage)
	if stage <= 3 then

    
		inst.AnimState:PlayAnimation(inst.anims.init)
		inst.AnimState:PushAnimation(inst.anims.idle, true)
	end  
end

local function SetSmall(inst)
    inst.anims = {
    	hit="cocoon_small_hit", 
    	idle="cocoon_small", 
    	init="grow_sac_to_small", 
    	freeze="frozen_small", 
    	thaw="frozen_loop_pst_small",
    }
    SetStage(inst, 1)



end


local function SetMedium(inst)
    inst.anims = {
    	hit="cocoon_medium_hit", 
    	idle="cocoon_medium", 
    	init="grow_small_to_medium", 
    	freeze="frozen_medium", 
    	thaw="frozen_loop_pst_medium",
    }
    SetStage(inst, 2)
end

local function SetLarge(inst)
    inst.anims = {
    	hit="cocoon_large_hit", 
    	idle="cocoon_large", 
    	init="grow_medium_to_large", 
    	freeze="frozen_large", 
    	thaw="frozen_loop_pst_large",
    }
    SetStage(inst, 3)
end



local function OnKilled(inst)
	inst.AnimState:PlayAnimation("cocoon_dead")
	local x, y, z = inst.Transform:GetWorldPosition()
    inst.SoundEmitter:KillSound("loop")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
	local creature = nil
	if inst.size ~= nil then
		if inst.size == 1 then
		creature = "deer"
		end
		if inst.size == 2 then
		creature = "beefalo"
		end
		if inst.size == 3 then
		creature = "mossling"
		end
		if inst.size == 4 then
		creature = "pigman"
		end
		if inst.size == 5 then
		creature = "bunnyman"
		end
		if inst.size == 6 then
		creature = "koalefant_summer"
		end
		if inst.size == 7 then
		creature = "little_walrus"
		end
		if inst.size == 8 then
		creature = "tallbird"
		end
		if inst.size == 9 then
		creature = "spiderqueen"
		end
		if inst.size == 10 then
		creature = "warg"
		end
		if inst.size == 11 then
		creature = "krampus"
		end
		if inst.size == 12 then
		creature = "walrus"
		end
		if inst.size == 13 then
		creature = "knight"
		end
		if inst.size == 14 then
		creature = "spat"
		end	
    local deadcreature = SpawnPrefab(creature)
	deadcreature.Transform:SetPosition(x, y, z)
	if creature == "spiderqueen" then
	deadcreature:AddTag("nodecomposepls")
	end
	deadcreature.components.health:Kill()
	else
    local deadcreature = SpawnPrefab("pigman")
	deadcreature.Transform:SetPosition(x, y, z)
	deadcreature.components.health:Kill()
	end
	local spawner = SpawnPrefab("webbedcreaturespawner")
	spawner.Transform:SetPosition(x, y, z)
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
	inst.SoundEmitter:KillSound("loop")
end

local function onsave(inst,data)
if inst.size ~= nil then
data.size = inst.size
else
data.size = math.random(1,14)
end
end
local function onload(inst,data)
if data and data.size ~= nil then
inst.size = data.size
else
inst.size = math.random(1,14)
end
end
local function SetSize(inst)
if inst.size == 1 then   --No Eyed Deer
SetMedium(inst)
end
if inst.size == 2 then   --Beefalo
SetLarge(inst)
end
if inst.size == 3 then   --Mossling
SetMedium(inst)
end
if inst.size == 4 then   --Pigman
SetSmall(inst)
end
if inst.size == 5 then   --Bunnyman
SetSmall(inst)
end
if inst.size == 6 then   --koalefant
SetLarge(inst)
end
if inst.size == 7 then   --wee mactusk
SetSmall(inst)
end
if inst.size == 8 then   --Tallbird
SetMedium(inst)
end
if inst.size == 9 then   --SpiderQueen
SetLarge(inst)
end
if inst.size == 10 then   --Varg
SetLarge(inst)
end
if inst.size == 11 then   --Krampus
SetMedium(inst)
end
if inst.size == 12 then   --Mactusk
SetMedium(inst)
end
if inst.size == 13 then   --Clockwork Knight
SetSmall(inst)
end
if inst.size == 14 then   --Ewecus
SetLarge(inst)
end
end

local function Regen(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
		if attacker:HasTag("widowsgrasp") then
		inst.components.health:Kill()
		end
	end
end
local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		inst.entity:AddSoundEmitter()


		--MakeObstaclePhysics(inst, .5)


		inst.AnimState:SetBank("spider_cocoon")
		inst.AnimState:SetBuild("spider_cocoon")
		inst.AnimState:PlayAnimation("cocoon_small", true)
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddTag("structure")
		inst:AddTag("webbedcreature")

		-------------------
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(1000000)
		inst.components.health.invincible = true
		inst:AddComponent("combat")       
        inst.components.combat:SetOnHit(Regen)
		inst:ListenForEvent("death", OnKilled)
		inst:AddTag("prey")
		inst:AddTag("hound")
		MakeLargePropagator(inst)

		inst:AddComponent("inspectable")
		inst:DoTaskInTime(0,SetSize)
		MakeSnowCovered(inst)
		inst.OnSave = onsave
		inst.OnLoad = onload
		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		inst.size = math.random(1,14)
		return inst
end


	

return Prefab( "webbedcreature", fn, assets, prefabs )

