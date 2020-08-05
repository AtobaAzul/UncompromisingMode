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
    inst.data.stage = stage -- track here, as growable component may go away
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
    inst.Physics:ClearCollisionMask()

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
	local x, y, z = inst.Transform:GetWorldPosition()
    local deadcreature = SpawnPrefab("pigman")
	deadcreature.Transform:SetPosition(x, y, z)
	deadcreature.components.health:Kill()
	
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
	inst.SoundEmitter:KillSound("loop")
end


local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		inst.entity:AddSoundEmitter()

		inst.data = {}

		MakeObstaclePhysics(inst, .5)

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon( "spiderden.png" )

		inst.AnimState:SetBank("spider_cocoon")
		inst.AnimState:SetBuild("spider_cocoon")
		inst.AnimState:PlayAnimation("cocoon_small", true)
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		inst:AddTag("structure")
	    --inst:AddTag("hostile")
		--inst:AddTag("spiderden")
		--inst:AddTag("hive")

		-------------------
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(100)

		-------------------

		---------------------
		---------------------

		---------------------
		-------------------

		---------------------
		-------------------


		-------------------

		inst:AddComponent("combat")
		inst:ListenForEvent("death", OnKilled)


		--------------------

		---------------------
		MakeLargePropagator(inst)

		---------------------

		---------------------

		--inst:AddComponent( "spawner" )
		--inst.components.spawner:Configure( "resident", max, initial, rate )
		--inst.spawn_weight = global_spawn_weight

		inst:AddComponent("inspectable")
		
		MakeSnowCovered(inst)

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		return inst
end


	

return Prefab( "webbedcreature", fn, assets, prefabs )

