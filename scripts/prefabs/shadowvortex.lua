require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/nightmare_torch.zip"),
}

local prefabs =
{
    "collapse_small",
    "nightlight_flame",
}

local function Beat(inst)
    inst.SoundEmitter:PlaySound("dontstarve/sanity/shadow_heart")
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local theta = inst.Transform:GetRotation()
	local TheAngle = 360 * DEGREES
	
	
	
	
	local damageents = TheSim:FindEntities(x, y, z, 1 * inst.Transform:GetScale(), { "player" }, { "playerghost" })
	local ents = TheSim:FindEntities(x, y, z, 15 * inst.Transform:GetScale(), { "player" }, { "playerghost" })
	local items = TheSim:FindEntities(x, y, z, 15 * inst.Transform:GetScale(), { "_inventoryitem" }, { "raidrat", "spider", "INLIMBO", "catchable", "fire", "irreplaceable", "heavy", "prey", "bird", "outofreach"--[[, "_container"]] } )
	
	for i, v in ipairs(damageents) do
		if v.components.health ~= nil then
			v.components.health:DoDelta(-5 * inst.Transform:GetScale(), false, inst.prefab)
		end
	end
	
	for i, v in ipairs(ents) do
		local px, py, pz = v.Transform:GetWorldPosition()
			
		local rad = math.rad(v:GetAngleToPoint(x, y, z))
		local velx = math.cos(rad) --* 4.5
		local velz = -math.sin(rad) --* 4.5
		
		local multiplierplayer = inst:GetDistanceSqToPoint(px, py, pz)
		print("Multiplier")
		print(multiplierplayer)
		
		multiplierplayer = (multiplierplayer * inst.Transform:GetScale()) / 50
		print("Divide by 10")
		print(multiplierplayer)
		
		if multiplierplayer > 20 then
			multiplierplayer = 20
		print("Too Far")
		print(multiplierplayer)
		elseif multiplierplayer < 1.5 then
			multiplierplayer = 1.5
		print("Too Close")
		print(multiplierplayer)
		end
		
		local dx, dy, dz = px + (((FRAMES * 4) * velx) / multiplierplayer) * inst.Transform:GetScale(), 0, pz + (((FRAMES * 4) * velz) / multiplierplayer) * inst.Transform:GetScale()
			
		local ground = TheWorld.Map:IsPassableAtPoint(dx, dy, dz)
		local boat = TheWorld.Map:GetPlatformAtPoint(dx, dz)
		if dx ~= nil and (ground or boat) then
			v.Transform:SetPosition(dx, dy, dz)
		end
	end
	
	for i, k in ipairs(items) do
		local gx, gy, gz = k.Transform:GetWorldPosition()
			
		local rad = math.rad(k:GetAngleToPoint(x, y, z))
		local velx = math.cos(rad) --* 4.5
		local velz = -math.sin(rad) --* 4.5
		
		local multiplieritem = inst:GetDistanceSqToPoint(gx, gy, gz)
		print(multiplieritem)
		
		local nx, ny, nz = gx + (FRAMES * velx * inst.Transform:GetScale()) / 2, 0, gz + (FRAMES * velz * inst.Transform:GetScale()) / 2
			
		local ground = TheWorld.Map:IsPassableAtPoint(nx, ny, nz)
		local boat = TheWorld.Map:GetPlatformAtPoint(nx, nz)
		if nx ~= nil and (ground or boat) then
			k.Transform:SetPosition(nx, ny, nz)
		end
	end
end

local function Disappear_mini(inst)
	inst.components.sizetweener:StartTween(0.05, 0.2, inst.Remove)
end

local function shrink_mini(inst)
	--inst.sg:GoToState("run")
	inst.components.sizetweener:StartTween(0.1, 8, Disappear_mini)
end

local function shrinktask_mini(inst)
	inst:DoTaskInTime(10, shrink_mini)
end
		
local function grow_mini(inst, time, startsize, endsize)
	inst.Transform:SetScale(0.1, 0.1, 0.1)
	inst.components.sizetweener:StartTween(1.8, 15, shrinktask_mini)
end


local function fn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("shadowtalker")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("shadowvortex")
    inst.AnimState:SetBuild("shadowvortex")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)

    inst.LightWatcher:SetLightThresh(.2)
    inst.LightWatcher:SetDarkThresh(.19)
	--inst:ListenForEvent("enterlight", Disappear)
	inst.AnimState:SetMultColour(1, 1, 1, .8)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("sizetweener")
	
	inst.grow_mini = grow_mini
	inst:grow_mini()
	
	inst:DoPeriodicTask(FRAMES, Vac)
	inst:DoPeriodicTask(1.5, Beat)
	
    inst.persists = false
	
    return inst
end

return Prefab("shadowvortex", fn, assets, prefabs)