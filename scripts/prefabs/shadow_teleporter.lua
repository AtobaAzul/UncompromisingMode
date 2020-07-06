local assets =
{
    Asset("ANIM", "anim/shadow_teleporter.zip"),
}

local function CalcSanityAura(inst, observer)
    return observer.components.sanity:IsCrazy()
        and -TUNING.SANITYAURA_MED
        or 0
end

local function OnAppear(inst)
    inst:RemoveEventCallback("animover", OnAppear)
    if not inst.killed then
        inst:RemoveTag("notarget")
        inst.components.health:SetInvincible(false)
        inst.AnimState:PlayAnimation("idle", true)
    end
end

local function OnDeath(inst)
    if not inst.killed then
        inst.killed = true
		
		local x, y, z = inst.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("shadow_despawn")
		despawnfx.Transform:SetPosition(x, y, z)

        inst:AddTag("NOCLICK")
        inst.persists = false

        inst:RemoveEventCallback("animover", OnAppear)
        inst:RemoveEventCallback("death", OnDeath)

        inst:ListenForEvent("animover", inst.Remove)
        inst.AnimState:PlayAnimation("disappear")

        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + FRAMES, inst.Remove)
    end
end

local MAX_LIGHT_FRAME = 20

---Added Stuff



local function getrandomposition(caster)
		local centers = {}
		for i, node in ipairs(TheWorld.topology.nodes) do
			if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
				table.insert(centers, {x = node.x, z = node.y})
			end
		end
		if #centers > 0 then
			local pos = centers[math.random(#centers)]
			return Point(pos.x, 0, pos.z)
		else
			return caster:GetPosition()
		end
end

local function teleport_end(teleportee, locpos)

    if teleportee.components.inventory ~= nil and teleportee.components.inventory:IsHeavyLifting() then
        teleportee.components.inventory:DropItem(
            teleportee.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end

    --#v2c hacky way to prevent lightning from igniting us
    local preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
    if preventburning then
        teleportee.components.burnable.burning = true
    end
    TheWorld:PushEvent("ms_sendlightningstrike", locpos)
    if preventburning then
        teleportee.components.burnable.burning = false
    end

    if teleportee:HasTag("player") then
        teleportee.sg.statemem.teleport_task = nil
        teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
        teleportee.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
    else
        teleportee:Show()
        if teleportee.DynamicShadow ~= nil then
            teleportee.DynamicShadow:Enable(true)
        end
        if teleportee.components.health ~= nil then
            teleportee.components.health:SetInvincible(false)
        end
        teleportee:PushEvent("teleported")
    end
	
	
	local x, y, z = teleportee.Transform:GetWorldPosition()
	local nightylight = SpawnPrefab("nightlight")
	nightylight.Transform:SetPosition(x - 3, y, z - 3)
	nightylight.AnimState:SetMultColour(0, 0, 0, 0.6)
	nightylight:RemoveComponent("inspectable")
	nightylight:WatchWorldState("isday", function() 
		local x, y, z = nightylight.Transform:GetWorldPosition()
		local despawnfx = SpawnPrefab("shadow_despawn")
		despawnfx.Transform:SetPosition(x, y, z)
		
		nightylight:Remove()
	end)
	
	nightylight.persists = false
end

local function teleport_continue(teleportee, locpos)
    local ground = TheWorld
    if teleportee.Physics ~= nil then
        teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
    else
        teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
    end

    if teleportee:HasTag("player") then
        teleportee:SnapCamera()
        teleportee:ScreenFade(true, 2)
        teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3, teleport_end, locpos)
    else
        teleport_end(teleportee, locpos)
    end
end


local function OnAttacked(inst, data)
    if data ~= nil and data.attacker ~= nil and data.attacker:HasTag("player") then
		local ground = TheWorld
				
		local locpos = getrandomposition(data.attacker)
		data.attacker.sg:GoToState("forcetele")
		ground:PushEvent("ms_sendlightningstrike", data.attacker:GetPosition())
		data.attacker.sg.statemem.teleport_task = data.attacker:DoTaskInTime(1, teleport_continue, locpos)
		inst.components.health:Kill()
    end
end


local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .2)
    RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
    inst.Physics:CollidesWith(COLLISION.SANITY)

    inst.Transform:SetTwoFaced()

    --inst:AddTag("shadowcreature")
    --inst:AddTag("monster")
    --inst:AddTag("hostile")
    --inst:AddTag("shadow")
    inst:AddTag("notraptrigger")
    inst:AddTag("shadowteleporter")
    --inst:AddTag("notarget")

    inst.AnimState:SetBank("shadow_teleporter")
    inst.AnimState:SetBuild("shadow_teleporter")
    inst.AnimState:PlayAnimation("appear")
    inst.AnimState:SetMultColour(1, 1, 1, 1)

    -- this is purely view related
    --[[inst:AddComponent("transparentonsanity")
    inst.components.transparentonsanity.most_alpha = .8
    inst.components.transparentonsanity.osc_amp = .1]]

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
    inst.components.health:SetInvincible(true)
    inst.components.health.nofadeout = true
    inst.components.health.redirect = nodebrisdmg

    inst:AddComponent("combat")
	
    inst:AddComponent("inspectable")

    inst:AddComponent("savedrotation")
    inst:AddComponent("entitytracker")

    --inst:ListenForEvent("gotcommander", OnGotCommander)
    --inst:ListenForEvent("lostcommander", OnLostCommander)
	inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("animover", OnAppear)
    inst:ListenForEvent("death", OnDeath)
	
	inst:DoTaskInTime(30, function() inst.components.health:Kill() end)
	
	inst.persists = false

    return inst
end

return Prefab("shadow_teleporter", fn, assets)
