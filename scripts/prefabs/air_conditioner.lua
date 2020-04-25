require "prefabutil"

function Default_PlayAnimation(inst, anim, loop)
    inst.AnimState:PlayAnimation(anim, loop)
end

function Default_PushAnimation(inst, anim, loop)
    inst.AnimState:PushAnimation(anim, loop)
end

local function onopen(inst)
    if not inst:HasTag("burnt") then
		inst:AddTag("airconditioneropen")
        inst.AnimState:PlayAnimation("open")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end 

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
		inst:RemoveTag("airconditioneropen")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function onhammered(inst, worker)
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
	if not inst.AnimState:IsCurrentAnimation("idle_fueled") then
		inst.AnimState:PlayAnimation("hit")
	end
	
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
		inst.components.container:Close()
	end
end

local assets =
{
    Asset("ANIM", "anim/rain_meter.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
        inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_place")
    --the global animover handler will restart the check task
end

local function makeburnt(inst)
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function TryPerish(player, inst)

	local redcaps = #inst.components.container:FindItems( function(item) return item:HasTag("red_mushroom_fuel") end )
	local greencaps = #inst.components.container:FindItems( function(item) return item:HasTag("green_mushroom_fuel") end )
	local bluecaps = #inst.components.container:FindItems( function(item) return item:HasTag("blue_mushroom_fuel") end )

	if not player:IsInLimbo() then
		if bluecaps > 0 then
			player.components.health:DoDelta(bluecaps * 0.1)
		end
		
		if greencaps > 0 then
			player.components.sanity:DoDelta(greencaps * 0.1)
		end
		
		if redcaps > 0 and player.components.hayfever.nextsneeze < 120 then
			player.components.hayfever:SetNextSneezeTime(player.components.hayfever.nextsneeze + redcaps * 1)
		end
		return
    end
	
		
end

local function DoSpoil(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 10, nil, nil, { "player" })
    for i, v in ipairs(ents) do
        TryPerish(v, inst)
    end
end

local function CheckForItems(inst)
	if inst.components.container ~= nil then
		local perishables = #inst.components.container:FindItems( function(item) return item:HasTag("mushroom_fuel") end )

		if perishables > 0 then

			if not inst:HasTag("burnt") then
				if not inst:HasTag("airconditioneropen") then
					if inst.AnimState:IsCurrentAnimation("idle_fueled") or
						inst.AnimState:IsCurrentAnimation("place") then
						--NOTE: push again even if already playing, in case an idle was also pushed
						inst:_PushAnimation("idle_fueled", true)
					else
						inst:_PlayAnimation("idle_fueled", true)
					end
				end
			end

			if inst.rottask == nil then
				inst.rottask = inst:DoPeriodicTask(2, DoSpoil)
			end
		else
			if not inst:HasTag("airconditioneropen") then
				inst:_PushAnimation("idle", true)
			end
			if inst.rottask ~= nil then
				inst.rottask:Cancel()
			end
			inst.rottask = nil
		end
	end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
	inst:DoTaskInTime(0, CheckForItems)
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
    inst.MiniMapEntity:SetIcon("air_conditioner.tex")

    inst.AnimState:SetBank("airconditioner")
    inst.AnimState:SetBuild("airconditioner")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("chest")
	
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			inst.replica.container:WidgetSetup("air_conditioner") 
		end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)       
    MakeSnowCovered(inst)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("air_conditioner")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(5)
		
    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("animover", CheckForItems)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst:ListenForEvent("burntup", makeburnt)
	
	inst:ListenForEvent("itemget", CheckForItems)
	inst:ListenForEvent("itemlose", CheckForItems)
	
    MakeHauntableWork(inst)

	inst._PlayAnimation = Default_PlayAnimation
	inst._PushAnimation = Default_PushAnimation
		
    return inst
end

return Prefab("air_conditioner", fn, assets, prefabs),
    MakePlacer("air_conditioner_placer", "airconditioner", "airconditioner", "idle")
