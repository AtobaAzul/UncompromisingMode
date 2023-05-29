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

SetSharedLootTable("mindweaver",
{
    { "nightmarefuel",  0.5 },
})

local brain = require "brains/mindweaverbrain"

local function FinishExtendedSound(inst, soundid)
    inst.SoundEmitter:KillSound("sound_"..tostring(soundid))
    inst.sg.mem.soundcache[soundid] = nil
    if inst.sg.statemem.readytoremove and next(inst.sg.mem.soundcache) == nil then
        inst:Remove()
    end
end

local function PlayExtendedSound(inst, soundname)
    if inst.sg.mem.soundcache == nil then
        inst.sg.mem.soundcache = {}
        inst.sg.mem.soundid = 0
    else
        inst.sg.mem.soundid = inst.sg.mem.soundid + 1
    end
    inst.sg.mem.soundcache[inst.sg.mem.soundid] = true
    inst.SoundEmitter:PlaySound(inst.sounds[soundname], "sound_"..tostring(inst.sg.mem.soundid))
    inst:DoTaskInTime(5, FinishExtendedSound, inst.sg.mem.soundid)
end

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
				PlayExtendedSound(inst, "taunt")
				inst.components.follower:SetLeader(v)
				break
			end
		elseif #ents > 0 and inst.components.follower.leader ~= nil then
			if inst.shadowsize < 5 then
				inst.shadowsize = inst.shadowsize + 0.1
				inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize / 2)
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
			inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize / 2)
		end
	elseif inst.shadowsize > 0--[[1.1]] then
		inst.shadowsize = inst.shadowsize - 0.1
		inst.DynamicShadow:SetSize(inst.shadowsize, inst.shadowsize / 2)
	end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

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
	inst:AddTag("shadow_aligned")
	inst:AddTag("notraptrigger")

    inst.AnimState:SetBank("mindweaver")
    inst.AnimState:SetBuild("mindweaver")
    inst.AnimState:PlayAnimation("appear")
	inst.AnimState:SetFinalOffset(2)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
	inst.AnimState:UsePointFiltering(true)
	
	inst.Transform:SetScale(1.6, 1.6, 1.6)

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	
    inst:AddComponent("locomotor")
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
	
    inst:AddComponent("follower")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('mindweaver')
	
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
	inst:WatchWorldState("iscaveday", function() 
		if not inst.sg:HasStateTag("grabbing") then
			inst:Remove()
		end
	end)
	
	inst:DoPeriodicTask(0.1, ScanForPlayer)
	inst:DoTaskInTime(0,function(inst) PlayExtendedSound(inst, "taunt") end)
	--inst.ResetShadow = ResetShadow

    return inst
end

return Prefab( "mindweaver", fn, assets, prefabs)