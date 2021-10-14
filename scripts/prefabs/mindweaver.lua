require "stategraphs/SGmindweaver"

--local brain = require "brains/swilsonbrain"
local assets =
{
    Asset("ANIM", "anim/mindweaver.zip"),
}

local prefabs =
{
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    --idle = "dontstarve/sanity/creature2/idle",
    idle = "dontstarve/sanity/creature1/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require "brains/mindweaverbrain"

--local function Disappear(inst)
	--if not inst.sg:HasStateTag("grabbing") and not inst.components.health:IsDead() then
		--inst.sg:GoToState("grab")
	--end
--end

local function ResetShadow(inst)
	if inst.shadowsize ~= nil and inst.shadowsize > 0 then
		inst.shadowsize = inst.shadowsize - 0.25
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
		
		inst.shadowtask = inst:DoPeriodicTask(0.1, ResetShadow)
	else
		inst.DynamicShadow:SetSize(0, 0)
		
		if inst.shadowtask ~= nil then
			inst.shadowtask:Cancel()
			inst.shadowtask = nil
		end
	end
end

local function Cooldown(inst)
	inst.shadowsize = 0
	inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	inst.cooldown = false
end

local function ScanForPlayer(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if not inst.cooldown and inst:GetTimeAlive() >= 5 then
		local ents = TheSim:FindEntities(x, y, z, 10, { "player" }, { "playerghost" })
	
		if inst.components.follower.leader == nil then
			for i, v in ipairs(ents) do
				inst.Physics:Teleport(v.Transform:GetWorldPosition())
				--inst.Transform:SetPosition(v.Transform:GetWorldPosition())
				inst.components.follower:SetLeader(v)
				break
			end
		elseif #ents > 0 and inst.components.follower.leader ~= nil then
			if inst.shadowsize < 5 then
				inst.shadowsize = inst.shadowsize + 0.1
				inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
			else
				if not inst.sg:HasStateTag("grabbing") and not inst.components.health:IsDead() then
					if inst.shadowtask ~= nil then
						inst.shadowtask:Cancel()
						inst.shadowtask = nil
					end
					inst.components.follower.leader = nil
					inst.sg:GoToState("grab")
					inst.cooldown = true
					inst:DoTaskInTime(10, Cooldown)
				end
			end
		elseif inst.shadowsize > 0--[[1.1]] then
			inst.shadowsize = inst.shadowsize - 0.1
			inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
		end
	elseif inst.shadowsize > 0--[[1.1]] then
		inst.shadowsize = inst.shadowsize - 0.1
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize)
	end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()

	MakeCharacterPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)
	
	inst.shadowsize = 0
		
    inst.DynamicShadow:SetSize(0, 0)

	--inst.Transform:SetFourFaced()
	inst:AddTag("monster")
    inst:AddTag("hostile")   
    inst:AddTag("swilson") 
	inst:AddTag("nightmarecreature")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("mindweaver")
    inst.AnimState:SetBuild("mindweaver")
    inst.AnimState:PlayAnimation("appear")
	inst.Transform:SetScale(1.6, 1.6, 1.6)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
	
    inst:AddComponent("follower")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('shadow_creature')
	
    inst:AddComponent("knownlocations")
	
    --inst:AddComponent("playerprox")
    --inst.components.playerprox:SetDist(3, 5)
    --inst.components.playerprox:SetOnPlayerNear(ScanForPlayer)
    --inst.components.playerprox:SetPlayerAliveMode(true)
	
    inst:AddComponent("combat")
    inst.sounds = sounds 
	inst.cooldown = false
	
    inst:SetStateGraph("SGmindweaver")
    inst:SetBrain(brain)
	
	inst:WatchWorldState("isday", function() 
		if not inst.sg:HasStateTag("grabbing") then
			inst:Remove()
		end
	end)
	
	inst:DoPeriodicTask(0.1, ScanForPlayer)
	
	inst.ResetShadow = ResetShadow

    return inst
end

return Prefab( "mindweaver", fn, assets, prefabs)