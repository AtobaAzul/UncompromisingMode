local assets =
{
    Asset("ANIM", "anim/wixie_clock.zip"),
    Asset("ANIM", "anim/wixie_clock_hands.zip"),
    Asset("ANIM", "anim/wixie_dangley.zip"),
    Asset("ANIM", "anim/wooden_queen_piece.zip"),
}

local prefabs =
{
}

local function InitializeClockPieces(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    inst.second = SpawnPrefab("wixie_clockhand_second")
    inst.minute = SpawnPrefab("wixie_clockhand_minute")
    inst.hour = SpawnPrefab("wixie_clockhand_hour")

    inst.seconddangle = SpawnPrefab("wixie_clockdangley1")
    inst.seconddangle.host = inst
    inst.minutedangle = SpawnPrefab("wixie_clockdangley2")
    inst.minutedangle.host = inst
    inst.hourdangle = SpawnPrefab("wixie_clockdangley3")
    inst.hourdangle.host = inst

    inst.front = SpawnPrefab("wixie_clockfront")

    inst.front.Transform:SetPosition(x, y - 0.1, z)

    inst.second.entity:SetParent(inst.entity)
    inst.second.Transform:SetPosition(0, 0, 0)
    inst.entity:AddFollower()

    inst.minute.entity:SetParent(inst.entity)
    inst.minute.Transform:SetPosition(0, 0, 0)
    inst.entity:AddFollower()

    inst.hour.entity:SetParent(inst.entity)
    inst.hour.Transform:SetPosition(0, 0, 0)
    inst.entity:AddFollower()

    --inst.seconddangle.entity:SetParent(inst.entity)
    inst.seconddangle.Transform:SetPosition(x, y - 0.06, z)
    inst.seconddangle.myhand = inst.second

    --inst.minutedangle.entity:SetParent(inst.entity)
    inst.minutedangle.Transform:SetPosition(x, y - 0.06, z)
    inst.minutedangle.myhand = inst.minute

    --inst.hourdangle.entity:SetParent(inst.entity)
    inst.hourdangle.Transform:SetPosition(x, y - 0.06, z)
    inst.hourdangle.myhand = inst.hour
end

local function OnActivate_Clock(inst, doer)
    if inst.hourdangle ~= nil and inst.seconddangle ~= nil and inst.minutedangle ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local nearbyplayers = TheSim:FindEntities(x, y, z, 30, { "player" })

        if inst.final_code_ready and inst.hourdangle.count == 12 and inst.minutedangle.count == 2 and inst.seconddangle.count == 7 then
            if nearbyplayers ~= nil and #nearbyplayers == #AllPlayers or not TUNING.DSTU.ALL_MUST_BE_GATHERED  then
                inst.canbeused = false
                --print("ding dong the witch is dead")
                for i = 1, 8 do
                    inst:DoTaskInTime((i * 3) - 3, function()
                        local dusktime = 16 - ((i - 1) * 2)

                        local nighttime = ((i - 1) * 2)

                        local spawn = TheSim:FindFirstEntityWithTag("wixie_wardrobe")

                        if i == 8 then
                            spawn:PushEvent("spawn_shadow_wix")
                            TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = 0, night = 16 })
                        else
                            spawn:PushEvent("wixie_wardrobe_shutter")
                            TheWorld:PushEvent("ms_setclocksegs", { day = 0, dusk = dusktime, night = nighttime })
                        end

                        local sound = 9 - i

                        inst.SoundEmitter:PlaySound("UCSounds/wixie_clock/" .. sound)
                    end)
                end

                inst.final_code_ready = false

                inst.components.timer:StartTimer("reset_use", 9600)

                TheNet:SystemMessage("The time has come...")
            else
                TheNet:SystemMessage("All must be gathered before you can proceed...")
            end
        elseif inst.hourdangle.count == 10 and inst.minutedangle.count == 9 and inst.seconddangle.count == 1 then
            print("SpawnKey")
            local papyrus = SpawnPrefab("wixie_piano_card")
            papyrus.Transform:SetPosition(inst.Transform:GetWorldPosition())
            papyrus.name = "Tempus sit amet"
            Launch2(papyrus, inst, 2, 0, 1, .5)
        elseif inst.hourdangle.count == 1 and inst.minutedangle.count == 5 and inst.seconddangle.count == 8 then
            local piece = SpawnPrefab("wooden_queen_piece")
            piece.Transform:SetPosition(inst.Transform:GetWorldPosition())
            piece:AddTag("puzzlespawn")
            local launch_target = doer ~= nil and doer or inst

            Launch2(piece, launch_target, 2, 0, 1, .5)
        else
            if doer ~= nil and doer.components.sanity ~= nil then
                doer.components.sanity:DoDelta(-10)
            end

            inst.SoundEmitter:PlaySound("dontstarve/common/chesspile_repair")
        end
    end

    inst.SoundEmitter:KillSound("ticking_clock")
end

local function MakeUsable(inst)
    if TheWorld.state.isday and inst.canbeused then
        inst.components.activatable.inactive = true

        inst.SoundEmitter:PlaySound("UCSounds/wixie_clock/ticking_clock", "ticking_clock")

        inst:DoTaskInTime(13, function(inst)
            inst.components.activatable.inactive = false

            inst.SoundEmitter:KillSound("ticking_clock")
        end)
    end
end

local function TimerDone(inst, data)
    if data.name == "reset_use" then
        inst.canbeused = true
    end
end

local function OnSave(inst, data)
    if inst.canbeused ~= nil then
        data.canbeused = inst.canbeused
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.canbeused ~= nil then
        inst.canbeused = data.canbeused
    end
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

    inst.AnimState:SetBuild("wixie_clock")
    inst.AnimState:SetBank("wixie_clock")
    inst.AnimState:PlayAnimation("idle", true)

    --MakeObstaclePhysics(inst, .2)
    inst:AddTag("wixie_clock")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.repaired = false
    inst.canbeused = true
    inst.final_code_ready = false

    inst:AddComponent("inspectable")

    inst:DoTaskInTime(1, InitializeClockPieces)

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate_Clock
    inst.components.activatable.inactive = false
    inst.components.activatable.quickaction = true

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", TimerDone)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.MakeUsable = MakeUsable

    inst:WatchWorldState("isday", MakeUsable)

    return inst
end

local function fncommon(handtype, startpoint)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_clock_hands")
    inst.AnimState:SetBank("wixie_clock_hands")
    inst.AnimState:PlayAnimation(handtype .. startpoint, false)

    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.handtype = handtype

    inst.persists = false

    return inst
end

local function minfn()
    local inst = fncommon("min", 12)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function secfn()
    local inst = fncommon("sec", 4)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function hourfn()
    local inst = fncommon("hour", 8)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function OnActivate(inst)
    if inst.count >= 12 then
        inst.count = 1
    else
        inst.count = inst.count + 1
    end

    if inst.myhand ~= nil then
        inst.myhand.AnimState:PlayAnimation(inst.myhand.handtype .. inst.count, false)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
    end

    inst.AnimState:SetPercent(inst.dangletype, ((1 / 12) * inst.count))

    inst.components.activatable.inactive = true
end

local function fncommondangle(dangle, startpoint)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_dangley")
    inst.AnimState:SetBank("wixie_dangley")
    inst.AnimState:SetPercent(dangle, ((1 / 12) * startpoint))

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.dangletype = dangle
    inst.myhand = nil
    inst.count = startpoint

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
    inst.components.activatable.quickaction = true

    inst.persists = false

    return inst
end

local function dangle1fn()
    local inst = fncommondangle("dangley1", 4)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function dangle2fn()
    local inst = fncommondangle("dangley2", 12)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function dangle3fn()
    local inst = fncommondangle("dangley3", 8)

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function frontfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("wixie_clock")
    inst.AnimState:SetBank("wixie_clock")
    inst.AnimState:PlayAnimation("back")

    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

-- Hey look fucker, spoilers, okay???
local function getdesc(inst, viewer)
    return viewer:HasTag("troublemaker") and "Oh, it's one of my moms carvings!\n\"VII\" is engraved on the back." or
        "\"VII\" is engraved on the back."
end

local function queenfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("wooden_queen_piece")
    inst.AnimState:SetBuild("wooden_queen_piece")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.WOOD
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    ---------------------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getspecialdescription = getdesc

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wooden_queen_piece.xml"

    inst:DoTaskInTime(0, function()
        if not inst:HasTag("puzzlespawn") then
            inst:Remove()
        end
    end)

    inst.persists = false

    return inst
end

return Prefab("wixie_clock", fn, assets, prefabs),
    Prefab("wixie_clockhand_minute", minfn, assets, prefabs),
    Prefab("wixie_clockhand_second", secfn, assets, prefabs),
    Prefab("wixie_clockhand_hour", hourfn, assets, prefabs),
    Prefab("wixie_clockdangley1", dangle1fn, assets, prefabs),
    Prefab("wixie_clockdangley2", dangle2fn, assets, prefabs),
    Prefab("wixie_clockdangley3", dangle3fn, assets, prefabs),
    Prefab("wixie_clockfront", frontfn, assets, prefabs),
    Prefab("wooden_queen_piece", queenfn, assets, prefabs)
