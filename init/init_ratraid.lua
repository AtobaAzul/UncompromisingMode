local function CooldownRaid(inst)
	GLOBAL.TheWorld.net:RemoveTag("raided")
	print("Rat Raid Cooldown is over.")
end

local function SpawnRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local x2 = x + math.random(-10, 10)
	local z2 = z + math.random(-10, 10)
	local players = GLOBAL.FindPlayersInRange(x, y, z, 50)
	for i, v in ipairs(players) do
		local raid = GLOBAL.SpawnPrefab("uncompromising_ratherd")
		if GLOBAL.TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
			raid.Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
			GLOBAL.TheWorld:DoTaskInTime(9600 + math.random(4800), CooldownRaid)
		else
			inst:DoTaskInTime(0, SpawnRaid)
		end
	end
end

local function SoundRaid(inst)
	if ratwarning ~= nil then
		inst.SoundEmitter:PlaySound("turnoftides/creatures/together/carrat/stunned", "ratwarning")
		inst.SoundEmitter:SetParameter("ratwarning", "size", ratwarning)
		inst:DoTaskInTime(math.random(10 / ratwarning, 15 / ratwarning), SoundRaid)
	end
end

local function StartRaid(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = GLOBAL.FindPlayersInRange(x, y, z, 50)
	if ratwarning == nil then
		ratwarning = 0
	else
		ratwarning = ratwarning + 1
	end
	if ratwarning == 1 then
		inst:DoTaskInTime(0, SoundRaid)
	end
	if ratwarning == 3 then
		for i, v in ipairs(players) do
			v.components.talker:Say(GLOBAL.GetString(v, "ANNOUNCE_RATRAID"))
		end
	end
	if ratwarning == 10 then
		inst:DoTaskInTime(1, SpawnRaid)
		for i, v in ipairs(players) do
			v.components.talker:Say(GLOBAL.GetString(v, "ANNOUNCE_RATRAID_SPAWN"))
		end
		ratwarning = nil
	else
		inst:DoTaskInTime(math.random(3, 6), StartRaid)
	end
	
	print("Rat Raid Warning :", ratwarning)
end

local function ActiveRaid(inst, doer)
	if not doer or not doer:IsValid() or not doer.Transform then
        return
    end

	local x, y, z = doer.Transform:GetWorldPosition()
	local playerage = doer.components.age:GetAgeInDays()
	local ents = TheSim:FindEntities(x, y, z, 20, nil, nil, {"_inventoryitem"})
	if playerage >= 50 and math.random() > 0.05 and
		not GLOBAL.TheWorld:HasTag("cave") and
		not GLOBAL.TheWorld.net:HasTag("raided") and
		not inst.components.container:IsEmpty() and
		#ents >= 20 then
		GLOBAL.TheWorld.net:AddTag("raided")
		print("Rat Raid Triggered !")
		inst:DoTaskInTime(3, StartRaid, doer)
	end
end

AddPrefabPostInit("treasurechest", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.AnimState:PushAnimation("closed", false)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
			
			--Rat Raid
			inst:DoTaskInTime(0, ActiveRaid, doer)
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

AddPrefabPostInit("icebox", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
		
		--Rat Raid
		inst:DoTaskInTime(0, ActiveRaid, doer)
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

AddPrefabPostInit("dragonflychest", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
			
			--Rat Raid
			inst:DoTaskInTime(0, ActiveRaid, doer)
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)

AddPrefabPostInit("saltbox", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	local function onclose_raid(inst, doer)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("close")
			inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
			
			--Rat Raid
			inst:DoTaskInTime(0, ActiveRaid, doer)
		end
	end
	
	inst.components.container.onclosefn = onclose_raid
end)