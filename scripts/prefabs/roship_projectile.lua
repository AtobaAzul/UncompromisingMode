local assets =
{
    Asset("ANIM", "anim/snowball.zip"),
}

local prefabs =
{
    "splash_snow_fx",
}
local function Shockness(inst,x,y,z)
x = x + math.random(-1,1)
z = z + math.random(-1,1)
SpawnPrefab("electricchargedfx").Transform:SetPosition(x, 0, z)
local targets = TheSim:FindEntities(x,y,z,1,{"_health"},{"playerghost","chess"}) --Todo, make it shock other things?
	for k,v in pairs(targets) do
		if v:HasTag("player") and v.components.health ~= nil and not v.components.health:IsDead() then
		if not (v.components.inventory ~= nil and v.components.inventory:IsInsulated()) then
			v.sg:GoToState("electrocute")
			v.components.health:DoDelta(-5, nil, inst.prefab, nil, inst) --From the onhit stuff...
		end
		else
		if not inst:HasTag("electricdamageimmune") then
		v.components.health:DoDelta(-5, nil, inst.prefab, nil, inst) --From the onhit stuff...
		end
		end
	end
end
local function OnHitZap(inst, attacker, target)
    SpawnPrefab("electricchargedfx").Transform:SetPosition(inst.Transform:GetWorldPosition())
				for i = 1, 3 do
				for j = 1, 3 do
				local x, y, z = inst.Transform:GetWorldPosition() 
				Shockness(inst,x-2+i*2,y,z-2+j*2) --Spawn shock AOE
				end
				end
	local x, y, z = inst.Transform:GetWorldPosition() 
	local ents = TheSim:FindEntities(x, y, z, 3, nil, { "shadow", "INLIMBO" })
	if #ents > 0 then
		for i, v in ipairs(ents) do							
			if not inst:HasTag("chess") then
				if v.components.health ~= nil and not v.components.health:IsDead() then
					if not (v.components.inventory ~= nil and v.components.inventory:IsInsulated()) then
					v.sg:GoToState("electrocute")
					v.components.health:DoDelta(-30, nil, inst.prefab, nil, inst) --From the onhit stuff...
					else
					v.components.health:DoDelta(-5, nil, inst.prefab, nil, inst)
					end
					else
					if not inst:HasTag("electricdamageimmune") and v.components.health ~= nil then
					v.components.health:DoDelta(-30, nil, inst.prefab, nil, inst) --From the onhit stuff...
					end
				end
			end
		end
    end
	
    inst:Remove()
end


local function onthrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("bishop_attack")
    inst.AnimState:SetBuild("bishop_attack")
    inst.AnimState:PlayAnimation("idle",true)

    inst.Physics:SetMass(1)
    inst.Physics:SetCapsule(0.2, 0.2)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
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

    MakeInventoryPhysics(inst)

    --projectile (from complexprojectile component) added to pristine state for optimization

	
    inst:AddTag("projectile")
	inst:AddTag("weapon")
    
	inst:AddTag("frozen")
    inst:AddTag("watersource")
	
    MakeInventoryFloatable(inst, "med", 0.05, 0.65)

    inst.entity:SetPristine()
	
	inst:AddComponent("reticule")
    inst.components.reticule.targetfn = ReticuleTargetFn
    inst.components.reticule.ease = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")

    inst:AddComponent("complexprojectile")
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 0, 0))
    inst.components.complexprojectile:SetOnLaunch(onthrown)
    inst.components.complexprojectile:SetOnHit(OnHitZap)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(20, 10)

    --inst.persists = false

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("roship_projectile", fn, assets, prefabs)
