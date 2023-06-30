local prefabs =
{
    "nightmarefuel",
}

local assets =
{
    Asset("ANIM", "anim/dreadeye.zip"), -----------------------------------------
}

local shadowrock_assets =
{
    Asset("ANIM", "anim/rock.zip"),
    Asset("MINIMAP_IMAGE", "rock"),
}

local shadowtree_assets =
{
    Asset("ANIM", "anim/evergreen_new.zip"), --build
    Asset("ANIM", "anim/evergreen_new_2.zip"), --build
    Asset("ANIM", "anim/evergreen_tall_old.zip"),
    Asset("ANIM", "anim/evergreen_short_normal.zip"),

    Asset("SOUND", "sound/forest.fsb"),
    Asset("MINIMAP_IMAGE", "evergreen_lumpy"),

    Asset("MINIMAP_IMAGE", "evergreen_burnt"),
    Asset("MINIMAP_IMAGE", "evergreen_stump"),
}

local shadowgrass_assets =
{
    Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass1.zip"),
    Asset("ANIM", "anim/grass_diseased_build.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local shadowsapling_assets =
{
    Asset("ANIM", "anim/sapling.zip"),
    Asset("ANIM", "anim/sapling_diseased_build.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature2/die",
    idle = "dontstarve/sanity/creature2/idle",
    taunt = "dontstarve/sanity/creature2/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require("brains/dreadeyebrain") -----------------------------------------

--local original_tile_type = TheWorld.Map:GetTileAtPoint(pt:Get())
--local function dreadeyetimer(inst)
--inst.disguise_cd = inst.disguise_cd - 1
--end

local NOTAGS = { "playerghost", "INLIMBO" }

local function retargetfn(inst)
    local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
    local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
    local target1, target2 = nil, nil
    for i, v in ipairs(AllPlayers) do
        if v:IsValid() and inst:IsValid() and v.components.sanity:IsCrazy() and not v:HasTag("playerghost") and not v:HasTag("notarget_shadow") then
            local distsq = v:GetDistanceSqToInst(inst)
            if distsq < rangesq then
                if inst.components.shadowsubmissive:TargetHasDominance(v) then
                    if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
                        target1 = v
                        rangesq1 = distsq
                        rangesq = math.max(rangesq1, rangesq2)
                    end
                elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
                    target2 = v
                    rangesq2 = distsq
                    rangesq = math.max(rangesq1, rangesq2)
                end
            end
        end
    end

    if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
        --Targets with shadow dominance have higher priority within half targeting range
        --Force target switch if current target does not have shadow dominance
        return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
    end
    return target2
end

local function NotifyBrainOfTarget(inst, target)
    if inst.brain ~= nil and inst.brain.SetTarget ~= nil then
        inst.brain:SetTarget(target)
    end
end

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
		inst.sanityreward = 20
		
        attacker.components.sanity:DoDelta(inst.sanityreward)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		if inst.sanityreward ~= nil then
			inst.halfreward = inst.sanityreward / 2
		end
		
		if inst.sanityreward ~= nil then
			inst.quarterreward = inst.sanityreward / 4
		end
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil then
				if v.components.sanity:IsInsane() then
					v.components.sanity:DoDelta(inst.halfreward)
				else
					v.components.sanity:DoDelta(inst.quarterreward)
				end
			end
		end
    end
end

local function CalcSanityAura(inst, observer)
    return inst.components.combat:HasTarget()
        and observer.components.sanity:IsCrazy()
        and -TUNING.SANITYAURA_LARGE
        or 0
end

local function ShareTargetFn(dude)
    return dude:HasTag("shadowcreature") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function OnDeath(inst, data)
	if inst.disguiseprefab ~= nil then
		local px, py, pz = inst.disguiseprefab.Transform:GetWorldPosition()
		SpawnPrefab("mini_dreadeye_fx").Transform:SetPosition(px, py, pz)
		inst.disguiseprefab:Remove()
		inst.disguiseprefab = nil
	end

    if data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("crazy") then
        --max one nightmarefuel if killed by a crazy NPC (e.g. Bernie)
        inst.components.lootdropper:SetLoot({ "nightmarefuel" })
        inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function ShadowSuprise(inst)
	if inst.isdisguised and not inst.components.health:IsDead() then 
		inst.sg:GoToState("disguise_attack")
		inst.isdisguised = false
		
		if inst.suprise_task ~= nil then
			inst.suprise_task:Cancel()
			inst.suprise_task = nil
		end
		
		if inst.shadoweye_task ~= nil then
			inst.shadoweye_task:Cancel()
			inst.shadoweye_task = nil
		end
		
		--inst.components.health:DoDelta(100)
		
		if inst.disguiseprefab ~= nil then
			local px, py, pz = inst.disguiseprefab.Transform:GetWorldPosition()
			SpawnPrefab("mini_dreadeye_fx").Transform:SetPosition(px, py, pz)
			--inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
			inst.disguiseprefab:Remove()
			inst.disguiseprefab = nil
		end
	end
end

local function TryEyeSpawn(inst, v)

	local x1, y1, z1 = v.Transform:GetWorldPosition()
	if x1 ~= nil and z1 ~= nil and v.components.sanity and v.components.sanity:IsInsane() then
		local eye = TheSim:FindEntities(x1, y1, z1, 8, {"shadow_eye"})
			
		if eye ~= nil and #eye ~= 0 then
			return
		end
			
		local myeye = SpawnPrefab("mini_dreadeye")
		myeye.Transform:SetPosition(v.Transform:GetWorldPosition())
		myeye.leader = inst
		
		--SpawnPrefab("mini_dreadeye").Transform:SetPosition(x1 + math.random(-5,5), 0, z1 + math.random(-5,5))
	end
	
end

local function ShadowEyeSpawn(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, nil, NOTAGS, { "player" })
	
	for i, v in ipairs(ents) do
        TryEyeSpawn(inst, v)
    end
end

local function Disguise(inst)
	if not inst.components.health:IsDead() then
		inst.isdisguised = true
		inst.disguisecount = 0
	
		local disguise = SpawnPrefab("dreadeye_disguise")
		disguise.Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.disguiseprefab = disguise
		disguise.host = inst
		
		if inst.suprise_task ~= nil then
			inst.suprise_task:Cancel()
			inst.suprise_task = nil
		end
		
		inst.suprise_task = inst:DoTaskInTime(20, ShadowSuprise)
		
		if inst.shadoweye_task ~= nil then
			inst.shadoweye_task:Cancel()
			inst.shadoweye_task = nil
		end
		
		if inst.components.combat:HasTarget() then
			inst.shadoweye_task = inst:DoPeriodicTask(4, ShadowEyeSpawn)
		end
	end
end

local function TryDisguise(inst, target)
	inst.disguisetarget = target
	inst.sg:GoToState("disguise_pre")
	--Disguise(inst)
end

local function ResetCooldown(inst)
	if inst.oncooldown ~= nil then
		inst.oncooldown:Cancel()
	end
	
	inst.oncooldown = nil
end

local function onnear(inst, target)
	if inst.oncooldown == nil then
		if inst.isdisguised and not inst.components.health:IsDead() then
			if target ~= nil and target.components.sanity ~= nil and target.components.sanity:GetPercent() <= .7 then
				inst.sg:GoToState("disguise_attack")
				inst.isdisguised = false
				
				if inst.suprise_task ~= nil then
					inst.suprise_task:Cancel()
					inst.suprise_task = nil
				end
				
				if inst.shadoweye_task ~= nil then
					inst.shadoweye_task:Cancel()
					inst.shadoweye_task = nil
				end
				
				SpawnPrefab("dreadeye_sanityburst").Transform:SetPosition(inst.Transform:GetWorldPosition())
				SpawnPrefab("mini_dreadeye_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				
				if inst.disguiseprefab ~= nil then
					inst.disguiseprefab:Remove()
					inst.disguiseprefab = nil
				end
				
				inst.oncooldown = inst:DoTaskInTime(2.5, ResetCooldown)
			end
		elseif not inst.isdisguised and not inst.components.health:IsDead() and not inst.components.combat:HasTarget() then	
			if target ~= nil and target.components.sanity ~= nil and target.components.sanity:GetPercent() <= .7 and target.components.sanity:GetPercent() > .2 then
				TryDisguise(inst, target)
				
				inst.oncooldown = inst:DoTaskInTime(2.5, ResetCooldown)
			else
				inst.sg:GoToState("teleport_to")
				
				inst.oncooldown = inst:DoTaskInTime(2.5, ResetCooldown)
			end
		end
	end
end

local function onfar(inst, target)
	if inst.oncooldown == nil then
		if not inst.isdisguised and not inst.components.health:IsDead() and not inst.components.combat:HasTarget() then	
			TryDisguise(inst, target)
		end
	end
end

local function OnEntitySleep(inst)
	inst.sg:GoToState("disguise_attack")
end

local function OnSave(inst, data)
    data.atkcount = inst.atkcount or nil
end

local function OnPreLoad(inst, data)
    if data ~= nil then
        if data.atkcount then
            inst.atkcount = data.atkcount
        end
    end
end

local function CLIENT_ShadowSubmissive_HostileToPlayerTest(inst, player)
	if player:HasTag("shadowdominance") then
		return false
	end
	local combat = inst.replica.combat
	if combat ~= nil and combat:GetTarget() == player then
		return true
	end
	local sanity = player.replica.sanity
	if sanity ~= nil and sanity:IsCrazy() then
		return true
	end
	return false
end

local function AllRadiusPlayers(inst, self)
	if inst.oncooldown == nil then
		local x, y, z = inst.Transform:GetWorldPosition()
		local radius = 4
		
		if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
			radius = 6
		end
		
		local players = FindPlayersInRange(x, y, z, radius, { "player" }, { "playerghost" })

		local closeplayers = {}
		for i, v in ipairs(players) do
			if v:IsValid() then
				onnear(inst, v)
			end
		end
	end
end

local function PokeDisguise(inst)
	if inst.isdisguised then
		inst.disguisecount = inst.disguisecount + 1
		
		if inst.disguisecount == 2 then
			ShadowSuprise(inst)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 3, 0.5)
    RemovePhysicsColliders(inst)
	inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	inst.Physics:CollidesWith(COLLISION.SANITY)

    --inst.Transform:SetScale(1.12, 1.12, 1.12)
    --inst.Transform:SetFourFaced()

    inst:AddTag("shadowcreature")
	inst:AddTag("gestaltnoloot")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
	inst:AddTag("shadow_aligned")
    inst:AddTag("notraptrigger")
	inst:AddTag("ignorewalkableplatforms")

	--shadowsubmissive (from shadowsubmissive component) added to pristine state for optimization
	inst:AddTag("shadowsubmissive")
	
	inst.suprise_task = nil

    inst.AnimState:SetBank("dreadeye")
    inst.AnimState:SetBuild("dreadeye")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    --inst:AddComponent("transparentonsanity_dreadeye")
    if not TheNet:IsDedicated() then
		-- this is purely view related
		inst:AddComponent("transparentonsanity_dreadeye")
		inst.components.transparentonsanity_dreadeye:ForceUpdate()
	end

	inst.HostileToPlayerTest = CLIENT_ShadowSubmissive_HostileToPlayerTest

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.disguisecount = 0
	inst.PokeDisguise = PokeDisguise
	inst.isdisguised = false
    inst.atkcount = 3
	inst.TryDisguise = TryDisguise
    --inst.disguise_form = nil
    --inst.disguise_cd = -1

    inst:AddComponent("uncompromising_shadowfollower")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.DSTU.DREADEYE_SPEED
    --inst.components.locomotor.pathcaps = { allowocean = true }
    inst.components.locomotor.pathcaps = { ignorecreep = true }
	inst.components.locomotor:SetTriggersCreep(false)
    inst.sounds = sounds
    inst:SetStateGraph("SGdreadeye")

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health.nofadeout = true
	
    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.DSTU.DREADEYE_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.DSTU.DREADEYE_RANGE_1, TUNING.DSTU.DREADEYE_RANGE_2)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst.components.health:SetMaxHealth(TUNING.DSTU.DREADEYE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.DSTU.DREADEYE_DAMAGE)

    inst:AddComponent("shadowsubmissive")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "nightmarefuel" })

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
    inst:ListenForEvent("death", OnDeath)

	inst.Disguise = Disguise
	
	inst:DoPeriodicTask(.5, AllRadiusPlayers)
	
    --inst.OnEntitySleep = OnEntitySleep

    --inst.OnSave = OnSave
    --inst.OnPreLoad = OnPreLoad

    --inst:DoPeriodicTask(FRAMES, function() dreadeyetimer(inst) end)

    inst.persists = false

    return inst
end

local function near_burst(inst, target)
	if target ~= nil and target.components.sanity ~= nil and target.components.sanity:GetPercent() <= .7 then
		if target.components.sanity ~= nil and target.components.sanity:IsSane() then
			target.components.sanity:DoDelta(-10)
		end
	end
	
	inst:Remove()
end

local function SanityBurst(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local radius = 6
		
	local burstring = SpawnPrefab("dreadeye_sanityburstring")
	burstring.Transform:SetPosition(x, 0, z)
	burstring.Transform:SetScale(1.8, 1.8, 1.8)
	if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
		radius = 8
		burstring.Transform:SetScale(2.1, 2.1, 2.1)
	end
		
	local players = FindPlayersInRange(x, y, z, radius, { "player" }, { "playerghost" })

	local closeplayers = {}
	for i, v in ipairs(players) do
		if v:IsValid() then
			near_burst(inst, v)
		end
	end
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("shadow_teleport")
    inst.AnimState:SetBuild("shadow_teleport")
    inst.AnimState:PlayAnimation("portal_in")
	inst.AnimState:SetTime(inst.AnimState:GetCurrentAnimationLength() / 2)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.Transform:SetScale(2, 2, 2)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    if not TheNet:IsDedicated() then
		inst:AddComponent("transparentonsanity_dreadeye")
		inst.components.transparentonsanity_dreadeye:ForceUpdate()
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("animover", SanityBurst)

    inst.persists = false

    return inst
end

local function fx2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("dreadeye_circle")
    inst.AnimState:SetBuild("dreadeye_circle")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	inst.Transform:SetScale(2, 2, 2)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    if not TheNet:IsDedicated() then
		inst:AddComponent("transparentonsanity_dreadeye")
		inst.components.transparentonsanity_dreadeye:ForceUpdate()
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")
	
	inst:ListenForEvent("animover", inst.Remove)

    inst.persists = false

    return inst
end

local disguises =
{
	{
		name = "rock1",
		bank = "rock",
		build = "rock",
		anim = "full",
	},
	{
		name = "rock2",
		bank = "rock2",
		build = "rock2",
		anim = "full",
	},
	{
		name = "evergreen",
		bank = "evergreen_short",
		build = "evergreen_new",
		anim = "idle_normal",
	},
	{
		name = "grass",
		bank = "grass",
		build = "grass1",
		anim = "idle",
	},
	{
		name = "sapling",
		bank = "sapling",
		build = "sapling",
		anim = "sway",
	},
	{
		name = "berrybush",
		bank = "berrybush",
		build = "berrybush",
		anim = "idle",
	},
	{
		name = "carrot_planted",
		bank = "carrot",
		build = "carrot",
		anim = "planted",
	},
}

local situational_disguises =
{
	{
		name = "rock1",
		bank = "rock",
		build = "rock",
		anim = "full",
	},
	{
		name = "rock2",
		bank = "rock2",
		build = "rock2",
		anim = "full",
	},
	{
		name = "reeds",
		bank = "grass",
		build = "reeds",
		anim = "idle",
	},
	{
		name = "marsh_tree",
		bank = "marsh_tree",
		build = "tree_marsh",
		anim = "swap_1_loop",
	},
	{
		name = "rock_flintless",
		bank = "rock_flintless",
		build = "rock_flintless",
		anim = "full",
	},
	{
		name = "hooded_fern",
		bank = "largefern",
		build = "largefern",
		anim = "idle",
	},
	{
		name = "evergreen_sparse",
		bank = "evergreen_short",
		build = "evergreen_new_2",
		anim = "idle_normal",
	},
	{
		name = "trapdoorgrass",
		bank = "trapdoorgrass",
		build = "trapdoorgrass",
		anim = "idle",
	},
	{
		name = "deciduoustree",
		bank = "tree_leaf",
		build = "tree_leaf_trunk_build",
		anim = "idle_tall",
	},
	{
		name = "grass",
		bank = "grass",
		build = "grass1",
		anim = "idle",
	},
}

local cave_disguises =
{
	{
		name = "stalagmite_tall",
		bank = "rock_stalagmite_tall",
		build = "rock_stalagmite_tall",
		anim = "full_"..math.random(2),
	},
	{
		name = "stalagmite_tall_full",
		bank = "rock_stalagmite_tall",
		build = "rock_stalagmite_tall",
		anim = "full_"..math.random(2),
	},
	{
		name = "stalagmite_tall_med",
		bank = "rock_stalagmite_tall",
		build = "rock_stalagmite_tall",
		anim = "med_"..math.random(2),
	},
	{
		name = "stalagmite_tall_low",
		bank = "rock_stalagmite_tall",
		build = "rock_stalagmite_tall",
		anim = "low_"..math.random(2),
	},
}

local situational_cave_disguises =
{
	{
		name = "mushtree_tall",
		bank = "mushroom_tree",
		build = "mushroom_tree_tall",
		anim = "idle_loop",
	},
	{
		name = "mushtree_medium",
		bank = "mushroom_tree_med",
		build = "mushroom_tree_med",
		anim = "idle_loop",
	},
	{
		name = "mushtree_small",
		bank = "mushroom_tree_small",
		build = "mushroom_tree_small",
		anim = "idle_loop",
	},
	-- ruins
	{
		name = "ruins_statue_head",
		bank = "statue_ruins",
		build = "statue_ruins",
		anim = "idle_full",
	},
	{
		name = "ruins_statue_head_nogem",
		bank = "statue_ruins_small",
		build = "statue_ruins_small",
		anim = "idle_full",
	},
	{
		name = "ruins_statue_mage",
		bank = "statue_ruins",
		build = "statue_ruins",
		anim = "idle_full",
	},
	{
		name = "ruins_statue_mage_nogem",
		bank = "statue_ruins_small",
		build = "statue_ruins_small",
		anim = "idle_full",
	},
}

local ocean_disguises =
{
	{
		name = "bullkelp_plant",
		bank = "bullkelp",
		build = "bullkelp",
		anim = "idle",
	},
	{
		name = "boatfragment04",
		bank = "boat_broken",
		build = "boat_brokenparts_build",
		anim = "idle_loop_03",
	},
	{
		name = "boatfragment05",
		bank = "boat_broken",
		build = "boat_brokenparts_build",
		anim = "idle_loop_04",
	},
	{
		name = "boatfragment03",
		bank = "boat_broken",
		build = "boat_brokenparts_build",
		anim = "idle_loop_05",
	},
	{
		name = "messagebottle",
		bank = "bottle",
		build = "bottle",
		anim = "idle_water",
	},
	{
		name = "seastack",
		bank = "water_rock01",
		build = "water_rock_01",
		anim = math.random(5).."_full"
	},
}

local function shadowdisguise_fn(bank, build, anim, icon, tag, multcolour)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeSnowCoveredPristine(inst)

    inst:AddComponent("transparentonsanity_dreadeye_objects")

	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	
	inst:DoTaskInTime(0, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 20)
		
		if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
			if TheWorld:HasTag("cave") then
				for i, v in ipairs(situational_cave_disguises) do
					for n, b in ipairs(ents) do
						if v.name == b.prefab then
							inst.AnimState:SetBank(v.bank)
							inst.AnimState:SetBuild(v.build)
							
							inst.AnimState:PlayAnimation(v.anim, true)
							return
						end
					end
				end
				
				local disguisechoice = math.random(#cave_disguises)
		
				for i, v in ipairs(cave_disguises) do
					if i == disguisechoice then
						inst.AnimState:SetBank(v.bank)
						inst.AnimState:SetBuild(v.build)
						
						inst.AnimState:PlayAnimation(v.anim, true)
					end
				end
			else
				for i, v in ipairs(situational_disguises) do
					for n, b in ipairs(ents) do
						if v.name == b.prefab then
							inst.AnimState:SetBank(v.bank)
							inst.AnimState:SetBuild(v.build)
							
							if v.name == "deciduoustree" then
								if not TheWorld.state.iswinter then
									if TheWorld.state.isautumn then
										inst.AnimState:OverrideSymbol("swap_leaves", "tree_leaf_orange_build", "swap_leaves")
									else
										inst.AnimState:OverrideSymbol("swap_leaves", "tree_leaf_green_build", "swap_leaves")
									end
								end
									
								inst.color = .5 + math.random() * .5
								inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
							end
							
							inst.AnimState:PlayAnimation(v.anim, true)
							return
						end
					end
				end
				
				local disguisechoice = math.random(#disguises)
				
				for i, v in ipairs(disguises) do
					if i == disguisechoice then
						inst.AnimState:SetBank(v.bank)
						inst.AnimState:SetBuild(v.build)
						
						inst.AnimState:PlayAnimation(v.anim, true)
					end
				end
			end
		else
			for i, v in ipairs(ocean_disguises) do
				for n, b in ipairs(ents) do
					if v.name == b.prefab then
						inst.AnimState:SetBank(v.bank)
						inst.AnimState:SetBuild(v.build)
						inst.AnimState:PlayAnimation(v.anim, true)
						
						if v.name == "seastack" then
							inst.front_fx = SpawnPrefab("float_fx_front")
							inst.front_fx.entity:SetParent(inst.entity)
							inst.front_fx.Transform:SetPosition(0, 0.1, 0)
							inst.front_fx.AnimState:PlayAnimation("idle_front_med", true)
							inst.front_fx.Transform:SetScale(1.1, 0.9, 1.1)
						elseif v.name == "messagebottle" then
							inst.front_fx = SpawnPrefab("float_fx_front")
							inst.front_fx.entity:SetParent(inst.entity)
							inst.front_fx.Transform:SetPosition(0, 0.04, 0)
							inst.front_fx.AnimState:PlayAnimation("idle_front_small", true)
						elseif v.name == "bullkelp_plant" then
							AddDefaultRippleSymbols(inst, true, false)
						end
						
						return
					end
				end
				
				local disguisechoice = math.random(#disguises)
				
				if i == disguisechoice then
					inst.AnimState:SetBank(v.bank)
					inst.AnimState:SetBuild(v.build)
					inst.AnimState:PlayAnimation(v.anim, true)
						
					if v.name == "seastack" then
						inst.front_fx = SpawnPrefab("float_fx_front")
						inst.front_fx.entity:SetParent(inst.entity)
						inst.front_fx.Transform:SetPosition(0, 0.1, 0)
						inst.front_fx.AnimState:PlayAnimation("idle_front_med", true)
						inst.front_fx.Transform:SetScale(1.1, 0.9, 1.1)
					elseif v.name == "messagebottle" then
						inst.front_fx = SpawnPrefab("float_fx_front")
						inst.front_fx.entity:SetParent(inst.entity)
						inst.front_fx.Transform:SetPosition(0, 0.04, 0)
						inst.front_fx.AnimState:PlayAnimation("idle_front_small", true)
					elseif v.name == "bullkelp_plant" then
						AddDefaultRippleSymbols(inst, true, false)
					end
				end
			end
		end
	end)
	
	MakeSnowCovered(inst)
	
    return inst
end
	
return Prefab("dreadeye", fn, assets),
		Prefab("dreadeye_sanityburst", fxfn),
		Prefab("dreadeye_sanityburstring", fx2fn),
		Prefab("dreadeye_disguise", shadowdisguise_fn)