local assets =
{
	Asset("ANIM", "anim/sand_dune.zip")
}

local prefabs =
{
	"sand",
}

local startregen

TUNING.SAND_REGROW_TIME = 960 -- sand dune regrow time
TUNING.SAND_REGROW_VARIANCE = 480 -- sand dune regrow variance
TUNING.SAND_DEPLETE_CHANCE = 0.25

-- these should match the animation names to the workleft
local anims = {"low", "med", "full"}

local function onregen(inst)
	inst.components.activatable.inactive = false
	if inst.components.workable.workleft < #anims-1 then
		inst.components.workable:SetWorkLeft(inst.components.workable.workleft+1)
		startregen(inst)
	else
		inst.targettime = nil
	end
end

startregen = function(inst, regentime)

	if inst.components.workable.workleft < #anims-1 then
		-- more to grow
		regentime = regentime or (TUNING.SAND_REGROW_TIME + math.random()*TUNING.SAND_REGROW_VARIANCE)

		if TheWorld.state.issummer then
			regentime = regentime / 2
		elseif TheWorld.state.isspring then
			regentime = regentime * 2
		end

		if inst.task then
			inst.task:Cancel()
		end
		inst.task = inst:DoTaskInTime(regentime, onregen, "regen")
		inst.targettime = GetTime() + regentime
	else
		-- no more to do
		if inst.task then
			inst.task:Cancel()
		end
		inst.targettime = nil
	end

	if inst.components.workable.workleft < 1 then
		inst.AnimState:PlayAnimation(anims[1])
	else
		inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft+1])
	end
end

local function workcallback(inst, worker, workleft)

	if workleft < 0 then
		-- the devtool probably did this, spit out 2
		inst.components.lootdropper:SetLoot({"logs", "logs"})
	else
		inst.components.lootdropper:SetLoot({"logs"})
	end

	if workleft <= 0 then
		inst.components.activatable.inactive = true
	end

	inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper.chancerandomloot = 0.01  -- drop some random item 1% of the time

	inst.components.lootdropper:AddRandomLoot("rock", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_crow", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin", 0.01)
	inst.components.lootdropper:AddRandomLoot("feather_robin_winter", 0.01)
	inst.components.lootdropper:AddRandomLoot("stalker_minion1", 0.001)
	inst.components.lootdropper:AddRandomLoot("stalker_minion2", 0.001)
	inst.components.lootdropper:AddRandomLoot("spider", 0.002)
	inst.components.lootdropper:AddRandomLoot("redgem", 0.002)
	inst.components.lootdropper:AddRandomLoot("stalker_minion1", 0.002)
	inst.components.lootdropper:AddRandomLoot("orangegem", 0.001)

	-- figure out which side to drop the loot
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(worker.Transform:GetWorldPosition())

	local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)
	
	if he_right then
		inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*(.5+math.random())))
	else
		inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5+math.random())))
	end

	--inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandpile")

	startregen(inst)
end

local function onsave(inst, data)
	if inst.targettime then
		local time = GetTime()
		if inst.targettime > time then
			data.time = math.floor(inst.targettime - time)
		end
		data.workleft = inst.components.workable.workleft
	end
end
local function onload(inst, data)

	if data and data.workleft then
		inst.components.workable.workleft = data.workleft

		if data.workleft <= 0 then
			inst.components.activatable.inactive = true
		end

	end
	
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
		if math.random() < TUNING.SAND_DEPLETE_CHANCE and inst.components.workable.workleft > 0 then
			-- the rain made this sandhill shrink
			inst.components.workable.workleft = inst.components.workable.workleft - math.random(0, inst.components.workable.workleft)
			startregen(inst)
		end
	end
end

local function sandhillfn(Sim)
	-- print ('sandhillfn')
	local inst = CreateEntity()
	inst.OnLongUpdate = LongUpdate
	inst.OnSave = onsave
	inst.OnLoad = onload
	inst.OnEntityWake = onwake
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	inst.AnimState:SetBuild("sand_dune")
	inst.AnimState:SetBank("sand_dune")
	inst.AnimState:PlayAnimation(anims[#anims])
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

	----------------------
	inst:AddComponent("inspectable")
	----------------------
	inst:AddComponent("lootdropper")

	--full, med, low
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(#anims-1)
	inst.components.workable:SetOnWorkCallback(workcallback)

	return inst
end

return Prefab( "um_sandhill", sandhillfn, assets, prefabs)
