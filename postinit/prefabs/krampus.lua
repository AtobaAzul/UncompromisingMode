local env = env
GLOBAL.setfenv(1, GLOBAL)

-----------------------------------------------------------------
-- Krampii will knock the items out of players
-----------------------------------------------------------------

local function OnHitOther(inst, data)
    if data.target ~= nil then
		if inst.components.thief ~= nil then
			inst.components.thief:StealItem(data.target)
		end
	
		if data.target:HasTag("creatureknockbackable") or data.target:HasTag("player") and data.target.components.inventory ~= nil and not data.target:HasTag("fat_gang") and
			not data.target:HasTag("foodknockbackimmune") and
			not (data.target.components.rider ~= nil and data.target.components.rider:IsRiding()) and
			--Don't knockback if you wear marble
			(
			data.target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil or
				not data.target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and
				not data.target.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
			inst.sg:GoToState("taunt")
		end
    end
end

local function CheckLeaving(inst, data)
	if data.statename ~= nil and data.statename == "exit" then
		if not inst.components.health:IsDead() then
			inst.components.health:SetInvincible(false)
			
			inst:DoTaskInTime(1, function()
				inst.components.health:SetInvincible(true)
				local klaus_sack = TheSim:FindFirstEntityWithTag("klaussacklock")
				local current_middleman = TheSim:FindFirstEntityWithTag("krampus_middleman")
				
				if klaus_sack ~= nil and klaus_sack.components.inventory ~= nil then
					inst.components.inventory:TransferInventory(klaus_sack)
				elseif current_middleman ~= nil then
					inst.components.inventory:TransferInventory(current_middleman)
				else
					local middleman = SpawnPrefab("krampus_middleman_inventory")
					middleman.Transform:SetPosition(inst.Transform:GetWorldPosition())
					inst.components.inventory:TransferInventory(middleman)
				end
			end)
		end
	end
end

env.AddPrefabPostInit("krampus", function(inst)
	if not TheWorld.ismastersim then
		return
	end

    inst:AddComponent("thief")
	
    inst:ListenForEvent("onhitother", OnHitOther)
	inst:ListenForEvent("newstate", CheckLeaving)
	inst.components.combat:SetAttackPeriod(TUNING.KRAMPUS_ATTACK_PERIOD)
end)
