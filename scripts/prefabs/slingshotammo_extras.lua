local assets =
{
    Asset("ANIM", "anim/wixieammo.zip"),
}


local assets_firecrackers =
{
    Asset("ANIM", "anim/firecrackers.zip"),
}

local prefabs_firecrackers =
{
    "explode_firecrackers",
}

local AURA_EXCLUDE_TAGS = { "noclaustrophobia", "rabbit", "playerghost", "abigail", "companion", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible" }
local GOOP_EXCLUDE_TAGS = { "noclaustrophobia", "rabbit", "playerghost", "shadow", "shadowminion", "INLIMBO", "notarget", "noattack", "invisible" }

if not TheNet:GetPVPEnabled() then 
	table.insert(AURA_EXCLUDE_TAGS, "player")
end

-- temp aggro system for the slingshots
local function no_aggro(attacker, target)
	local targets_target = target.components.combat.target
	return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker 
			and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
			and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
end

local function DealDamage(inst, attacker, target, salty)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
		inst.finaldamage = (inst.damage * (1 + (inst.powerlevel / 2))) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)
		
		if salty ~= nil and salty and target.components.health ~= nil then
			local scalingdamage = ((2 - target.components.health:GetPercent()) + (2 - target.components.health:GetPercent())) - 1
			inst.finaldamage = inst.finaldamage * scalingdamage
			print("salty damage = "..inst.finaldamage)
			
			if target:HasTag("snowish") or target.prefab == "snurtle" or target.prefab == "slurtle" then
				inst.finaldamage = inst.finaldamage * 2
			end
		end
		
		if no_aggro(attacker, target) then
			target.components.combat:SetShouldAvoidAggro(attacker)
		end
		
		if target:HasTag("shadowcreature") or 
			target.sg == nil or 
			target.wixieammo_hitstuncd == nil and not 
			(target.sg:HasStateTag("busy") or 
			target.sg:HasStateTag("caninterrupt")) or
			target.sg:HasStateTag("frozen")	then
			target.wixieammo_hitstuncd = target:DoTaskInTime(8, function()
				if target.wixieammo_hitstuncd ~= nil then
					target.wixieammo_hitstuncd:Cancel()
				end
						
				target.wixieammo_hitstuncd = nil
			end)
		
			target.components.combat:GetAttacked(attacker, inst.finaldamage, inst)
		else
			target.components.combat:GetAttacked(attacker, 0, inst)
			
			if target.components.combat ~= nil then
				target.components.combat:SetTarget(attacker)
			end
			
			target.components.health:DoDelta(-inst.finaldamage, false, inst, false, attacker, false)
		end
		
		if target.components.combat ~= nil then
			target.components.combat:RemoveShouldAvoidAggro(attacker)
		end
		
		if attacker.components.combat ~= nil then
			attacker.components.combat:SetTarget(target)
		end
    end
end

local function ImpactFx(inst, attacker, target, salty)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil and target.components.combat.hiteffectsymbol ~= nil and inst.impactfx ~= nil then
		local impactfx = SpawnPrefab(inst.impactfx)
		impactfx.Transform:SetPosition(target.Transform:GetWorldPosition())
		
		if salty ~= nil and salty then
			local saltyfx = SpawnPrefab("impact")
		
			if target.components.health ~= nil then
				local percent = 1.5 - target.components.health:GetPercent()
				
				saltyfx.Transform:SetPosition(target.Transform:GetWorldPosition())
				saltyfx.Transform:SetScale(percent, percent, percent)
			else
				saltyfx.Transform:SetPosition(target.Transform:GetWorldPosition())
				saltyfx.Transform:SetScale(0.1, 0.1, 0.1)
			end
		end
    end
end

local function OnHit(inst, attacker, target)
	DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    inst:Remove()
end

local function SpawnFirecrackers(inst, pt, starting_angle, attacker, powerlevel)
    local fireworks = SpawnPrefab("firecrackers_slingshot")
    if fireworks ~= nil then
        fireworks.Transform:SetPosition(pt.x, 0, pt.z)
		fireworks.components.burnable:Ignite()
		fireworks.attacker = attacker
		fireworks.powerlevel = powerlevel
		--fireworks:TheAttacker(attacker)
    end
end

local function OnHit_Firecrackers(inst, attacker, target)
	if target:HasDebuff("wixiecurse_debuff") then
		inst.powerlevel = inst.powerlevel + 1
		target:PushEvent("wixiebite")
	end

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)

    local pt
    if target ~= nil and target:IsValid() then
        pt = target:GetPosition()
    else
        pt = inst:GetPosition()
        target = nil
    end

	local theta = math.random() * 2 * PI
	SpawnFirecrackers(target, pt, theta, attacker, inst.powerlevel)

    inst:Remove() 
end

local function OnMiss(inst, owner, target)
--	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then 
--		splash
--	else
--		ground impact
--	end

    inst:Remove()
end

local STARTLE_TAGS = { "canbestartled" }

local function TheAttacker(attacker)
	inst.attacker = attacker
end

local function DoPop(inst, remaining, total, level, hissvol)
    local x, y, z = inst.Transform:GetWorldPosition()
	
	local crackerfx = SpawnPrefab("slingshot_explode_firecrackers")
    crackerfx.Transform:SetPosition(x, y, z)
	crackerfx.Transform:SetScale((inst.powerlevel / 2), (inst.powerlevel / 2), (inst.powerlevel / 2))
	--crackerfx.scale = 10
	--crackerfx.Transform:SetScale(10, 10, 10)
	print("pop")
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 1.2 + inst.powerlevel, { "_combat" }, AURA_EXCLUDE_TAGS)) do
		if v.components.health ~= nil and not (v.components.health:IsDead() or v == inst.attacker or v:HasTag("playerghost") or (v:HasTag("player") and TheNet:GetPVPEnabled())) and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				if not v.components.health:IsDead() then
					--
					--v:PushEvent("attacked", {attacker = inst.attacker or nil, damage = 5, weapon = nil})
					if v:HasTag("epic") then
						v.components.health:DoDelta(-10)
						
						if v.components.combat:GetImpactSound(v) ~= nil then
							v.SoundEmitter:PlaySound(v.components.combat:GetImpactSound(v))
						end
					else
						if no_aggro(inst.attacker, v) then
							v.components.combat:SetShouldAvoidAggro(inst.attacker)
						end
					
						v.components.combat:GetAttacked(inst, 10, inst)
						
						if v.components.combat ~= nil then
							v.components.combat:SetTarget(inst.attacker or nil)
							v.components.combat:RemoveShouldAvoidAggro(inst.attacker)
						end
					end
				end
			end
		end
    end

    for i, v in ipairs(TheSim:FindEntities(x, y, z, TUNING.FIRECRACKERS_STARTLE_RANGE, STARTLE_TAGS)) do
        v:PushEvent("startle", { source = inst })
    end

    if remaining > 1 then
        inst.AnimState:PlayAnimation("spin_loop"..tostring(math.random(3)))

        if hissvol > .5 then
            hissvol = hissvol - .1
            inst.SoundEmitter:SetVolume("hiss", hissvol)
        end

        local newlevel = 8 - math.ceil(8 * remaining / total)
        for i = level + 1, newlevel do
            inst.AnimState:Hide("F"..tostring(i))
        end

        local angle = math.random() * 2 * PI
        local spd = 1.5
        inst.Physics:Teleport(x, math.max(y * .5, .1), z)
        inst.Physics:SetVel(math.cos(angle) * spd, 8, math.sin(angle) * spd)

        --23 frames in spin_loop, so if the delay gets longer, loop the anim
        inst:DoTaskInTime(.3 + .3 * math.random(), DoPop, remaining - 1, total, newlevel, hissvol)
    else
        inst:Remove()
    end
end

local function StartExploding(inst)
    inst:RemoveComponent("burnable")
    inst:AddTag("NOCLICK")
    inst:AddTag("scarytoprey")
    inst.Physics:SetFriction(.2)
	
	local bouncecount = 8
	
    DoPop(inst, bouncecount, bouncecount, 0, 1)
    inst:RemoveComponent("stackable")
    inst.persists = false
end

local function StartFuse(inst)
    inst.starttask = nil
    inst:RemoveComponent("burnable")

    inst.AnimState:PlayAnimation("burn")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")

    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), StartExploding, math.floor(33.4 * math.sqrt(inst.components.stackable:StackSize() + 3) - 58.8 + .5))

    inst:RemoveComponent("stackable")
    inst.persists = false
end

local function OnIgniteFn(inst)
    if inst.starttask == nil then
        inst.starttask = inst:DoTaskInTime(0, StartExploding)
    end
    inst.components.inventoryitem.canbepickedup = false
end

local function OnExtinguishFn(inst)
    if inst.starttask ~= nil then
        inst.starttask:Cancel()
        inst.starttask = nil
        inst.components.burnable:Ignite()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("firecrackers")
    inst.AnimState:SetBuild("firecrackers")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(0.9,0.9,0.9)

    inst:AddTag("explosive")
	inst:AddTag("scarytoprey")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	if inst.powerlevel == nil then
		inst.powerlevel = 1
	end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")

    inst:AddComponent("burnable")
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)

    inst.components.burnable:SetBurnTime(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn()

	--inst:ListenForEvent("findattacker", data)

    MakeHauntableLaunchAndIgnite(inst)
	
    inst.persists = false

    return inst
end

local function Beat(inst)
	inst.SoundEmitter:SetParameter("shadowvortex", "intensity", inst.Transform:GetScale() / 1.8)
end

local function Init(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/idle", "shadowvortex")
	inst:DoPeriodicTask(0.5, Beat)
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 10 * inst.Transform:GetScale(), { "_combat" }, AURA_EXCLUDE_TAGS)
	
	for i, v in ipairs(ents) do
		if (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				local px, py, pz = v.Transform:GetWorldPosition()
					
				local rad = math.rad(v:GetAngleToPoint(x, y, z))
				local velx = math.cos(rad) --* 4.5
				local velz = -math.sin(rad) --* 4.5
				
				local multiplierplayer = inst:GetDistanceSqToPoint(px, py, pz)
				
				multiplierplayer = (multiplierplayer * inst.Transform:GetScale()) / 50
				
				if multiplierplayer > 15 then
					multiplierplayer = 15
				elseif multiplierplayer < 1.5 then
					multiplierplayer = 1.5
				end
				
				local dx, dy, dz = px + (((FRAMES * 4) * velx) / multiplierplayer) * inst.Transform:GetScale(), py, pz + (((FRAMES * 4) * velz) / multiplierplayer) * inst.Transform:GetScale()
					
				local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
				local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
				local ocean = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
				local on_water = nil
																				
				if TUNING.DSTU.ISLAND_ADVENTURES then
					on_water = IsOnWater(dx, dy, dz)
				end
													
				if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then	
					if v ~= nil and v.components.locomotor ~= nil and dx ~= nil and (ground or boat or ocean and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
						if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
							--[[if ocean and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
								v.components.amphibiouscreature:OnEnterOcean()
							end]]
							
							v.Transform:SetPosition(dx, dy, dz)
						end
					end
				end
			end
		end
	end
end

local function Damage(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local damageents = TheSim:FindEntities(x, y, z, 1 * inst.Transform:GetScale(), { "_combat" }, AURA_EXCLUDE_TAGS)
	
	for i, v in ipairs(damageents) do
		if v.components.combat ~= nil and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				v.components.combat:GetAttacked(inst, 2 * inst.Transform:GetScale(), inst)
			end
		end
	end
end

local function Disappear_mini(inst)
	inst.components.sizetweener:StartTween(0.05, 0.1, inst.Remove)
end

local function shrink_mini(inst)
	--inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.1, inst.powerlevel * 2, Disappear_mini)
end

local function shrinktask_mini(inst)
	inst:DoTaskInTime(inst.powerlevel * 2, shrink_mini)
end
		
local function grow_mini(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(inst.powerlevel * 1.2, 1, shrinktask_mini)
end

local function vortexfn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("shadowtalker")
	inst:AddTag("scarytoprey")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("shadowvortex")
    inst.AnimState:SetBuild("shadowvortex")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

	inst.AnimState:SetMultColour(1, 1, 1, .8)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	if inst.powerlevel == nil then
		inst.powerlevel = 1
	end

	inst:AddComponent("sizetweener")
	
	inst.grow_mini = grow_mini
	inst:grow_mini()
	
	inst:DoPeriodicTask(FRAMES, Vac)
	inst:DoPeriodicTask(2, Damage)
	
	inst:DoTaskInTime(0, Init)
	
    inst.persists = false
	
    return inst
end

local MAX_HONEY_VARIATIONS = 7
local MAX_RECENT_HONEY = 4
local HONEY_PERIOD = .2
local HONEY_LEVELS =
{
    {
        min_scale = .5,
        max_scale = .8,
        threshold = 8,
        duration = 1.2,
    },
    {
        min_scale = .5,
        max_scale = 1.1,
        threshold = 2,
        duration = 2,
    },
    {
        min_scale = 1,
        max_scale = 1.3,
        threshold = 1,
        duration = 4,
    },
}

local function PickHoney(inst)
    local rand = table.remove(inst.availablehoneyslow, math.random(#inst.availablehoneyslow))
    table.insert(inst.usedhoneyslow, rand)
    if #inst.usedhoneyslow > MAX_RECENT_HONEY then
        table.insert(inst.availablehoneyslow, table.remove(inst.usedhoneyslow, 1))
    end
    return rand
end

local function DoHoneyTrail(inst)
    local level = HONEY_LEVELS[
        ( inst.sg ~= nil and not inst.sg:HasStateTag("moving") and 1) or
        (inst.components.locomotor ~= nil and inst.components.locomotor.walkspeed <= TUNING.BEEQUEEN_SPEED and 2) or
        3
    ]

    inst.honeyslowcount = inst.honeyslowcount + 1

    if inst.honeyslowthreshold > level.threshold then
        inst.honeyslowthreshold = level.threshold
    end

    if inst.honeyslowcount >= inst.honeyslowthreshold then
        local hx, hy, hz = inst.Transform:GetWorldPosition()
        inst.honeyslowcount = 0
        if inst.honeyslowthreshold < level.threshold then
            inst.honeyslowthreshold = math.ceil((inst.honeyslowthreshold + level.threshold) * .5)
        end

        local fx = nil
        if TheWorld.Map:IsPassableAtPoint(hx, hy, hz) then
            fx = SpawnPrefab("wixiehoney_trail")
            fx:SetVariation(PickHoney(inst), GetRandomMinMax(level.min_scale, level.max_scale), level.duration + math.random() * .5)
        else
            fx = SpawnPrefab("splash_sink")
        end
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
	
	inst.honeyslowcancelcount = inst.honeyslowcancelcount + 1
	
	if inst.honeyslowcancelcount >= inst.honeyslowmax then
		if inst.honeyslowtask ~= nil then
			inst.honeyslowtask:Cancel()
			inst.honeyslowtask = nil
		end
	end
end

local function OnHit_Honey(inst, attacker, target)
	if target:HasDebuff("wixiecurse_debuff") then
		inst.powerlevel = inst.powerlevel + 1
		target:PushEvent("wixiebite")
	end

    DealDamage(inst, attacker, target)
    ImpactFx(inst, attacker, target)
	
	target.honeyslowcancelcount = 0
	target.honeyslowmax = 75 * inst.powerlevel
	target.honeyslowthreshold = HONEY_LEVELS[1].threshold
    target.availablehoneyslow = {}
    target.usedhoneyslow = {}
    for i = 1, MAX_HONEY_VARIATIONS do
        table.insert(target.availablehoneyslow, i)
    end
	target.honeyslowcount = math.ceil(target.honeyslowthreshold * .5)
	
	if target.honeyslowtask ~= nil then
		target.honeyslowtask:Cancel()
		target.honeyslowtask = nil
	end
	
	if target.tarslowtask ~= nil then
		target.tarslowtask:Cancel()
		target.tarslowtask = nil
	end
	
	if target.sg ~= nil or target.components.locomotor ~= nil then
		target.honeyslowtask = target:DoPeriodicTask(HONEY_PERIOD, DoHoneyTrail)
	end
	
    inst:Remove()
end

local function OnHit_Rubber(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
		
		DealDamage(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		
		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
		else
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
		end
			
		local x, y, z = target.Transform:GetWorldPosition()
		
		local ents = TheSim:FindEntities(x, y, z, 10, { "_combat" }, AURA_EXCLUDE_TAGS)
			
		for i, v in ipairs(ents) do 
			if v ~= target and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
				if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
					local rubberband = SpawnPrefab("slingshotammo_rubber_rebound")
					rubberband.Transform:SetPosition(target.Transform:GetWorldPosition())
					rubberband.components.projectile:Throw(inst, v, attacker)
					rubberband.components.projectile:SetHoming(true)
					
					rubberband.maxbounces = 30 * inst.powerlevel
					
					break
				end
			end
		end
	end
	
    inst:Remove()
end

local function OnHit_Tremor(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
	
		DealDamage(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		
		local tremors = SpawnPrefab("slingshot_tremors")
		tremors.Transform:SetPosition(target.Transform:GetWorldPosition())
		tremors.powerlevel = inst.powerlevel
		tremors.attacker = attacker
	end
	
    inst:Remove()
end

local function OnHit_MoonRock(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
	
		if target:HasTag("shadow") or target:HasTag("shadowcreature") or target:HasTag("stalker") or target:HasTag("shadowchesspiece") then
			inst.powerlevel = inst.powerlevel + 2
		end
	
		DealDamage(inst, attacker, target)
		ImpactFx(inst, attacker, target)
	end
	
    inst:Remove()
end

local function OnHit_Salt(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
		
		DealDamage(inst, attacker, target, true)
		ImpactFx(inst, attacker, target, true)
	end
	
    inst:Remove()
end

local function DealHealing(inst, attacker, target, salty)
    if target ~= nil and target:IsValid() and target:HasTag("player") and target.components.health ~= nil and not target.components.health:IsDead() then
        target.components.health:DoDelta(1)
    end
end

local function OnHit_Goop(inst, attacker, target)
	if target ~= nil and (inst.maxbounces == nil or inst.bouncecount < inst.maxbounces) then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
		
		DealHealing(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		
		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
		else
			inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
		end
			
		local x, y, z = target.Transform:GetWorldPosition()
		local playerdetected = false
		local goop = SpawnPrefab("slingshotammo_goop_proj_secondary")
		
		local players = TheSim:FindEntities(x, y, z, 10, { "_combat" }, {"noclaustrophobia", "playerghost"}, { "companion", "player" })
		local ents = TheSim:FindEntities(x, y, z, 10, { "_combat" }, GOOP_EXCLUDE_TAGS)
		
		for i, v in pairs(players) do 
			if v ~= target then
				goop.Transform:SetPosition(target.Transform:GetWorldPosition())
				goop.components.projectile:Throw(inst, v, attacker)
				goop.components.projectile:SetHoming(true)
				goop.oldtarget = v
				
				if inst.maxbounces == nil then
					goop.maxbounces = 20 * inst.powerlevel
				else
					goop.maxbounces = inst.maxbounces
					goop.bouncecount = inst.bouncecount + 1
				end
					
				playerdetected = true
				
				break
			end
		end
		
		if not playerdetected then
			for i, v in pairs(ents) do 
				if v ~= target and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
					goop.Transform:SetPosition(target.Transform:GetWorldPosition())
					goop.components.projectile:Throw(inst, v, attacker)
					goop.components.projectile:SetHoming(true)
					goop.oldtarget = v
				
					if inst.maxbounces == nil then
						goop.maxbounces = 20 * inst.powerlevel
					else
						goop.maxbounces = inst.maxbounces
						goop.bouncecount = inst.bouncecount + 1
					end
					
					goop.rebound = true
					
					break
				end
			end
		end
	end
	
    inst:Remove()
end

local function OnHit_Slime(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = inst.powerlevel + 1
			target:PushEvent("wixiebite")
		end
		
		DealDamage(inst, attacker, target)
		ImpactFx(inst, attacker, target)
		
		local x, y, z = target.Transform:GetWorldPosition()
		local hitfx = SpawnPrefab("slingshotammo_slime_impact")
		
		if target.slingshot_slime ~= nil then
			target.slingshot_slime:Advance()
		elseif target.components.combat then
			hitfx.entity:SetParent(target.entity)
			hitfx.Transform:SetPosition(0, 0, 0)
			
			if target.components.combat ~= nil and 
			target.components.combat.hiteffectsymbol ~= nil and
			target.components.combat.hiteffectsymbol ~= "marker" then
				hitfx.entity:AddFollower():FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
			elseif target:HasTag("smallcreature") then
				hitfx.Transform:SetPosition(0, .5, 0)
			else
				hitfx.Transform:SetPosition(0, 2, 0)
			end
			
			hitfx.target = target
			target.slingshot_slime = hitfx
			target.slingshot_slime:Advance()
		
			hitfx:ListenForEvent("onignite", function(inst)
					if target ~= nil then
						if target.components.combat ~= nil then
							if no_aggro(attacker, target) then
								target.components.combat:SetShouldAvoidAggro(attacker)
							end
						
							target.components.combat:GetAttacked(attacker, hitfx.damage, attacker)
							
							if target.components.combat ~= nil then
								target.components.combat:RemoveShouldAvoidAggro(attacker)
							end
						end
							
						local debuffkey = hitfx.prefab
						target.components.locomotor:RemoveExternalSpeedMultiplier(target, debuffkey) 
						target._slingslime_speedmulttask = nil
						target.slingshot_slime = nil
							
						SpawnPrefab("explode_small").Transform:SetPosition(target.Transform:GetWorldPosition())
					end
				
				
					hitfx:Remove()
				end, target)

			hitfx:DoPeriodicTask(.2, function()
				if target.components.burnable ~= nil and target.components.burnable:IsBurning() or target.components.propagator and target.components.propagator.spreading then
					if target ~= nil then
						if target.components.combat ~= nil then
							if no_aggro(attacker, target) then
								target.components.combat:SetShouldAvoidAggro(attacker)
							end
						
							target.components.combat:GetAttacked(attacker, 50, attacker)
							
							if target.components.combat ~= nil then
								target.components.combat:RemoveShouldAvoidAggro(attacker)
							end
						end
						
						local debuffkey = hitfx.prefab
						target.components.locomotor:RemoveExternalSpeedMultiplier(target, debuffkey) 
						target._slingslime_speedmulttask = nil
						target.slingshot_slime = nil
								
						SpawnPrefab("explode_small").Transform:SetPosition(target.Transform:GetWorldPosition())
					end
					
					hitfx:Remove()
				end
			end)
		end
	end
	
    inst:Remove()
end

local function OnHit_Shadow(inst, attacker, target)
	if target ~= nil then
		if target:HasDebuff("wixiecurse_debuff") then
			inst.powerlevel = 1.25
			target:PushEvent("wixiebite")
		else
			inst.powerlevel = 1
		end
		
		DealDamage(inst, attacker, target)
		ImpactFx(inst, attacker, target)
	end
	
    inst:Remove()
end

local function oncollide(inst, other)
    local attacker = inst.components.projectile.owner
    if other ~= nil and attacker ~= nil and 
		other:IsValid() and 
		other.components.combat ~= nil and not
		other:HasTag("projectile") and not
		other:HasTag("playerghost") and not
		other:HasTag("player") then
        if attacker ~= nil and attacker:IsValid() and other ~= attacker then
			inst.OnHit(inst, attacker, other)
			inst:Remove()
        end
    end
end

local function CollisionCheck(inst)
	if inst.OnHit ~= nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local attacker = inst.components.projectile.owner or nil
		
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 3, { "_combat" }, inst.healinggoop and GOOP_EXCLUDE_TAGS or AURA_EXCLUDE_TAGS)) do
			print(v.prefab.."for loop")
			if inst.healinggoop or v:GetPhysicsRadius(0) > 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
				print(v.prefab.."phys check")
				if inst.oldtarget == nil or inst.oldtarget ~= nil and not v == inst.oldtarget then
					print(v.prefab.."old target")
					if inst.healinggoop or not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
						print(v.prefab.."follower check")
						if inst.healinggoop and v ~= attacker or not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
							print(v.prefab.."not me check")
							inst.OnHit(inst, attacker, v)
							inst:Remove()
							return
						end
					end
				end
			end
		end
		
		for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, { "_combat" }, AURA_EXCLUDE_TAGS)) do
			if v:IsValid() and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
				if inst.oldtarget == nil or inst.oldtarget ~= nil and not v == inst.oldtarget then
					if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
						if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
							inst.OnHit(inst, attacker, v)
							inst:Remove()
							return
						end
					end
				end
			end
		end
	end
end

local function secondaryproj_fn(symbol, overridebuild)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    --inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	--inst.Physics:CollidesWith(COLLISION.GIANTS)
	--inst.Physics:CollidesWith(COLLISION.FLYERS)
	inst.Physics:SetCapsule(0.85, 0.85)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild(overridebuild or "wixieammo")
    inst.AnimState:PlayAnimation("spin_loop", true)
	inst.AnimState:OverrideSymbol("rock", overridebuild or "wixieammo", symbol)

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
	inst:AddTag("scarytoprey")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.persists = false
	
	if inst.powerlevel == nil then
		inst.powerlevel = 1
	end
	
    inst:AddComponent("locomotor")
	
    inst:AddComponent("weapon")
    inst:AddComponent("projectile")
	
    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnPreHitFn(nil)
    inst.components.projectile:SetOnHitFn(nil)
    inst.components.projectile:SetOnMissFn(nil)
	inst.components.projectile:SetLaunchOffset(Vector3(1, 0.5, 0))
	
	inst:DoPeriodicTask(FRAMES, CollisionCheck)
	
	inst:DoTaskInTime(2 - (inst.powerlevel * inst.powerlevel), inst.Remove)

    return inst
end

local function crackerproj_fn()
    local inst = secondaryproj_fn("rock")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Firecrackers)
	
	inst.impactfx = "explode_firecrackers"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS
			
	inst.OnHit = OnHit_Firecrackers
	
    return inst
end

local function honeyproj_fn()
    local inst = secondaryproj_fn("slow")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Honey)
	
	inst.impactfx = "slingshotammo_honey_impact"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW
	
	inst.OnHit = OnHit_Honey
	
    return inst
end

local function rubberproj_fn()
    local inst = secondaryproj_fn("marble")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Rubber)
	
	inst.impactfx = "slingshotammo_rubber_impact"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW
	
	inst.OnHit = OnHit_Rubber
	
    return inst
end

local function tremorproj_fn()
    local inst = secondaryproj_fn("poop")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Tremor)
	
	inst.impactfx = "sand_puff"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW
	
	inst.OnHit = OnHit_Tremor
	
    return inst
end

local function ShadowCheck(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local attacker = inst.components.projectile.owner or nil
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, { "_combat" }, { "noclaustrophobia", "bird", "rabbit", "playerghost", "abigail", "companion", "ghost", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible" }, { "shadow", "shadowcreature" })) do
		if v:IsValid() and v.components.combat ~= nil and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
				OnHit_MoonRock(inst, attacker, v)
			end
		end
    end
end

local function moonrockproj_fn()
    local inst = secondaryproj_fn("freeze")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_MoonRock)
	
	inst.impactfx = "slingshotammo_moonrock_impact"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_MARBLE
	
	inst.OnHit = OnHit_MoonRock
	
	inst:DoPeriodicTask(FRAMES, ShadowCheck)
	
    return inst
end

local function GlassCut(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local attacker = inst.components.projectile.owner or nil
	
	for i, v in ipairs(TheSim:FindEntities(x, y, z, 3, "_combat", { "noclaustrophobia", "bird", "rabbit", "wall", "invisible", "player", "companion", "INLIMBO" })) do
		if v:GetPhysicsRadius(0) > 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
				
					inst.finallevel = inst.powerlevel
					
					if no_aggro(attacker, v) then
						v.components.combat:SetShouldAvoidAggro(attacker)
					end
					
					if v:HasTag("shadow_aligned") then
						inst.finallevel = inst.powerlevel + .5
					end
					
					if v:HasDebuff("wixiecurse_debuff") then
						inst.finallevel = inst.finallevel + 1
						v:PushEvent("wixiebite")
					end
					
					if v:HasTag("shadowcreature") or 
					v.sg == nil or 
					v.wixieammo_hitstuncd == nil and not
					(v.sg:HasStateTag("busy") or 
					v.sg:HasStateTag("caninterrupt")) or
					v.sg:HasStateTag("frozen") then
						v.wixieammo_hitstuncd = v:DoTaskInTime(8, function()
							if v.wixieammo_hitstuncd ~= nil then
								v.wixieammo_hitstuncd:Cancel()
							end
							
							v.wixieammo_hitstuncd = nil
						end)
					
						v.components.combat:GetAttacked(attacker, (7 * inst.finallevel) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1), inst)
					else
						v.components.combat:GetAttacked(attacker, 0, inst)
						
						if v.components.combat ~= nil then
							v.components.combat:SetTarget(attacker)
						end
						
						v.components.health:DoDelta(-((7 * inst.finallevel) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)), false, inst, false, attacker, false)
					end
					
					if v.components.combat ~= nil then
						v.components.combat:RemoveShouldAvoidAggro(attacker)
					end
				end
			end
		end
    end

	for i, v in ipairs(TheSim:FindEntities(x, y, z, 2, "_combat", { "noclaustrophobia", "bird", "rabbit", "wall", "invisible", "player", "companion", "INLIMBO" })) do
		if v:GetPhysicsRadius(0) <= 1.5 and v:IsValid() and v.components.combat ~= nil and v.components.combat ~= nil and v.components.health ~= nil and not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
				if not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
				
					inst.finallevel = inst.powerlevel
					
					if no_aggro(attacker, v) then
						v.components.combat:SetShouldAvoidAggro(attacker)
					end
					
					if v:HasTag("shadow_aligned") then
						inst.finallevel = inst.powerlevel + .5
					end
					
					if v:HasDebuff("wixiecurse_debuff") then
						inst.finallevel = inst.finallevel + 1
						v:PushEvent("wixiebite")
					end
					
					if v:HasTag("shadowcreature") or 
					v.sg == nil or 
					v.wixieammo_hitstuncd == nil and not 
					(v.sg:HasStateTag("busy") or 
					v.sg:HasStateTag("caninterrupt")) or
					v.sg:HasStateTag("frozen") then
						v.wixieammo_hitstuncd = v:DoTaskInTime(8, function()
							if v.wixieammo_hitstuncd ~= nil then
								v.wixieammo_hitstuncd:Cancel()
							end
							
							v.wixieammo_hitstuncd = nil
						end)
					
						v.components.combat:GetAttacked(attacker, (7 * inst.finallevel) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1), inst)
					else
						v.components.combat:GetAttacked(attacker, 0, inst)
						
						if v.components.combat ~= nil then
							v.components.combat:SetTarget(attacker)
						end
						
						v.components.health:DoDelta(-((7 * inst.finallevel) * (attacker.components.combat ~= nil and attacker.components.combat.externaldamagemultipliers:Get() or 1)), false, inst, false, attacker, false)
					end
					
					if v.components.combat ~= nil then
						v.components.combat:RemoveShouldAvoidAggro(attacker)
					end
				end
			end
		end
    end
end

local function moonglassproj_fn()
    local inst = secondaryproj_fn("gold")

    if not TheWorld.ismastersim then
        return inst
    end
	
    --inst.Physics:ClearCollisionMask()
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(nil)
	
	inst.impactfx = "sand_puff"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD
	
	inst:DoPeriodicTask(FRAMES, GlassCut)
	
	inst.OnHit = nil
	
    return inst
end

local function saltproj_fn()
    local inst = secondaryproj_fn("thulecite")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Salt)
	
	inst.impactfx = "slingshotammo_salt_impact"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS
	
	inst.OnHit = OnHit_Salt
	
    return inst
end

local function goopproj_fn()
    local inst = secondaryproj_fn("trinket_1")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Goop)
	
	inst.maxbounces = nil
	inst.bouncecount = 0
	
	inst.healinggoop = true
	
	inst.impactfx = "slingshotammo_goop_impact"
	
	inst.damage = 0
	inst.rebound = false
	
	inst.OnHit = OnHit_Goop
	
    return inst
end

local function slimeproj_fn()
    local inst = secondaryproj_fn("freeze", "wixieammo_IA")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Slime)
	
	--inst.impactfx = "slingshotammo_goop_impact"
	
	inst.damage = 5
	
	inst.OnHit = OnHit_Slime
	
    return inst
end

local function shadowproj_fn()
    local inst = secondaryproj_fn("rock", "wixieammo_IA")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.Physics:SetCollisionCallback(nil)
    inst.components.projectile:SetOnHitFn(OnHit_Shadow)
	
	inst.impactfx = "wanda_attack_pocketwatch_normal_fx"
	
	inst.damage = TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS
			
	inst.OnHit = OnHit_Shadow
	
    return inst
end

local function OnHitLazy(inst, attacker, target)
	
	if inst.caster ~= nil then
	
		local xc, yc, zc = inst.caster.Transform:GetWorldPosition()
			
		local sandclone = SpawnPrefab("wixie_shadowclone")
			
		SpawnPrefab("shadow_puff_large_back").Transform:SetPosition(xc, yc - .1, zc)
		sandclone.Transform:SetPosition(xc, yc - .05, zc)
		SpawnPrefab("shadow_puff_large_front").Transform:SetPosition(xc, yc, zc)
		
		local targetingents = TheSim:FindEntities(xc, yc, zc, 15, { "_combat" }, { "noclaustrophobia", "INLIMBO" })
		
		for i, v in pairs(targetingents) do
			if v:IsValid() and v.components ~= nil and v.components.combat ~= nil and v.components.combat.target ~= nil and v.components.combat.target == inst.caster then
				--v.components.combat:SuggestTarget(inst)
				v.components.combat.target = sandclone
				print("change formation!")
			end
		end
		
		local pt = inst:GetPosition()
		if TheWorld.Map:IsPassableAtPoint(pt.x, 0, pt.z) then
			inst.caster.Physics:Teleport(pt:Get())
			inst.caster.SoundEmitter:PlaySound("dontstarve/common/staff_blink")
		end
	end
		
	local x, y, z = inst.Transform:GetWorldPosition()
		
	SpawnPrefab("sand_puff_large_back").Transform:SetPosition(x, y - .1, z)
	SpawnPrefab("slingshotammo_lazy_impact").Transform:SetPosition(x, y - .05, z)
	SpawnPrefab("sand_puff_large_front").Transform:SetPosition(x, y, z)
	
    inst:Remove()
end

local function lazyproj_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.entity:AddPhysics()
	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:SetCapsule(0.1, 0.1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("NOCLICK")
    inst:AddTag("projectile")

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo")
	inst.AnimState:PlayAnimation("spin_loop", true)
	inst.AnimState:OverrideSymbol("rock", "wixieammo_IA", "slow")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
	
	inst.caster = nil
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-25)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(1, 0.5, 0))
    inst.components.complexprojectile:SetOnHit(OnHitLazy)
	
    return inst
end

local function Advance(inst)
	if inst.level < 5 then
		inst.level = inst.level + 1
		
		inst.damage = 50 * inst.level
		
		inst.AnimState:PlayAnimation("lvl"..inst.level, false)
	end

	local debuffkey = inst.prefab
	local size = inst.level / 7.5
	
	if inst.target ~= nil and inst.target:IsValid() and inst.target.components.locomotor ~= nil then
		if inst.target._slingslime_speedmulttask ~= nil then
			inst.target._slingslime_speedmulttask:Cancel()
		end
		inst.target._slingslime_speedmulttask = inst.target:DoTaskInTime(30, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._slingslime_speedmulttask = nil inst:Remove() i.slingshot_slime = nil end)

		inst.target.components.locomotor:SetExternalSpeedMultiplier(inst.target, debuffkey, 1 - size)
	else
		inst:Remove()
	end
end

local function impactslimefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("wixie_slimeball")
    inst.AnimState:SetBuild("wixie_slimeball")
    inst.AnimState:PlayAnimation("lvl1", false)
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.damage = 50
	inst.level = 0
	inst.Advance = Advance
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/honey_drip")
	
	inst.persists = false

    return inst
end

local function shadowclone_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("wixie_shadowclone")
    inst.AnimState:SetBuild("wixie_shadowclone")
    inst.AnimState:PlayAnimation("pose"..math.random(5), true)

	inst:AddTag("shadowminion")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(500)
	
	inst:DoTaskInTime(30, function(inst) 
		inst.components.health:Kill() 
	end)
	
    inst:ListenForEvent("attacked", function(inst)
		inst.SoundEmitter:PlaySound("dontstarve/impacts/impact_sanity_armour_dull")
	end)
	
    inst:ListenForEvent("death", function(inst)
		SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		inst:Remove()
	end)
	
	inst.persists = false

    return inst
end

local function fncommon(symbol, inv, overridebuild)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:OverrideSymbol("rock", overridebuild or "wixieammo", symbol)

    inst:AddTag("molebait")
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")

    if not TUNING.DSTU.WIXIE then
        inst:DoTaskInTime(0, inst.Remove)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("reloaditem")

    inst:AddComponent("tradable")
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 0

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/"..inv..".xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("bait")
    MakeHauntableLaunch(inst)

    return inst
end

local function cracker_fn()
    local inst = fncommon("rock", "slingshotammo_firecrackers")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function honey_fn()
    local inst = fncommon("slow", "slingshotammo_honey")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 1
    inst.components.edible.healthvalue = 1
	
    return inst
end

local function rubber_fn()
    local inst = fncommon("marble", "slingshotammo_rubber")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function tremor_fn()
    local inst = fncommon("poop", "slingshotammo_tremor")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function moonrock_fn()
    local inst = fncommon("freeze", "slingshotammo_moonrock")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function moonglass_fn()
    local inst = fncommon("gold", "slingshotammo_moonglass")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function salt_fn()
    local inst = fncommon("thulecite", "slingshotammo_salt")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function goop_fn()
    local inst = fncommon("trinket_1", "slingshotammo_goop")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function slime_fn()
    local inst = fncommon("freeze", "slingshotammo_slime", "wixieammo_IA")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function lazy_fn()
    local inst = fncommon("slow", "slingshotammo_lazy", "wixieammo_IA")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function shadow_fn()
    local inst = fncommon("rock", "slingshotammo_shadow", "wixieammo_IA")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function Rebound(inst, attacker, target)
	if target ~= nil then
		ImpactFx(inst, attacker, target)
		
		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
		end
		
		
		if not target:HasTag("wall") and not target:HasTag("structure") then
			if no_aggro(attacker, target) then
				target.components.combat:SetShouldAvoidAggro(attacker)
			end
		
			target.components.combat:GetAttacked(inst, 10, inst)
			
			if target.components.combat ~= nil then
				target.components.combat:RemoveShouldAvoidAggro(attacker)
			end
		end
		
		if inst.bouncecount <= inst.maxbounces then
			local x, y, z = target.Transform:GetWorldPosition()
			
			local ents = TheSim:FindEntities(x, y, z, 10, { "_combat" }, AURA_EXCLUDE_TAGS)
			
			for i, v in pairs(ents) do
				--if v ~= target and v.components and v.components.health ~= nil and not (v.components.health:IsDead() or v == attacker or v:HasTag("playerghost") or (v:HasTag("player") and not TheNet:GetPVPEnabled())) then
				if v ~= target and (v:HasTag("bird_mutant") or not v:HasTag("bird")) then
					if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
						if target ~= nil and target:IsValid() and target.components and target.components.locomotor then
							local x, y, z = inst.Transform:GetWorldPosition()
							local tx, ty, tz = target.Transform:GetWorldPosition()
															
							local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
							
							
							--for i = 1, 50 do
								target:DoTaskInTime(0.1, function(target)
									if target ~= nil then 
										--local x, y, z = inst.Transform:GetWorldPosition()
										--local tx, ty, tz = target.Transform:GetWorldPosition()
										local tx2, ty2, tz2 = target.Transform:GetWorldPosition()
															
										--local rad = math.rad(inst:GetAngleToPoint(tx, ty, tz))
										local velx = math.cos(rad) --* 4.5
										local velz = -math.sin(rad) --* 4.5
															
										local giantreduction = target:HasTag("epic") and 4 or target:HasTag("smallcreature") and 1.5 or 2
											
										--local dx, dy, dz = tx2 + (((inst.powerlevel) / (i + 1)) * velx) / giantreduction, ty2, tz2 + (((inst.powerlevel) / (i + 1)) * velz) / giantreduction
										local dx, dy, dz = tx2 + (1 * velx) / giantreduction, ty2, tz2 + (1 * velz) / giantreduction
										local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
										local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
										local ocean = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
										local on_water = nil
																							
										if TUNING.DSTU.ISLAND_ADVENTURES then
											on_water = IsOnWater(dx, dy, dz)
										end
												
										if not (target.sg ~= nil and (target.sg:HasStateTag("swimming") or target.sg:HasStateTag("invisible"))) then	
											if target ~= nil and target.components.locomotor ~= nil and dx ~= nil and (ground or boat or ocean and target.components.locomotor:CanPathfindOnWater() or target.components.tiletracker ~= nil and not target:HasTag("whale")) then
												if not target:HasTag("aquatic") and not on_water or target:HasTag("aquatic") and on_water then
													--[[if ocean and target.components.amphibiouscreature and not target.components.amphibiouscreature.in_water then
														target.components.amphibiouscreature:OnEnterOcean()
													end]]
													
													target.Transform:SetPosition(dx, dy, dz)
												end
											end
										end
									end
								end)
							--end
						end
					
						local rubberband = SpawnPrefab("slingshotammo_rubber_rebound")
						rubberband.Transform:SetPosition(target.Transform:GetWorldPosition())
						
						rubberband.components.projectile:Throw(inst, v, attacker)
						rubberband.components.projectile:SetHoming(true)
						rubberband.maxbounces = inst.maxbounces
						rubberband.bouncecount = inst.bouncecount + 1
						
						break
					end
				end
			end
		end
	end
	
	inst:Remove()
end

local function rebound()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("slingshotammo")
    inst.AnimState:SetBuild("wixieammo")
    inst.AnimState:PlayAnimation("spin_loop", true)
	inst.AnimState:OverrideSymbol("rock", "wixieammo", "marble")

    inst:AddTag("blunt")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

	RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("weapon")

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(13)
    inst.components.projectile:SetOnHitFn(Rebound)
	
	inst.maxbounces = 30
	inst.bouncecount = 0
	inst.impactfx = "slingshotammo_rubber_impact"
	
	inst.persists = false
	inst:DoTaskInTime(2, inst.Remove)
	
    MakeHauntableLaunch(inst)

    return inst
end

local function commonimpact_fn(bank, build, anim, override, iaammo)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
	
	if anim ~= nil then
		inst.AnimState:PlayAnimation(anim)
	end
	
    inst.AnimState:SetRayTestOnBB(true)
	
	inst.AnimState:SetFinalOffset(FINALOFFSET_MAX)

	if override ~= nil then
		inst.AnimState:OverrideSymbol("rock", iaammo ~= nil and iaammo and "wixieammo_IA" or "wixieammo", override)
	end
	
    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local function impacthoneyfn()
    local inst = commonimpact_fn("honey_splash", "honey_splash", "anim")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/honey_drip")

    return inst
end

local function impactmoonrockfn()
    local inst = commonimpact_fn("slingshotammo", "wixieammo", "used", "freeze")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/rock")

    return inst
end

local function impactgoldfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("goldshattered")
    inst.AnimState:SetBuild("goldshattered")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/mine")
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false

    return inst
end

local function impactrubberfn()
    local inst = commonimpact_fn("slingshotammo", "wixieammo", "used", "marble")

    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function impactsaltfn()
    local inst = commonimpact_fn("slingshotammo", "wixieammo", "used", "thulecite")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/rock")

    return inst
end

local function impactgoopfn()
    local inst = commonimpact_fn("slingshotammo", "wixieammo", "used", "trinket_1")

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/honey_drip")

    return inst
end

local function impactlazyfn()
    local inst = commonimpact_fn("slingshotammo", "wixieammo", "used", "trinket_1", true)

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/gold")
	
    return inst
end

local TREMOR_EXCLUDE_TAGS = { "noclaustrophobia", "wall", "player", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "flying" }

local function Tremor(inst)
	if inst.attacker == nil then
		inst.attacker = inst
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local tremorring = SpawnPrefab("groundpoundring_fx")
	tremorring.Transform:SetPosition(x, y, z)
	tremorring.Transform:SetScale(0.66, 0.66, 0.66)
	
	local puffx = SpawnPrefab("sand_puff")
	puffx.Transform:SetPosition(x, y, z)
	
	local ents = TheSim:FindEntities(x, y, z, 5, { "_combat" }, AURA_EXCLUDE_TAGS)
	
	for i, v in ipairs(ents) do
		if (v:HasTag("bird_mutant") or not v:HasTag("bird")) and not v:HasTag("stageusher") then
			if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
		
				local distsq = v ~= nil and x ~= nil and v:GetDistanceSqToPoint(x, y, z) or 1
				for i = 1, 50 do
					inst:DoTaskInTime((i - 1) / 50, function(inst)
						local px, py, pz = v.Transform:GetWorldPosition()
						if px ~= nil then
							local distancemultiplier = 1 + (distsq / 10)
							local rad = math.rad(v:GetAngleToPoint(px, py, pz))
							local velx = math.cos(rad) --* 4.5
							local velz = -math.sin(rad) --* 4.5
							
							
							local giantreduction = v:HasTag("epic") and 3 or v:HasTag("smallcreature") and 0.8 or 1
									
							
							local dx, dy, dz = px + (((2 / (i + 1)) * velx) / giantreduction) / distancemultiplier, py, pz + (((2 / (i + 1)) * velz) / giantreduction) / distancemultiplier
													
							--local dx, dy, dz = px - (((FRAMES * 4) * velx) / multiplierplayer) * inst.Transform:GetScale(), py, pz - (((FRAMES * 4) * velz) / multiplierplayer) * inst.Transform:GetScale()
								
							local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
							local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
							local ocean = TheWorld.Map:IsOceanAtPoint(dx, dy, dz)
							local on_water = nil
																				
							if TUNING.DSTU.ISLAND_ADVENTURES then
								on_water = IsOnWater(dx, dy, dz)
							end
							
							if not (v.sg ~= nil and (v.sg:HasStateTag("swimming") or v.sg:HasStateTag("invisible"))) then	
								if v ~= nil and v.components.locomotor ~= nil and dx ~= nil and (ground or boat or ocean and v.components.locomotor:CanPathfindOnWater() or v.components.tiletracker ~= nil and not v:HasTag("whale")) then
									if not v:HasTag("aquatic") and not on_water or v:HasTag("aquatic") and on_water then
										--[[if ocean and v.components.amphibiouscreature and not v.components.amphibiouscreature.in_water then
											v.components.amphibiouscreature:OnEnterOcean()
										end]]
										
										v.Transform:SetPosition(dx, dy, dz)
									end
								end
							end
						end
					end)
				end
				
				if v:IsValid() and v.components.combat ~= nil and v.components.combat ~= nil and v.components.health ~= nil then
					inst.finaldamage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD * (1 + inst.powerlevel) / 2
					
					if inst.attacker ~= nil and 
						inst.attacker.components ~= nil and 
						inst.attacker.components.combat then
						
						inst.finaldamage = inst.finaldamage * (inst.attacker.components.combat ~= nil and inst.attacker.components.combat.externaldamagemultipliers:Get() or 1)
					end
					
					if no_aggro(inst.attacker, v) then
						v.components.combat:SetShouldAvoidAggro(inst.attacker)
					end
					
					v.components.combat:GetAttacked(inst.attacker, inst.finaldamage, inst)
					
					if v.components.combat ~= nil then
						v.components.combat:RemoveShouldAvoidAggro(inst.attacker)
					end
				end
			end
		end
	end
	
	
	inst.tremorcount = inst.tremorcount + 1
	
	if inst.tremorcount >= (3 * inst.powerlevel) then
		inst:Remove()
	end
end

local function tremmorfn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("shadowtalker")
    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	if inst.powerlevel == nil then
		inst.powerlevel = 1
	end
	
	inst.tremorcount = 0
	inst.attacker = nil

	inst:DoTaskInTime(0, Tremor)
	inst:DoPeriodicTask(1, Tremor)
	
	inst:DoPeriodicTask(0.4, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local x1 = x + math.random(-0.3, 0.3)
		local z1 = z + math.random(-0.3, 0.3)
		
		local fx = SpawnPrefab("sinkhole_warn_fx_"..math.random(3))
		fx.Transform:SetPosition(x1, 0, z1)
	end)
	
	inst.persists = false
		
    return inst
end

local function crackerexplosion_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
		
	--inst.Transform:SetFromProxy(proxy.GUID)
		
	inst.AnimState:SetBank("explode")
	inst.AnimState:SetBuild("explode")
	inst.AnimState:PlayAnimation("small_firecrackers")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetLightOverride(1)
		
	inst.Transform:SetFourFaced()

	inst:AddTag("FX")
		
	inst.entity:SetCanSleep(false)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.SoundEmitter:PlaySoundWithParams("dontstarve/common/together/fire_cracker", { start = math.random() })

	inst.persists = false
	inst:DoTaskInTime(1, inst.Remove)
	inst:ListenForEvent("animover", inst.Remove)

	return inst
end

return Prefab("slingshotammo_firecrackers", cracker_fn, assets, prefabs),
		Prefab("slingshotammo_firecrackers_proj_secondary", crackerproj_fn, assets, prefabs),
		Prefab("firecrackers_slingshot", fn, assets_firecrackers, prefabs_firecrackers),
		Prefab("slingshot_explode_firecrackers", crackerexplosion_fn, assets, prefabs),
		Prefab("slingshotammo_honey", honey_fn, assets, prefabs),
		Prefab("slingshotammo_honey_proj_secondary", honeyproj_fn, assets, prefabs),
		Prefab("slingshotammo_honey_impact", impacthoneyfn, assets, prefabs),
		Prefab("slingshotammo_goldshatter", impactgoldfn, assets, prefabs),
		Prefab("slingshotammo_rubber", rubber_fn, assets, prefabs),
		Prefab("slingshotammo_rubber_proj_secondary", rubberproj_fn, assets, prefabs),
		Prefab("slingshotammo_rubber_impact", impactrubberfn, assets, prefabs),
		Prefab("slingshotammo_rubber_rebound", rebound, assets, prefabs),
		Prefab("slingshot_vortex", vortexfn, assets, prefabs),
		Prefab("slingshotammo_tremor", tremor_fn, assets, prefabs),
		Prefab("slingshotammo_tremor_proj_secondary", tremorproj_fn, assets, prefabs),
		Prefab("slingshot_tremors", tremmorfn, assets, prefabs),
		Prefab("slingshotammo_moonrock", moonrock_fn, assets, prefabs),
		Prefab("slingshotammo_moonrock_proj_secondary", moonrockproj_fn, assets, prefabs),
		Prefab("slingshotammo_moonrock_impact", impactmoonrockfn, assets, prefabs),
		Prefab("slingshotammo_moonglass", moonglass_fn, assets, prefabs),
		Prefab("slingshotammo_moonglass_proj_secondary", moonglassproj_fn, assets, prefabs),
		Prefab("slingshotammo_salt", salt_fn, assets, prefabs),
		Prefab("slingshotammo_salt_proj_secondary", saltproj_fn, assets, prefabs),
		Prefab("slingshotammo_salt_impact", impactsaltfn, assets, prefabs),
		Prefab("slingshotammo_goop", goop_fn, assets, prefabs),
		Prefab("slingshotammo_goop_proj_secondary", goopproj_fn, assets, prefabs),
		Prefab("slingshotammo_goop_impact", impactgoopfn, assets, prefabs),
		Prefab("slingshotammo_slime", slime_fn, assets, prefabs),
		Prefab("slingshotammo_slime_impact", impactslimefn, assets, prefabs),
		Prefab("slingshotammo_slime_proj_secondary", slimeproj_fn, assets, prefabs),
		Prefab("slingshotammo_lazy", lazy_fn, assets, prefabs),
		Prefab("slingshotammo_lazy_proj_secondary", lazyproj_fn, assets, prefabs),
		Prefab("slingshotammo_lazy_impact", impactlazyfn, assets, prefabs),
		Prefab("slingshotammo_shadow", shadow_fn, assets, prefabs),
		Prefab("slingshotammo_shadow_proj_secondary", shadowproj_fn, assets, prefabs),
		Prefab("wixie_shadowclone", shadowclone_fn, assets, prefabs)