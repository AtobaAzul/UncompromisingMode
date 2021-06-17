local assets =
{
	Asset("ANIM", "anim/hat_corvus.zip"),
}

local SCARYTOPREY_TAGS = { "scarytoprey" }
local function IsDangerNearby(x, y, z)
    local ents = TheSim:FindEntities(x, y, z, 8, SCARYTOPREY_TAGS)
    return next(ents) ~= nil
end

local function SpawnCrow(inst, spawnpoint, ignorebait)

	local robin = inst.components.container:Has("feather_robin", 1)
	local robin_winter = inst.components.container:Has("feather_robin_winter", 1)
	local crow = inst.components.container:Has("feather_crow", 1)
	local canary = inst.components.container:Has("feather_canary", 1)
	
	if robin then
		inst.birdtype = "robin"
	elseif robin_winter then
		inst.birdtype = "robin_winter"
	elseif crow then
		inst.birdtype = "crow"
	elseif canary then
		inst.birdtype = "canary"
	end
		
    local prefab = "crow"
	
    if inst.birdtype == nil then
        return
	end
	
    local prefab = inst.birdtype
	
    if prefab == nil then
        return
    end

    local bird = SpawnPrefab(prefab)
    if math.random() < .5 then
        bird.Transform:SetRotation(180)
    end
    if bird:HasTag("bird") then
        spawnpoint.y = 15
    end

    --see if there's bait nearby that we might spawn into
    if bird.components.eater and not ignorebait then
        local bait = TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 15)
        for k, v in pairs(bait) do
            local x, y, z = v.Transform:GetWorldPosition()
            if bird.components.eater:CanEat(v) and not v:IsInLimbo() and
                v.components.bait and
                not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) and
                not IsDangerNearby(x, y, z) and
                (bird.components.floater ~= nil or TheWorld.Map:IsPassableAtPoint(x, y, z)) then
                spawnpoint.x, spawnpoint.z = x, z
                bird.bufferedaction = BufferedAction(bird, v, ACTIONS.EAT)
                break
            elseif v.components.trap and
                v.components.trap.isset and
                (not v.components.trap.targettag or bird:HasTag(v.components.trap.targettag)) and
                not v.components.trap.issprung and
                math.random() < TUNING.BIRD_TRAP_CHANCE and
                not IsDangerNearby(x, y, z) then
                spawnpoint.x, spawnpoint.z = x, z
                break
            end
        end
    end

    bird.Physics:Teleport(spawnpoint:Get())

    return bird
end

local BIRDBLOCKER_TAGS = {"birdblocker"}
local function GetSpawnPoint(pt)
    --We have to use custom test function because birds can't land on creep
    local function TestSpawnPoint(offset)
        local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()
        local allow_water = true
        local moonstorm = false
        if TheWorld.net.components.moonstorms and next(TheWorld.net.components.moonstorms:GetMoonstormNodes()) then
            local node_index = TheWorld.Map:GetNodeIdAtPoint(spawnpoint_x, 0, spawnpoint_z)
            local nodes = TheWorld.net.components.moonstorms._moonstorm_nodes:value()
            for i, node in pairs(nodes) do
                if node == node_index then
                    moonstorm = true
                    break
                end
            end
        end

        return TheWorld.Map:IsPassableAtPoint(spawnpoint_x, spawnpoint_y, spawnpoint_z, allow_water) and
               TheWorld.Map:GetTileAtPoint(spawnpoint_x, spawnpoint_y, spawnpoint_z) ~= GROUND.OCEAN_COASTAL_SHORE and
               not TheWorld.GroundCreep:OnCreep(spawnpoint_x, spawnpoint_y, spawnpoint_z) and
               #(TheSim:FindEntities(spawnpoint_x, 0, spawnpoint_z, 4, BIRDBLOCKER_TAGS)) == 0 and
               not moonstorm
    end

    local theta = math.random() * 2 * PI
    local radius = 6 + math.random() * 6
    local resultoffset = FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

    if resultoffset ~= nil then
        return pt + resultoffset
    end
end

local function CalcValue(player, basevalue, modifier)
	local ret = basevalue
	local attractor = player and player.components.birdattractor
	if attractor then
		ret = ret + attractor.spawnmodifier:CalculateModifierFromKey(modifier)
	end
	return ret
end

local BIRD_MUST_TAGS = { "bird" }
local function SpawnCrowForPlayer(inst, reschedule)
	local owner = inst.components.inventoryitem.owner
	
	if owner ~= nil then
		local pt = owner:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 64, BIRD_MUST_TAGS)
		if #ents < CalcValue(inst, TUNING.BIRD_SPAWN_MAX, "maxbirds") then
			local spawnpoint = GetSpawnPoint(pt)
			if spawnpoint ~= nil then
				SpawnCrow(inst, spawnpoint)
			end
		end
	end
end

	local function onequip(inst, owner)
	
		owner.AnimState:OverrideSymbol("swap_hat", "hat_corvus", "swap_hat")

        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
			owner.AnimState:Hide("HEAD")
		
		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end
		
		if inst.components.container ~= nil then
			inst.components.container:Open(owner)
		end
		
        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
		
		if inst.crowtask ~= nil then
			inst.crowtask:Cancel()
			inst.crowtask = nil
		end
		
		inst.crowtask = inst:DoPeriodicTask(10, SpawnCrowForPlayer)
    end

	local function onunequip(inst, owner)

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
		
		if inst.components.container ~= nil then
			inst.components.container:Close()
		end
        
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
		
		if inst.crowtask ~= nil then
			inst.crowtask:Cancel()
			inst.crowtask = nil
		end
    end

	local function fn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("corvushat")
        inst.AnimState:SetBuild("hat_corvus")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()
		
        inst.components.floater:SetSize("med")
        inst.components.floater:SetVerticalOffset(0.1)
        inst.components.floater:SetScale(0.63)

        if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) 
				inst.replica.container:WidgetSetup("corvushat") 
			end
            return inst
        end

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/corvushat.xml"

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
		
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("corvushat")
		inst.components.container.canbeopened = false

        MakeHauntableLaunch(inst)
		--------------------------------------------------------------
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(TUNING.TOPHAT_PERISHTIME)
        inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)

        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

        return inst
    end


return Prefab( "corvushat", fn, assets)