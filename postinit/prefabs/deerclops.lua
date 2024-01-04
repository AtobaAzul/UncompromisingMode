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

local function SpinCheck(inst, data)
    if data ~= nil and data.name == "spinattack" and inst.components.health ~= nil and not inst.components.health:IsDead() then
        if inst.components.combat.target ~= nil and inst:GetDistanceSqToInst(inst.components.combat.target) < 12 and not inst.sg:HasStateTag("attack") then
            inst.sg:GoToState("spinbeam_pre")
        else
            inst.components.timer:StartTimer("spinattack", 0.5)
        end
    end
end

local function EnterPhase2Trigger(inst)
    if not inst.components.health:IsDead() then
        local upgradeburst = SpawnPrefab("maxwell_smoke")
        upgradeburst.Transform:SetPosition(inst.Transform:GetWorldPosition())
        upgradeburst.Transform:SetScale(3, 3, 3)

        inst.Transform:SetScale(1.85, 1.85, 1.85)
        inst.components.combat:SetAttackPeriod(TUNING.DEERCLOPS_ATTACK_PERIOD * 0.9)

        --if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        inst.AnimState:SetBuild("deerclops_yule_blue")

        --inst.entity:AddLight()
        inst.Light:SetIntensity(.6)
        inst.Light:SetRadius(8)
        inst.Light:SetFalloff(3)
        inst.Light:SetColour(0, 0, 1)
        inst.Light:Enable(true)

        --[[inst:DoTaskInTime(0.1, function(inst)
            inst:AddComponent("timer")
            inst:ListenForEvent("timerdone", SpinCheck)
            inst.components.timer:StartTimer("spinattack", 10 + math.random(1, 5))
        end)]] --Temporarily remove spin attack till it can be reworked to not kill PCs
        inst:ListenForEvent("newstate", OnNewState)

        --end

        inst.sg:GoToState("taunt")
    end
end

local function UpdateLevelIce(inst) --Save For Tier2
    if inst.components.workable ~= nil then
        inst.components.health:SetAbsorptionAmount(.8)
    end
end

local function OnWork(inst, worker, workleft) --Save for Tier 2
    if workleft <= 0 then
        inst:RemoveComponent("workable")
        UpdateLevelIce(inst)
        inst.components.timer:StartTimer("freezearmor", 30 + math.random(0, 10))
    end
end

local function FreezeArmor(inst, data) --Save For Tier 2
    if data ~= nil then
        if data.name == "freezearmor" then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
            inst.components.workable:SetOnWorkCallback(OnWork)
            inst.sg:GoToState("taunt")
            UpdateLevelIce(inst)
        end
    end
end


local function AuraFreezeEnemies(inst)
    if inst.components.combat.target ~= nil and inst.components.health ~= nil and not inst.components.health:IsDead() then
        if inst:GetDistanceSqToPoint(inst.components.combat.target:GetPosition()) < 4 then
            inst.sg:GoToState("aurafreeze_pre")
            inst:DoTaskInTime(7, function(inst) inst.sg:GoToState("aurafreeze_pst") end)
        else
            inst.components.combat:SetRange(TUNING.DEERCLOPS_ATTACK_RANGE * 0.6)
        end
    else
        inst.components.timer:StartTimer("auratime", 15)
    end
end
local function IceyCheck(inst, data)
    if data ~= nil and data.name == "auratime" and inst.upgrade == "ice_mutation" then
        AuraFreezeEnemies(inst)
    end
end

local function MakeEnrageable(inst)
    inst.components.health:SetMaxHealth(TUNING.DEERCLOPS_HEALTH * TUNING.DSTU.DEERCLOPS_HEALTH)
    EnterPhase2Trigger(inst) --Removing the trigger, only ice laser
    inst.upgrade = "enrage_mutation"
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("laserbeam_cd", TUNING.DEERCLOPS_ATTACK_PERIOD * (math.random(3) - .5))
end

local function MakeStrong(inst)
    inst.components.health:SetMaxHealth((TUNING.DEERCLOPS_HEALTH * 1.125) * TUNING.DSTU.DEERCLOPS_HEALTH)
    inst.upgrade = "strength_mutation"
    inst:DoTaskInTime(0.1, function(inst) inst:AddComponent("timer") end)
    if inst.components.healthtrigger ~= nil then
        inst:RemoveComponent("healthtrigger") --Bandaid fix to attempt to correct the health trigger just getting added anyways
    end
end

local function MakeIcey(inst)
    inst.components.health:SetMaxHealth((TUNING.DEERCLOPS_HEALTH * 0.875) * TUNING.DSTU.DEERCLOPS_HEALTH)
    inst.upgrade = "ice_mutation"
    if inst.components.freezable ~= nil then
        inst:RemoveComponent("freezable")
    end
    inst:DoTaskInTime(0.1, function(inst) inst:AddComponent("timer")
    inst.components.timer:StartTimer("auratime", 15) end)
    inst:ListenForEvent("timerdone", IceyCheck)
    if inst.components.healthtrigger ~= nil then
        inst:RemoveComponent("healthtrigger") --Bandaid fix to attempt to correct the health trigger just getting added anyways
    end
end
--[[ Save For Tier 2
inst:AddComponent("timer")
inst:ListenForEvent("timerdone", FreezeArmor)
inst.components.timer:StartTimer("freezearmor",0.1)]]
------------

------------

local function ChooseUpgrades(inst)
    if inst.upgrade == nil then
        local chance = math.random()
        if chance < 0.33 then
            MakeEnrageable(inst)
        end
        if chance >= 0.33 and chance <= 0.66 then
            MakeStrong(inst)
        end
        if chance > 0.66 then
            MakeIcey(inst)
        end
    else
        if inst.upgrade == "enrage_mutation" then
            MakeEnrageable(inst)
        end
        if inst.upgrade == "strength_mutation" then
            MakeStrong(inst)
        end
        if inst.upgrade == "ice_mutation" then
            MakeIcey(inst)
        end
    end
end

local function OnSave(inst, data)
    data.enraged = inst.enraged or nil
    data.upgrade = inst.upgrade
    if inst.components.health ~= nil then
        data.healthUM = inst.components.health.currenthealth
    end
end

local function OnLoad(inst, data)
    if data then
        if data.upgrade == nil then
            ChooseUpgrades(inst)
        else
            if data.upgrade == "enrage_mutation" then
                MakeEnrageable(inst)
            end
            if data.upgrade == "strength_mutation" then
                MakeStrong(inst)
            end
            if data.upgrade == "ice_mutation" then
                MakeIcey(inst)
            end
        end
        if data.healthUM ~= nil then
            inst.components.health.currenthealth = data.healthUM
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
        inst.Light:SetColour(0, 0, 1)

        inst.Light:Enable(false)
    end

    if not TheWorld.ismastersim then
        return
    end

    local _OnHitOther = UpvalueHacker.GetUpvalue(Prefabs.deerclops.fn, "OnHitOther")

    local function OnHitOther(inst, data)
        if inst.sg:HasStateTag("heavyhit") then
            local other = data.target
            if other ~= nil then
                if not (other.components.health ~= nil and other.components.health:IsDead()) then
                    if other ~= nil and other.components.inventory ~= nil and not other:HasTag("fat_gang") and not other:HasTag("foodknockbackimmune") and not (other.components.rider ~= nil and other.components.rider:IsRiding()) and
                    --Don't knockback if you wear marble
                    (other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil or not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble") and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")) then
                        other:PushEvent("knockback", {knocker = inst, radius = 150, strengthmult = 1.2})
                    end
                end
            end
        else
            if not inst.sg:HasStateTag("noice") then
                _OnHitOther(inst, data)
            end
        end
    end

	if _OnHitOther ~= nil then
		inst:RemoveEventCallback("onhitother", _OnHitOther)
		inst:ListenForEvent("onhitother", OnHitOther)
	end
	
    inst.Physics:SetCollisionCallback(oncollide)
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad
	
	local function OnSave(inst, data)
		data.upgrade = inst.upgrade
		if inst.components.health ~= nil then
			data.healthUM = inst.components.health.currenthealth
		end
		
		return _OnSave(inst, data)
	end
	
	local function OnLoad(inst, data)
		if data then
			if data.upgrade == nil then
				ChooseUpgrades(inst)
			else	
				if data.upgrade == "enrage_mutation" then
					inst.upgrade = "enrage_mutation"
					MakeEnrageable(inst)
				end
				
				if data.upgrade == "strength_mutation" then
					inst.upgrade = "strength_mutation"
					MakeStrong(inst)
				end
				
				if data.upgrade == "ice_mutation" then
					inst.upgrade = "ice_mutation"
					MakeIcey(inst)
				end
			end
			
			if data.healthUM ~= nil then
				inst.components.health.currenthealth = data.healthUM
			end
		end
		
		return _OnLoad(inst, data)
	end
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst:RemoveComponent("freezable")

    inst.count = 0

    inst.EnterPhase2Trigger = EnterPhase2Trigger
    inst:AddComponent("groundpounder")
    inst.components.groundpounder.destroyer = true
    inst.components.groundpounder.damageRings = 2
    inst.components.groundpounder.destructionRings = 2
    inst.components.groundpounder.platformPushingRings = 2
    inst.components.groundpounder.numRings = 3
    inst:AddTag("deergemresistance")

    inst.MakeEnrageable = MakeEnrageable
    inst.MakeIcey = MakeIcey
    inst.MakeStrong = MakeStrong

    inst:DoTaskInTime(0.1, ChooseUpgrades(inst)) --Incase we need to specify an upgrade because this deerclops despawned.
end)
