local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local brain = require("brains/bigwobybrain")

local function checkfav(inst, food)
	if food ~= nil and (food.prefab == "monstermeat_dried" or food.prefab == "monstersmallmeat_dried") then
		inst.components.hunger:DoDelta(15)
	end
end

local function OnAttacked(inst, food)
	inst.AnimState:PlayAnimation("hit")
end

local function TriggerTransformation(inst)
    if inst.sg.currentstate.name ~= "transform" and not inst.transforming then
        inst.persists = false
        inst:AddTag("NOCLICK")
        inst.transforming = true

        inst.components.rideable.canride = false

        if inst.components.container:IsOpen() then
            inst.components.container:Close()
        end

        if inst.components.rideable:IsBeingRidden() then
            --SG won't handle "transformation" event while we're being ridden
            --SG is forced into transformation state AFTER dismounting (OnRiderChanged)
            inst.components.rideable:Buck(true)
        else
            inst:PushEvent("transform")
        end
    end
	
	inst:DoPeriodicTask(1, function(inst)
        inst.transforming = false
		TriggerTransformation(inst)
	end)
end

local function OnHungerDelta2(inst, data)
    if data.newpercent <= 0.3 then
		TriggerTransformation(inst)
    end
	
	if data.newpercent <= 0.4 and inst.hungerpercent ~= 0.4 then
		inst.hungerpercent = 0.4
			
		if inst._playerlink ~= nil and data.newpercent < data.oldpercent then
			inst._playerlink.components.talker:Say(GetString(inst._playerlink, "ANNOUNCE_BIGWOBYHUNGRY"))
		end
	elseif data.newpercent <= 0.6 and data.newpercent > 0.4 and inst.hungerpercent ~= 0.6 then
		inst.hungerpercent = 0.6
		
		if inst._playerlink ~= nil and data.newpercent < data.oldpercent then
			inst._playerlink.components.talker:Say(GetString(inst._playerlink, "ANNOUNCE_BIGWOBYNORMAL"))
		end
	elseif data.newpercent <= 0.8 and data.newpercent > 0.6 and inst.hungerpercent ~= 0.8 then
		inst.hungerpercent = 0.8
		
		if inst._playerlink ~= nil and data.newpercent < data.oldpercent then
			inst._playerlink.components.talker:Say(GetString(inst._playerlink, "ANNOUNCE_BIGWOBYFULL"))
		end
	elseif data.newpercent > 0.8 then
		inst.hungerpercent = 1
	end
	
	if inst._playerlink ~= nil then
		inst._playerlink:PushEvent("updatewobyhunger", {wobyhunger = inst.components.hunger:GetPercent()})
	end
end

local function ResetSanityHit(inst)
	inst.sanityhittask = nil
end

local function ResetWalterWorry(inst)
	inst.walterworrytask = nil
end

local function redirect_to_hunger(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
	if inst.sanityhittask == nil and inst._playerlink ~= nil and inst._playerlink.components.sanity ~= nil then
		inst.sanityhittask = inst:DoTaskInTime(.3, ResetSanityHit)
		
		if inst.walterworrytask == nil and inst._playerlink ~= nil and inst._playerlink.components.talker then
			inst._playerlink.components.talker:Say(GetString(inst._playerlink, "ANNOUNCE_WOBY_HURT"))
			inst.walterworrytask = inst:DoTaskInTime(10, ResetWalterWorry)
		end
		
		inst._playerlink.components.sanity:DoDelta(amount / 20)
	end
	
	--[[if amount ~= nil and amount < 0 then
		inst.components.hunger:DoDelta(amount)
		
		if inst.components.hunger:GetPercent() <= 0.2 then
			TriggerTransformation(inst)
		end
	end]]
end

local function inspect_woby(inst, viewer)
	local wobyhunger = inst.components.hunger:GetPercent()

    return (viewer ~= nil and viewer:HasTag("pinetreepioneer") and
		(wobyhunger >= 0.8 and "FULL" or
		wobyhunger < 0.8 and wobyhunger >= 0.6 and "GENERIC" or
		wobyhunger < 0.6 and wobyhunger >= 0.4 and "HUNGRY" or
		wobyhunger < 0.4 and "STARVING")
		) or "GENERIC"
end

local function CheckForMoreTargets(inst)
	inst.components.combat:DropTarget()
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 17, nil, { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive" })
				
	for i, v in ipairs(ents) do
		if inst.wobytarget ~= nil and inst.wobytarget:IsValid() and not inst.wobytarget:HasTag("outofreach") and not inst.wobytarget:HasTag("INLIMBO") or inst.components.hunger:GetPercent() == 0 then
			if inst._playerlink ~= nil and inst._playerlink:IsValid() and inst.wobytarget ~= nil and inst.wobytarget:IsValid() and not inst._playerlink:IsNear(inst.wobytarget, 35) then
				inst.oldwobytarget = inst.wobytarget
				inst.wobytarget = nil
			end
			
			break
		end

		if v ~= nil and not v:HasTag("INLIMBO") and inst.oldwobytarget ~= nil and v ~= inst.oldwobytarget and v.prefab == inst.oldwobytarget.prefab and v:IsValid() then
			if v.components.pickable == nil and v.components.harvestable == nil or v.components.pickable ~= nil and v.components.pickable.canbepicked and v.components.pickable.caninteractwith or v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() and v.components.combat == nil then
				if v.components.inventoryitem then
					for k = 1, inst.components.container.numslots do
						if inst.components.container:GetItemInSlot(k) ~= nil and inst.components.container:GetItemInSlot(k).prefab == v.prefab and inst.components.container:GetItemInSlot(k).components.stackable ~= nil and not inst.components.container:GetItemInSlot(k).components.stackable:IsFull() then
							inst.wobytarget = v

							break
						elseif not inst.components.container:IsFull() then
							inst.wobytarget = v

							break
						end
					end
				else
					inst.wobytarget = v
					
					break
				end
			end
		end
	end
end

local function RemoveTarget(inst)
	inst.oldwobytarget = nil
	inst.wobytarget = nil
end

env.AddPrefabPostInit("wobybig", function(inst)

	inst:AddTag("customwobytag")
	inst:AddTag("noauradamage")
	inst:AddTag("tiddlevirusimmune")
    inst:AddTag("notraptrigger")
    --inst:RemoveTag("peacefulmount")
	
	if not TheWorld.ismastersim then
		return
	end
	
    inst:SetBrain(brain)
	
	inst.hungerpercent = 1
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetOnEatFn(checkfav)
	end
	
	if inst.components.hunger ~= nil then
        inst.components.eater:SetStrongStomach(true)
		inst:ListenForEvent("hungerdelta", OnHungerDelta2)
	end
		
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(500)
	inst.components.health:SetAbsorptionAmount(1)
	inst.components.health.redirect = redirect_to_hunger

	inst:RemoveComponent("freezable")
	inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
	
	inst:AddComponent("combat")
	
	if inst.components.follower ~= nil then
		inst.components.follower:KeepLeaderOnAttacked()
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.getstatus = inspect_woby
	end
	
	if inst.components.health ~= nil then
		inst.components.health.canheal = false
	end
	
	inst:ListenForEvent("woby_dropped_item", function(inst, data)
		if inst._playerlink ~= nil and inst._playerlink.components.health ~= nil and not inst._playerlink.components.health:IsDead() then
			if data.dropped_item == nil or data.dropped_item ~= nil and not data.dropped_item:HasTag("heavy") then
				inst._playerlink.components.talker:Say(GetString(inst._playerlink, "ANNOUNCE_WOBY_TOOFULL"))
			end
			
			inst.wobytarget = nil
			inst.oldwobytarget = nil
		end
	end)
	
    inst:ListenForEvent("riderchanged", RemoveTarget)
	
	inst:DoPeriodicTask(2, CheckForMoreTargets)
end)

