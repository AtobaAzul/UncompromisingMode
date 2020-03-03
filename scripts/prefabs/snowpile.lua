local assets =
{
	Asset("ANIM", "anim/snowpile.zip")
}

local prefabs =
{
	"sand",
}

TUNING.SNOW_X_SCALE = 0 + math.random(0.3,0.5)
TUNING.SNOW_Y_SCALE = 0 + math.random(0.1,0.3)
TUNING.SNOW_REGROW_TIME = 200
TUNING.SNOW_REGROW_VARIANCE = 80
TUNING.SNOW_DEPLETE_CHANCE = 0.25

local AURA_EXCLUDE_TAGS = { "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible" }

local startregen

-- these should match the animation names to the workleft
local anims = {"low", "med", "full"}

local function onregen(inst)
--print("anothertry")
--[[
	if inst.Transform:GetWorldPosition() ~= nil then
		local x1, y1, z1 = inst.Transform:GetWorldPosition()
		local ents2 = TheSim:FindEntities(x1, y1, z1, 8, { "fire" })
	end--]]

	--if inst ~= nil then
		if TheWorld.state.iswinter then--or ents2 ~= nil and #ents2 < 0 then
			if inst.components.workable.workleft < 3 then
				SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.components.workable:SetWorkLeft(inst.components.workable.workleft+1)
				inst.components.pickable.cycles_left = inst.components.pickable.cycles_left + 1
				startregen(inst)
			elseif inst.components.workable.workleft == 3 and math.random() <= 0.25 then
				local x1, y1, z1 = inst.Transform:GetWorldPosition()
				local ents2 = TheSim:FindEntities(x1, y1, z1, 40, { "player" })
				if #ents2 > 0 then
					print("Snowball Fight!")
					local snowattack = SpawnPrefab("snowmong")
					local spawnpoint = inst.Transform:GetWorldPosition()
					snowattack.Transform:SetPosition(inst.Transform:GetWorldPosition())
					snowattack.sg:GoToState("enter")
					inst:DoTaskInTime(0.1, SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition()))
					inst:DoTaskInTime(0.2, inst:Remove())
				end
			else
				startregen(inst)
			end
		else
			if inst.components.workable.workleft > 1 then
				SpawnPrefab("washashore_puddle_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst.components.workable:SetWorkLeft(inst.components.workable.workleft-1)
				inst.components.pickable.cycles_left = inst.components.pickable.cycles_left - 1
				startregen(inst)
			else
				SpawnPrefab("washashore_puddle_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
			end
		end
end

startregen = function(inst, regentime)
	if inst.components.workable.workleft < #anims + 1 then
		-- more to grow
		--regentime = regentime or (TUNING.SNOW_REGROW_TIME + math.random()*TUNING.SNOW_REGROW_VARIANCE)
		
		regentime = regentime or (TUNING.SNOW_REGROW_TIME + math.random()*TUNING.SNOW_REGROW_VARIANCE)


		if TheWorld.state.issnowing then
			regentime = regentime / 2
		elseif TheWorld.state.iswinter and not TheWorld.state.issnowing then
			regentime = regentime
		else
			regentime = regentime / 2
		end

		if inst.task then
			inst.task:Cancel()
		end
		inst.task = inst:DoTaskInTime(regentime, onregen, "regen")
		inst.targettime = GetTime() + regentime
	--[[else
		-- no more to do
		if inst.task then
			inst.task:Cancel()
		end
		inst.targettime = nil]]
	end

	if inst.components.workable.workleft == 0 then
		inst:Remove()
	else
		inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft])
		inst.AnimState:PlayAnimation(anims[inst.components.pickable.cycles_left])
	end

	-- print('startregen', inst.components.workable.workleft, regentime, anims[inst.components.workable.workleft])
end

local function workcallback(inst, worker, workleft)
	-- print('trying to spawn SNOW', inst, worker, workleft)

	if workleft < 0 then
		-- the devtool probably did this, spit out 2
		--inst.components.lootdropper:SetLoot({"ice", "ice"})
	else
		--inst.components.lootdropper:SetLoot({"ice"})
	end
--[[
	if workleft <= 1 then
		inst.components.activatable.inactive = true
	end
--]]
	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper.chancerandomloot = 0.01  -- drop some random item 1% of the time

	inst.components.lootdropper:AddRandomLoot("rock", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_crow", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin_winter", 0.01)

	-- figure out which side to drop the loot
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(worker.Transform:GetWorldPosition())

	local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)
	
	if he_right then
		inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*(.5+math.random())))
	else
		inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5+math.random())))
	end
	
	if inst.components.pickable.cycles_left > 0 then
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		inst.components.pickable.cycles_left = inst.components.workable.workleft
	else
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		inst:Remove()
	end
	--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandpile")

	startregen(inst)
end

local function workcallback2(inst)
	-- print('trying to spawn sand', inst, worker, workleft)

	
	if inst.components.workable.workleft > 0 then
		inst.components.workable:SetWorkLeft(inst.components.workable.workleft - 1)
	end
	--if workleft < 0 then
		-- the devtool probably did this, spit out 2
		--inst.components.lootdropper:SetLoot({"ice", "ice"})
	--else
		inst.components.lootdropper:SetLoot({"ice"})
	--end

	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper.chancerandomloot = 0.01  -- drop some random item 1% of the time

	inst.components.lootdropper:AddRandomLoot("rock", 0.01)
	inst.components.lootdropper:AddRandomLoot("ice", 0.05)
	inst.components.lootdropper:AddRandomLoot("feather_crow", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin_winter", 0.01)

	
		local pt = Vector3(inst.Transform:GetWorldPosition())
		inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5+math.random())))

	--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandpile")

	if inst.components.workable.workleft >= 0 then
		inst:Remove()
	else
		startregen(inst)
	end
	
end

local function onsave(inst, data)
	if inst.targettime then
		local time = GetTime()
		if inst.targettime > time then
			data.time = math.floor(inst.targettime - time)
		end
		data.cycles_left = inst.components.pickable.cycles_left
		data.workleft = inst.components.workable.workleft
		-- print('sandhill onsave', data.workleft)
	end
end
local function onload(inst, data)

	if data and data.workleft then
		inst.components.workable.workleft = data.workleft

		--[[if data.workleft <= 0 then
			inst.components.activatable.inactive = true
		end--]]

	end
	
	if data and data.cycles_left then
		inst.components.pickable.cycles_left = data.cycles_left
		
	end
	-- print('sandhill onload', inst.components.workable.workleft)
	if data and data.time then
		startregen(inst, data.time)
	end
end

-- note: this doesn't really handle skipping 2 regens in a long update
local function LongUpdate(inst, dt)

	if inst.targettime then
	
		local time = GetTime()
		if inst.targettime > time + dt then
			--resechedule
			local time_to_regen = inst.targettime - time - dt
			-- print ("LongUpdate resechedule", time_to_regen)
			
			startregen(inst, time_to_regen)
		else
			--skipped a regen, do it now
			-- print ("LongUpdate skipped regen")
			onregen(inst)
			--[[
			inst.components.workable:SetWorkLeft(inst.components.workable.workleft+1)
			startregen(inst)
			--]]
		end
	end
end

local function onwake(inst)
	if TheWorld.state.isspring and TheWorld.state.israining then
		if math.random() < TUNING.SNOW_DEPLETE_CHANCE and inst.components.workable.workleft > 0 then
			-- the rain made this sandhill shrink
			inst.components.workable.workleft = inst.components.workable.workleft - math.random(0, inst.components.workable.workleft)
			startregen(inst)
		end
	end
end

local function TryColdness(v)

	if v.components.moisture ~= nil then
		v.components.moisture:DoDelta(1)
	end
	--[[
	if v.components.temperature ~= nil then
		v.components.temperature:SetTemperature(v.components.temperature:GetCurrent() + 1)
	end--]]
	--[[
	if v.components.temperature ~= nil then
		v.components.temperature:DoDelta(-1.5)
	end--]]
end

local NOTAGS = { "playerghost", "INLIMBO" }
local function DoAreaColdness(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, NOTAGS, { "_health" })
    for i, v in ipairs(ents) do
        TryColdness(v)
    end
	
	if inst.components.workable.workleft and inst.components.workable.workleft > 1 then
		inst:AddTag("snowpile")
	else
		inst:RemoveTag("snowpile")
	end
	
end



local function onpickedfn(inst, picker)

    if picker.components.moisture then
        if picker.components.talker and picker == ThePlayer then
            ThePlayer.components.talker:Say(GetString(ThePlayer.prefab, "ANNOUNCE_COLD"))
        end
        
		picker.components.moisture:DoDelta(10)
        
    end
	
	if picker.components.temperature ~= nil then
		picker.components.temperature:DoDelta(-5)
	end
	
	if inst.components.workable.workleft > 0 then
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		inst.components.workable.workleft = inst.components.pickable.cycles_left
	else
		if inst.Transform:GetWorldPosition() ~= nil then
			SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		inst:Remove()
	end

	startregen(inst)
	
end

local function makefullfn(inst)
    if inst.components.pickable.cycles_left <= 0 then
        inst.components.workable:SetWorkLeft(1)
        inst:AddTag("dungpile")
        inst.AnimState:PlayAnimation("dead_to_idle")
        inst.AnimState:PushAnimation("idle")
    end
end

local function makebarrenfn(inst)
    inst:Remove()
end


local function snowpilefn(Sim)
	-- print ('sandhillfn')
	local inst = CreateEntity()
	inst.OnLongUpdate = LongUpdate
	inst.OnSave = onsave
	inst.OnLoad = onload
	inst.OnEntityWake = onwake
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	anim:SetBuild("snowpile")
	anim:SetBank("sand_dune")
	anim:PlayAnimation(anims[#anims])
	
	inst.entity:SetPristine()
	
	MakeObstaclePhysics(inst, 2, 0)
	
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
	inst:AddTag("snowpileradius")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    RemovePhysicsColliders(inst)
	--local xscale = 0 + math.random(0.3,0.5)
	--local yscale = 0 + math.random(0.1,0.3)
	
	
	inst:AddComponent("aura")
    inst.components.aura.radius = 2
    inst.components.aura.tickperiod = TUNING.TOADSTOOL_SPORECLOUD_TICK
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    inst._coldtask = inst:DoPeriodicTask(inst.components.aura.tickperiod / 2, DoAreaColdness, inst.components.aura.tickperiod / 2)

	--inst:AddComponent("unevenground")
    --inst.components.unevenground.radius = 2
	
	inst.OnLongUpdate = LongUpdate
	----------------------
	inst:AddComponent("inspectable")
	----------------------
	inst:AddComponent("lootdropper")

	--full, med, low
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(workcallback)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

    inst.components.pickable.getregentimefn = 0
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.max_cycles = 3
    inst.components.pickable.cycles_left = 1
    inst.components.pickable:SetUp("ice",0)
    inst.components.pickable.transplanted = true
	
	SpawnPrefab("splash_snow_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	startregen(inst)
	
	return inst
end

return Prefab( "snowpile", snowpilefn, assets, prefabs)
