local assets =
{
    Asset("ANIM", "anim/blow_dart.zip"),
    Asset("ANIM", "anim/swap_blowdart.zip"),
    Asset("ANIM", "anim/swap_blowdart_pipe.zip"),
}

local _turnoffstring = ACTIONS.TURNOFF.strfn

ACTIONS.TURNOFF.strfn = function(act)
    local tar = act.target
	return tar ~= nil and tar:HasTag("harpoonreel") and "HARPOON" or _turnoffstring(act)
end

local prefabs =
{
    "impact",
}

local prefabs_yellow =
{
    "impact",
    "electrichitsparks",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_um_harpoon", "swap_um_harpoon")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("impact")
    if impactfx ~= nil and target.components.combat then
        local follower = impactfx.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0, 0)
        if attacker ~= nil and attacker:IsValid() then
            impactfx:FacePoint(attacker.Transform:GetWorldPosition())
        end
    end
	
	
	if inst.x ~= nil then
		local ground = TheWorld.Map:IsPassableAtPoint(inst.x, inst.y, inst.z)
		local boat = TheWorld.Map:GetPlatformAtPoint(inst.x, inst.z)
		
		if ground or boat then
			--[[local hitpoint = SpawnPrefab("spear")
			hitpoint.Transform:SetPosition(inst.x, inst.y, inst.z)
			hitpoint.entity:SetParent(target.entity)]]
			
			local reel = SpawnPrefab("uncompromising_harpoonreel")
			reel.Transform:SetPosition(inst.x, inst.y, inst.z)
			reel.target = target
			reel.damagemax = inst.damagemax
			reel.tensionmax = inst.tensionmax
			reel.ropetype = inst.ropetype
			reel.AnimState:PlayAnimation("place")
		end
	end
	
    inst:Remove()
end

local function onthrown(inst, data)
	if data ~= nil and data.thrower then
		local x, y, z = data.thrower.Transform:GetWorldPosition()
		inst.x = x
		inst.y = y
		inst.z = z
	end

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
end

local function pipethrown(inst)
    --inst.AnimState:PlayAnimation("dart_pipe")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function spawntornado(inst, target)
	local owner = inst.components.inventoryitem.owner
	
	if owner == nil then
		return
	end
	
	local x, y, z = owner.Transform:GetWorldPosition()
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
	
	if target.components ~= nil and target.components.workable and not owner:GetCurrentPlatform() then
		return
	end
	
	local proj = SpawnPrefab("uncompromising_harpoon_projectile")
	proj.Transform:SetPosition(x, y, z)
	proj.components.projectile:Throw(owner, target)
	proj.damagemax = inst.damagemax
	proj.tensionmax = inst.tensionmax
	proj.ropetype = inst.ropetype
	
	inst:Remove()
end

local function fncommon(ropetype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_harpoon")
    inst.AnimState:SetBuild("um_harpoon")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("quickcast")
    inst:AddTag("nopunch")

    inst.spelltype = "HARPOON"

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "small", 0.05, {0.75, 0.5, 0.75})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.ropetype = ropetype

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    -------
	
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	if inst.tensionmax ~= nil and inst.tensionmax > 150 then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/uncompromising_harpoon_heavy.xml"
	else
		inst.components.inventoryitem.atlasname = "images/inventoryimages/uncompromising_harpoon.xml"
	end
	
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseonworkable = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.quickcast = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canuseonpoint_water = false
    inst.components.spellcaster:SetSpellFn(spawntornado)
    inst.components.spellcaster.castingstate = "castspell_tornado"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

local function fnlight()
    local inst = fncommon("uncompromising_harpoonrope")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.tensionmax = 150
	inst.damagemax = 150

    return inst
end

local function fnheavy()
    local inst = fncommon("uncompromising_harpoonchain")

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.tensionmax = 250
	inst.damagemax = 250

    return inst
end

local function harpoon()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("um_harpoon")
    inst.AnimState:SetBuild("um_harpoon")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("blowdart")
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")
	inst:AddTag("NOCLICK")
	RemovePhysicsColliders(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetOnThrownFn(pipethrown)
    inst.components.projectile:SetRange(TUNING.WALRUS_DART_RANGE)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnMissFn(inst.Remove)
    inst.components.projectile:SetLaunchOffset(Vector3(3, 2, 0))
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)

    inst.persists = false

    return inst
end

local function KillRopes(inst)
	inst.SoundEmitter:PlaySound("UCSounds/harpoon/break")

	inst:AddTag("NOCLICK")

	if inst.harpoontask ~= nil then
		inst.harpoontask:Cancel()
	end
		 
	inst.harpoontask = nil
	
	if inst.hitfx ~= nil then
		inst.hitfx:Remove()
	end
	if inst.ropetype == "rope" then
		SpawnPrefab("uncompromising_harpoon").Transform:SetPosition(inst.Transform:GetWorldPosition())
	else
		SpawnPrefab("uncompromising_harpoon_heavy").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	
	for i, ropes in ipairs(inst.ropes) do
		ropes:DoTaskInTime(.5/i, function(ropes)
			if ropes.entity:IsVisible() then
				SpawnPrefab(ropes.breakfx).Transform:SetPosition(ropes.Transform:GetWorldPosition())
			end
			
			ropes:Remove()
			if inst ~= nil and i == 1 then
				inst.AnimState:PlayAnimation("break")
				inst:ListenForEvent("animover", inst.Remove)
				--inst:Remove()
			end
		end)
	end
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function CooldownSound(inst)
    inst._soundcd = nil
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if inst ~= nil and inst:IsValid() and inst.target ~= nil and inst.target:IsValid() then
		if inst:GetDistanceSqToInst(inst.target) ~= nil and inst:GetDistanceSqToInst(inst.target) > inst.distance then
			local px, py, pz = inst.target.Transform:GetWorldPosition()
			
			local platform = inst:GetCurrentPlatform()
			
			if platform ~= nil and platform:IsValid() then
				if inst._cdtask == nil then
					local rowdistmult = (inst:GetDistanceSqToInst(inst.target) / 100)
				
					inst._cdtask = inst:DoTaskInTime(.5, OnCooldown)
					
					local row_dir_x, row_dir_z = VecUtil_Normalize(px - x, pz - z)
					
					local boat_physics = platform.components.boatphysics
				
					boat_physics:ApplyForce(row_dir_x, row_dir_z, .5 * rowdistmult)
				end
			end
			
			if inst.target.components.locomotor ~= nil then
				local rad = math.rad(inst.target:GetAngleToPoint(x, y, z))
				local velx = math.cos(rad) --* 4.5
				local velz = -math.sin(rad) --* 4.5
				
				local locationmodifier = platform ~= nil and 1 or 2
				
				local dx, dy, dz = px + (((FRAMES * 5) * velx) * locationmodifier), 0, pz + (((FRAMES * 5) * velz) * locationmodifier)
					
				local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
				local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
				if dx ~= nil and (ground or boat or inst.target.components.locomotor:CanPathfindOnWater()) then
					inst.target.Physics:Teleport(dx, py, dz)
					--inst.target.Transform:SetPosition(dx, py, dz)
				end
			end
			
			local tensionmult = inst.target:HasTag("epic") and 2 or inst.target:HasTag("smallcreature") and .5 or 1
			
			if inst.tension < inst.tensionmax * 1.5 then
				inst.tension = inst.tension + (1 * tensionmult)
			end
			
			if inst.tension >= inst.tensionmax then
						print("damage")
				inst.damage = inst.damage + (1 * tensionmult)
				
				if inst._soundcd == nil then
					if inst.damage < (inst.damagemax / 4) then
						inst._soundcd = inst:DoTaskInTime(.8 + math.random(), CooldownSound)
						print("low")
						inst.SoundEmitter:PlaySound("UCSounds/harpoon/"..inst.ropetype.."stretch_low")
					elseif inst.damage < (inst.damagemax / 3) then
						inst._soundcd = inst:DoTaskInTime(.6 + math.random(), CooldownSound)
						print("mid")
						inst.SoundEmitter:PlaySound("UCSounds/harpoon/"..inst.ropetype.."stretch_mid")
					elseif inst.damage < (inst.damagemax / 2) then
						inst._soundcd = inst:DoTaskInTime(.4 + math.random(), CooldownSound)
						print("high")
						inst.SoundEmitter:PlaySound("UCSounds/harpoon/"..inst.ropetype.."stretch_high")
					elseif inst.damage < inst.damagemax then
						inst._soundcd = inst:DoTaskInTime(.2 + math.random(), CooldownSound)
						print("veryhigh")
						inst.SoundEmitter:PlaySound("UCSounds/harpoon/"..inst.ropetype.."stretch_veryhigh")
					end
				
	                --inst.reel.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
			end
		elseif inst.tension > 1 or inst.damage > 1 then
			if inst.tension > 1 then
				inst.tension = inst.tension - 0.1
			elseif inst.damage > 1 then
				inst.damage = inst.damage - 0.1
			end
		end
	else
		KillRopes(inst)
		return
	end
		
	if inst ~= nil and inst.damage >= inst.damagemax then
		if inst.harpoontask ~= nil then
			inst.harpoontask:Cancel()
		end
		
		inst.harpoontask = nil
		KillRopes(inst)
		return
	end
	
	if inst ~= nil and inst:IsValid() and inst.target ~= nil and inst.target:IsValid() and inst.ropes ~= nil and inst:GetDistanceSqToInst(inst.target) ~= nil then
		local scale = (inst:GetDistanceSqToInst(inst.target) / 3)
		print(scale)
		print(inst:GetDistanceSqToInst(inst.target))
		for i2, ropes in ipairs(inst.ropes) do
			local p2x, p2y, p2z = inst.target.Transform:GetWorldPosition()
			local rad2 = math.rad(inst:GetAngleToPoint(p2x, p2y, p2z))
			local velx2 = math.cos(rad2) --* 4.5
			local velz2 = -math.sin(rad2) --* 4.5
			
			local dx, dy, dz = x + ((i2 * velx2) / 3.5), 0.5, z + ((i2 * velz2) / 3.5)
			if p2y < 5 then
				if i2 <= scale--[[ + 1]] then
					ropes.Transform:SetRotation(inst:GetAngleToPoint(p2x, p2y, p2z))
					ropes:Show()
					
					local height = (1 / scale) * i2
					
					ropes.Transform:SetPosition(dx, height + 0.8, dz)
					
					inst.hitfx.Transform:SetPosition(dx, height + 0.8, dz)
				else
					ropes:Hide()
				end
				
				inst.hitfx:ForceFacePoint(inst.target.Transform:GetWorldPosition())
			else
				KillRopes(inst)
				return
			end
		end
	elseif inst.ropes ~= nil then
		
		KillRopes(inst)
	end
end

local function InitializeRope(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	inst.ropes = {}
	
	for i = 1, 40 do
		local ropes = SpawnPrefab(inst.ropetype)
		ropes.Transform:SetPosition(x, y, z)
		table.insert(inst.ropes, ropes)
	end
	
	if inst.target ~= nil and inst.target:IsValid() then
		local hitfx = SpawnPrefab("uncompromising_harpoonhitfx")
		hitfx.Transform:SetPosition(inst.target.Transform:GetWorldPosition())
		
		inst.hitfx = hitfx
	end
end

local function DoPuff(inst, channeler)
	inst.SoundEmitter:PlaySound("UCSounds/harpoon/reel")
	inst.AnimState:PlayAnimation("reel")

    inst.components.activatable.inactive = true
	
	if inst.distance > 15 then
		inst.distance = inst.distance - 15
	end
end

local function OnStopChanneling(inst)
	inst.channeler = nil
end

local function GetVerb(inst)
	return "HARPOON"
end

local function reel()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
	
	inst:AddTag("harpoonreel")

    inst.AnimState:SetBank("UM_harpoonreel")
    inst.AnimState:SetBuild("UM_harpoonreel")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)
	
	inst.GetActivateVerb = GetVerb

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.target = nil
	inst.distance = 100
	inst.tension = 1
	inst.tensionmax = 0
	inst.damage = 1
	inst.damagemax = 0
	inst.ropetype = nil

    inst:AddComponent("inspectable")
	
	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = DoPuff
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	
    inst:AddComponent("machine")
    inst.components.machine.turnonfn = KillRopes
    inst.components.machine.turnofffn = KillRopes
    inst.components.machine.cooldowntime = 0.5
	inst.components.machine.ison = true
	--[[
    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(DoPuff, OnStopChanneling)
    inst.components.channelable.use_channel_longaction_noloop = true
    inst.components.channelable.skip_state_channeling = true]]
	
	inst:DoTaskInTime(0, InitializeRope)
	inst.harpoontask = inst:DoPeriodicTask(0.05, Vac)
	inst:DoTaskInTime(60, KillRopes)
	
	inst.persists = false
	
    return inst
end

local function rope()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("harpoon_rope")
    inst.AnimState:SetBuild("harpoon_rope")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetEightFaced()
	
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.type = "rope"
	
	inst.breakfx = "wood_splinter_jump"
	
	inst.persists = false
	
    return inst
end

local function chain()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("harpoon_rope")
    inst.AnimState:SetBuild("harpoon_rope")
    inst.AnimState:PlayAnimation("chainidle")
	inst.Transform:SetEightFaced()
	
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.type = "chain"
	
	inst.breakfx = "mining_fx"
	
	inst.persists = false
	
    return inst
end

local function fnhit()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("um_harpoonhitfx")
    inst.AnimState:SetBuild("um_harpoonhitfx")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetEightFaced()
	
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.persists = false
	
    return inst
end
-------------------------------------------------------------------------------
return Prefab("uncompromising_harpoon", fnlight, assets, prefabs),
		Prefab("uncompromising_harpoon_projectile", harpoon, assets, prefabs),
		Prefab("uncompromising_harpoonreel", reel, assets, prefabs),
		Prefab("uncompromising_harpoonrope", rope, assets, prefabs),
		Prefab("uncompromising_harpoon_heavy", fnheavy, assets, prefabs),
		Prefab("uncompromising_harpoonchain", chain, assets, prefabs),
		Prefab("uncompromising_harpoonhitfx", fnhit, assets, prefabs)