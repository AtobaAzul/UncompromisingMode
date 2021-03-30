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
		
		if inst.components.inventory and inst.components.inventory:EquipHasTag("gore_horn") and inst.sg:HasStateTag("moving") and inst.facing_angle ~= nil and inst.facing_angle_old ~= nil and
		(inst.facing_angle >= inst.facing_angle_old + inst.angleadjustment2 - 10 and inst.facing_angle <= inst.facing_angle_old + inst.angleadjustment1 + 10)
		and inst.components.locomotor ~= nil
		and not inst.components.rider:IsRiding() then
			if inst.runspeed == nil then
				inst.runspeed = 1
			elseif inst.runspeed ~= nil and inst.runspeed < 2.5 then
				if inst.facing_angle ~= nil and inst.facing_angle_old ~= nil and (inst.facing_angle >= inst.facing_angle_old + inst.angleadjustment2 - 3 and inst.facing_angle <= inst.facing_angle_old + inst.angleadjustment1 + 3) then
					inst.runspeed = inst.runspeed + 0.025
				elseif inst.runspeed > 1 then
					inst.runspeed = inst.runspeed - 0.025
				end
			end
			
			if inst.runspeed >= 2.5 and inst.physbox == nil then
				inst.physbox = SpawnPrefab("gore_horn_physbox")
				--inst.physbox.AnimState:SetFinalOffset(-1)
				--inst.physbox.Physics:Teleport(0,0,0)
				inst.physbox.owner = inst
				inst.physbox.entity:AddFollower()
				inst.physbox.Follower:FollowSymbol(inst.GUID, "swap_hat", 0, 80, 0)
			
				--inst:AddChild(inst.physbox)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/charge_LP", "gorehorn")	
			end
			
			--[[if inst.runspeed < 0.25 and inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end]]
			
			--inst.SoundEmitter:SetParameter("gorehorn", "intensity", inst.runspeed / 2.5)
			if inst.task == nil then
				inst.task = inst:DoPeriodicTask(0.27, function(inst) 
					inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/steam", nil, inst.runspeed / 2.5) 
					if inst.runspeed > 2.3 then
						SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
					end
					
					--[[if not inst.sg:HasStateTag("moving") then
						inst.task:Cancel()
						inst.task = nil
					end]]
				end)
			end
			--inst.SoundEmitter:KillSound("gorecharge")
            --inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/charge_LP", "gorecharge", inst.runspeed / 2.5)
			--inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/steam", nil, inst.runspeed / 2.5)
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "gore_horn", inst.runspeed)
		else
			if inst.physbox ~= nil then
				inst.physbox.AnimState:PlayAnimation("close")
				inst.physbox:DoTaskInTime(0.3, inst.Remove)
				inst.physbox = nil
				inst.SoundEmitter:KillSound("gorehorn")
			end
            --inst.SoundEmitter:KillSound("gorecharge")
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
				inst.SoundEmitter:KillSound("gorehorncharge")
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
	
	local function ClearRecentlyCharged(inst, other)
		inst.recentlycharged[other] = nil
	end
	
	local function onothercollide(inst, other)
		if not other:IsValid() or inst.recentlycharged[other] then
			return
		elseif other:HasTag("smashable") and other.components.health ~= nil then
			--other.Physics:SetCollides(false)
			other.components.health:Kill()
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
		elseif other.components.workable ~= nil
			and other.components.workable:CanBeWorked()
			and other.components.workable.action ~= ACTIONS.NET then
			SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
			other.components.workable:Destroy(inst)
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
			if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
				inst.recentlycharged[other] = true
				inst:DoTaskInTime(3, ClearRecentlyCharged, other)
			end
		elseif other.components.health ~= nil and not other.components.health:IsDead() then
			inst.recentlycharged[other] = true
			inst:DoTaskInTime(3, ClearRecentlyCharged, other)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
            other.components.combat:GetAttacked(inst, 50, nil)
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
		end
	end
	
	--[[local function oncollide(inst, other)
		if not (other ~= nil and other:IsValid() and inst:IsValid())
			or inst.recentlycharged[other]
			or other:HasTag("player") then
			--or Vector3(inst.Physics:GetVelocity()):LengthSq() < 42 then
			return
		end
		ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
		inst:DoTaskInTime(2 * FRAMES, onothercollide, other)
	end]]
	
	local NOTAGS = { "fx", "INLIMBO", "shadow", "player" }
	local function oncollide(inst)
		if inst.owner ~= nil then
			local x, y, z = inst.owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 3, nil, NOTAGS)
			for i, v in ipairs(ents) do
				onothercollide(inst, v)
			end
		end
	end

	local function physboxfn()
		local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddPhysics()
        inst.entity:AddNetwork()
		
		inst.AnimState:SetBank("forcefield")
		inst.AnimState:SetBuild("forcefield")
		inst.AnimState:PlayAnimation("open")
		inst.AnimState:PushAnimation("idle_loop", true)
		
		--MakeCharacterPhysics(inst, 50, 1.5)

		--[[inst.Physics:SetCollisionGroup(COLLISION.ITEMS)
		inst.Physics:ClearCollisionMask()
		inst:SetPhysicsRadiusOverride(10)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:SetCapsule(1.5, 1.5)]]

		--inst:AddTag("fx")
		
		inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		--[[inst:AddComponent("locomotor")
		inst.recentlycharged = {}
		inst.Physics:SetCollisionCallback(oncollide)
		inst:ListenForEvent("on_collide", oncollide)]]
		
		inst.owner = nil
		
		inst.recentlycharged = {}
		inst:DoPeriodicTask(0.2, oncollide)
		
		
		inst.persists = false

        return inst
    end

return Prefab( "gore_horn_hat", fn, assets),
		Prefab( "gore_horn_physbox", physboxfn, assets)