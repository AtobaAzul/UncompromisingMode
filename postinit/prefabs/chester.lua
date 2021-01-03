local env = env
GLOBAL.setfenv(1, GLOBAL)
--Have to re-include the functions
local function MorphShadowChester(inst)
    inst.AnimState:SetBuild("chester_shadow_build")
    inst:AddTag("spoiler")
    inst.MiniMapEntity:SetIcon("chestershadow.png")
    inst.components.maprevealable:SetIcon("chestershadow.png")

    inst.components.container:WidgetSetup("shadowchester")

    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphShadowEyebone()
    end

    inst.ChesterState = "SHADOW"
    inst._isshadowchester:set(true)
end

local function MorphSnowChester(inst)
    inst.AnimState:SetBuild("chester_snow_build")
    inst:AddTag("fridge")
    inst.MiniMapEntity:SetIcon("chestersnow.png")
    inst.components.maprevealable:SetIcon("chestersnow.png")

    local leader = inst.components.follower.leader
    if leader ~= nil then
        inst.components.follower.leader:MorphSnowEyebone()
    end

    inst.ChesterState = "SNOW"
    inst._isshadowchester:set(false)
end
--Have to re-include the functions

local CHESTER_PICKUP_MUST_TAGS = { "_inventoryitem"}
local CHESTER_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive", "chester_eyebone" }
local function pickup_UM(inst)
    if inst == nil or inst.components.container == nil then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 1.5*TUNING.ORANGEAMULET_RANGE, nil, CHESTER_PICKUP_CANT_TAGS, CHESTER_PICKUP_MUST_TAGS)
    for i, v in ipairs(ents) do
        if v.components.inventoryitem ~= nil and                                 --Inventory stuff
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
    inst.ChesterState = "LAZY"
    inst._isshadowchester:set(false)
end


local function CanMorph(inst)
    if inst.ChesterState ~= "NORMAL" or not TheWorld.state.isfullmoon then
        return false, false
    end

    local container = inst.components.container
    if container:IsOpen() then
        return false, false
    end

    local canShadow = true
    local canSnow = true
	local canLazy = true

    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item == nil then
            return false, false
        end

        canShadow = canShadow and item.prefab == "nightmarefuel"
        canSnow = canSnow and item.prefab == "bluegem"
		canLazy = canLazy and item.prefab == "townportaltalisman"
		
        if not (canShadow or canSnow or canLazy) then
            return false, false
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

local function MorphChesterUM(inst)
    local canShadow, canSnow, canLazy = CanMorph(inst)
    if not (canShadow or canSnow or canLazy) then
        return
    end

    local container = inst.components.container
    for i = 1, container:GetNumSlots() do
        container:RemoveItem(container:GetItemInSlot(i)):Remove()
    end

    DoMorph(inst, (canShadow and MorphShadowChester) or (canSnow and MorphSnowChester) or (canLazy and MorphLazyChester))
end

local function OnPreLoad2(inst, data)
    if data == nil then
        return
    elseif data.ChesterState == "SHADOW" then
        DoMorph(inst, MorphShadowChester)
    elseif data.ChesterState == "SNOW" then
        DoMorph(inst, MorphSnowChester)
    elseif data.ChesterState == "LAZY" then
        DoMorph(inst, MorphLazyChester)
    end
end

env.AddPrefabPostInit("chester", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
    inst.MorphChester = MorphChesterUM
	inst.OnPreLoad = OnPreLoad2
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
        inst.components.inventoryitem:ChangeImageName(nil)
		--duct tape fix
		if inst.EyeboneState == "LAZY" then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_closed_lazy.xml"		
		end
		--duct tape fix
        inst.AnimState:PlayAnimation("idle_loop", true)
    end
end

local function CloseEye(inst)
    if inst.isOpenEye then
        inst.isOpenEye = nil
        inst.components.inventoryitem:ChangeImageName(nil)
		--duct tape fix
		if inst.EyeboneState == "LAZY" then
		inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_lazy.xml"		
		end
		--duct tape fix
        inst.AnimState:PlayAnimation("dead", true)
    end
end
local function RefreshEye(inst)
    inst.components.inventoryitem:ChangeImageName(inst.isOpenEye and inst.openEye or inst.closedEye)
end
local function MorphLazyEyebone(inst)
    inst.AnimState:SetBuild("chester_eyebone_lazy")

    --inst.openEye = "chester_eyebone_lazy"
    --inst.closedEye = "chester_eyebone_closed_lazy"
    RefreshEye(inst)

    inst.EyeboneState = "LAZY"
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
local function OnLoadBoneUM(inst, data)
    if data == nil then
        return
    end

    if data.EyeboneState == "SHADOW" then
        MorphShadowEyebone(inst)
    elseif data.EyeboneState == "SNOW" then
        MorphSnowEyebone(inst)
	elseif data.EyeboneState == "LAZY" then
        MorphLazyEyebone(inst)
    end

    if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining + GetTime()
    else
        OpenEye(inst)
    end
end

	inst.MorphLazyEyebone = MorphLazyEyebone
    inst.OnLoad = OnLoadBoneUM
end)