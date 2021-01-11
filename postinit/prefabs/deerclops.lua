local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------


local PHASE2_HEALTH = .5

local function OnNewState(inst, data)
    if not (inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("waking")) then
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(0, 0, 1)
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
		
		

			--if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
				inst.AnimState:SetBuild("deerclops_yule_blue")

				--inst.entity:AddLight()
				inst.Light:SetIntensity(.6)
				inst.Light:SetRadius(8)
				inst.Light:SetFalloff(3)
				inst.Light:SetColour(0, 0, 1)
				inst.Light:Enable(true)

				inst:DoTaskInTime(0.1, inst:AddComponent("timer"))
				inst:ListenForEvent("newstate", OnNewState)
				
			--end
		
		inst.sg:GoToState("taunt")
		inst.enraged = true
	
	end
end
local function MakeIcey(inst)
inst:AddComponent("healthtrigger")
inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, EnterPhase2Trigger)
inst.upgrade = "ice_mutation"
print(inst.upgrade)
end
local function MakeStrong(inst)
inst.components.health:SetMaxHealth(5000)
inst.upgrade = "strength_mutation"
inst:DoTaskInTime(0.1, inst:AddComponent("timer"))
if inst.components.healthtrigger ~= nil then
inst:RemoveComponent("healthtrigger")      --Bandaid fix to attempt to correct the health trigger just getting added anyways
end
print(inst.upgrade)
end
local function ChooseUpgrades(inst)
if inst.upgrades == nil then
if math.random() > 0.5 then
MakeIcey(inst)
else
MakeStrong(inst)
end
end
end
local function OnSave(inst, data)
    data.enraged = inst.enraged or nil
	data.upgrade = inst.upgrade
	print(inst.upgrade)
end

local function OnPreLoad(inst, data)
    if data ~= nil then
        if data.enraged then
            EnterPhase2Trigger(inst)
        end
    end
end
local function OnLoad(inst, data)
    if data then
		print("here's the upgrades")
		print(data.upgrade)
		if data.upgrade == nil then
		ChooseUpgrades(inst)
		else
		
			if data.upgrade == "ice_mutation" then
			MakeIcey(inst)
			end
			if data.upgrade == "strength_mutation" then
			MakeStrong(inst)
			end
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

	local _OnHitOther = UpvalueHacker.GetUpvalue(Prefabs.deerclops.fn, "OnHitOther")

	local function OnHitOther(inst,data)
	if inst.sg:HasStateTag("heavyhit") then
		local other = data.target
		if other ~= nil then
			if not (other.components.health ~= nil and other.components.health:IsDead()) then
			if other ~= nil and other.components and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and (other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
			other:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1.2})
			end
			end
		end
	else
	if not inst.sg:HasStateTag("noice") then
	_OnHitOther(inst,data)
	end
	end
	end

	inst:RemoveEventCallback("onhitother", _OnHitOther)
    inst:ListenForEvent("onhitother", OnHitOther)
	
	if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		inst.entity:AddLight()
		inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(0, 0, 1)
		
		inst.Light:Enable(false)
	end
	

	if not TheWorld.ismastersim then
		return
	end
	
    inst.Physics:SetCollisionCallback(oncollide)
	
	inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	inst.OnLoad = OnLoad
	inst:RemoveComponent("freezable")
	

	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("cursed_antler", 1)
	end
	
	inst:AddComponent("groundpounder")
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
	inst:DoTaskInTime(0,ChooseUpgrades(inst))

end)