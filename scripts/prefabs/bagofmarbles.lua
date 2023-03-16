local assets =
{
    Asset("ANIM", "anim/sleepbomb.zip"),
    Asset("ANIM", "anim/swap_sleepbomb.zip"),
}

local prefabs =
{
    "sleepbomb_burst",
    "sleepcloud",
    "reticule",
    "reticuleaoe",
    "reticuleaoeping",
}

local easing = require("easing")

local TREMOR_EXCLUDE_TAGS = { "noclaustrophobia", "wall", "player", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO", "notarget", "noattack", "invisible", "flying" }

local function OnHit_Marbles(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(x, y, z)
	
	for i = 1, 10 do
		local marble = SpawnPrefab("slipperymarblesproj")
		marble.Transform:SetPosition(x, 2, z)
		marble.type = math.random(4)
		local targetpos = inst:GetPosition()
		
		targetpos.x = targetpos.x + math.random(-4, 4)
		targetpos.z = targetpos.z + math.random(-4, 4)
		
		local dx = targetpos.x - x
		local dz = targetpos.z - z
		local rangesq = dx * dx + dz * dz
		
		local maxrange = TUNING.FIRE_DETECTOR_RANGE
		local speed = easing.linear(rangesq, maxrange, 5, maxrange * maxrange)
		marble.components.complexprojectile:SetHorizontalSpeed(25)
		marble.components.complexprojectile:SetGravity(-30)
		marble.components.complexprojectile:SetLaunchOffset(Vector3(0, .25, 0))
		marble.components.complexprojectile.usehigharc = true
		marble.components.complexprojectile:Launch(targetpos, inst, inst)
	end
	
    inst:Remove()
end

local function OnHit_Warbles(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("shadow_puff").Transform:SetPosition(x, y, z)
	
	for i, v in pairs(TheSim:FindEntities(x, y, z, 2, { "player" }, { "player_ghost" })) do
		if v ~= nil and v:IsValid() then
			if not v.components.health:IsDead() then
				v:PushEvent("knockback", {knocker = inst, radius = 30, strengthmult = 1})
			end
		end
	end
	
	for i = 1, 5 do
		local marble = SpawnPrefab("slipperymarblesproj")
		marble.Transform:SetPosition(x, 2, z)
		marble.player_targeting = true
		marble.type = 5
		--marble.AnimState:SetMultColour(0, 0, 0, 0.6)
		
		local targetpos = inst:GetPosition()
		
		targetpos.x = targetpos.x + math.random(-6, 6)
		targetpos.z = targetpos.z + math.random(-6, 6)
		
		local dx = targetpos.x - x
		local dz = targetpos.z - z
		local rangesq = dx * dx + dz * dz
		
		local maxrange = TUNING.FIRE_DETECTOR_RANGE
		local speed = easing.linear(rangesq, maxrange, 5, maxrange * maxrange)
		marble.components.complexprojectile:SetHorizontalSpeed(20)
		marble.components.complexprojectile:SetGravity(-30)
		marble.components.complexprojectile:SetLaunchOffset(Vector3(0, .25, 0))
		marble.components.complexprojectile.usehigharc = true
		marble.components.complexprojectile:Launch(targetpos, inst, inst)
	end
	
	if inst.bouncecount == 0 then
		inst:DoTaskInTime(0.05, inst.Remove)
	else
		local newtarget = FindClosestPlayerInRangeSq(x, y, z, 1000, true)
		local newtargetpos = newtarget ~= nil and newtarget:GetPosition() or inst:GetPosition()
			
		inst.components.complexprojectile:Launch(newtargetpos, inst, inst)
		inst.bouncecount = inst.bouncecount - 1
	end
end

local function OnHit_Checker(inst, attacker, target)
	if inst.prefab == "bagofmarbles" then
		OnHit_Marbles(inst, attacker, target)
	else
		OnHit_Warbles(inst, attacker, target)
	end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_marblebag", "swap_sleepbomb")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:PlayAnimation("spin_loop")

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:SetCapsule(1, .1)
end

local function ReticuleTargetFn()
    local player = ThePlayer
    local ground = TheWorld.Map
    local pos = Vector3()
    --Attack range is 8, leave room for error
    --Min range was chosen to not hit yourself (2 is the hit range)
    for r = 6.5, 3.5, -.25 do
        pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
        if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
            return pos
        end
    end
    return pos
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetTwoFaced()

    MakeInventoryPhysics(inst)

    --projectile (from complexprojectile component) added to pristine state for optimization
    inst:AddTag("projectile")

    inst.AnimState:SetBank("marblebag")
    inst.AnimState:SetBuild("marblebag")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetDeltaTimeMultiplier(.75)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    local advancedtargeting = TheNet:GetServerGameMode() == "lavaarena"
    if advancedtargeting then
        inst.components.reticule.reticuleprefab = "reticuleaoe"
        inst.components.reticule.pingprefab = "reticuleaoeping"
        inst.components.reticule.mouseenabled = true

        inst:AddTag("nopunch")
    else
        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
    end

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	if not inst.prefab == "bagofmarbles" then
		inst.AnimState:SetMultColour(0, 0, 0, 0.6)
	end
	
	inst.bouncecount = 4

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(20)
    inst.components.complexprojectile:SetGravity(-40)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, .25, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHit_Checker)

    if not advancedtargeting then
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon:SetRange(8, 10)
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/bagofmarbles.xml"

    inst:AddComponent("stackable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.equipstack = true

    MakeHauntableLaunch(inst)

    return inst
end

local function MarbleLand(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ground = TheWorld.Map:IsPassableAtPoint(x, y, z)
	local boat = TheWorld.Map:GetPlatformAtPoint(x, z)
	local ocean = TheWorld.Map:IsOceanAtPoint(x, y, z)
	
	if ground or boat then
		local marble = SpawnPrefab("slipperymarbles")
		marble.Transform:SetPosition(x, 0, z)
		marble.type = inst.type
		marble.player_targeting = inst.player_targeting
		marble.AnimState:PlayAnimation("idle_"..marble.type)
	elseif ocean then
		SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
	end
	
    inst:Remove()
end

local function oncollide(inst, other)
	local x, y, z = inst.Transform:GetWorldPosition()
	if y == 0 then
		MarbleLand(inst)
	end
end

local function MarbleThrow(inst)

    inst:AddTag("NOCLICK")
    inst.persists = false
    inst.AnimState:PlayAnimation("spin_"..inst.type, true)
	
    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(10)
    inst.Physics:SetDamping(5)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()

	inst.Physics:SetCapsule(0.02, 0.02)
	
    inst.Physics:SetCollisionCallback(oncollide)
end

local function slipperymarblesprojfn()
    local inst = CreateEntity()

    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("baggedmarble")
    inst.AnimState:SetBuild("baggedmarbles")
    inst.AnimState:PlayAnimation("idle")
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.type = 1
	
	inst.player_targeting = false
	
    inst:AddComponent("weapon")
    inst:AddComponent("projectile")
	
    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-25)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, .5, 0))
    inst.components.complexprojectile:SetOnLaunch(MarbleThrow)
    inst.components.complexprojectile:SetOnHit(MarbleLand)
    inst.components.complexprojectile.usehigharc = true
	
    return inst
end

local function MarbleInit(inst)
    inst.AnimState:PlayAnimation("idle_"..inst.type)
	
	inst:DoTaskInTime(inst.player_targeting and 20 or 60, function(inst)
		inst.fadeout = true
	end)
end

local function slipperymarblesfn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    --inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("baggedmarble")
    inst.AnimState:SetBuild("baggedmarbles")
    inst.AnimState:PlayAnimation("idle_1")
	
	inst.Transform:SetScale(1.5, 1.5, 1.5)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.type = 1
	inst.fadeout = false
	inst.fadetime = 1
	inst.player_targeting = false
	
	inst:DoTaskInTime(0, MarbleInit)
	
	inst.slippytask = inst:DoPeriodicTask(0.1, function(inst)
	
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = inst.player_targeting and 
				TheSim:FindEntities(x, y, z, 1.5, { "player" }, { "playerghost" })
			or
				TheSim:FindEntities(x, y, z, 1.5, { "_combat" }, TREMOR_EXCLUDE_TAGS)
		
		if inst.fadeout then
			inst.fadetime = inst.fadetime - 0.1
			local k = inst.fadetime
			local c = inst.fadetime
			if inst.player_targeting then
				c = 0
			end
			inst.AnimState:SetMultColour(c, c, c, k)
		end
		
		if inst.fadetime <= 0 then
			inst:Remove()
		end
	
		for i, v in ipairs(ents) do
			if inst.player_targeting and v ~= nil and v:IsValid() then
				if not v.components.health:IsDead() then
					v:PushEvent("knockback", {knocker = inst, radius = 10, strengthmult = 1})
					
					if v.SoundEmitter ~= nil then
						v.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
					end
				end
				
				inst:DoTaskInTime(0.05, inst.Remove)
			elseif not inst.player_targeting and not v:HasTag("noslippy") and v.components.health ~= nil and not v.components.health:IsDead() then
				if not (v.components.follower ~= nil and v.components.follower:GetLeader() ~= nil and v.components.follower:GetLeader():HasTag("player")) then
					if v.SoundEmitter ~= nil then
						v.SoundEmitter:PlaySound("dontstarve/common/tool_slip")
					end
					SpawnPrefab("slingshotammo_hitfx_marble").Transform:SetPosition(x, y, z)
					
					v:AddTag("noslippy")
					local rad = math.rad(v:GetAngleToPoint(x, y, z))
					local velx = math.cos(rad) --* 4.5
					local velz = -math.sin(rad) --* 4.5
					
					if v:IsValid() and v.components.combat ~= nil and v.components.combat ~= nil and v.components.health ~= nil then
						v.components.combat:GetAttacked(inst, 34, inst)
					end
							
					for i = 1, 50 do
						v:DoTaskInTime((i - 1) / 50, function(v)
							local px, py, pz = v.Transform:GetWorldPosition()
							
							local giantreduction = v:HasTag("epic") and 2 or v:HasTag("smallcreature") and 0.8 or 1
									
							if px == nil or py == nil or pz == nil then--just to be sure...
								return
							end

							local dx, dy, dz = px + (((3 / (i + 3)) * velx) / giantreduction), py, pz + (((3 / (i + 3)) * velz) / giantreduction)
													
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
							
							if i >= 50 then 
								v:RemoveTag("noslippy")
							end
						end)
					end
					
					inst:Remove()
				end
			end
		end
	end)
	
	inst.persists = false
		
    return inst
end

return Prefab("bagofmarbles", fn, assets, prefabs),
		Prefab("bagofwarbles", fn),
		Prefab("slipperymarbles", slipperymarblesfn),
		Prefab("slipperymarblesproj", slipperymarblesprojfn)