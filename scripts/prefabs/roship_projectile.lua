local function OnHitZap(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
    
	SpawnPrefab("electric_explosion").Transform:SetPosition(x,0,z)
	SpawnPrefab("bishop_charge_hit").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	local ents = TheSim:FindEntities(x, 0, z, 5, {"_health"}, { "shadow", "INLIMBO", "chess" })
	
	if #ents > 0 then
		for i, v in ipairs(ents) do			
			if v.components.health ~= nil and not v.components.health:IsDead() then
				if not (v.components.inventory ~= nil and v.components.inventory:IsInsulated()) then
					if v.sg ~= nil then
						v.sg:GoToState("electrocute")
					end

					v.components.health:DoDelta(-30, nil, inst.prefab, nil, inst) --From the onhit stuff...
				else
					v.components.health:DoDelta(-15, nil, inst.prefab, nil, inst)
				end
					
			else
				if not inst:HasTag("electricdamageimmune") and v.components.health ~= nil then
					v.components.health:DoDelta(-30, nil, inst.prefab, nil, inst) --From the onhit stuff...
				end
			end
		end
    end
	
    inst:Remove()
end
local function onthrown(inst)
	inst.Light:Enable(true)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("roship_attack")
    inst.AnimState:SetBuild("roship_attack")
    inst.AnimState:PlayAnimation("idle",true)

    inst.Physics:SetMass(3)
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
    inst.entity:AddLight()    
    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(1)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    MakeInventoryPhysics(inst)

    --projectile (from complexprojectile component) added to pristine state for optimization

	
    inst:AddTag("projectile")
	inst:AddTag("weapon")
    
	
    MakeInventoryFloatable(inst, "med", 0.05, 0.65)

    inst.entity:SetPristine()
	
	--[[inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true]]

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0.5, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitZap)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)

    --inst.persists = false

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("roship_projectile", fn)
