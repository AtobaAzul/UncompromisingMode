AddAction("LAVASPIT", "LAVASPIT", function(act)
    if act.doer and act.target and act.doer.prefab == "dragonfly" then
        local spit = SpawnPrefab("lavaspit")
        local x, y, z = act.doer.Transform:GetWorldPosition()
        local downvec = TheCamera:GetDownVec()
        local offsetangle = math.atan2(downvec.z, downvec.x) * (180 / math.pi)
        if act.doer.AnimState:GetCurrentFacing() == 0 then -- Facing right
            offsetangle = offsetangle + 70
        else                                               -- Facing left
            offsetangle = offsetangle - 70
        end
        while offsetangle > 180 do offsetangle = offsetangle - 360 end
        while offsetangle < -180 do offsetangle = offsetangle + 360 end
        local offsetvec = Vector3(math.cos(offsetangle * DEGREES), -.3, math.sin(offsetangle * DEGREES)) * 1.7
        spit.Transform:SetPosition(x + offsetvec.x, y + offsetvec.y, z + offsetvec.z)
        spit.Transform:SetRotation(act.doer.Transform:GetRotation())
    end
end)

AddAction("INFEST", "INFEST", function(act)
    if not act.doer.infesting then act.doer.components.infester:Infest(act.target) end

    return true
end)

AddAction("UNCOMPROMISING_PAWN_HIDE", "UNCOMPROMISING_PAWN_HIDE", function(act)
    -- Dummy action for pawn.
end)

AddAction("UNCOMPROMISING_PAWN_SHAKE", "UNCOMPROMISING_PAWN_SHAKE", function(act)
    -- Dummy action for pawn.
end)

AddAction("RAT_STEAL_EQUIPPABLE", "RAT_STEAL_EQUIPPABLE", function(act)
    if act.target.components.container then
        act.target.components.container:DropOneItemWithTag("_equippable")
        return true
    end
end)
AddAction("RAT_STEAL_GEM", "RAT_STEAL_GEM", function(act)
    if act.target.components.container then
        act.target.components.container:DropOneItemWithTag("gem")
        return true
    end
end)

AddAction("CASTLIGHTER", "CASTLIGHTER", function(act)
    local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
    local act_pos = act:GetActionPoint()
    if staff and staff:HasTag("lighter") and staff.components.spellcaster and staff.components.spellcaster:CanCast(act.doer, act.target, act_pos) then
        staff.components.spellcaster:CastSpell(act.target, act_pos)
        return true
    end
end)

AddAction("WINGSUIT", "WINGSUIT", function(act)
    local staff = act.invobject or act.doer.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
    local act_pos = act:GetActionPoint()
    if staff and staff.components.spellcaster and staff.components.spellcaster:CanCast(act.doer, act.target, act_pos) then
        staff.components.spellcaster:CastSpell(act.target, act_pos)
        return true
    end
end)

local createburrow = AddAction("CREATE_BURROW", GLOBAL.STRINGS.ACTIONS.CREATE_BURROW, function(act)
    local act_pos = act:GetActionPoint()
    if act.doer.components.hunger.current > 15 and not GLOBAL.TheWorld.Map:GetPlatformAtPoint(act_pos.x, act_pos.z) then
        local burrows = GLOBAL.TheSim:FindEntities(act_pos.x, 0, act_pos.z, 10000, { "winkyburrow" })
        local home = false

        for i, v in pairs(burrows) do if v.myowner == act.doer.userid then home = true end end

        if home then
            local burrow = GLOBAL.SpawnPrefab("uncompromising_winkyburrow")
            burrow.Transform:SetPosition(act_pos.x, 0, act_pos.z)
            act.doer.components.hunger:DoDelta(-15)
        else
            local burrow = GLOBAL.SpawnPrefab("uncompromising_winkyhomeburrow")
            burrow.Transform:SetPosition(act_pos.x, 0, act_pos.z)
            burrow.myowner = act.doer.userid

            act.doer.components.hunger:DoDelta(-20)
        end

        return true
    end
end)

createburrow.priority = HIGH_ACTION_PRIORITY
createburrow.rmb = true
createburrow.distance = 2
createburrow.mount_valid = false

local charge_powercell = AddAction("CHARGE_POWERCELL", GLOBAL.STRINGS.ACTIONS.CHARGE_POWERCELL, function(act)
    local target = act.target or act.invobject

    if (target ~= nil and target:HasTag("powercell")) and (act.doer ~= nil and act.doer:HasTag("batteryuser")) then
        act.doer.components.batteryuser:ChargeFrom(target)
        return true
    else
        return false
    end
end)

charge_powercell.instant = true
charge_powercell.rmb = true
charge_powercell.priority = HIGH_ACTION_PRIORITY

if TUNING.DSTU.WICKERNERF then
    local _ReadFn = GLOBAL.ACTIONS.READ.fn

    GLOBAL.ACTIONS.READ.fn = function(act)
        local targ = act.target or act.invobject
        if targ ~= nil and act.doer ~= nil and not act.doer:HasTag("aspiring_bookworm") then if targ.components.book ~= nil and act.doer.components.reader ~= nil and act.doer.components.sanity ~= nil and act.doer.components.sanity:IsInsane() then return false end end

        return _ReadFn(act)
    end
end

local _UpgradeStrFn = GLOBAL.ACTIONS.UPGRADE.strfn

GLOBAL.ACTIONS.UPGRADE.strfn = function(act)
    if act.target ~= nil and act.target:HasTag(GLOBAL.UPGRADETYPES.SLUDGE_CORK .. "_upgradeable") then return "SLUDGE_CORK" end
    return _UpgradeStrFn(act)
end

local _AddFuelFn = GLOBAL.ACTIONS.ADDFUEL.fn
local _AddWetFuelFn = GLOBAL.ACTIONS.ADDWETFUEL.fn

GLOBAL.ACTIONS.ADDFUEL.fn = function(act)
    if act.doer.components.inventory and act.invobject.components.finiteuses ~= nil and act.invobject:HasTag("sludge_oil") then
        local fuel = act.invobject
        if fuel then
            if act.target.components.fueled and act.target.components.fueled:TakeFuelItem(fuel, act.doer) then
                return true
            else
                act.doer.components.inventory:GiveItem(fuel)
            end
        end
    else
        return _AddFuelFn(act)
    end
end

GLOBAL.ACTIONS.ADDWETFUEL.fn = function(act) -- I'M GOING TO ***BOMB KLEI*** WHY THE *FUCK* IS WETFUEL IT'S OWN ACTION.
    if act.doer.components.inventory and act.invobject.components.finiteuses ~= nil and act.invobject:HasTag("sludge_oil") then
        local fuel = act.invobject
        if fuel then
            if act.target.components.fueled and act.target.components.fueled:TakeFuelItem(fuel, act.doer) then
                return true
            else
                act.doer.components.inventory:GiveItem(fuel)
            end
        end
    else
        return _AddWetFuelFn(act)
    end
end

local _UseSpellBookStrFn = GLOBAL.ACTIONS.USESPELLBOOK.strfn

GLOBAL.ACTIONS.USESPELLBOOK.strfn = function(act)
    local target = act.invobject or act.target
    return target:HasTag("telestaff") and "TELESTAFF" or _UseSpellBookStrFn ~= nil and _UseSpellBookStrFn(act) or "BOOK"
end

local SET_CUSTOM_NAME = GLOBAL.Action({ distance = 2, mount_valid = true })
SET_CUSTOM_NAME.id = "SET_CUSTOM_NAME"
SET_CUSTOM_NAME.str = STRINGS.ACTIONS.SET_CUSTOM_NAME
AddAction(SET_CUSTOM_NAME)

SET_CUSTOM_NAME.fn = function(act)
    local focus = nil
    if act.target and act.target:HasTag("telebase") or act.target.prefab == "pocketwatch_portal" or act.target.prefab == "pocketwatch_recall" --[[or act.target:HasTag("_equippable")]] then focus = act.target end

    if focus and focus.components.writeable then
        if focus.components.writeable:IsBeingWritten() then return false, "INUSE" end

        act.doer.tool_prefab = act.invobject.prefab
        if act.invobject.components.stackable then
            act.invobject.components.stackable:Get():Remove()
        else
            act.invobject:Remove()
        end

        focus.components.writeable:BeginWriting(act.doer)

        return true
    end
end

GLOBAL.ACTIONS.CHANGEIN.rmb = true
GLOBAL.ACTIONS.CHANGEIN.priority = 10

GLOBAL.ACTIONS.REPAIR.distance = 2.5

AddComponentAction("USEITEM", "drawingtool", function(inst, doer, target, actions, right) if target:HasTag("telebase") or target.prefab == "pocketwatch_recall" or target.prefab == "pocketwatch_portal" then table.insert(actions, GLOBAL.ACTIONS.SET_CUSTOM_NAME) end end)
if TUNING.DSTU.WARLY_BUTCHER then
    local _murderfn = GLOBAL.ACTIONS.MURDER.fn
    GLOBAL.ACTIONS.MURDER.fn = function(act)
        local murdered = act.invobject or act.target
        if murdered ~= nil and (murdered.components.health ~= nil or murdered.components.murderable ~= nil) and act.doer ~= nil and act.doer:HasTag("masterchef") then
            local stacksize = murdered.components.stackable ~= nil and murdered.components.stackable:StackSize() or 1
            local x, y, z = act.doer.Transform:GetWorldPosition()

            if murdered.components.lootdropper ~= nil then
                murdered.causeofdeath = act.doer
                local pos = GLOBAL.Vector3(x, y, z)
                for i = 1, stacksize do
                    local loots = murdered.components.lootdropper:GenerateLoot()
                    local lootprefab = loots[#loots > 1 and math.random(#loots) or 1]

                    if lootprefab ~= nil then
                        local loot = GLOBAL.SpawnPrefab(lootprefab)
                        if loot ~= nil then
                            act.doer.components.inventory:GiveItem(loot, nil, pos)
                        end
                    end
                end
            end

            if murdered.components.inventory and murdered:HasTag("drop_inventory_onmurder") then
                murdered.components.inventory:TransferInventory(act.doer)
            end
        end
        return _murderfn(act)
    end
end

GLOBAL.STRINGS.ACTIONS.START_CHANNELCAST.MOONFALL = "Start Casting"

local _Start_ChannelCastStrFn = GLOBAL.ACTIONS.START_CHANNELCAST.strfn
GLOBAL.ACTIONS.START_CHANNELCAST.strfn = function(act)
    return act.invobject and act.invobject:HasTag("moonfallstaff") and "MOONFALL" or _Start_ChannelCastStrFn(act)
end


AddComponentAction("USEITEM", "fuel", function(inst, doer, target, actions)
    if not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        or (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
        if inst.prefab ~= "spoiled_food" and
            inst:HasTag("quagmire_stewable") and
            target:HasTag("quagmire_stewer") and
            target.replica.container ~= nil and
            target.replica.container:IsOpenedBy(doer) then
            return
        end

        if inst:HasTag("SLUDGE_fuel") and (target:HasTag("BURNABLE_fueled") or target:HasTag("CHEMICAL_fueled") or target:HasTag("CAVE_fueled")) then
            table.insert(actions, inst:GetIsWet() and GLOBAL.ACTIONS.ADDWETFUEL or GLOBAL.ACTIONS.ADDFUEL)
        end
    end
end)
