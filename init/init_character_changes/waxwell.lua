local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
	
TUNING.SHADOWWAXWELL_FUEL_COST = 2
TUNING.SHADOWWAXWELL_HEALTH_COST = -15

TUNING.SHADOWWAXWELL_SANITY_PENALTY =
        {
            SHADOWLUMBER = .2,
            SHADOWMINER = .2,
            SHADOWDIGGER = .2,
            SHADOWDUELIST = .35,
			OLD_SHADOWWAXWELL = .275,
        }
		
TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY = 55

env.AddPrefabPostInit("waxwell", function(inst) 
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("codexumbrareader")

end)

local function doeffects(inst, pos)
    SpawnPrefab("statue_transition").Transform:SetPosition(pos:Get())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(pos:Get())
end

local function canread(inst, reader)
    return (inst.components.sanity:GetMaxWithPenalty() >= TUNING.OLD_SHADOWWAXWELL_SANITY_PENALTY)
end

local function onread(inst, reader)

	if not reader:HasTag("codexumbrareader") then
		return false
	end
	
    --Check sanity
    if not canread(reader) then 
        if reader.components.talker then
            reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOSANITY"))
            return true
        end
    end

    --Check reagent
    if not reader.components.inventory:Has("nightmarefuel", TUNING.SHADOWWAXWELL_FUEL_COST) then
        if reader.components.talker then
            reader.components.talker:Say(GetString(reader.prefab, "ANNOUNCE_NOFUEL"))
            return true
        end
    end

    reader.components.inventory:ConsumeByName("nightmarefuel", TUNING.SHADOWWAXWELL_FUEL_COST)

    --Ok you had everything. Make the image.
    local theta = math.random() * 2 * PI
    local pt = inst:GetPosition()
    local radius = math.random(3, 6)
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	local boatx, boaty, boatz = reader.Transform:GetWorldPosition()
    if offset then
		pt.x = pt.x + offset.x
		pt.z = pt.z + offset.z
		reader.components.petleash:SpawnPetAt(pt.x, 0, pt.z, "old_shadowwaxwell")
        reader.components.sanity:RecalculatePenalty()
        inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
        return true
	else
		reader.components.petleash:SpawnPetAt(boatx, boaty, boatz, "old_shadowwaxwell")
        reader.components.sanity:RecalculatePenalty()
        inst.SoundEmitter:PlaySound("dontstarve/maxwell/shadowmax_appear")
        return true
    end
end

env.AddPrefabPostInit("waxwelljournal", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.prototyper ~= nil then
		--inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PRESTIHATITATOR
	end

    inst:AddComponent("book")
    inst.components.book.onread = onread

end)