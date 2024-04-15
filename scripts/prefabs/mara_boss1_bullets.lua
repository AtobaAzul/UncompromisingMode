local prefabs = {
	"rock_break_fx"
}


-- Knockback.
-- Maybe rework init_knockback to include everything with knockback, not just giants?
-- I imagine its original purpose was to easily turn on/off the knockback mechanic in one place.
-- ...is there any particular reason that we aren't currently using it for much?
-- Anyway, I tried to gather up all the knockback resistors I found here for reference.
-- Is there any nuance I'm missing to the Uncomp/Vanilla knockback systems? -- Mara
local function OnHitOther(inst, other)
	local knockback_target_valid = false
	
	if other ~= nil then
		if other:HasTag("creatureknockbackable") then
			knockback_target_valid = true
		elseif not other:HasTag("fat_gang")
		and not other:HasTag("heavybody") -- Vanilla player SG, unused since 2019ish?? But mentioned in daywalker knockback code. Might be used soon.
		and not other:HasTag("foodknockbackimmune")
		and not (other.components.rider ~= nil and other.components.rider:IsRiding())
		and other.components.inventory ~= nil -- Don't knockback if the target is wearing knockback resistant equipment.
		and (
			other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil
			or (
				not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("marble")
				and not other.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY):HasTag("knockback_protection")
				and not other.components.inventory:ArmorHasTag("heavyarmor") -- Vanilla marble check; could be better to use this going forward for our anti-knockback equips?
			)
		)
		then
			knockback_target_valid = true
		end
	end
	
	-- The actual knockback is done here.
	if knockback_target_valid == true then
		other:PushEvent("knockback", { knocker = inst, radius = 2, strengthmult = 2.5 })
		if other.HUD ~= nil and other.HUD.shown then
			TheCamera:Shake(CAMERASHAKE.VERTICAL, .4, .02, .4) -- Camera shake for dramatic effect WHY NOT
		end
	end
end


-- Here's the part where we violently murder anything we so much as lightly graze :D
-- And anything near it!
local function OmaeWaMou(inst)
	local nextvictim = FindClosestEntity(inst, 3, true, { "_health" }, { "sans", "plant", "blocker", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	if nextvictim ~= nil and nextvictim.components.health ~= nil then
		local AREAATTACK_EXCLUDETAGS = { "sans", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" }
		
		inst.components.combat:DoAreaAttack(inst, 3, nil, nil, nil, AREAATTACK_EXCLUDETAGS)
		
		local bonebreakfx = SpawnPrefab("rock_break_fx")
		if bonebreakfx ~= nil then
			bonebreakfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		
		inst:DoTaskInTime(FRAMES*1, function() inst:Remove() end)
	end
end


-- Movement here.
local function WOOSH(inst)
	local nextvictim = FindClosestEntity(inst, 50, true, { "_health" }, { "sans", "plant", "blocker", "FX", "INLIMBO", "invisible", "notarget", "noattack", "playerghost" })
	
	if nextvictim ~= nil and nextvictim.components.health ~= nil and math.random() > 0.8 then
		inst:FacePoint(nextvictim.Transform:GetWorldPosition())
		inst.components.locomotor:RunForward()
--	elseif math.random() > 0.5 then
	--	Spiral movement pattern.
	else
		inst.components.locomotor:RunInDirection(math.random() * 359)
		inst.components.locomotor:RunForward()
	end
end


local function fn()
	local inst = CreateEntity()
	
	-- Core components
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 50, .5)
	RemovePhysicsColliders(inst)
	inst:AddTag("NOBLOCK")
	
	inst.AnimState:SetBank("mara_boss1_bullets")
	inst.AnimState:SetBuild("mara_boss1_bullets")
	local names = { "boss1_bullet0", "boss1_bullet1", "boss1_bullet2", "boss1_bullet3", "boss1_bullet4", "boss1_bullet5" }
	inst.animname = names[math.random(1, #names)]
	inst.AnimState:PlayAnimation(inst.animname)
	inst.Transform:SetScale((1 + math.random()), (1 + math.random()), (1 + math.random()))
	
	inst:AddTag("scarytoprey")
	inst:AddTag("sans")
	
	inst.Light:Enable(true)
	inst.Light:SetRadius(1)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetIntensity(0.75)
	inst.Light:SetColour(0, 0.5, 0.9)
	
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = ((30 * math.random()) + 35)
	inst.components.locomotor.runspeed = ((30 * math.random()) + 35)
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(10)
	inst.components.combat.onhitotherfn = OnHitOther
	
	inst:DoTaskInTime(0, WOOSH)
	inst:DoPeriodicTask((FRAMES * 4), OmaeWaMou, 0)
	
	
	inst:DoTaskInTime(0.8, function()
		ErodeAway(inst, 10*FRAMES)
	end)
	
	
	inst.OnEntitySleep = inst.Remove
	inst.persists = false
	
	return inst
end

return Prefab("mara_boss1_bullets", fn, nil, prefabs)
