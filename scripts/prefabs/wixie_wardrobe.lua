require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/wixie_wardrobe.zip"),
}

local prefabs =
{
    "collapse_big",
}

local function ShutterAndShake(inst)
	inst.AnimState:PlayAnimation("active")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_active")
end

local function OnActivate(inst, doer)
	if not inst.AnimState:IsCurrentAnimation("active") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", false)
		inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_hit")
	end
	
    inst.components.activatable.inactive = true
end

local function SpawnHer(inst, doer)
	inst.AnimState:PlayAnimation("active")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_active")
		
	inst.Light:Enable(true)
		
	inst:DoTaskInTime(20 * FRAMES, function()
		local shadowwixie = SpawnPrefab("shadow_wixie")
		shadowwixie:AddTag("puzzlespawn")
		shadowwixie.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end)
end

local function GetActivateVerb(inst)
	return "OPEN"
end

local dirs =
{
    N=135, 
    NE=180, 
	E=-135, 
	SE=-90,
	S=-45,
	SW=0,
	W=45,
	NW=90,
}

local function CheckAngle(inst, target)
	if target ~= nil then
		local x, y, z = target.Transform:GetWorldPosition()
		local heading = inst:GetAngleToPoint(x, y, z)
		local dir, closest_diff = nil, nil
			
		for k,v in pairs(dirs) do
			local diff = math.abs(anglediff(heading, v))
			if not dir or diff < closest_diff then
				dir, closest_diff = k, diff
			end
		end
					
		return dir
	else
		return nil
	end
end

local function GetAngles(inst)
	local beequeen = TheSim:FindFirstEntityWithTag("custom_beequeenhive_tag")
	local widowspawner = TheSim:FindFirstEntityWithTag("widowweb")
	local oasis = TheSim:FindFirstEntityWithTag("custom_oasis_tag")
	
	inst.beequeen = CheckAngle(inst, beequeen)
	inst.widowspawner = CheckAngle(inst, widowspawner)
	inst.oasis = CheckAngle(inst, oasis)
	
	if inst.beequeen == nil or inst.widowspawner == nil or inst.oasis == nil then
		inst:DoTaskInTime(5, GetAngles)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:SetPhysicsRadiusOverride(.8)
    MakeObstaclePhysics(inst, inst.physicsradiusoverride)

    inst:AddTag("wixie_wardrobe")
	
    inst.Light:SetRadius(15)
    inst.Light:SetFalloff(.9)
    inst.Light:SetIntensity(0.65)
    inst.Light:SetColour(200 / 255, 140 / 255, 140 / 255)
	inst.Light:Enable(false)
	
    inst.AnimState:SetBank("wardrobe")
    inst.AnimState:SetBuild("wixie_wardrobe")
    inst.AnimState:PlayAnimation("closed")

    inst.MiniMapEntity:SetIcon("wardrobe.png")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	inst.components.activatable.standingaction = true
	
	inst.GetActivateVerb = GetActivateVerb
	
    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
	
    MakeSnowCovered(inst)
	
	inst:ListenForEvent("wixie_wardrobe_shutter", OnActivate)
	inst:ListenForEvent("wixie_wardrobe_shake", ShutterAndShake)
	inst:ListenForEvent("spawn_shadow_wix", SpawnHer)
	
	inst:DoTaskInTime(5, GetAngles)
	
	inst:WatchWorldState("cycles", function() 
		inst.Light:Enable(false)
	end)

    return inst
end

return Prefab("wixie_wardrobe", fn, assets, prefabs)