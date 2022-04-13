local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function ResetLavae(inst)
    --Despawn all lavae
    local lavae = inst.components.rampingspawner.spawns
    for k, v in pairs(lavae) do
        k.components.combat:SetTarget(nil)
        k.components.locomotor:Clear()
        k.reset = true
    end
end

local function Reset(inst)
    ResetLavae(inst)
    --Fly off
    inst.reset = true

    --No longer start the respawn task here - was possible to duplicate this if the exiting failed.
end


local function BossCheck(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, { "epic" }, { "dragonfly" } )
	
	if #ents > 0 or TheWorld.state.issummer then
		Reset(inst)
	end

end

local function onnear(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(10, BossCheck)
	end
end

local function onfar(inst)
	inst.task = nil
end

env.AddPrefabPostInit("dragonfly", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst:AddTag("insect")
	
	inst.task = nil

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(50, 51) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

	if TUNING.DSTU.VETCURSE ~= "off" then
		inst:AddComponent("vetcurselootdropper")
		inst.components.vetcurselootdropper.loot = "slobberlobber"
	end

	inst.components.damagetracker.damage_threshold_fn = nil
	inst.components.lootdropper:AddChanceLoot("dragon_scales",    1.00)
	inst.components.lootdropper:AddChanceLoot("dragon_scales",    1.00)
	
		local function OnHitOther(inst, other)
			if inst.sg.currentstate.name ~= "pound" then
				if other:HasTag("creatureknockbackable") then
					other:PushEvent("knockback", {knocker = inst, radius = 75, strengthmult = 1.25})
				else
					if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and 
					--Don't knockback if you wear marble
					(other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
						other:PushEvent("knockback", {knocker = inst, radius = 75, strengthmult = 1.25})
					end
				end
			end
		end
	
	
		if inst.components.combat ~= nil then
			inst.components.combat.onhitotherfn = OnHitOther
		end
end)