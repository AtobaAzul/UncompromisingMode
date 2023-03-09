local TARGET_IGNORE_TAGS = { "INLIMBO", "moonglasscreature" }

local function destroystuff(inst)

	if inst.WINDSTAFF_CASTER == nil then
		inst:Remove()
	end
	if inst.destroy and inst.hidden ~= true then
		local x, y, z = inst.Transform:GetWorldPosition()

		local ents = TheSim:FindEntities(x, y, z, 2, nil, TARGET_IGNORE_TAGS, { "_health" })
		for i, v in ipairs(ents) do
			if v ~= inst.WINDSTAFF_CASTER and v:IsValid() then
				if v.components.health ~= nil and
					not v.components.health:IsDead() and
					v.components.combat ~= nil and
					v.components.combat:CanBeAttacked() then
					local damage = 40
					v.components.combat:GetAttacked(inst, damage, nil, "glass")

					if v:HasTag("player") and not (v.components.rider ~= nil and v.components.rider:IsRiding()) then
						if v.moonmaw_lavae_stun == nil then
							v.moonmaw_lavae_stun = 0
						end
						v.moonmaw_lavae_stun = v.moonmaw_lavae_stun + 1
						if v.moonmaw_lavae_stun > 4 then
							if v.sg:HasStateTag("wixiepanic") then
								v.sg:GoToState("idle")
							end

							v:PushEvent("knockback", { knocker = inst.WINDSTAFF_CASTER, radius = 1, strengthmult = 1 })
							v:DoTaskInTime(1.5, function(v) v.moonmaw_lavae_stun = 0 end)
						end
					end
				end
			end
		end
	end
end

local function Reposition(inst)
	if inst.WINDSTAFF_CASTER ~= nil then
		local x, y, z = inst.WINDSTAFF_CASTER.Transform:GetWorldPosition()
		if x ~= nil and y ~= nil and z ~= nil then
			inst.Transform:SetPosition(x, y, z)
		else
			inst:Remove()
		end
	end
end

local function CheckDist(inst)
	if inst ~= nil and inst.WINDSTAFF_CASTER ~= nil and inst.WINDSTAFF_CASTER.components.health ~= nil and
		not inst.WINDSTAFF_CASTER.components.health:IsDead() then
		local distance = inst ~= nil and inst:IsValid() and inst.WINDSTAFF_CASTER ~= nil and inst.WINDSTAFF_CASTER:IsValid()
			and inst:GetDistanceSqToInst(inst.WINDSTAFF_CASTER)

		if distance ~= nil and distance ~= true and distance ~= false and distance > 15 then
			Reposition(inst)
		end
	else
		inst:Remove()
	end
end

local function lavaering_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()



	inst.AnimState:SetFinalOffset(2)
	inst.AnimState:SetBank("moonmaw_lavae")
	inst.AnimState:SetBuild("moonmaw_lavae")
	--inst.AnimState:PlayAnimation("hover", true)

	--inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	inst.Transform:SetFourFaced()

	MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	local light = inst.entity:AddLight()
	inst.Light:Enable(true)
	inst.Light:SetRadius(2)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(.75)
	inst.Light:SetColour(121 / 255, 235 / 255, 12 / 255)

	inst:AddComponent("linearcircler")
	inst:AddComponent("leader")

	inst.WINDSTAFF_CASTER = nil
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")

	inst.Destroy = false

	inst:DoTaskInTime(1, function(inst)
		inst:DoPeriodicTask(.15, destroystuff)
		inst:DoPeriodicTask(10, CheckDist)
	end)
	inst.damagetime = 0.1
	inst:DoTaskInTime(inst.damagetime, Reposition)
	return inst
end

local function KeepTargetFn(inst, target)
	return target
		and target.components.combat
		and target.components.health
		and not target.components.health:IsDead()
end

local function NormalRetarget(inst)
	local targetDist = 10
	return FindEntity(inst, targetDist,
		function(guy)
			if inst.components.combat:CanTarget(guy) then
				return not guy:HasTag("moonglasscreature")
			end
		end)
end

local brain = require "brains/moonmaw_lavaebrain"
local function AnimOver(inst)
	if not inst.severed then
		if inst.number ~= nil then
			if inst.components.follower.leader ~= nil then
				local leader = inst.components.follower.leader
				local number = inst.number
				leader.lavae[number]:Show()
				leader.lavae[number].hidden = false
				leader.lavae[number].AnimState:PlayAnimation("descend")
				leader.lavae[number].AnimState:PushAnimation("hover")
			end
		end
		inst:Remove()
	end
end

local function CheckIfShouldGoBack(inst)
	if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.severed then
		if inst.components.follower ~= nil and inst.components.follower.leader ~= nil and inst.number ~= nil then
			--[[local leader = inst.components.follower.leader
		if leader.components.combat ~= nil and leader.components.combat.target == nil then --No Target, return home
			inst.AnimState:PlayAnimation("ascend")
			inst:ListenForEvent("animover", AnimOver)
		end	]]
		else
			inst.AnimState:PlayAnimation("ascend")
			inst:ListenForEvent("animover", AnimOver)
		end
	end
end

local function OnAttacked(inst, data)
	inst:ClearBufferedAction()
	if data.attacker and not data.attacker:HasTag("moonglasscreature") then
		inst.components.combat:SetTarget(data.attacker)
		if inst.components.follower ~= nil and inst.components.follower.leader ~= nil then
			local leader = inst.components.follower.leader
			if leader.components.combat ~= nil and leader.components.combat.target == nil then
				leader.components.combat:SetTarget(data.attacker)
			end
		end
	end
end

local function lavae_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()

	inst.DynamicShadow:SetSize(2, 2)


	inst.AnimState:SetFinalOffset(2)
	inst.AnimState:SetBank("moonmaw_lavae")
	inst.AnimState:SetBuild("moonmaw_lavae")
	inst.AnimState:PlayAnimation("hover", true)

	--inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	inst.Transform:SetFourFaced()

	MakeInventoryPhysics(inst)
	RemovePhysicsColliders(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.entity:AddLight()
	inst.Light:Enable(true)
	inst.Light:SetRadius(2)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(.75)
	inst.Light:SetColour(121 / 255, 235 / 255, 12 / 255)

	inst.WINDSTAFF_CASTER = nil
	inst:AddComponent("inspectable")
	inst:AddTag("moonglasscreature")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(250)
	inst.components.health.destroytime = 5
	inst.components.health.fire_damage_scale = 0

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(50)
	inst.components.combat.playerdamagepercent = .5
	inst.components.combat:SetRange(2)
	inst.components.combat:SetAttackPeriod(1)
	--inst.components.combat:SetRetargetFunction(3, NormalRetarget)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst.components.combat.battlecryenabled = false
	inst.components.combat:SetHurtSound("turnoftides/common/together/moon_glass/mine", nil, 0.5)

	inst:AddComponent("follower")
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 10
	inst.components.locomotor.runspeed = 10
	inst:ListenForEvent("attacked", OnAttacked)
	inst:SetStateGraph("SGmoonmaw_lavae")
	inst:SetBrain(brain)
	inst:DoTaskInTime(0, CheckIfShouldGoBack)
	inst:DoPeriodicTask(8, CheckIfShouldGoBack)

	inst.severed = false

	return inst
end

return Prefab("moonmaw_lavae_ring", lavaering_fn),
	Prefab("moonmaw_lavae", lavae_fn)
