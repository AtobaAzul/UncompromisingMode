-- Pickup function from Lazy Forager
local CHESTER_PICKUP_MUST_TAGS = { "_inventoryitem"}
local CHESTER_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", "catchable", "fire", "minesprung", "mineactive", "chester_eyebone" }
local function Pickup(inst)
    if inst == nil or inst.components.container == nil then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = GLOBAL.TheSim:FindEntities(x, y, z, 1.5 * GLOBAL.TUNING.ORANGEAMULET_RANGE, nil, CHESTER_PICKUP_CANT_TAGS, CHESTER_PICKUP_MUST_TAGS)
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
							if not other_item.components.stackable:IsFull() then
							--Amulet will only ever pick up items one at a time. Even from stacks.
							GLOBAL.SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
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
								GLOBAL.SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
			
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

--------------------------------------------------

local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

-- Chester --
AddPrefabPostInit("chester", function(inst)
    local _CheckForMorph = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.chester.fn, "CheckForMorph")
    local _DoMorph = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.chester.fn, "MorphChester", "DoMorph")
    local _MorphChester = inst.MorphChester
    local _OnPreLoad = inst.OnPreLoad

    local function CanMorphLazy(inst)
        if inst.ChesterState ~= "NORMAL" or not GLOBAL.TheWorld.state.isfullmoon then
            return false
        end

        local container = inst.components.container
        local canLazy = true

        if container:IsOpen() then
            return false
        end

        for i = 1, container:GetNumSlots() do
            local item = container:GetItemInSlot(i)
            if not (item and item.prefab == "townportaltalisman") then
                canLazy = false
                break
            end
        end

        return canLazy
    end

    local function CheckForMorph(inst)
        if CanMorphLazy(inst) then
            inst.sg:GoToState("transition")
        else
            _CheckForMorph(inst)
        end
    end
    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.chester.fn, CheckForMorph, "CheckForMorph")
            
    local function MorphLazyChester(inst)
        inst.AnimState:SetBuild("lazy_chester")

        inst.MiniMapEntity:SetIcon("lazychester_minimap.tex")
        inst.components.maprevealable:SetIcon("lazychester_minimap.tex")

        local leader = inst.components.follower.leader
        if leader ~= nil then
            inst.components.follower.leader:MorphLazyEyebone()
        end
        inst.task = inst:DoPeriodicTask(GLOBAL.TUNING.ORANGEAMULET_ICD, Pickup, nil, inst)
        inst.ChesterState = "LAZY"
        inst._isshadowchester:set(false)
    end

    local function MorphChester(inst)
        if CanMorphLazy(inst) then
            local container = inst.components.container
            for i = 1, container:GetNumSlots() do
                container:RemoveItem(container:GetItemInSlot(i)):Remove()
            end
            _DoMorph(inst, MorphLazyChester)
        else
            _MorphChester(inst)
        end
    end

    local function OnPreLoad(inst, data)
        if data == nil then return end
            
        if data.ChesterState == "LAZY" then
            _DoMorph(inst, MorphLazyChester)
        else
            _OnPreLoad(inst, data)
        end
    end

    inst.MorphChester = MorphChester
    inst.OnPreLoad = OnPreLoad
end)


-- Chester's Eyebone --
AddPrefabPostInit("chester_eyebone", function(inst)
    local _RefreshEye = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.chester_eyebone.fn, "MorphShadowEyebone", "RefreshEye")
    local _StartRespawn = UpvalueHacker.GetUpvalue(GLOBAL.Prefabs.chester_eyebone.fn, "FixChester", "StartRespawn")
    local _OnLoad = inst.OnLoad

    local function ResetEyebone(inst)
        inst.AnimState:SetBuild("chester_eyebone_build")
        inst.components.inventoryitem.imagename = "chester_eyebone_closed"
        inst.components.inventoryitem.atlasname = nil
        inst.openEye = "chester_eyebone"
        inst.closedEye = "chester_eyebone_closed"
        inst.EyeboneState = "NORMAL"
    end

    local function MorphLazyEyebone(inst)
        inst.AnimState:SetBuild("chester_eyebone_lazy")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_lazy.xml"

        inst.openEye = "chester_eyebone_lazy"
        inst.closedEye = "chester_eyebone_closed_lazy"
        _RefreshEye(inst)

        inst.EyeboneState = "LAZY"
    end
        
    local function StartRespawn(inst, time)
        _StartRespawn(inst, time)
        ResetEyebone(inst)
    end

    local function OnLoad(inst, data)
        if data == nil then return end

        if data.EyeboneState == "LAZY" then
            MorphLazyEyebone(inst)
            inst.components.inventoryitem.atlasname = "images/inventoryimages/chester_eyebone_lazy.xml"
        else
            inst.components.inventoryitem.imagename = nil
            inst.components.inventoryitem.atlasname = nil
        end

        _OnLoad(inst, data)
    end

    UpvalueHacker.SetUpvalue(GLOBAL.Prefabs.chester_eyebone.fn, StartRespawn, "FixChester", "StartRespawn")
	inst.MorphLazyEyebone = MorphLazyEyebone
    inst.OnLoad = OnLoad
end)
