require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/magician_chest.zip"),
}

local prefabs =
{
	"collapse_small",
}

local POCKETDIMENSIONCONTAINER_DEFS = {
	{--this def works
		name = "skull",
		prefab = "skullchest",
		ui = "anim/ui_portal_shadow_3x4.zip",
		widgetname = "shadowchester",
	},
	{--but this one doesn't??
		name = "winky",
		prefab = "uncompromising_winkyburrow_master",
		ui = "anim/ui_portal_shadow_3x4.zip",
		widgetname = "shadowchester",
	},
}

local function OnOpen(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		--inst.AnimState:PushAnimation("loop")
		--inst.SoundEmitter:PlaySound("maxwell_rework/magician_chest/open")
		--inst.SoundEmitter:PlaySound("maxwell_rework/shadow_magic/storage_void_LP", "loop")
		--inst._showopenfx:set(true)
	end
	local x, y, z = inst.Transform:GetWorldPosition()

	SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
	local players = TheSim:FindEntities(x, y, z, 4, { "player" }, { "ghost" })
	for i, v in ipairs(players) do
		if v ~= nil and v.components.sanity ~= nil then
			v.components.sanity:DoDelta(-10)
		end
	end
end

local function OnClose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.AnimState:PushAnimation("closed", false)
		--inst.SoundEmitter:PlaySound("maxwell_rework/magician_chest/close")
		--inst.SoundEmitter:KillSound("loop")
		--inst._showopenfx:set(false)
	end
	inst.SoundEmitter:KillSound("loop")
end

local function OnHammered(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		if inst.components.container_proxy ~= nil then
			inst.components.container_proxy:Close()
		end
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", false)
		--inst._showopenfx:set(false)
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function OnSave(inst, data)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.burnt and inst.components.burnable ~= nil then
		inst.components.burnable.onburnt(inst)
	end
end

local function AttachShadowContainer(inst)
	inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("skull"))
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	--MakeObstaclePhysics(inst, .4)

	inst.MiniMapEntity:SetIcon("skull_chest.png")

	inst:AddTag("structure")
	--inst:AddTag("chest")
	inst:AddTag("skullchest")

	inst.AnimState:SetBank("skull_chest")
	inst.AnimState:SetBuild("skull_chest")
	inst.AnimState:PlayAnimation("closed")

	MakeSnowCoveredPristine(inst)

	inst:AddComponent("container_proxy")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst.components.container_proxy:SetOnOpenFn(OnOpen)
	inst.components.container_proxy:SetOnCloseFn(OnClose)

	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)

	MakeSmallBurnable(inst, nil, nil, true)
	MakeMediumPropagator(inst)
	--inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("onbuilt", OnBuilt)
	MakeSnowCovered(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = AttachShadowContainer

	if not POPULATING then
		AttachShadowContainer(inst)
	end

	return inst
end

local function OnAnyOpenStorage(inst, data)
	if inst.components.container.opencount > 1 then
		--multiple users, make it global to all players now
		inst.Network:SetClassifiedTarget(nil)
	else
		--just one user, only network to that player
		inst.Network:SetClassifiedTarget(data.doer)
	end
end

local function OnAnyCloseStorage(inst, data)
	local opencount = inst.components.container.opencount
	if opencount == 0 then
		--all closed, disable networking
		inst.Network:SetClassifiedTarget(inst)
	elseif opencount == 1 then
		--only one user remaining, only network to that player
		local opener = next(inst.components.container.openlist)
		inst.Network:SetClassifiedTarget(opener)
	end
end

local function MakeContainer(def)
	local assets = {
		Asset("ANIM", def.ui),
		Asset("SCRIPT", "scripts/prefabs/pocketdimensioncontainer_defs.lua"),
	}

	local function fn()
		local inst = CreateEntity()

		if TheWorld.ismastersim then
			inst.entity:AddTransform() --So we can save
		end
		inst.entity:AddNetwork()
		inst.entity:AddServerNonSleepable()
		inst.entity:SetCanSleep(false)
		inst.entity:Hide()
		inst:AddTag("CLASSIFIED")
		inst:AddTag("pocketdimension_container")
		inst:AddTag("spoiler")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.Network:SetClassifiedTarget(inst)

		inst:AddComponent("container")
		inst.components.container:WidgetSetup(def.widgetname)
		inst.components.container.skipclosesnd = true
		inst.components.container.skipopensnd = true
		inst.components.container.skipautoclose = true
		inst.components.container.onanyopenfn = OnAnyOpenStorage
		inst.components.container.onanyclosefn = OnAnyCloseStorage

		TheWorld:SetPocketDimensionContainer(def.name, inst)

		return inst
	end

	return Prefab(def.prefab, fn, assets)
end

local container_prefabs = {}
for _, v in pairs(POCKETDIMENSIONCONTAINER_DEFS) do
	--I checked here and *the winky def is getting used here*
	table.insert(container_prefabs, MakeContainer(v))
end
printwrap("HERE!!!", container_prefabs)
return Prefab("skullchest_child", fn, assets, prefabs),
	MakePlacer("skullchest_child_placer", "skull_chest", "skull_chest", "closed"),
	unpack(container_prefabs)
