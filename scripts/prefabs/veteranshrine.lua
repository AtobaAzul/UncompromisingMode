local assets =
{
    Asset("ANIM", "anim/veteranshrine.zip"),      
}

local prefabs =
{
}


--[[
local function makeactive(inst)
    inst.AnimState:PlayAnimation("off", true)
    inst.components.activatable.inactive = false
end

local function makeused(inst)
    inst.AnimState:PlayAnimation("flow_loop", true)
end
]]

local function GetVerb()
    return "TOUCH"
end

local function ToggleCurse(inst, doer)
	if doer.components.debuffable ~= nil then
		if not doer.vetcurse == true then
			doer.components.debuffable:AddDebuff("buff_vetcurse", "buff_vetcurse")
			doer:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_VETCURSE", 1 })
			local x, y, z = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("statue_transition_2")
			if fx ~= nil then
				fx.Transform:SetPosition(x, y, z)
				fx.Transform:SetScale(1.2,1.2,1.2)
			end
			fx = SpawnPrefab("statue_transition")
			if fx ~= nil then
				fx.Transform:SetPosition(x, y, z)
				fx.Transform:SetScale(1.2,1.2,1.2)
			end
		end
	end
	inst.components.activatable.inactive = true
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    anim:SetBuild("veteranshrine")    
    anim:SetBank("veteranshrine")
    anim:PlayAnimation("idle", true)
    inst.GetActivateVerb = GetVerb
    MakeObstaclePhysics(inst, 2)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = ToggleCurse
    inst.components.activatable.inactive = true
    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    --inst.deactivate = deactivate

    --inst.OnSave = onsave 
    --inst.OnLoad = onload

    return inst
end

return Prefab("veteranshrine", fn, assets, prefabs)


