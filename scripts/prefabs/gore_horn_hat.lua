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


local function speedcheck(inst)

	if inst.binarytoggle == nil then
		inst.binarytoggle = true
	end

	if inst.binarytoggle ~= nil and inst.binarytoggle then
		inst.binarytoggle = false
		print("speedcheck")

		if inst.facing_angle ~= nil then
			inst.facing_angle_old = inst.facing_angle
		end
		inst.facing_angle = inst.Transform:GetRotation() + 180
		if inst.facing_angle == nil then
			inst.facing_angle_old = inst.facing_angle
		end

		inst.angleadjustment1 = 0
		inst.angleadjustment2 = 0
		
		if inst.facing_angle_old ~= nil and inst.facing_angle_old < 15 and inst.facing_angle > 345 then
			inst.angleadjustment1 = 360
		elseif inst.facing_angle_old ~= nil and inst.facing_angle_old > 345 and inst.facing_angle < 15 then
			inst.angleadjustment2 = -360
		end
		
		if inst.components.inventory and inst.components.inventory:EquipHasTag("gore_horn") and inst.facing_angle ~= nil and inst.facing_angle_old ~= nil and
		(inst.facing_angle >= inst.facing_angle_old + inst.angleadjustment2 - 10 and inst.facing_angle <= inst.facing_angle_old + inst.angleadjustment1 + 10)
		and inst.components.locomotor ~= nil
		and not inst.components.rider:IsRiding() then
			if inst.runspeed == nil then
				inst.runspeed = 1
			elseif inst.runspeed ~= nil and inst.runspeed < 2.5 then
				if inst.facing_angle ~= nil and inst.facing_angle_old ~= nil and (inst.facing_angle >= inst.facing_angle_old + inst.angleadjustment2 - 2 and inst.facing_angle <= inst.facing_angle_old + inst.angleadjustment1 + 2) then
					inst.runspeed = inst.runspeed + 0.02
				elseif inst.runspeed > 1 then
					inst.runspeed = inst.runspeed - 0.02
				end
			end
			
			if inst.runspeed >= 2.5 and inst.physbox == nil then
				inst.physbox = SpawnPrefab("gore_horn_physbox")
				inst.physbox.AnimState:SetFinalOffset(-1)
				inst.physbox.Physics:Teleport(0,0,0)	
				inst:AddChild(inst.physbox)
			end
			
			
			
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_minotaur/pawground", nil, inst.runspeed / 3)
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "gore_horn", inst.runspeed)
		else
			if inst.physbox ~= nil then
				inst.physbox:Remove()
				inst.physbox = nil
			end
			inst.runspeed = 1
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "gore_horn") 
		end
	else
		inst.binarytoggle = true
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
		
		owner:ListenForEvent("locomote", speedcheck)
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

		owner:RemoveEventCallback("locomote", speedcheck)
		
		owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "gore_horn") 
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
        inst:AddTag("gore_horn")
 
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

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

        MakeHauntableLaunch(inst)

        return inst
    end
	
	local function oncollide(inst, other)
		if other ~= nil and not other:HasTag("player") and other:IsValid() then
			SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst:Remove()
		end
	end

	local function physboxfn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddPhysics()
        inst.entity:AddNetwork()
		
		inst.AnimState:SetBank("hardshelltacos")
		inst.AnimState:SetBuild("hardshelltacos")
		inst.AnimState:PlayAnimation("idle")
		inst:AddTag("NOCLICK")

		inst.Physics:SetCollisionGroup(COLLISION.ITEMS)
		inst:SetPhysicsRadiusOverride(3)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)

        inst:AddTag("fx")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst.Physics:SetCollisionCallback(oncollide)

		inst.persists = false

        return inst
    end

return Prefab( "gore_horn_hat", fn, assets),
		Prefab( "gore_horn_physbox", physboxfn, assets)