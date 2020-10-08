local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local PHASE2_HEALTH = .5

local function OnNewState(inst, data)
    if not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("waking")) then
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
		--inst.Light:Enable(true)
	--else
		--inst:DoTaskInTime(2, inst.Light:Enable(false))
    end
end

local function EnterPhase2Trigger(inst)
    if not inst.components.health:IsDead() then
		local upgradeburst = SpawnPrefab("maxwell_smoke")
		upgradeburst.Transform:SetPosition(inst.Transform:GetWorldPosition())
		upgradeburst.Transform:SetScale(3, 3, 3)
		
		inst.Transform:SetScale(1.85, 1.85, 1.85)
		inst.components.combat:SetRange(TUNING.DEERCLOPS_ATTACK_RANGE * 1.1)
		inst.components.combat:SetAreaDamage(TUNING.DEERCLOPS_AOE_RANGE * 1.1, TUNING.DEERCLOPS_AOE_SCALE * 1.1)
		inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD * 0.9)
		
		

			if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
				inst.AnimState:SetBuild("deerclops_yule")

				--inst.entity:AddLight()
				inst.Light:SetIntensity(.6)
				inst.Light:SetRadius(8)
				inst.Light:SetFalloff(3)
				inst.Light:SetColour(1, 0, 0)
				inst.Light:Enable(true)

				inst:DoTaskInTime(0.1, inst:AddComponent("timer"))
				inst:ListenForEvent("newstate", OnNewState)
				
			end
		
		inst.sg:GoToState("taunt")
		inst.enraged = true
	
	end
end

local function OnSave(inst, data)
    data.enraged = inst.enraged or nil
end

local function OnPreLoad(inst, data)
    if data ~= nil then
        if data.enraged then
            EnterPhase2Trigger(inst)
        end
    end
end

local function oncollapse(inst, other)
    if other:IsValid() and other.components.workable ~= nil and other.components.workable:CanBeWorked() then
        SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
        other.components.workable:Destroy(inst)
    end
end

local function oncollide(inst, other)
    if other ~= nil and
        (other:HasTag("tree") or other:HasTag("boulder")) and not other:HasTag("giant_tree") and --HasTag implies IsValid
        Vector3(inst.Physics:GetVelocity()):LengthSq() >= 1 then
        inst:DoTaskInTime(2 * FRAMES, oncollapse, other)
    end
end

env.AddPrefabPostInit("deerclops", function(inst)
	
	if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		inst.entity:AddLight()
		inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(1, 0, 0)
		
		inst.Light:Enable(false)
	end
	

	if not TheWorld.ismastersim then
		return
	end
	
    inst.Physics:SetCollisionCallback(oncollide)
	
	inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	
	inst:RemoveComponent("freezable")
	
	inst:AddComponent("healthtrigger")
    inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("cursed_antler", 1)
	end
	
	inst:AddComponent("groundpounder")
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
	inst.components.groundpounder.groundpoundfx = "deerclops_ground_fx"
end)