local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function newtentacles(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
		local pt = reader:GetPosition()
		local numtentacles = 3

		reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)

		reader:StartThread(function()
			for k = 1, numtentacles do
				local theta = math.random() * 2 * PI
				local radius = math.random(3, 8)

				local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
					local pos = pt + offset
							--NOTE: The first search includes invisible entities
				return #TheSim:FindEntities(pos.x, 0, pos.z, 1, nil, { "INLIMBO", "FX" }) <= 0
					and TheWorld.Map:IsPassableAtPoint(pos:Get())
					and TheWorld.Map:IsDeployPointClear(pos, nil, 1)
				end)

				if result_offset ~= nil then
					local x, z = pt.x + result_offset.x, pt.z + result_offset.z
					local tentacle = SpawnPrefab("wicker_tentacle")
					tentacle.Transform:SetPosition(x, 0, z)
					tentacle.sg:GoToState("attack_pre")

					--need a better effect
					SpawnPrefab("shadow_puff").Transform:SetPosition(x, 0, z)
					ShakeAllCameras(CAMERASHAKE.FULL, .2, .02, .25, reader, 40)
				end

				Sleep(.33)
			end
		end)
		return true
	else
		return false
	end
end

env.AddPrefabPostInit("book_tentacles", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newtentacles
	end
end)

local function newsleep(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            local x, y, z = reader.Transform:GetWorldPosition()
            local range = 30
            local ents = TheNet:GetPVPEnabled() and
                        TheSim:FindEntities(x, y, z, range, nil, { "playerghost", "FX", "DECOR", "INLIMBO" }, { "sleeper", "player" }) or
                        TheSim:FindEntities(x, y, z, range, { "sleeper" }, { "player", "FX", "DECOR", "INLIMBO" })
            for i, v in ipairs(ents) do
                if v ~= reader and
                    not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                    not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                    not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
                    local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                    if mount ~= nil then
                        mount:PushEvent("ridersleep", { sleepiness = 10, sleeptime = 20 })
                    end
                    if v.components.sleeper ~= nil then
                        v.components.sleeper:AddSleepiness(10, 20)
                    elseif v.components.grogginess ~= nil then
                        v.components.grogginess:AddGrogginess(10, 20)
                    else
                        v:PushEvent("knockedout")
                    end
                end
            end
            return true
	else
		return false
	end
end

env.AddPrefabPostInit("book_sleep", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newsleep
	end
end)

local GARDENING_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO" }

local SILVICULTURE_ONEOF_TAGS = { "silviculture", "tree" }
local SILVICULTURE_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO" }

local HORTICULTURE_CANT_TAGS = { "pickable", "stump", "withered", "barren", "INLIMBO", "silviculture", "tree" }

local function trygrowth(inst)
    if not inst:IsValid()
		or inst:IsInLimbo()
        or (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then

        return false
    end

    if inst.components.pickable ~= nil then
        if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
            return false
        end
        if inst.components.pickable:FinishGrowing() then
			inst.components.pickable:ConsumeCycles(1) -- magic grow is hard on plants
			return true
		end
    end

    if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
        if inst.components.crop:DoGrow(1 / inst.components.crop.rate, true) then
			return true
		end
    end

    if inst.components.growable ~= nil then
        -- If we're a tree and not a stump, or we've explicitly allowed magic growth, do the growth.
        if inst.components.growable.magicgrowable or ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) then
			if inst.components.growable.domagicgrowthfn ~= nil then
				return inst.components.growable:DoMagicGrowth()
			else
	            return inst.components.growable:DoGrowth()
			end
        end
    end

    if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
        if inst.components.harvestable:Grow() then
			return true
		end
    end

	return false
end

local function GrowNext(spell, reader)
	while spell._next <= #spell._targets do
		local target = spell._targets[spell._next]
		spell._next = spell._next + 1

		if target:IsValid() and trygrowth(target) then
			spell._count = spell._count + 1
			if spell._count < TUNING.BOOK_GARDENING_MAX_TARGETS then
				spell:DoTaskInTime(0.1 + 0.3 * math.random(), GrowNext)
				return
			else
				break
			end
		end
	end

	spell:Remove() 
end

local function do_book_horticulture_spell(spell, reader)
    local x, y, z = reader.Transform:GetWorldPosition()
    local range = 30
    spell._targets = TheSim:FindEntities(x, y, z, range, nil, HORTICULTURE_CANT_TAGS)
	if #spell._targets == 0 then
		spell:Remove()
		return
	end

	spell._next = 1
	spell._count = 0
	GrowNext(spell, reader)
end

local function newgarden(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
		reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

		local spell = SpawnPrefab("book_horticulture_spell")
		spell.Transform:SetPosition(reader.Transform:GetWorldPosition())
		do_book_horticulture_spell(spell, reader)

		return true
	else
		return false
	end
end

--[[env.AddPrefabPostInit("book_gardening", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newgarden
	end
end)]]

env.AddPrefabPostInit("book_horticulture", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newgarden
	end
end)

local function newsilvagunner(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
		reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

        local x, y, z = reader.Transform:GetWorldPosition()
        local range = 30
		local ents = TheSim:FindEntities(x, y, z, range, nil, SILVICULTURE_CANT_TAGS, SILVICULTURE_ONEOF_TAGS)
		if #ents > 0 then
		trygrowth(table.remove(ents, math.random(#ents)))
			if #ents > 0 then
				local timevar = 1 - 1 / (#ents + 1)
				for i, v in ipairs(ents) do
					v:DoTaskInTime(timevar * math.random(), trygrowth)
				end
			end
		end
        return true
	else
		return false
	end
end

env.AddPrefabPostInit("book_silviculture", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newsilvagunner
	end
end)

local function newbrimstone(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
            local pt = reader:GetPosition()
            local num_lightnings = 16

            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            reader:StartThread(function()
                for k = 0, num_lightnings do
                    local rad = math.random(3, 15)
                    local angle = k * 4 * PI / num_lightnings
                    local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
                    TheWorld:PushEvent("ms_sendlightningstrike", pos)
                    Sleep(.3 + math.random() * .2)
                end
            end)
            return true
	else
		return false
	end
end

env.AddPrefabPostInit("book_brimstone", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newbrimstone
	end
end)

local function newbirds(inst, reader)
	if reader.components.sanity ~= nil and not reader.components.sanity:IsInsane() then
            local birdspawner = TheWorld.components.birdspawner
            if birdspawner == nil then
                return false
            end

            local pt = reader:GetPosition()

            reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
            
            --we can actually run out of command buffer memory if we allow for infinite birds
            local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 10, nil, nil, { "magicalbird" })
            if #ents > 30 then
                reader.components.talker:Say(GetString(reader, "ANNOUNCE_WAYTOOMANYBIRDS"))
            else
                local num = math.random(10, 20)
                if #ents > 20 then
                    reader.components.talker:Say(GetString(reader, "ANNOUNCE_TOOMANYBIRDS"))
                else
                    num = num + 10
                end
                reader:StartThread(function()
                    for k = 1, num do
                        local pos = birdspawner:GetSpawnPoint(pt)
                        if pos ~= nil then
                            local bird = birdspawner:SpawnBird(pos, true)
                            if bird ~= nil then
                               bird:AddTag("magicalbird")
                            end
                        end
                        Sleep(math.random(.2, .25))
                    end
                end)
            end

            return true
	else
		return false
	end
end

env.AddPrefabPostInit("book_birds", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book ~= nil then
        inst.components.book.onread = newbirds
	end
end)

env.AddPrefabPostInit("plant_normal_ground", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("wormwood_plant_ground")
	
end)