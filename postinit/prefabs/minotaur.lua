local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function Bonk(inst)
	if not inst.components.health:IsDead() then
		inst.sg:GoToState("AGStunwake")
	end
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
    elseif other.components.workable ~= nil
        and other.components.workable:CanBeWorked()
        and other.components.workable.action ~= ACTIONS.NET then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
        if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
            inst.recentlycharged[other] = true
            inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        end
		
		if other:HasTag("guardianbonk") or other:HasTag("megaboulder") then
			inst.sg:GoToState("AGStun")
			inst:DoTaskInTime(4.5, Bonk, inst)
			
			if other:HasTag("guardianbonk") then
				other:Smash()
			end
		end
	elseif other:HasTag("guardianbonk") then
			inst.sg:GoToState("AGStun")
			inst:DoTaskInTime(4.5, Bonk, inst)
			other:Smash()
    elseif other.components.health ~= nil and not other.components.health:IsDead() then
        inst.recentlycharged[other] = true
        inst:DoTaskInTime(3, ClearRecentlyCharged, other)
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/explo")
        inst.components.combat:DoAttack(other)
    end
end

local function oncollide(inst, other)
    if not (other ~= nil and other:IsValid() and inst:IsValid())
        or inst.recentlycharged[other]
        or other:HasTag("player")
        or Vector3(inst.Physics:GetVelocity()):LengthSq() < 42 then
        return
    end
    ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
    inst:DoTaskInTime(2 * FRAMES, onothercollide, other)
end

env.AddPrefabPostInit("minotaur", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	
	inst.jumpready = true
	
	inst:AddComponent("timer")
	
	inst:AddComponent("vetcurselootdropper")
	inst.components.vetcurselootdropper.loot = "gore_horn_hat"
	inst.components.lootdropper:AddChanceLoot("skullchest_child_blueprint",1.00)
	inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 3
    inst.components.groundpounder.destructionRings = 3
    inst.components.groundpounder.numRings = 3
	
    inst.Physics:SetCollisionCallback(oncollide)

		local function OnHitOther(inst, other)
			if other:HasTag("creatureknockbackable") then
			other:PushEvent("knockback", {knocker = inst, radius = 200, strengthmult = 1.5})
			else
			if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and 
			--Don't knockback if you wear marble
			(other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ==nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
				other:PushEvent("knockback", {knocker = inst, radius = 200, strengthmult = 1.5})
			end
			end
		end
	
		if inst.components.combat ~= nil then
			inst.components.combat.onhitotherfn = OnHitOther
		end

end)
