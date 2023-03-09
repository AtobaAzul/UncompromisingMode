require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/firepit.zip"),
}

local prefabs =
{
    "campfirefire",
    "collapse_small",
    "ash",
}

local function LetsBowl_Ball(inst)
	print("lets bowl lets bowl lets rock and roll")
	local x, y, z = inst.Transform:GetWorldPosition()
	inst.pushcount = inst.pushcount + 1

	inst:DoTaskInTime(3, function(inst)
		if inst.pushcount >= 3 then
			local ents = TheSim:FindEntities(x, y, z, 20, { "bowlingpin" })
			for i, v in ipairs(ents) do
				v:Remove()
			end

			inst:Remove()
		else
			print("return to your position")
			inst.Transform:SetPosition(x, y, z)
		end
	end)

	
--[[
	local ents = TheSim:FindEntities(x, y, z, 1, { "_combat", "bowlingpin" }, { "wixieshoved" })


	for i, v in ipairs(ents) do
		if v ~= inst then
			v:PushEvent("wixieshoved")
													
			SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())
													
			v:AddTag("wixieshoved")
			for i = 1, 50 do
				inst:DoTaskInTime((i - 1) / 50, function(inst)
					if v ~= nil and v.Transform:GetWorldPosition() and target ~= nil and tx ~= nil then
						local px, py, pz = v.Transform:GetWorldPosition()
						local rad_collision = -math.rad(v:GetAngleToPoint(tx, ty, tz))
						local velx_collision = math.cos(rad_collision) --* 4.5
						local velz_collision = -math.sin(rad_collision) --* 4.5
							
						local targetreduction = target:HasTag("epic") and 1 or target:HasTag("smallcreature") and 3 or 2
						local vreduction = v:HasTag("epic") and 3 or v:HasTag("smallcreature") and 1 or 2
						local finalreduction = targetreduction + vreduction
						local vdebuffmultiplier = v.components.freezable ~= nil and v.components.freezable:IsFrozen() and 1.25 or 1
																	
						local basepower = 10 / i or 10
						if px ~= nil then
							local vx, vy, vz = px + (((5 / (i + 1)) * velx_collision) / finalreduction) * vdebuffmultiplier, py, pz + (((5 / (i + 1)) * velz_collision) / finalreduction) * vdebuffmultiplier

							local ground_collision = TheWorld.Map:IsPassableAtPoint(vx, vy, vz)
							local boat_collision = TheWorld.Map:GetPlatformAtPoint(vx, vz)
							if v.components.locomotor ~= nil and vx ~= nil and (ground_collision or boat_collision) then
								v.Transform:SetPosition(vx, vy, vz)										
							end
						end
					end
																
					if i >= 50 then
						v:RemoveTag("wixieshoved")
					end
				end)
			end
		end
	end]]
end

local function SpawnPins(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 6, y, z)

	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 8, y, z + 1)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 8, y, z - 1)

	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 10, y, z + 2)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 10, y , z)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 10, y, z - 2)

	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 12, y, z + 3)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 12, y, z + 1)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 12, y, z - 3)
	SpawnPrefab("bowlingpin").Transform:SetPosition(x + 12, y, z - 1)
end

local function ballfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("mooneyes")
    inst.AnimState:SetBuild("mooneyes")
    inst.AnimState:PlayAnimation("crater")

	inst:AddTag("smallcreature")
	
	MakeHeavyObstaclePhysics(inst, .25)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.pushcount = 0

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst:AddComponent("combat")
    inst:AddComponent("health")
	inst.components.health.maxhealth = 100
	inst.components.health.invincible = true
	
	inst:ListenForEvent("wixieshoved", LetsBowl_Ball)

	inst:DoTaskInTime(0, SpawnPins)

	inst.persists = false

    return inst
end

local function LetsBowl(inst)
    inst.AnimState:PlayAnimation("knocked", false)
	inst:ListenForEvent("animover", inst.Remove)
	--[[local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 1.5, { "_combat", "bowlingpin" }, { "wixieshoved" })
					
	
	for i, v in ipairs(ents) do
		if v ~= inst then
			v:PushEvent("wixieshoved")
													
			SpawnPrefab("round_puff_fx_sm").Transform:SetPosition(v.Transform:GetWorldPosition())
													
			v:AddTag("wixieshoved")
			for i = 1, 50 do
				inst:DoTaskInTime((i - 1) / 50, function(inst)
					if v ~= nil and v.Transform:GetWorldPosition() and target ~= nil and tx ~= nil then
						print("v knocked")
						local px, py, pz = v.Transform:GetWorldPosition()
						local rad_collision = -math.rad(v:GetAngleToPoint(tx, ty, tz))
						local velx_collision = math.cos(rad_collision) --* 4.5
						local velz_collision = -math.sin(rad_collision) --* 4.5
																	
																	
						local targetreduction = target:HasTag("epic") and 1 or target:HasTag("smallcreature") and 3 or 2
						local vreduction = v:HasTag("epic") and 3 or v:HasTag("smallcreature") and 1 or 2
						local finalreduction = targetreduction + vreduction
						local vdebuffmultiplier = v.components.freezable ~= nil and v.components.freezable:IsFrozen() and 1.25 or 1
																	
						local basepower = 10 / i or 10
						if px ~= nil then
							local vx, vy, vz = px + (((5 / (i + 1)) * velx_collision) / finalreduction) * vdebuffmultiplier, py, pz + (((5 / (i + 1)) * velz_collision) / finalreduction) * vdebuffmultiplier

							local ground_collision = TheWorld.Map:IsPassableAtPoint(vx, vy, vz)
							local boat_collision = TheWorld.Map:GetPlatformAtPoint(vx, vz)
							if v.components.locomotor ~= nil and vx ~= nil and (ground_collision or boat_collision) then
								print("v should be moving")
								v.Transform:SetPosition(vx, vy, vz)										
							end
						end
					end
																
					if i >= 50 then
						v:RemoveTag("wixieshoved")
					end
				end)
			end
		end
	end]]
end

local function pinfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("bowlingpin")

    inst.AnimState:SetBank("bowlingpin")
    inst.AnimState:SetBuild("bowlingping")
    inst.AnimState:PlayAnimation("idle")
	inst.Transform:SetScale(2, 2, 2)
	
	MakeHeavyObstaclePhysics(inst, .5)

    inst:AddTag("bowlingpin")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst:AddComponent("combat")
    inst:AddComponent("health")
	inst.components.health.maxhealth = 100
	inst.components.health.invincible = true
	
	inst:ListenForEvent("wixieshoved", LetsBowl)

	inst.persists = false

    return inst
end

return Prefab("bowlingball", ballfn, assets, prefabs),
		Prefab("bowlingpin", pinfn, assets, prefabs)