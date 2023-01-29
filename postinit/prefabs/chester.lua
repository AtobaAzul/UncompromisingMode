local env = env
GLOBAL.setfenv(1, GLOBAL)

--Please, never do this again.
--I'm just continueing this because I'm too lazy and impatient to fix it right now.
--Just use upvaluehacker

local ChesterStateNames =
{
	"NORMAL",
	"SNOW",
	"SHADOW",
	"LAZY",
}
local ChesterState = table.invert(ChesterStateNames)


local DOWN_FACING_ANIMS =
{
	"open",
	"idle_loop_open",
	"closed",
	"hit",
	"sleep_pre",
	"sleep_loop",
	"sleep_pst",
	"death",
	"transition",
}

local SIDE_FACING_ANIMS =
{
	"chomp",
	"lick",
}

local function GetBreathAnimFacing(inst)
	for i, v in ipairs(DOWN_FACING_ANIMS) do
		if inst.AnimState:IsCurrentAnimation(v) then
			return FACING_DOWN
		end
	end
	for i, v in ipairs(SIDE_FACING_ANIMS) do
		if inst.AnimState:IsCurrentAnimation(v) then
			return FACING_RIGHT
		end
	end
	return inst.AnimState:GetCurrentFacing()
end

local function EmitFrost(inst, frostbreath)
	if frostbreath.refreshsortorder then
		local facing = GetBreathAnimFacing(inst)
		if facing == FACING_DOWN then
			frostbreath.fx.VFXEffect:SetSortOrder(0, 1)
			frostbreath.fx2.VFXEffect:SetSortOrder(0, 1)
		elseif facing == FACING_UP then
			frostbreath.fx.VFXEffect:SetSortOrder(0, -1)
			frostbreath.fx2.VFXEffect:SetSortOrder(0, -1)
		else
			frostbreath.fx.VFXEffect:SetSortOrder(0, -1)
			frostbreath.fx2.VFXEffect:SetSortOrder(0, 1)
		end
		frostbreath.refreshsortorder = false
	end
	frostbreath.fx.Follower:SetOffset(math.random() * 20 - 10, math.random() * 15 - 10, 0)
	frostbreath.fx2.Follower:SetOffset(math.random() * 20 - 10, math.random() * 15 - 10, 0)
	frostbreath.fx:Emit()
	frostbreath.fx2:Emit()
	if frostbreath.count > 1 then
		frostbreath.count = frostbreath.count - 1
	else
		frostbreath.count = 0
		frostbreath.task:Cancel()
		frostbreath.task = nil
	end
end

local function DoFrostBreath(inst)
	local frostbreath = inst.frostbreath
	local delay =
		(inst.AnimState:IsCurrentAnimation("idle_loop") and math.random() + 2) or
		(inst.AnimState:IsCurrentAnimation("idle_loop_open") and math.random() * .5 + .25) or
		0

	if delay > 0 then
		local t = GetTime()
		if frostbreath.lasttime ~= nil and t < frostbreath.lasttime + delay then
			return
		end
		frostbreath.lasttime = t
	else
		frostbreath.lasttime = nil
	end

	if frostbreath.task ~= nil then
		frostbreath.task:Cancel()
	end
	if inst:HasTag("moving") then
		frostbreath.count = math.random(2, 3)
	else
		frostbreath.count = 1
	end
	frostbreath.refreshsortorder = true
	frostbreath.task = inst:DoPeriodicTask(math.random(4, 5) * FRAMES, EmitFrost, 0, frostbreath)
end

local function PushFrostBreathTrigger(inst)
	inst._frostbreathtrigger:push()
end

local function TriggerAndDoFrostBreath(inst)
	inst._frostbreathtrigger:push()
	DoFrostBreath(inst)
end

local function EnableFrostBreath(inst, enable)
	if enable then
		if inst.frostbreath == nil then
			if TheNet:IsDedicated() then
				inst.frostbreath = true
				--push the net event, but don't need to show the fx locally
				inst:ListenForEvent("animover", PushFrostBreathTrigger)
			else
				inst.frostbreath =
				{
					fx = SpawnPrefab("frostbreath"),
					fx2 = SpawnPrefab("frostbreath"),
				}
				inst.frostbreath.fx.entity:SetParent(inst.entity)
				inst.frostbreath.fx.entity:AddFollower()
				inst.frostbreath.fx.Follower:FollowSymbol(inst.GUID, "breath_left", 0, 0, 0)
				inst.frostbreath.fx2.entity:SetParent(inst.entity)
				inst.frostbreath.fx2.entity:AddFollower()
				inst.frostbreath.fx2.Follower:FollowSymbol(inst.GUID, "breath_right", 0, 0, 0)
				if TheWorld.ismastersim then
					--push the net event and also show the fx locally
					inst:ListenForEvent("animover", TriggerAndDoFrostBreath)
				else
					--listen for net event because client does not receive
					--animover events for server owned networked entities.
					inst:ListenForEvent("chester._frostbreathtrigger", DoFrostBreath)
				end
			end
		end
	elseif inst.frostbreath ~= nil then
		if inst.frostbreath == true then
			inst:RemoveEventCallback("animover", PushFrostBreathTrigger)
		else
			inst.frostbreath.fx:Remove()
			inst.frostbreath.fx2:Remove()
			if inst.frostbreath.task ~= nil then
				inst.frostbreath.task:Cancel()
			end
			if TheWorld.ismastersim then
				inst:RemoveEventCallback("animover", TriggerAndDoFrostBreath)
			else
				inst:RemoveEventCallback("chester._frostbreathtrigger", DoFrostBreath)
			end
		end
		inst.frostbreath = nil
	end
end


local function ReleaseShadowBreath(fx)
	fx.Follower:StopFollowing()
end

local function EmitShadow(inst, isleft, taskname)
	local facing = GetBreathAnimFacing(inst)
	local fx = CreateShadowBreath(inst.shadowbreath.pool)
	if isleft then
		fx.Follower:FollowSymbol(inst.GUID, "breath_left", math.random() * 20 - 10, math.random() * 15 - 10, 0)
		fx.AnimState:SetFinalOffset(facing == FACING_DOWN and 1 or -1)
	else
		fx.Follower:FollowSymbol(inst.GUID, "breath_right", math.random() * 20 - 10, math.random() * 15 - 10, 0)
		fx.AnimState:SetFinalOffset(facing == FACING_UP and -1 or 1)
	end
	fx:DoTaskInTime(0, ReleaseShadowBreath)

	local health = inst.replica.health
	inst.shadowbreath[taskname] =
		not (health ~= nil and health:IsDead()) and
		inst:DoTaskInTime(.35 + math.random() * .6, EmitShadow, isleft, taskname) or
		nil
end

local function EnableShadowBreath(inst, enable)
	if enable then
		if inst.shadowbreath == nil and not TheNet:IsDedicated() then
			inst.shadowbreath =
			{
				pool = {},
				task = inst:DoTaskInTime(math.random() * .6, EmitShadow, true, "task"),
				task2 = inst:DoTaskInTime(math.random() * .6, EmitShadow, false, "task2"),
			}
		end
	elseif inst.shadowbreath ~= nil then
		inst.shadowbreath.task:Cancel()
		inst.shadowbreath.task2:Cancel()
		for i, v in ipairs(inst.shadowbreath.pool) do
			v:Remove()
		end
		inst.shadowbreath.pool.invalid = true
		inst.shadowbreath = nil
	end
end

local function ToggleBreath(inst)
	local state = inst._chesterstate:value()
	EnableFrostBreath(inst, state == ChesterState.SNOW)
	EnableShadowBreath(inst, state == ChesterState.SHADOW)
end


local function SetBuild(inst)
    local skin_build = inst:GetSkinBuild()
	local chester_state = inst._chesterstate:value()
    if skin_build ~= nil then
		local state =
			(chester_state == ChesterState.SHADOW and "_shadow") or
			(chester_state == ChesterState.SNOW and "_snow") or
			""

        inst.AnimState:OverrideItemSkinSymbol("chester_body", skin_build, "chester_body" .. state, inst.GUID, "chester_build")
        inst.AnimState:OverrideItemSkinSymbol("chester_foot", skin_build, "chester_foot" .. state, inst.GUID, "chester_build")
        inst.AnimState:OverrideItemSkinSymbol("chester_lid", skin_build, "chester_lid" .. state, inst.GUID, "chester_build")
        inst.AnimState:OverrideItemSkinSymbol("chester_tongue", skin_build, "chester_tongue" .. state, inst.GUID, "chester_build")
    else
        inst.AnimState:ClearAllOverrideSymbols()

		inst.AnimState:SetBuild(
			(chester_state == ChesterState.SHADOW and "chester_shadow_build") or
			(chester_state == ChesterState.SNOW and "chester_snow_build") or
			"chester_build"
		)
    end
	if chester_state == ChesterState.SHADOW then
		inst.AnimState:AddOverrideBuild("tophat_fx")
		inst.AnimState:SetSymbolMultColour("fx_float", 1, 1, 1, .5)
	else
		inst.AnimState:ClearOverrideBuild("tophat_fx")
		inst.AnimState:SetSymbolMultColour("fx_float", 1, 1, 1, 1)
	end
end

local function AttachShadowContainer(inst)
	inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("shadow"))
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end

local function OnClose(inst)
    if not inst.components.health:IsDead() and inst.sg.currentstate.name ~= "transition" then
		inst.sg.statemem.closing = true
        inst.sg:GoToState("close")
    end
end


local function SwitchToContainer(inst)
	if inst.components.container == nil then
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("chester")
		inst.components.container.onopenfn = OnOpen
		inst.components.container.onclosefn = OnClose
		inst.components.container.skipclosesnd = true
		inst.components.container.skipopensnd = true
	end

	inst.components.container_proxy:Close()
	inst.components.container_proxy:SetCanBeOpened(false)
	inst.components.container_proxy:SetMaster(nil)
end

local function SwitchToShadowContainerProxy(inst)
	inst.components.container_proxy:SetOnOpenFn(OnOpen)
	inst.components.container_proxy:SetOnCloseFn(OnClose)
	inst.components.container_proxy:SetCanBeOpened(true)

	--NOTE: don't check POPULATING here; it's checked before this entire function is called
	AttachShadowContainer(inst)

	local x, y, z = inst.Transform:GetWorldPosition()
	local container = inst.components.container
	if container ~= nil then
		local shadowcontainer = inst.components.container_proxy:GetMaster().components.container
		for i = 1, container:GetNumSlots() do
			local item = container:RemoveItemBySlot(i)
			if item ~= nil then
				item.prevcontainer = nil
				item.prevslot = nil

				if not shadowcontainer:GiveItem(item, i, nil, false) then
					item.Transform:SetPosition(x, y, z)
					if item.components.inventoryitem ~= nil then
						item.components.inventoryitem:OnDropped(true)
					end
				end
			end
		end
		inst:RemoveComponent("container")
	end
end


local function MorphShadowChester(inst)
	inst:RemoveTag("fridge")
	inst:AddTag("spoiler")
	inst.MiniMapEntity:SetIcon("chestershadow.png")
	inst.components.maprevealable:SetIcon("chestershadow.png")

	if POPULATING then
		--For loading legacy save data
		inst.components.container:WidgetSetup("shadowchester")
	else
		SwitchToShadowContainerProxy(inst)
	end

	local leader = inst.components.follower.leader
	if leader ~= nil then
		inst.components.follower.leader:MorphShadowEyebone()
	end

	inst.sg.mem.isshadow = true
	inst._chesterstate:set(ChesterState.SHADOW)
	SetBuild(inst)
	ToggleBreath(inst)
end

local function MorphSnowChester(inst)
	inst:RemoveTag("spoiler")
	inst:AddTag("fridge")
	inst.MiniMapEntity:SetIcon("chestersnow.png")
	inst.components.maprevealable:SetIcon("chestersnow.png")

	SwitchToContainer(inst)

	local leader = inst.components.follower.leader
	if leader ~= nil then
		inst.components.follower.leader:MorphSnowEyebone()
	end

	inst.sg.mem.isshadow = nil
	inst._chesterstate:set(ChesterState.SNOW)
	SetBuild(inst)
	ToggleBreath(inst)
end

local CHESTER_PICKUP_MUST_TAGS = { "_inventoryitem" }
local CHESTER_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung",
	"mineactive", "chester_eyebone" }
local function pickup_UM(inst)
	if inst == nil or inst.components.container == nil then
		return
	end
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 1.5 * TUNING.ORANGEAMULET_RANGE, nil, CHESTER_PICKUP_CANT_TAGS,
		CHESTER_PICKUP_MUST_TAGS)
	for i, v in ipairs(ents) do
		if v.components.inventoryitem ~= nil and --Inventory stuff
			v.components.inventoryitem.canbepickedup and
			v.components.inventoryitem.cangoincontainer and
			not v.components.inventoryitem:IsHeld() then

			if inst.components.minigame_participator ~= nil then
				local minigame = inst.components.minigame_participator:GetMinigame()
				if minigame ~= nil then
					minigame:PushEvent("pickupcheat", { cheater = inst, item = v })
				end
			end
			for k = 1, 9 do
				local other_item = inst.components.container.slots[k]
				if other_item and other_item.prefab == v.prefab and other_item.skinname == v.skinname then
					if other_item.components.stackable ~= nil and not other_item.components.stackable:IsFull() then
						--Amulet will only ever pick up items one at a time. Even from stacks.
						SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

						local v_pos = v:GetPosition()
						if v.components.stackable ~= nil then
							v = v.components.stackable:Get()
						end
						if v.components.trap ~= nil and v.components.trap:IsSprung() then
							v.components.trap:Harvest(owner)
						else
							inst.components.container:GiveItem(v, nil, v_pos)
						end
						return
					else
						for k = 1, 9 do
							if inst.components.container.slots[k] == nil then
								SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

								local v_pos = v:GetPosition()
								if v.components.stackable ~= nil then
									v = v.components.stackable:Get()
								end
								if v.components.trap ~= nil and v.components.trap:IsSprung() then
									v.components.trap:Harvest(owner)
								else
									inst.components.container:GiveItem(v, nil, v_pos)
								end
								return
							end
						end
					end
				end
			end
		end
	end
end

local function MorphLazyChester(inst)
	inst.AnimState:SetBuild("lazy_chester")

	inst.MiniMapEntity:SetIcon("lazychester_minimap.tex")
	inst.components.maprevealable:SetIcon("lazychester_minimap.tex")

	local leader = inst.components.follower.leader
	if leader ~= nil then
		inst.components.follower.leader:MorphLazyEyebone()
	end
	inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, pickup_UM, nil, inst)

	inst._chesterstate:set(ChesterState.LAZY)
	SetBuild(inst)
	ToggleBreath(inst)
	inst.sg.mem.isshadow = nil
end

local function CanMorph(inst)
    if inst._chesterstate:value() ~= ChesterState.NORMAL or not TheWorld.state.isfullmoon then
        return false, false, false
    end

    local container = inst.components.container
    if container == nil or container:IsOpen() then
        return false, false, false
    end

    local canShadow = true
    local canSnow = true
	local canLazy = true

    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item == nil then
            return false, false, false
        end

        canShadow = canShadow and item.prefab == "nightmarefuel"
        canSnow = canSnow and item.prefab == "bluegem"
		canLazy = canLazy and item.prefab == "townportaltalisman"

        if not (canShadow or canSnow or canLazy) then
            return false, false, false
        end
    end

    return canShadow, canSnow, canLazy
end


local function CheckForMorph(inst)
    local canShadow, canSnow, canLazy = CanMorph(inst)
    if canShadow or canSnow or canLazy then
        inst.sg:GoToState("transition")
    end
end

local function DoMorph(inst, fn)
    inst.MorphChester = nil
    inst:StopWatchingWorldState("isfullmoon", CheckForMorph)
    inst:RemoveEventCallback("onclose", CheckForMorph)
    fn(inst)
end

local function MorphChester(inst)
    local canShadow, canSnow, canLazy = CanMorph(inst)
    if not (canShadow or canSnow) then
        return
    end

    local container = inst.components.container
    for i = 1, container:GetNumSlots() do
        container:RemoveItem(container:GetItemInSlot(i)):Remove()
    end

    DoMorph(inst, canShadow and MorphShadowChester or canSnow and MorphSnowChester or canLazy and MorphLazyChester)
end

env.AddPrefabPostInit("chester", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local _OnPreLoad = inst.OnPreLoad

	local function OnPreLoad(inst, data)
		if data == nil then
			return
		elseif data.ChesterState == "LAZY" then
			DoMorph(inst, MorphLazyChester)
		end

		_OnPreLoad(inst, data)
	end

	inst.MorphChester = MorphChester
	inst.OnPreLoad = OnPreLoad
	inst:WatchWorldState("isfullmoon", CheckForMorph)
end)
----------------------------------------------------------------
--Eyebone stuff

env.AddPrefabPostInit("chester_eyebone", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local SPAWN_DIST = 30


	local function OpenEye(inst)
		if not inst.isOpenEye then
			inst.isOpenEye = true
			inst.components.inventoryitem.atlasname = nil
			inst.components.inventoryitem:ChangeImageName(inst.openEye)
			if inst.EyeboneState == "LAZY" then
				inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_closed_lazy.xml"
				inst.components.inventoryitem:ChangeImageName("chester_eyebone_lazy")
			end
			inst.AnimState:PlayAnimation("idle_loop", true)
		end
	end

	local function CloseEye(inst)
		if inst.isOpenEye then
			inst.isOpenEye = nil
			inst.components.inventoryitem.atlasname = nil
			inst.components.inventoryitem:ChangeImageName(inst.closedEye)
			if inst.EyeboneState == "LAZY" then
				inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_lazy.xml"
				inst.components.inventoryitem:ChangeImageName("chester_eyebone_lazy")
			end
			inst.AnimState:PlayAnimation("dead", true)
		end
	end

	local function RefreshEye(inst)
		inst.components.inventoryitem:ChangeImageName(inst.isOpenEye and inst.openEye or inst.closedEye)
	end

	local function MorphLazyEyebone(inst)
		inst.AnimState:SetBuild("chester_eyebone_lazy")
		inst.EyeboneState = "LAZY"
		inst.openEye = "chester_eyebone_lazy"
		inst.closedEye = "chester_eyebone_closed_lazy"

		if inst.respawntime == nil then
			OpenEye(inst)
		else
			CloseEye(inst)
		end
	end

	local function MorphShadowEyebone(inst)
		inst.AnimState:SetBuild("chester_eyebone_shadow_build")

		inst.openEye = "chester_eyebone_shadow"
		inst.closedEye = "chester_eyebone_closed_shadow"
		RefreshEye(inst)

		inst.EyeboneState = "SHADOW"
	end

	local function MorphSnowEyebone(inst)
		inst.AnimState:SetBuild("chester_eyebone_snow_build")

		inst.openEye = "chester_eyebone_snow"
		inst.closedEye = "chester_eyebone_closed_snow"
		RefreshEye(inst)

		inst.EyeboneState = "SNOW"
	end

	local _OnLoad = inst.OnLoad

	local function OnLoadBoneUM(inst, data)
		if data == nil then
			return
		end

		if data.EyeboneState == "LAZY" then
			MorphLazyEyebone(inst)
		end

		_OnLoad(inst, data)
	end

	inst.MorphLazyEyebone = MorphLazyEyebone
	inst.OnLoad = OnLoadBoneUM
end)
