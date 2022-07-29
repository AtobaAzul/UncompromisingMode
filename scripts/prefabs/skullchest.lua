require "prefabutil"
local function onopen(inst, data) 
	if not inst:HasTag("burnt") then
		if TheWorld.components.skullchestinventory.trunk and not TheWorld.components.skullchestinventory.trunk.components.container:IsOpen() then
			TheWorld.components.skullchestinventory.trunk.Transform:SetPosition(data.doer.Transform:GetWorldPosition())
			TheWorld.components.skullchestinventory.trunk.components.container:Open(data.doer)
		end
	
		inst.AnimState:PlayAnimation("open")
		local x,y,z = inst.Transform:GetWorldPosition()
		SpawnPrefab("shadow_despawn").Transform:SetPosition(x,y,z)
		local players = TheSim:FindEntities(x,y,z,3,{"player"},{"ghost"})
		for i,v in ipairs(players) do
			if v ~= nil and v.components.sanity ~= nil then
				v.components.sanity:DoDelta(-10)
			end
		end
	end
end

local function onclose(inst, data)
	if not inst:HasTag("burnt") then
		if TheWorld.components.skullchestinventory.trunk then
			TheWorld.components.skullchestinventory.trunk.components.container:Close(data.doer)
		end
	
		inst.AnimState:PlayAnimation("close")
	end
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", true)	
end

local function MakeChest(name, bank, build, indestructible, master_postinit, prefabs, assets, common_postinit, force_non_burnable)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

		if name == "skullchest_child" then
			inst.MiniMapEntity:SetIcon(name..".png")
		else
			inst.entity:SetCanSleep(false)
		end
        inst:AddTag("structure")
        inst:AddTag("chest")

		if name == "skullchest_child" then
			inst:AddTag("skull_storage")
			inst.AnimState:SetBank(bank)
			inst.AnimState:SetBuild(build)
			inst.AnimState:PlayAnimation("closed")
		end

		MakeSnowCoveredPristine(inst)
		
        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
		
		if name == "skullchest_child" then
			inst.components.container.onopenfn = onopen
			inst.components.container.onclosefn = onclose
		end
		
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true


        if not indestructible then
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)

            if not force_non_burnable then
                MakeSmallBurnable(inst, nil, nil, true)
                MakeMediumPropagator(inst)
            end
        end

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn)
end

return MakeChest("skullchest", "skull_chest", "skull_chest", true, nil, { "collapse_small" }),
MakeChest("skullchest_child", "skull_chest", "skull_chest", false, nil, { "collapse_small" }),
MakePlacer("skullchest_child_placer", "skull_chest", "skull_chest", "closed")