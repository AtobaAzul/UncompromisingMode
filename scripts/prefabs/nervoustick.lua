local prefabs =
{
    "nightmarefuel",
}

local assets =
{
    Asset("ANIM", "anim/nervoustick.zip"), -----------------------------------------
}

local sounds =
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature2/attack_grunt",
    death = "dontstarve/sanity/creature1/die",
    idle = "dontstarve/sanity/creature2/idle",
    taunt = "dontstarve/sanity/creature1/taunt",
    appear = "dontstarve/sanity/creature2/appear",
    disappear = "dontstarve/sanity/creature2/dissappear",
}

local brain = require("brains/nervoustickbrain") -----------------------------------------


local function retargetfn(inst)
	local target = 
	FindEntity(
				inst,
                8,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                end,
                { "player" },
                { "playerghost" }
            )
        or FindEntity(
				inst,
                15,
                function(guy)
                    return inst.components.combat:CanTarget(guy) and not guy:IsInLight()
                end,
                { "player" },
                { "playerghost" }
            )
        or nil
	
	return target
end

local function NotifyBrainOfTarget(inst, target)
    if inst.brain ~= nil and inst.brain.SetTarget ~= nil then
        inst.brain:SetTarget(target)
    end
end

local function onkilledbyother(inst, attacker)
    if attacker ~= nil and attacker.components.sanity ~= nil then
	
		inst.sanityreward = 1
	
        attacker.components.sanity:DoDelta(0.1)
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 10, { "player" }, { "playerghost" } )
		
		for i, v in ipairs(ents) do
			if v ~= attacker and v.components.sanity ~= nil and v.components.sanity:IsInsane() then
				inst.halfreward = ((v.components.sanity.max * 0.25) + 10) / 2
				inst.quarterreward = ((v.components.sanity.max * 0.25) + 10) / 4
				
				v.components.sanity:DoDelta(inst.halfreward)
				
				if v.components.sanity:IsInsane() then
					v.components.sanity:DoDelta(inst.halfreward)
				else
					v.components.sanity:DoDelta(inst.quarterreward)
				end
			end
		end
    end
end

local function ShareTargetFn(dude)
    return dude:HasTag("nervoustick") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
    inst.hitcount = inst.hitcount - 1
end

local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

local function startwiggling(inst, data)
	inst.randomimage = math.random(1, 8)
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/nervoustick_"..inst.randomimage..".xml"
	inst.components.inventoryitem:ChangeImageName("nervoustick_"..inst.randomimage.."")
end

local function startdamaging(inst, data)
    inst.owner = inst.components.inventoryitem.owner
	
	if inst.owner ~= nil and inst.owner.components.inventoryitem ~= nil then
		inst.owner = inst.owner.components.inventoryitem.owner
	end
	
    if inst.owner ~= nil then
		if inst.owner.components.health ~= nil and not inst.owner.components.health:IsDead() then
			inst.owner.components.health:DoDelta(-1)
		end
	else
		inst.task:Cancel()
		inst.task = nil
	end
end

local function topocket(inst, owner)
    --cancelblink(inst)
	if inst.task == nil then
		inst.task = inst:DoPeriodicTask(0.2, startwiggling)
		inst.damagetask = inst:DoPeriodicTask(1, startdamaging)
	end
    --tostore(inst, owner)
end

local function toground(inst)
	if inst.damagetask ~= nil then
		inst.damagetask:Cancel()
		inst.damagetask = nil
	end
	
	if inst.task ~= nil then
		inst.task:Cancel()
		inst.task = nil
	end
end

local function OnHitOther(inst, other)
	if other.components.inventory:IsFull() then
		inst.components.thief:StealItem(other)
	end
end

local function Invade(inst, data)
	if data.target ~= nil and data.target:HasTag("player") and not data.target.components.inventory ~= nil then
		if data.target.components.inventory:IsFull() then
			inst.components.thief:StealItem(data.target)
		end
		--inst.components.inventoryitem.canbepickedup = true
		inst.components.combat:ShareTarget(data.target, 30, ShareTargetFn, 1)
		
		data.target.components.inventory:GiveItem(inst)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, 0.5)
    RemovePhysicsColliders(inst)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    --inst.Physics:CollidesWith(COLLISION.WORLD)

    inst:AddTag("shadowcreature")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")
    inst:AddTag("nervoustick")
    inst:AddTag("notraptrigger")
    inst:AddTag("nosteal")

    inst.AnimState:SetBank("nervoustick")
    inst.AnimState:SetBuild("nervoustick")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetMultColour(1, 1, 1, .5)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 5
	inst.components.locomotor:SetTriggersCreep(false)
    inst.sounds = sounds
    inst:SetStateGraph("SGnervoustick")

    inst:AddComponent("knownlocations")

    inst:SetBrain(brain)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_TINY

    inst:AddComponent("health")
    inst.components.health.nofadeout = true

    inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(0.1)
    inst.components.combat:SetAttackPeriod(0.8)
    inst.components.combat:SetRange(1, 4)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    --inst.components.combat.onhitotherfn = OnHitOther

	inst.components.health:SetMaxHealth(1)

    --inst:AddComponent("shadowsubmissive")
    inst:AddComponent("lootdropper")
    inst:AddComponent("thief")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	--inst.components.inventoryitem.cangoincontainer = true
	inst.components.inventoryitem:SetSinks(false)
	
    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)
	
	inst:ListenForEvent("onattackother", Invade)
	
	inst:WatchWorldState("isday", inst.Remove)

    inst.persists = true

    return inst
end

local function beat(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/sanity/shadow_heart")
    inst.beattask = inst:DoTaskInTime(.75 + math.random() * .75, beat)
end

local function denfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("shadowheart")
    inst.AnimState:SetBuild("shadowheart")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(0, 0, 0, .5)

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(3)
	inst.components.childspawner:SetSpawnPeriod(3)
	inst.components.childspawner:SetMaxChildren(8)
	inst.components.childspawner.childname = "nervoustick"
    inst.components.childspawner:StartSpawning()
    inst.components.childspawner:StartRegen()
    -- initialize with no children
    inst.components.childspawner.childreninside = 0
	
    inst.beattask = inst:DoTaskInTime(.75 + math.random() * .75, beat)
	
	inst:WatchWorldState("isday", inst.Remove)

	return inst
end


return Prefab("nervoustick", fn, assets),
		Prefab("nervoustickden", denfn, assets, prefabs)