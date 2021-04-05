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

local function fuelme(inst)
	if inst.components.fueled:GetPercent() < 1 then
		if inst.pausedfuel then
			inst.components.fueled:DoDelta(10)
		end
		if inst.components.fueled:GetPercent() >= 1 then
			if inst.fuelmetask ~= nil then
				inst.fuelmetask:Cancel()
				inst.fuelmetask = nil
			end
		end
	else
		if inst.fuelmetask ~= nil then
			inst.fuelmetask:Cancel()
			inst.fuelmetask = nil
		end
	end
end

local function reducespeed(inst)
	inst.runspeed = 1
	if inst.physbox ~= nil then
		inst.physbox = nil
	end
	inst.SoundEmitter:KillSound("gorehorn")
	
	inst.gorehorn.components.fueled:DoDelta(-50)
end

local function unpausefueled(inst)
	inst.pausedfuel = true
	if inst.fuelmetask == nil then
		inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)
	end
end

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
		
		if inst.facing_angle_old ~= nil and inst.facing_angle_old < 10 and inst.facing_angle > 350 then
			inst.angleadjustment1 = 360
		elseif inst.facing_angle_old ~= nil and inst.facing_angle_old > 350 and inst.facing_angle < 10 then
			inst.angleadjustment2 = -360
		end
		
		if inst.gorehorn ~= nil and inst.gorehorn.components.fueled:GetPercent() > 0 and inst.components.inventory and inst.components.inventory:EquipHasTag("gore_horn") and inst.sg:HasStateTag("moving") and inst.facing_angle ~= nil and inst.facing_angle_old ~= nil and
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
			
			if inst.runspeed >= 2 and inst.physbox == nil then
				inst.physbox = SpawnPrefab("gore_horn_physbox")
				inst.physbox.owner = inst
				inst.physbox.entity:AddFollower()
				inst.physbox.Follower:FollowSymbol(inst.GUID, "swap_hat", 0, 90, 0)
				
				inst:ListenForEvent("onremove", function(inst) 
					if inst.runspeed ~= nil then 
						inst.runspeed = 1
					end
				end, inst.physbox)
				inst:ListenForEvent("gore_horn_collision", reducespeed)
			
				inst.SoundEmitter:PlaySound("dontstarve/creatures/rook_nightmare/charge_LP", "gorehorn")	
			end
			
			if inst.task == nil then
				inst.task = inst:DoPeriodicTask(0.27, function(inst) 
					inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/steam", nil, inst.runspeed / 2) 
					if inst.runspeed > 1.7 then
						SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
					end
				end)
			end
			
			inst.components.locomotor:SetExternalSpeedMultiplier(inst, "gore_horn", inst.runspeed)
			if inst.runspeed >= 2 then
				inst.gorehorn.components.fueled:DoDelta(-1)
				inst.gorehorn.pausedfuel = false
				if inst.gorehorn.unpausefueledtask ~= nil then
					inst.gorehorn.unpausefueledtask:Cancel()
					inst.gorehorn.unpausefueledtask = nil
				end
				inst.gorehorn.unpausefueledtask = inst.gorehorn:DoTaskInTime(3, unpausefueled)
			end
		else
			if inst.physbox ~= nil then
				inst.physbox.AnimState:PlayAnimation("close")
				inst.physbox:DoTaskInTime(0.3, inst.physbox.Remove)
				inst.physbox = nil
				inst.SoundEmitter:KillSound("gorehorn")
			end

			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
				inst.SoundEmitter:KillSound("gorehorncharge")
			end
			
			inst.runspeed = 1
			inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "gore_horn") 
			
			inst:RemoveEventCallback("gore_horn_collision", reducespeed)
		end
	else
		inst.binarytoggle = true
	end
end
	
local function onequip(inst, owner)
	if not owner:HasTag("vetcurse") then
		inst:DoTaskInTime(0, function(inst, owner)
			local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner
			local tool = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if tool ~= nil and owner ~= nil then
				owner.components.inventory:Unequip(EQUIPSLOTS.HEAD)
				owner.components.inventory:DropItem(tool)
				owner.components.inventory:GiveItem(inst)
				owner.components.talker:Say(GetString(owner, "CURSED_ITEM_EQUIP"))
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/HUD_hot_level1")
				
				owner.components.combat:GetAttacked(inst, 0.1, nil)
			end
		end)
	else
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
		
		owner.gorehorn = inst
		
		owner:ListenForEvent("locomote", speedcheck)
	end
	
	if inst.fuelmetask == nil then
		inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)
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

		owner:RemoveEventCallback("locomote", speedcheck)
		
		if owner.physbox ~= nil then
			owner.physbox.AnimState:PlayAnimation("close")
			owner.physbox:DoTaskInTime(0.3, owner.physbox.Remove)
			owner.physbox = nil
			owner.SoundEmitter:KillSound("gorehorn")
		end

		if owner.task ~= nil then
			owner.task:Cancel()
			owner.task = nil
			owner.SoundEmitter:KillSound("gorehorncharge")
		end
		
		owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "gore_horn") 
		
		if inst.fuelmetask == nil then
			inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)
		end
	
    end
	
	local function stoprunning(inst)
		inst.pausedfuel = true
    end
	
	local function checkiffull(inst)
		if inst.components.fueled:GetPercent() >= 1 then
			inst.pausedfuel = false
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
		
		inst:AddComponent("fueled")
		inst.components.fueled:InitializeFuelLevel(100)
		inst.components.fueled.accepting = false
		inst.components.fueled:SetDepletedFn(stoprunning)
		inst:ListenForEvent("percentusedchange", checkiffull)
		
		inst.fueltask = nil
		inst.fuelmetask = nil
		inst.pausedfuel = true
		inst.readytorun = true
		
		if inst.fuelmetask == nil then
			inst.fuelmetask = inst:DoPeriodicTask(0.5, fuelme)
		end

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
	
	local function onothercollide(inst, other,owner)
		if not other:IsValid() or inst.recentlycharged[other] then
			return
		elseif other:HasTag("smashable") and other.components.health ~= nil then
			other.components.health:Kill()
			
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
			
			inst.AnimState:PlayAnimation("close")
			inst:DoTaskInTime(0.3, inst.Remove)
			
			if inst.owner ~= nil then
				inst.owner:PushEvent("gore_horn_collision")
			end
		elseif other.components.workable ~= nil
			and other.components.workable:CanBeWorked()
			and other.components.workable.action ~= ACTIONS.NET then
			SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
			other.components.workable:Destroy(owner)
			if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
				inst.recentlycharged[other] = true
				inst:DoTaskInTime(3, ClearRecentlyCharged, other)
			end
			
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
			
			inst.AnimState:PlayAnimation("close")
			inst:DoTaskInTime(0.3, inst.Remove)
			
			if inst.owner ~= nil then
				inst.owner:PushEvent("gore_horn_collision")
			end
		elseif other.components.health ~= nil and not other.components.health:IsDead() then
			inst.recentlycharged[other] = true
			inst:DoTaskInTime(3, ClearRecentlyCharged, other)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
            other.components.combat:GetAttacked(owner, 150, nil)
			
			ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
			
			inst.AnimState:PlayAnimation("close")
			inst:DoTaskInTime(0.3, inst.Remove)
			
			if inst.owner ~= nil then
				inst.owner:PushEvent("gore_horn_collision")
			end
		end
	end
	
	local NOTAGS = { "fx", "INLIMBO", "shadow", "player", "DIG_workable" }
	local function oncollide(inst)
		if inst.owner ~= nil then
			local x, y, z = inst.owner.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 3, nil, NOTAGS)
			for i, v in ipairs(ents) do
				onothercollide(inst, v,inst.owner)
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
		
		inst.AnimState:SetMultColour(0, 0, 0, 1)

		inst:AddTag("fx")
		
		inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		
		inst.owner = nil
		
		inst.recentlycharged = {}
		inst:DoPeriodicTask(0.2, oncollide)
	
		inst.persists = false

        return inst
    end

return Prefab( "gore_horn_hat", fn, assets),
		Prefab( "gore_horn_physbox", physboxfn, assets)