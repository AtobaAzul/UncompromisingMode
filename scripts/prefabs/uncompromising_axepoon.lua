local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart", "swap_blowdart")
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
		
		if inst.x ~= nil and target.components.locomotor then
			local reel = SpawnPrefab("uncompromising_axereel")
			reel.Transform:SetPosition(inst.x, inst.y, inst.z)
			reel.target = target
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
    inst.components.inventoryitem.pushlandedevents = false
end

local function common(anim, tags, removephysicscolliders)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("blow_dart")
    inst.AnimState:SetBuild("blow_dart")
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("blowdart")
    inst:AddTag("sharp")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    if tags ~= nil then
        for i, v in ipairs(tags) do
            inst:AddTag(v)
        end
    end

    if removephysicscolliders then
        RemovePhysicsColliders(inst)
    end

    MakeInventoryFloatable(inst, "small", 0.05, {0.75, 0.5, 0.75})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(8, 10)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(60)
    inst.components.projectile:SetOnHitFn(onhit)
    inst:ListenForEvent("onthrown", onthrown)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end

-------------------------------------------------------------------------------
-- Pipe Dart (Damage)
-------------------------------------------------------------------------------
local function pipeequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_blowdart_pipe", "swap_blowdart_pipe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function pipethrown(inst)
    inst.AnimState:PlayAnimation("dart_pipe")
    inst:AddTag("NOCLICK")
    inst.persists = false
end

local function pipe()
    local inst = common("idle_pipe")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.equippable:SetOnEquip(pipeequip)
    inst.components.weapon:SetDamage(1) --set low so it won't kill enemies
    inst.components.projectile:SetOnThrownFn(pipethrown)

    local swap_data = {sym_build = "swap_blowdart_pipe", bank = "blow_dart", anim = "idle_pipe"}
    inst.components.floater:SetBankSwapOnFloat(true, -4, swap_data)

    return inst
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if inst ~= nil and inst:IsValid() and inst.target ~= nil and inst.target:IsValid() then
		if inst:GetDistanceSqToInst(inst.target) ~= nil and inst:GetDistanceSqToInst(inst.target) > inst.distance then
			local px, py, pz = inst.target.Transform:GetWorldPosition()
			
			local boat = inst:GetCurrentPlatform()
			
			if boat ~= nil and boat:IsValid() then
				
				local row_dir_x, row_dir_z = VecUtil_Normalize(px - x, pz - z)
				
				local boat_physics = boat.components.boatphysics
			
				boat_physics:ApplyRowForce(row_dir_x, row_dir_z, 1, 6)
			else
				local rad = math.rad(inst.target:GetAngleToPoint(x, y, z))
				local velx = math.cos(rad) --* 4.5
				local velz = -math.sin(rad) --* 4.5
				
				local dx, dy, dz = px + (((FRAMES * 5) * velx) * 2), 0, pz + (((FRAMES * 5) * velz) * 2)
					
				local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
				local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
				if dx ~= nil and (ground or boat) then
					inst.target.Transform:SetPosition(dx, dy, dz)
				end
			end
			
			local tensionmult = inst.target:HasTag("epic") and 2 or inst.target:HasTag("smallcreature") and .5 or 1
			inst.tension = inst.tension + (1 * tensionmult)
		elseif inst.tension > 1 then
			inst.tension = inst.tension - 0.1
		end
	else
		for i,v in ipairs(inst.ropeTable) do
			v:Remove()
		end
		inst:Remove()
	end
		
	if inst ~= nil and inst.tension >= 200 then
		for i,v in ipairs(inst.ropeTable) do
			v:Remove()
		end
		inst:Remove()
	end
end

local function InitializeRope(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local previousRope, ropeLeader
	local sections = math.floor(inst.distance/7)
	inst.ropeTable = {}
	for i = 1,sections do
		local rope = SpawnPrefab("uncompromising_axerope")
		table.insert(inst.ropeTable,rope)
		if previousRope then -- This rope spawned after the first one, it needs to tell the previous it should follow it.
			previousRope.nextLinkage = rope
			rope.previousLinkage = previousRope
		else --No previous rope? this guy's the leader
			rope.previousLinkage = inst
			inst.nextLinkage = rope
		end
		if i == sections then
			rope.nextLinkage = inst.target
		end
		rope.Transform:SetPosition(x,y,z)
		previousRope = rope
	end
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function DoPuff(inst, channeler)
	if inst._cdtask == nil then
        inst._cdtask = inst:DoTaskInTime(1, OnCooldown)
		if inst.distance > 20 then
			inst.distance = inst.distance - 20
		end
		if inst.nextLinkage then
			for i = 1,4 do
				inst:DoTaskInTime(i*0.2, function(inst)
					if inst.nextLinkage then
						local _oldlinkage = inst.nextLinkage
						inst.nextLinkage = _oldlinkage.nextLinkage
						if inst.nextLinkage then
							inst.nextLinkage.previousLinkage = inst
							_oldlinkage:Remove()
						else
							inst:Remove()
						end
					else
						inst:Remove()
					end
				end)
			end
		else
			inst:Remove()
		end
	end
end

local function OnStopChanneling(inst)
	inst.channeler = nil
end

local function reel()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("boat_wheel")
    inst.AnimState:SetBuild("boat_wheel")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.target = nil
	inst.distance = 100
	inst.tension = 1

    inst:AddComponent("inspectable")
	
    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(DoPuff, OnStopChanneling)
    inst.components.channelable.use_channel_longaction_noloop = true
    inst.components.channelable.skip_state_channeling = true
	inst:DoTaskInTime(0, InitializeRope)
	inst:DoPeriodicTask(FRAMES, Vac)
	
	inst.persists = false
	
    return inst
end

local function DestroyLinks(inst)
	local toDestroy = {}
	if inst.previousLinkage then
		local link = inst.previousLinkage
		while link do
			table.insert(toDestroy,link)
			link = link.previousLinkage
		end
	end
	if inst.nextLinkage then
		local link = inst.nextLinkage
		while link do
			table.insert(toDestroy,link)
			link = link.nextLinkage
		end	
	end
	for i,v in ipairs(toDestroy) do
		v:Remove()
	end
	inst:Remove()
end

local function VelocityCalcs(inst)
	if inst.nextLinkage == nil or inst.previousLinkage == nil then
		DestroyLinks(inst)
	end
	
	if inst.nextLinkage.components.health and inst.nextLinkage.components.health:IsDead() then
		DestroyLinks(inst)
	end
	
	local x_self,y_self,z_self = inst.Transform:GetWorldPosition()
	local x_next,y_next,z_next = inst.nextLinkage.Transform:GetWorldPosition()
	local x_prev,y_prev,z_prev = inst.previousLinkage.Transform:GetWorldPosition()	
	if x_next and x_prev and x_self then
		local x_focal = (x_next - x_prev)/2+x_prev
		local y_focal = (y_next - y_prev)/2+y_prev
		local z_focal = (z_next - z_prev)/2+z_prev
		
		local vel_x = (x_focal - x_self)
		local vel_y = (y_focal - y_self)
		local vel_z = (z_focal - z_self)

		inst.vel_x = 1.7*vel_x
		inst.vel_y = 1.7*vel_y
		inst.vel_z = 1.7*vel_z
	end
end

local function ApplyVel(inst)
	local x,y,z = inst.Transform:GetWorldPosition()
	inst.Transform:SetPosition(x+inst.vel_x,y+inst.vel_y,z+inst.vel_z)
end


local function Adjust(inst)
	VelocityCalcs(inst)
	ApplyVel(inst)

	local x,y,z = inst.nextLinkage.Transform:GetWorldPosition()
	inst:ForceFacePoint(x,y,z)
end

local function rope()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("snowball")
    inst.AnimState:SetBuild("snowball")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoPeriodicTask(FRAMES,Adjust)
	inst.persists = false
	
	inst.vel_x = 0
	inst.vel_y = 0
	inst.vel_z = 0
	
    return inst
end
-------------------------------------------------------------------------------
return Prefab("uncompromising_axepoon", pipe),
		Prefab("uncompromising_axereel", reel),
		Prefab("uncompromising_axerope", rope)
