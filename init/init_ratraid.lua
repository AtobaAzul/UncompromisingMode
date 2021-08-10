local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("ratcheck")
end)

env.AddPrefabPostInit("cave", function(inst)
    inst:AddComponent("ratcheck")
end)
--[[
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

for k, v in pairs(PLANT_DEFS) do
	env.AddPrefabPostInit(v, function (inst)
		if not TheWorld.ismastersim then
			return
		end

		local function OnPicked_Raid(inst, doer)
			if doer ~= nil and not inst.is_oversized and inst:HasTag("farm_plant_killjoy") and math.random() < 0.05 then
				TheWorld:PushEvent("activeraid", {container = inst, doer = doer, amount = 1})
			end
			
			return inst._OldOnPicked(inst, doer)
		end

		if inst.components.pickable ~= nil then
			inst._OldOnPicked = inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn = OnPicked_Raid
		end
	end)
end]]

env.AddPrefabPostInit("treasurechest", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.AnimState:PushAnimation("closed", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
			
			--Rat Raid
			if doer ~= nil and doer:HasTag("player") then
				--inst:DoTaskInTime(0, ActiveRaid, doer)
				TheWorld:PushEvent("activeraid", {container = inst, doer = doer, amount = 1})
			end
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

env.AddPrefabPostInit("icebox", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
		
		--Rat Raid
		if doer ~= nil and doer:HasTag("player") then
			--inst:DoTaskInTime(0, ActiveRaid, doer)
			TheWorld:PushEvent("activeraid", {container = inst, doer = doer, amount = 1})
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

env.AddPrefabPostInit("dragonflychest", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
			
			--Rat Raid
			if doer ~= nil and doer:HasTag("player") then
				--inst:DoTaskInTime(0, ActiveRaid, doer)
				TheWorld:PushEvent("activeraid", {container = inst, doer = doer, amount = 1})
			end
		end
	end
	
	local function killrat(inst, data)
		data.rat = data.doer or data.worker
		
		if data.rat ~= nil and data.rat:HasTag("raidrat") and data.rat.components.health ~= nil then
			data.rat.components.health:Kill()
		end
	end
	
    inst:ListenForEvent("worked", killrat)
	
	inst.components.container.onclosefn = onclose_raid
end)

env.AddPrefabPostInit("saltbox", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
			
			--Rat Raid
			if doer ~= nil and doer:HasTag("player") then
				--inst:DoTaskInTime(0, ActiveRaid, doer)
				TheWorld:PushEvent("activeraid", {container = inst, doer = doer, amount = 1})
			end
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

env.AddPrefabPostInit("cookpot", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onharvest_raid(inst)
		if not inst:HasTag("burnt") then
			TheWorld:PushEvent("activeraid", {container = inst, doer = nil, amount = 1})
		end
		
		return inst._Oldonharvest(inst)
	end
	
	inst._Oldonharvest = inst.components.stewer.onharvest
	inst.components.stewer.onharvest = onharvest_raid
end)

env.AddPrefabPostInit("portablecookpot", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local function onharvest_raid(inst)
		if not inst:HasTag("burnt") then
			TheWorld:PushEvent("activeraid", {container = inst, doer = nil, amount = 1})
		end
		
		return inst._Oldonharvest(inst)
	end
	
	inst._Oldonharvest = inst.components.stewer.onharvest
	inst.components.stewer.onharvest = onharvest_raid
end)