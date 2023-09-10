local assets =
{
    Asset("ANIM", "anim/houndious_observious.zip"),
	Asset("IMAGE", "images/inventoryimages/houndious_observious.tex"),
	Asset("ATLAS", "images/inventoryimages/houndious_observious.xml"),
	Asset("IMAGE", "images/map_icons/houndious_observious_map.tex"),
	Asset("ATLAS", "images/map_icons/houndious_observious_map.xml"),
}

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place",false)
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_place")
    --the global animover handler will restart the check task
end

local function makeburnt(inst)
	inst.AnimState:PlayAnimation("burnt",false)
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function ondestroyed(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then 
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst)
	inst.AnimState:PlayAnimation("hit",false)
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
		inst.AnimState:PlayAnimation("burnt",false)
    end
end

local function Observious(inst)
	if not inst:HasTag("burnt") then
		if TheWorld.components.hounded then
			local houndtime = TheWorld.components.hounded:GetTimeToAttack()/(60*8) --Convert seconds to DS days 
			if houndtime then -- Will eventually get it to check for giants too, though I think we may wanna *actually* (which means without bug or fail) redo giant spawns before we do that...
				--TheNet:Announce(houndtime)
				if houndtime > 7 then
					inst.AnimState:PlayAnimation("idle",false)
				elseif houndtime <= 7 and houndtime > 6 then
					inst.AnimState:PlayAnimation("idle_7",false)
				elseif houndtime <= 6 and houndtime > 5 then
					inst.AnimState:PlayAnimation("idle_6",false)
				elseif houndtime <= 5 and houndtime > 4 then
					inst.AnimState:PlayAnimation("idle_5",false)
				elseif houndtime <= 4 and houndtime > 3 then
					inst.AnimState:PlayAnimation("idle_4",false)
				elseif houndtime <= 3 and houndtime > 2 then
					inst.AnimState:PlayAnimation("idle_3",false)
					inst:DoTaskInTime(0.2,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.1,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
				elseif houndtime <= 2 and houndtime > 1 then
					inst.AnimState:PlayAnimation("idle_2",false)
					inst:DoTaskInTime(0.2,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(0.5,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.1,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.7,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
				elseif houndtime <= 1 then
					inst.AnimState:PlayAnimation("idle_1",false)
					inst:DoTaskInTime(0.2,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(0.5,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(0.8,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.1,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.4,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(1.7,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
					inst:DoTaskInTime(2.0,function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk") end)
				end
			end
		else
			inst.AnimState:PlayAnimation("idle",false)
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)
	local minimap = inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("houndious_observious_map.tex") --This isn't working...?

    inst.AnimState:SetBank("houndious_observious")
    inst.AnimState:SetBuild("houndious_observious")
	inst.AnimState:PlayAnimation("idle",false)

    inst:AddTag("structure")
	
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(25)
    inst.components.workable:SetOnFinishCallback(ondestroyed)
    inst.components.workable:SetOnWorkCallback(onhit)       
	

	
    inst:ListenForEvent("onbuilt", onbuilt)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst:ListenForEvent("burntup", makeburnt)
	inst:ListenForEvent("animover",Observious)
    MakeHauntableWork(inst)
		
    return inst
end


return Prefab("houndious_observious", fn, assets),
    MakePlacer("houndious_observious_placer", "houndious_observious", "houndious_observious", "place_pre")
