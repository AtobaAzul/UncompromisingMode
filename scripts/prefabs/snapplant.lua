require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/snapplant.zip"),
	Asset("MINIMAP_IMAGE", "snapplant"),
}

local prefabs =
{
	"collapse_small",
}

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("drop")
	inst:DoTaskInTime(0.5, function(inst) 
		inst:DoTaskInTime(0.1, function(inst) inst.AnimState:PlayAnimation("idle_loop",true) end)
		SpawnPrefab("splash").Transform:SetPosition(inst.Transform:GetWorldPosition()) 
	end)
end

local function onsave(inst)
	if inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
end

local function Die(inst)
	inst.AnimState:PlayAnimation("death")
	inst:ListenForEvent("animover", inst.Remove)
end

local function Bind(inst, buddy)
	if buddy ~= nil and buddy.components.follower then
		buddy.components.follower:SetLeader(inst)
        inst:ListenForEvent("death", function() Die(inst) end, buddy)
	end

	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle_loop",true)
end

local function extinguish(inst)
	inst.AnimState:PlayAnimation("idle_gargle")
	inst:DoTaskInTime(1.8, function(inst) 
		SpawnPrefab("splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst:DoTaskInTime(0.1, function(inst) inst.components.burnable:Extinguish() end)
	end)
	inst.AnimState:PushAnimation("idle_loop",true)

	
end

local function fn()
	local inst = CreateEntity()
	
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    
	inst.MiniMapEntity:SetIcon("snapplant_map.tex")
    
    inst.AnimState:SetBank("snapplant")
    inst.AnimState:SetBuild("snapplant")
    inst.AnimState:PlayAnimation("idle_loop",true)

    inst.Transform:SetScale(0.66, 0.66, 0.66)

    inst:AddTag("snapplant")
	inst:AddTag("irreplaceable")
    
	MakeSnowCoveredPristine(inst)  
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("leader")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snapplant.xml"
    inst.components.inventoryitem:SetSinks(true)
	
	MakeSnowCovered(inst, .01)    

	inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable:SetBurnTime(3000)
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0) )
    inst.components.burnable:SetOnIgniteFn(extinguish)
    inst.components.burnable:SetOnBurntFn(nil)

    inst:ListenForEvent("ondropped", OnDropped)

	inst.Bind = Bind

	inst.OnSave = onsave

    return inst
end

return Prefab( "snapplant", fn, assets, prefabs)