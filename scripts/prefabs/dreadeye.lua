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

local brain = require("brains/shadowcreaturebrain") -----------------------------------------

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
        if v.components.sanity:IsInsane() and not v:HasTag("playerghost") then
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
        attacker.components.sanity:DoDelta(20)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 15, { "player" }, { "playerghost" } )
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil and v.components.sanity:IsInsane() then
				v.components.sanity:DoDelta(10)
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
    if data ~= nil and data.afflicter ~= nil and data.afflicter:HasTag("crazy") then
        --max one nightmarefuel if killed by a crazy NPC (e.g. Bernie)
        inst.components.lootdropper:SetLoot({ "nightmarefuel" })
        inst.components.lootdropper:SetChanceLootTable(nil)
    end
end

local function ShadowSuprise(inst)
	if inst.isdisguised and not inst.components.health:IsDead() then 
		inst.sg:GoToState("disguise_attack")
		inst:RemoveTag("NOCLICK")
		
		if inst.suprise_task ~= nil then
			inst.suprise_task:Cancel()
			inst.suprise_task = nil
		end
		
		if inst.shadoweye_task ~= nil then
			inst.shadoweye_task:Cancel()
			inst.shadoweye_task = nil
		end
		
		inst.isdisguised = false
		inst.components.health:DoDelta(100)
	end
end

local function TryEyeSpawn(v)

	local x1, y1, z1 = v.Transform:GetWorldPosition()
	if x1 ~= nil and z1 ~= nil and v.components.sanity and v.components.sanity:IsInsane() then
		SpawnPrefab("mini_dreadeye").Transform:SetPosition(v.Transform:GetWorldPosition())
		--SpawnPrefab("mini_dreadeye").Transform:SetPosition(x1 + math.random(-5,5), 0, z1 + math.random(-5,5))
	end
	
end

local function ShadowEyeSpawn(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 50, nil, NOTAGS, { "player" })
	
	for i, v in ipairs(ents) do
        TryEyeSpawn(v)
    end
end

local function Disguise(inst)
	if not inst.components.health:IsDead() then
		inst:AddTag("NOCLICK")
		local morphchance = math.random(1, 4)
		if morphchance == 1 then
			SpawnPrefab("shadow_rock").Transform:SetPosition(inst.Transform:GetWorldPosition())
		elseif morphchance == 2 then
			SpawnPrefab("shadow_tree").Transform:SetPosition(inst.Transform:GetWorldPosition())
		elseif morphchance == 3 then
			SpawnPrefab("shadow_grass").Transform:SetPosition(inst.Transform:GetWorldPosition())
		else
			SpawnPrefab("shadow_sapling").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
		
		inst.isdisguised = true
		
		if inst.suprise_task ~= nil then
			inst.suprise_task:Cancel()
			inst.suprise_task = nil
		end
		
		inst.suprise_task = inst:DoPeriodicTask(15, ShadowSuprise)
		
		if inst.shadoweye_task ~= nil then
			inst.shadoweye_task:Cancel()
			inst.shadoweye_task = nil
		end
		
		inst.shadoweye_task = inst:DoPeriodicTask(4, ShadowEyeSpawn)
	end
end

local function onnear(inst, target)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 3, 0.5)
    RemovePhysicsColliders(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.WORLD)

    --inst.Transform:SetScale(1.12, 1.12, 1.12)
    --inst.Transform:SetFourFaced()

    inst:AddTag("shadowcreature")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
    inst:AddTag("notraptrigger")
	
	inst.suprise_task = nil

    inst.AnimState:SetBank("dreadeye")
    inst.AnimState:SetBuild("dreadeye")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    --inst:AddComponent("transparentonsanity_dreadeye")
    inst:AddComponent("transparentonsanity")

    inst.entity:SetPristine()
	
	inst.isdisguised = false

    if not TheWorld.ismastersim then
        return inst
    end

    inst.atkcount = 3
    --inst.disguise_form = nil
    --inst.disguise_cd = -1

    inst:AddComponent("uncompromising_shadowfollower")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.DSTU.DREADEYE_SPEED
    --inst.components.locomotor.pathcaps = { allowocean = true }
	inst.components.locomotor:SetTriggersCreep(false)
    inst.sounds = sounds
    inst:SetStateGraph("SGdreadeye")

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health.nofadeout = true
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
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
	
    inst.OnEntitySleep = OnEntitySleep

    --inst.OnSave = OnSave
    --inst.OnPreLoad = OnPreLoad

    --inst:DoPeriodicTask(FRAMES, function() dreadeyetimer(inst) end)

    inst.persists = false

    return inst
end

local function onnear(inst, target)
    SpawnPrefab("shadow_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
	SpawnPrefab("shadow_puff_large_back").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("shadow_puff_large_front").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:DoTaskInTime(0, function() inst:Remove() end)
end

local function shadowdisguise_fn(bank, build, anim, icon, tag, multcolour)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    if icon ~= nil then
        inst.MiniMapEntity:SetIcon(icon)
    end

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)

    if type(anim) == "table" then
        for i, v in ipairs(anim) do
            if i == 1 then
                inst.AnimState:PlayAnimation(v)
            else
                inst.AnimState:PushAnimation(v, false)
            end
        end
    else
        inst.AnimState:PlayAnimation(anim)
    end

    MakeSnowCoveredPristine(inst)

    inst:AddComponent("transparentonsanity_dreadeye_objects")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
--[[
    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "ROCK"--]]
    MakeSnowCovered(inst)
	
	inst:DoTaskInTime(15, function() 
	SpawnPrefab("shadow_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
	SpawnPrefab("shadow_puff_large_back").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("shadow_puff_large_front").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:DoTaskInTime(0, function() inst:Remove() end) 
	end)

    return inst
end


local function shadowrockfn()
    local inst = shadowdisguise_fn("rock", "rock", "full", "rock.png")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function shadowtreefn()
    local inst = shadowdisguise_fn("evergreen_short", "evergreen_new", "idle_normal", "evergreen.png")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function shadowgrassfn()
    local inst = shadowdisguise_fn("grass", "grass1", "idle", "grass.png")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function shadowsaplingfn()
    local inst = shadowdisguise_fn("sapling", "sapling", "sway", "sapling.png")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("dreadeye", fn, assets),
		Prefab("shadow_rock", shadowrockfn, shadowrock_assets),
		Prefab("shadow_tree", shadowtreefn, shadowtree_assets),
		Prefab("shadow_grass", shadowgrassfn, shadowgrass_assets),
		Prefab("shadow_sapling", shadowsaplingfn, shadowsapling_assets)