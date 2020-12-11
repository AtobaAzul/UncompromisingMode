local assets =
{
	Asset("ANIM", "anim/hat_snowgoggles.zip"),
	Asset("ATLAS", "images/inventoryimages/gasmask.xml"),
	Asset("IMAGE", "images/inventoryimages/gasmask.tex"),
}

	local SINKHOLD_BLOCKER_TAGS = { "player" }


local EFFECTS =
{
    hot = "dr_hot_loop",
    warmer = "dr_warmer_loop",
    warm = "dr_warm_loop_2",
    cold = "dr_warm_loop_1",
}

local function FindClosestPart(inst)

    if inst.tracking_parts == nil then
        inst.tracking_parts = {}
        for k,v in pairs(Ents) do
            if v:HasTag("weapon") then
                table.insert(inst.tracking_parts, v)
            end
        end
    end

    if inst.tracking_parts then
        local closest = nil
        local closest_dist = nil
        for k,v in pairs(inst.tracking_parts) do
            if v:IsValid() and not v:IsInLimbo() then
                local dist = v:GetDistanceSqToInst(inst)
                if not closest_dist or dist < closest_dist then
                    closest = v
                    closest_dist = dist
                end
            end
        end

        return closest
    end

end

local function CheckTargetPiece(inst)
    if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner then
        local intensity = 0
        local closeness = nil
        local fxname = nil
        local target = FindClosestPart(inst)
        local nextpingtime = TUNING.DIVINING_DEFAULTPING * 2
        if target ~= nil then
            local distsq = inst.components.inventoryitem.owner:GetDistanceSqToInst(target)
            intensity = math.max(0, 1 - (distsq/(TUNING.DIVINING_MAXDIST*TUNING.DIVINING_MAXDIST) ))
            for k,v in ipairs(TUNING.DIVINING_DISTANCES) do
                closeness = v
                fxname = EFFECTS[v.describe]

                if v.maxdist and distsq <= v.maxdist*v.maxdist then
                    nextpingtime = closeness.pingtime
                    break
                end
            end
        end

        if closeness ~= inst.closeness then
            inst.closeness = closeness
            local desc = inst.components.inspectable:GetDescription(inst.components.inventoryitem.owner)
            if desc then
                inst.components.inventoryitem.owner.components.talker:Say(desc)
            end
        end

        if fxname ~= nil then
            --Don't care if there is still a reference to previous fx...
            --just let it finish on its own and remove itself
            inst.fx = SpawnPrefab(fxname)
            inst.fx.entity:AddFollower()
            inst.fx.Follower:FollowSymbol(inst.components.inventoryitem.owner.GUID, "swap_hat", 80, -320, 0)
        end

        inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping", "ping")
        inst.SoundEmitter:SetParameter("ping", "intensity", intensity)
        inst.task = inst:DoTaskInTime(nextpingtime or 5, CheckTargetPiece)
    end 
end


	local function woodlegs_spawntreasure(inst)
	
	if inst.checktask == nil then
        inst.checktask = inst:DoTaskInTime(5, CheckTargetPiece)
	end
	
	
	
		--[[if isload then
			return
		end

		local equipper = inst and inst.components.equippable and inst.components.equippable.equipper

		if equipper and not equipper:HasTag("player") and math.random() > 0.66 then
			--don't always give treasure if not the player.
			return
		end
		--]]
		print("callback")
	local pos = inst:GetPosition()
		
	local x = GetRandomWithVariance(pos.x, TUNING.ANTLION_SINKHOLE.RADIUS)
    local z = GetRandomWithVariance(pos.z, TUNING.ANTLION_SINKHOLE.RADIUS)

    local function IsValidSinkholePosition(offset)
		print("isval")
        local x1, z1 = x + offset.x, z + offset.z
        if #TheSim:FindEntities(x1, 0, z1, 500, SINKHOLD_BLOCKER_TAGS) > 0 then
            print("false1")
			return false
        end
        for dx = -1, 1 do
            for dz = -1, 1 do
                if not TheWorld.Map:IsPassableAtPoint(x1 + dx * TUNING.ANTLION_SINKHOLE.RADIUS, 0, z1 + dz * TUNING.ANTLION_SINKHOLE.RADIUS, false, true) then
                    print("false2")
					return false
                end
            end
        end
		print("true")
        return true
    end

    local offset = Vector3(0, 0, 0)
    offset =
        IsValidSinkholePosition(offset) and offset or
        FindValidPositionByFan(math.random() * 2 * PI, 1000, 9, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, 1000, 17, IsValidSinkholePosition) or
        FindValidPositionByFan(math.random() * 2 * PI, 1000, 17, IsValidSinkholePosition) or
        nil

    if offset ~= nil then
		print("off~nil")
        local sinkhole = SpawnPrefab("nightstick")
        sinkhole.Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
		
		
		
	--[[
		local pos = inst:GetPosition()
		local offset = FindGroundOffset(pos, math.random() * 2 * math.pi, math.random(25, 30), 18)

		if offset then
			local spawn_pos = pos + offset
		    local tile = GetVisualTileType(spawn_pos:Get())
    		local is_water = GetMap():IsWater(tile)
    		local treasure = SpawnPrefab("buriedtreasure")

    		treasure.Transform:SetPosition(spawn_pos:Get())
    		treasure:SetRandomTreasure()

    		if equipper then
    			inst.components.equippable.equipper:PushEvent("treasureuncover")
    		end
		end]]
	end
	
	local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "hat_mole", "swap_hat")

        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
			owner.AnimState:Hide("HEAD")
		
		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end
		

        if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
		
		if inst.task ~= nil then
			inst.task:Cancel()
		end
		
		if inst.task == nil then
			inst.closeness = nil
			inst.tracking_parts = nil
			inst.task = inst:DoTaskInTime(5, woodlegs_spawntreasure)
		end
    end

	local function onunequip(inst, owner)

        owner.AnimState:ClearOverrideSymbol("swap_hat")
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then
            inst.components.fueled:StopConsuming()
        end
		
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
    end

	local function fn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("hat_mole")
        inst.AnimState:SetBuild("molehat")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")
		
        inst:AddTag("goggles")

        MakeInventoryFloatable(inst)

        inst.entity:SetPristine()
		
        inst.components.floater:SetSize("med")
        inst.components.floater:SetVerticalOffset(0.1)
        inst.components.floater:SetScale(0.63)

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/snowgoggles.xml"

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

        MakeHauntableLaunch(inst)
		--------------------------------------------------------------
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = FUELTYPE.USAGE
        inst.components.fueled:InitializeFuelLevel(100)
        inst.components.fueled:SetDepletedFn(--[[generic_perish]]inst.Remove)
		inst.components.fueled:SetSectionCallback(woodlegs_spawntreasure)

        inst:AddComponent("insulator")
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

        return inst
    end


return Prefab( "rat_hat", fn, assets)