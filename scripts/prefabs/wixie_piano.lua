local WixiePiano = require "screens/WixiePiano"

local assets =
{
    Asset("ANIM", "anim/wixie_piano.zip"),      
}

local prefabs =
{
}

AddModRPCHandler("UncompromisingSurvival", "PianoPuzzleComplete", function()
	TheWorld:PushEvent("pianopuzzlecomplete")
end)

local function TogglePianoe(inst)
	local player = inst.Pianoe:value()
	if player == ThePlayer then
		local function acceptance()
			TheFrontEnd:PopScreen()
		end

		local bpds = WixiePiano()

		TheFrontEnd:PushScreen(bpds)
	end
end

local function OnActivate(inst, doer)
	inst.valid_cursee_id = doer.userid
	inst.Pianoe:set_local(doer)
	inst.Pianoe:set(doer)
	
	inst.components.activatable.inactive = true
end

local function RegisterNetListeners(inst)
	inst:ListenForEvent("SetPianoedirty", TogglePianoe)
end

local function SpawnKey(inst)
	SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function fn(Sim)
    local inst = CreateEntity()

	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	--inst.entity:AddMiniMapEntity()
	--inst.MiniMapEntity:SetIcon("veteranshrine_map.tex")

    inst.AnimState:SetBuild("wixie_piano")    
    inst.AnimState:SetBank("wixie_piano")
    inst.AnimState:PlayAnimation("idle", true)
	
    --inst.GetActivateVerb = GetVerb
	
	inst.Pianoe = net_entity(inst.GUID, "SetPianoe.plyr", "SetPianoedirty")

	inst:DoTaskInTime(0, RegisterNetListeners)
	
    MakeObstaclePhysics(inst, 1)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true
	inst.components.activatable.standingaction = true
	
    inst:AddComponent("inspectable")

	inst:ListenForEvent("pianopuzzlecomplete", SpawnKey)
	
    return inst
end

return Prefab("wixie_piano", fn, assets, prefabs)