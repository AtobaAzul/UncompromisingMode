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

local function RemoveWhirlpool(inst)
	inst.components.colourtweener:StartTween({1,1,1,0}, 3, inst.Remove)
	inst.SoundEmitter:KillSound("whirlpool")
	
    inst.persists = false
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function Vac(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local boats = TheSim:FindEntities(x, y, z, 25, {"boat"})
	
	for i, v in ipairs(boats) do
		local px, py, pz = v.Transform:GetWorldPosition()
		local theta = (inst:GetAngleToPoint(px, 0, pz) + 66) * DEGREES
		
		px = px + 7.5*math.cos(theta)
		pz = pz - 7.5*math.sin(theta)
		
		local row_dir_x, row_dir_z = VecUtil_Normalize(x - px, z - pz)
		local boat_physics = v.components.boatphysics
		
		if boat_physics ~= nil then
			if boat_physics:GetTotalAnchorDrag() < 2 then

				boat_physics:ApplyForce(row_dir_x, row_dir_z, .2)
			end
		end
	end
end

local function Init(inst)
	inst.SoundEmitter:PlaySound("UCSounds/um_whirlpool/um_whirlpool_loop", "whirlpool")
	
	if inst.vactask == nil then
		inst.vactask = inst:DoPeriodicTask(.25, Vac)
	end
end

local function OnWake(inst)
	if inst.vactask == nil then
		inst.vactask = inst:DoPeriodicTask(.25, Vac)
	end
end

local function OnSleep(inst)
	if inst.vactask ~= nil then
		inst.vactask:Cancel()
		inst.vactask = nil
	end
end

local function fn()
    local inst = CreateEntity()
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(true)
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetMultColour(1,1,1,0)

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
	
    inst.AnimState:SetBank("um_whirlpool")
    inst.AnimState:SetBuild("um_whirlpool")
    inst.AnimState:PlayAnimation("spin2", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
	inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)
	
	inst.Transform:SetScale(3, 3, 3)
	
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({1,1,1,1}, 3)
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", RemoveWhirlpool)
	
	inst:DoTaskInTime(0, Init)

    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep
	
    return inst
end

return Prefab("um_whirlpool", fn, assets, prefabs)