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
    inst:RemoveComponent("channelable")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function TryPerish(item)
    if item:IsInLimbo() then
        local owner = item.components.inventoryitem ~= nil and item.components.inventoryitem.owner or nil
        if owner == nil or
            (owner.components.container ~= nil and
                owner:HasTag("air_conditioner")) then
            --in limbo but not inventory or container?
            --or in a closed chest
            if item.components.perishable:GetPercent() >= 0.5 then
                item.components.perishable:ReducePercent(TUNING.TOADSTOOL_SPORECLOUD_ROT)
            end
        end
    end
    --[[
	if item.components.perishable:GetPercent() >= 0.5 then
		item.components.perishable:ReducePercent(TUNING.TOADSTOOL_SPORECLOUD_ROT)
	end
	--]]
end

local function TryPuff(player, inst)
    if inst.components.container ~= nil then
        local bluecaps = #inst.components.container:FindItems(function(item) return item:HasTag("blue_mushroom_fuel") end)
        local redcaps = #inst.components.container:FindItems(function(item) return item:HasTag("red_mushroom_fuel") end)
        local greencaps = #inst.components.container:FindItems(function(item) return item:HasTag("green_mushroom_fuel") end)

        if not player:IsInLimbo() then
            if bluecaps > 0 then
                if player:HasTag("plantkin") then
                    player.components.health:DoDelta(bluecaps * 0.4 * 0.8)
                else
                    player.components.health:DoDelta(bluecaps * 0.4)
                end
            end

            if greencaps > 0 then
                player.components.sanity:DoDelta(greencaps * 0.4)
            end

            if redcaps > 0 and player.components.hayfever ~= nil and player.components.hayfever.nextsneeze < 240 then
                player.components.hayfever:SetNextSneezeTime(player.components.hayfever.nextsneeze + redcaps * 3)
            end

            return
        end
    end

    local sporepuff = SpawnPrefab("air_conditioner_smoke")
    sporepuff.Transform:SetPosition(x, 4, z)
    if bluecaps ~= nil or redcaps ~= nil or greencaps ~= nil then
        local r = redcaps * 0.10 or 0.05
        local g = greencaps * 0.10 or 0.05
        local b = bluecaps * 0.10 or 0.05

        sporepuff.AnimState:SetMultColour(r, g, b, 0.5)
        sporepuff.Light:SetColour(r * 255, g * 255, b * 255)
    elseif bluecaps == 0 and redcaps == 0 and greencaps == 0 then
        sporepuff.AnimState:SetMultColour(0, 0, 0, 0)
    end
end

local function SmokePuff(inst, channeler)
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.components.container ~= nil then
        local bluecaps = inst.components.container:FindItems(function(item) return item:HasTag("blue_mushroom_fuel") end)
        local redcaps = inst.components.container:FindItems(function(item) return item:HasTag("red_mushroom_fuel") end)
        local greencaps = inst.components.container:FindItems(function(item) return item:HasTag("green_mushroom_fuel") end)

        local numbluecaps = #bluecaps
        local numredcaps = #redcaps
        local numgreencaps = #greencaps

        local blue = numbluecaps * 0.15 or 0.05
        local red = numredcaps * 0.15 or 0.05
        local green = numgreencaps * 0.15 or 0.05

        if red > 0 or blue > 0 or green > 0 then
            local sporepuff = SpawnPrefab("air_conditioner_smoke")
            sporepuff.Transform:SetPosition(x, 4, z)
            sporepuff.AnimState:SetMultColour(red, green, blue, 0.2)

            local air_conditioner_cloud = SpawnPrefab("air_conditioner_cloud")

            if channeler ~= nil and channeler:IsValid() then
                air_conditioner_cloud.Transform:SetPosition(channeler.Transform:GetWorldPosition())
            else
                air_conditioner_cloud.Transform:SetPosition(x + math.random(-10, 10), 0, z + math.random(-10, 10))
            end

            air_conditioner_cloud.AnimState:SetMultColour(red, green, blue, 0.2)
            air_conditioner_cloud.red = numredcaps
            air_conditioner_cloud.blue = numbluecaps
            air_conditioner_cloud.green = numgreencaps
        end
        for i, v in ipairs(bluecaps) do
            if v.components.perishable:GetPercent() <= 0.2 then
                v.components.perishable:Perish()
            else
                v.components.perishable:ReducePercent(0.2)
            end
        end

        for i, v in ipairs(redcaps) do
            if v.components.perishable:GetPercent() <= 0.2 then
                v.components.perishable:Perish()
            else
                v.components.perishable:ReducePercent(0.2)
            end
        end

        for i, v in ipairs(greencaps) do
            if v.components.perishable:GetPercent() <= 0.2 then
                v.components.perishable:Perish()
            else
                v.components.perishable:ReducePercent(0.2)
            end
        end
    end
end

local function OnCooldown(inst)
    inst._cdtask = nil
end

local function DoPuff(inst, channeler)
    if inst._cdtask == nil and inst.components.container ~= nil then
        inst._cdtask = inst:DoTaskInTime(1, OnCooldown)

        inst.channeler = channeler

        local bluecaps = inst.components.container:FindItems(function(item) return item:HasTag("blue_mushroom_fuel") and not item:HasTag("mushed_room") end)
        local redcaps = inst.components.container:FindItems(function(item) return item:HasTag("red_mushroom_fuel") and not item:HasTag("mushed_room") end)
        local greencaps = inst.components.container:FindItems(function(item) return item:HasTag("green_mushroom_fuel") and not item:HasTag("mushed_room") end)

        for i, v in ipairs(bluecaps) do
            v.components.perishable:SetOnPerishFn(nil)
            v.components.perishable.onperishreplacement = "blue_mushed_room"
            v:DoTaskInTime(0, function(v) v.components.perishable:Perish() end)
        end

        for i, v in ipairs(redcaps) do
            v.components.perishable:SetOnPerishFn(nil)
            v.components.perishable.onperishreplacement = "red_mushed_room"
            v:DoTaskInTime(0, function(v) v.components.perishable:Perish() end)
        end

        for i, v in ipairs(greencaps) do
            v.components.perishable:SetOnPerishFn(nil)
            v.components.perishable.onperishreplacement = "green_mushed_room"
            v:DoTaskInTime(0, function(v) v.components.perishable:Perish() end)
        end

        inst:DoTaskInTime(0.2, function()
            SmokePuff(inst, channeler)
        end)

        --[[local x, y, z = inst.Transform:GetWorldPosition()
		
		SpawnPrefab("pollenmites").Transform:SetPosition((x + math.random(-10, 10)), y, (z + math.random(-10, 10)))
		
		local ents = TheSim:FindEntities(x, y, z, 20, nil, nil, { "player" })
		for i, v in ipairs(ents) do
			TryPuff(v, inst)
		end
		
		local ents2 = TheSim:FindEntities(x, y, z, 1, nil, nil, { "mushroom_fuel" })
		for i, k in ipairs(ents2) do
			TryPerish(k)
		end]]

        inst:_PlayAnimation("idle_fueled")
    end

    inst.components.channelable:StopChanneling(true)
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

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnStopChanneling(inst)
    if inst.channeler ~= nil then
        --inst.channeler.sg:GoToState("idle")
    end
    inst.channeler = nil
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
    inst.MiniMapEntity:SetIcon("air_conditioner_map.tex")

    inst.AnimState:SetBank("airconditioner")
    inst.AnimState:SetBuild("airconditioner")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("air_conditioner")
    inst:AddTag("structure")
    inst:AddTag("chest")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            if inst.replica.container ~= nil then
                inst.replica.container:WidgetSetup("air_conditioner")
            end
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

    if TUNING.DSTU.AC_COOLING then
        inst:AddComponent("heater")
        inst.components.heater.heat = -115
        inst.components.heater:SetThermics(false, true)

        inst:DoPeriodicTask(1, function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local smog = TheSim:FindEntities(x, y, z, 20, { "smog" }, { "INLIMBO" })
            for k, v in pairs(smog) do
                v:Remove()
            end
        end)
    end
    inst:AddComponent("channelable")
    inst.components.channelable:SetChannelingFn(DoPuff, OnStopChanneling)
    inst.components.channelable.use_channel_longaction_noloop = true
    --inst.components.channelable.skip_state_stopchanneling = true
    inst.components.channelable.skip_state_channeling = true
    --inst.components.channelable.ignore_prechannel = true

    inst:ListenForEvent("onbuilt", onbuilt)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst:ListenForEvent("burntup", makeburnt)

    MakeHauntableWork(inst)

    inst._PlayAnimation = Default_PlayAnimation
    inst._PushAnimation = Default_PushAnimation

    return inst
end

local function perishfn(inst)
    inst:Remove()
end

local function MakeMushy(name, color)
    local function shrumfn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        local truecolor = (color)

        inst:AddTag("mushed_room")
        inst:AddTag("mushroom_fuel")
        inst:AddTag(truecolor .. "_mushroom_fuel")
        inst:AddTag("show_spoilage")

        inst.AnimState:SetBank("snapdragon_fertilizer")
        inst.AnimState:SetBuild("snapdragon_fertilizer")

        inst.AnimState:PlayAnimation("idle_" .. truecolor)

        MakeInventoryFloatable(inst)
        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/" .. truecolor .. "_mushed_room.xml"

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.perishfn = perishfn

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end

    return Prefab(name, shrumfn, assets, prefabs)
end

return Prefab("air_conditioner", fn, assets, prefabs),
    MakePlacer("air_conditioner_placer", "airconditioner", "airconditioner", "idle"),
    MakeMushy("blue_mushed_room", "blue"),
    MakeMushy("red_mushed_room", "red"),
    MakeMushy("green_mushed_room", "green")
