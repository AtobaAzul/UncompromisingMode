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

local PICKABLE_FOODS =
{
    berries = true,
    cave_banana = true,
    carrot = true,
    red_cap = true,
    blue_cap = true,
    green_cap = true,
}

local function FindClosestPart(inst)

    if inst.tracking_parts == nil then
        inst.tracking_parts = {}
		local targets = {}
        for k,v in pairs(Ents) do
			--if v:IsValid() and v:IsOnValidGround() then
				if v.components.pickable ~= nil then
					if targets.pickable == nil and
					v.components.pickable.caninteractwith and
					v.components.pickable:CanBePicked() and
					PICKABLE_FOODS[v.components.pickable.product] then
						table.insert(inst.tracking_parts, v)
					end
				end
			--end
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
        local nextpingtime = TUNING.DIVINING_DEFAULTPING
        if target ~= nil then
            local distsq = inst.components.inventoryitem.owner:GetDistanceSqToInst(target)
            intensity = math.max(0, 1 - (distsq/(TUNING.DIVINING_MAXDIST*TUNING.DIVINING_MAXDIST) ))
            for k,v in ipairs(
			{
				{maxdist=25, describe="hot", pingtime=1},
				{maxdist=50, describe="warmer", pingtime=2},
				{maxdist=100, describe="warm", pingtime=4},
				{maxdist=200, describe="cold", pingtime=6},
				{maxdist=300, describe="cold", pingtime=8},
			}) do
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
		
		-->>>>>The original divining rod never kills the ping sound for some reason?<<<<<--
        inst.SoundEmitter:KillSound("ping")
		-->>>>><<<<<--
		
        inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping", "ping")
        inst.SoundEmitter:SetParameter("ping", "intensity", intensity)
        inst.task = inst:DoTaskInTime(nextpingtime or 1, CheckTargetPiece)
    end 
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
		
		if not inst.disabled then
			inst.closeness = nil 
			inst.tracking_parts = nil       
			inst.task = inst:DoTaskInTime(1, CheckTargetPiece)
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

		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		
		if inst.fx ~= nil then
			if inst.fx:IsValid() then
				inst.fx:Remove()
			end
			inst.fx = nil
		end
		
		inst.closeness = nil
    end

	local function describe(inst)
		if inst.components.equippable:IsEquipped() then
			if inst.closeness and inst.closeness.describe then
				return string.upper(inst.closeness.describe)
			end
			return "COLD"
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

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
		inst.components.inspectable.getstatus = describe
		inst.components.inventoryitem.atlasname = "images/inventoryimages/snowgoggles.xml"
		
        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)

        return inst
    end


return Prefab("bearger_mask", fn, assets)