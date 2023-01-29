local assets =
{
    Asset("ANIM", "anim/snowpile.zip"),
}

local anims = { "low", "med", "full" }


local function DoColdMenace(inst)
    local snowattack = SpawnPrefab("snowmong")
    local spawnpoint = inst.Transform:GetWorldPosition()
    snowattack.Transform:SetPosition(inst.Transform:GetWorldPosition())
    snowattack.sg:GoToState("enter")
    snowattack.SetTier(snowattack)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst:DoTaskInTime(0.1, function() SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z) end)
    inst:DoTaskInTime(0.2, inst.Remove)
end

local function TryColdMenace(inst)
    if math.random() > 0.9 and (inst.components.workable.workleft > 2 or inst.components.pickable.cycles_left > 2) and
        not inst.mongproof then --This chance could be adjusted or scale vvith time.
        inst:DoColdMenace(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        if math.random() > 0.3 then --Have a good chance of spavvning buddies vvith them.
            local sno = TheSim:FindEntities(x, y, z, 10, { "snowpile" })
            local nummongs = math.random(1, 3)
            for i, pile in ipairs(sno) do
                if nummongs > 0 then
                    nummongs = nummongs - 1
                    pile:DoColdMenace(pile)
                end
            end
        end
        local sno = TheSim:FindEntities(x, y, z, 20, { "snowpile" })
        for i, pile in ipairs(sno) do
            pile.mongproof = true
        end
    end
end

TUNING.SNOW_X_SCALE = 0 + math.random(0.3, 0.5)
TUNING.SNOW_Y_SCALE = 0 + math.random(0.1, 0.3)
TUNING.SNOW_REGROW_TIME = 120
TUNING.SNOW_REGROW_VARIANCE = 80
TUNING.SNOW_DEPLETE_CHANCE = 0.25

local AURA_EXCLUDE_TAGS = {
    "noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible"
}

local INVALID_TILES = table.invert({ GROUND.SCALE })

local startregen


local function FindSpreadSpot(inst, angle)
    local x, y, z = inst.Transform:GetWorldPosition()
    if (not angle) or inst.count > 4 then
        angle = math.random(0, 2 * PI)
    end
    x = x + 4 * math.cos(angle)
    z = z + 4 * math.sin(angle)
    if TheSim:FindEntities(x, y, z, 2, { "snowpile" }) then --Don't vvant to be close to a single pile
        inst.redo = true
    end
    if #TheSim:FindEntities(x, y, z, 3, { "snowpile" }) > 3 then -- Don't vvant to clog the piles all in one location either
        inst.redo = true
    end
    if inst.count > 7 or not inst.redo then -- If vve've been going at it forever... then maybe just return this anyhovv
        return x, y, z, angle
    else
        inst.redo = nil
        inst.count = inst.count + 1
        return FindSpreadSpot(inst, angle)
    end
end

local function SpreadSno(inst)
    inst.count = 0
    inst.redo = nil
    local x, y, z, angle = FindSpreadSpot(inst, inst.angle and inst.angle + math.random(-1, 1) * 0.05 or nil)
    inst.components.workable.workleft = 2
    inst.components.pickable.cycles_left = 2
    inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft])
    local sno = SpawnPrefab("snowpile")
    sno.Transform:SetPosition(x, y, z)
    sno.angle = angle
end

local function onregen(inst)
    local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
    local tile
    if my_x ~= nil and my_y ~= nil and my_z ~= nil then
        tile = TheWorld.Map:GetTileAtPoint(my_x, 0, my_z)
    end
    if TheWorld.state.iswinter and
        not (tile ~= nil and INVALID_TILES[tile]) then -- or ents2 ~= nil and #ents2 < 0 then
        if inst.components.workable.workleft < 3 then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(my_x, 0, my_z)
            inst.components.workable:SetWorkLeft(inst.components.workable.workleft + 1)
            inst.components.pickable.cycles_left = inst.components.pickable.cycles_left + 1
            startregen(inst)
        else
            --SpreadSno(inst)
            --startregen(inst)
        end
    else
        if inst.components.workable.workleft > 1 then
            SpawnPrefab("washashore_puddle_fx").Transform:SetPosition(my_x, 0, my_z)
            inst.components.workable:SetWorkLeft(inst.components.workable.workleft - 1)
            inst.components.pickable.cycles_left = inst.components.pickable.cycles_left - 1
            startregen(inst)
        else
            SpawnPrefab("washashore_puddle_fx").Transform:SetPosition(my_x, 0, my_z)
            inst:Remove()
        end
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local plants = TheSim:FindEntities(x, y, z, 1.5, { "farm_plant" })

    if #plants > 0 then
        for k, v in ipairs(plants) do
            if v.components.farmplantstress ~= nil then
                v.components.farmplantstress:SetStressed("happiness", true, inst)
            end
            if v.components.farmplanttendable ~= nil then
                v.components.farmplanttendable:SetTendable(v.components.growable:GetCurrentStageData().tendable)
            end
        end
    end
end

startregen = function(inst, regentime)
    if inst.components.workable.workleft < #anims + 1 then
        -- more to grow
        -- regentime = regentime or (TUNING.SNOW_REGROW_TIME + math.random()*TUNING.SNOW_REGROW_VARIANCE)

        regentime = regentime or (TUNING.SNOW_REGROW_TIME + math.random() * TUNING.SNOW_REGROW_VARIANCE)

        if TheWorld.state.issnowing or
            ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) then
            regentime = regentime / 2
        elseif TheWorld.state.iswinter and not TheWorld.state.issnowing and
            not
            ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")
            ) then
            regentime = regentime
        else
            regentime = regentime / 2
        end

        if inst.task then inst.task:Cancel() end
        inst.task = inst:DoTaskInTime(regentime, onregen, "regen")
        inst.targettime = GetTime() + regentime
        --[[else
		-- no more to do
		if inst.task then
			inst.task:Cancel()
		end
		inst.targettime = nil]]
    end

    if inst.components.workable.workleft <= 0 or inst.components.pickable.cycles_left <= 0 then
        inst:Remove()
    else
        if inst.components.workable.workleft ~= nil or inst.components.pickable.cycles_left ~= nil then
            inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft])
            -- inst.AnimState:PlayAnimation(anims[inst.components.pickable.cycles_left])
        end
    end

    -- print('startregen', inst.components.workable.workleft, regentime, anims[inst.components.workable.workleft])
end

local function workcallback(inst, worker, workleft)

    inst.components.lootdropper:SpawnLootPrefab("snowball_throwable")

    if worker ~= nil and worker:HasTag("wereplayer") and worker.components.moisture then
        worker.components.moisture:DoDelta(5)
    end

    if worker ~= nil and worker:HasTag("wereplayer") and worker.components.health ~= nil and
        not worker.components.health:IsDead() then
        worker.components.health:DoDelta(-2)
    end

    if inst.components.workable.workleft > 0 and inst.components.workable.workleft < 1 then
        inst.components.workable.workleft = 0
    elseif inst.components.workable.workleft > 1 and inst.components.workable.workleft < 2 then
        inst.components.workable.workleft = 1
    elseif inst.components.workable.workleft > 2 and inst.components.workable.workleft < 3 then
        inst.components.workable.workleft = 2
    end

    TryColdMenace(inst)

    local x, y, z = inst.Transform:GetWorldPosition()

    if inst.components.pickable.cycles_left > 0 then
        if inst.Transform:GetWorldPosition() ~= nil then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst.components.pickable.cycles_left = inst.components.workable.workleft
    else
        if inst.Transform:GetWorldPosition() ~= nil then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst:Remove()
    end
    if inst.components.workable.workleft <= 0 then
        inst:Remove()
    else
        startregen(inst)
    end
end

local function onsave(inst, data)
    if inst.targettime then
        local time = GetTime()
        if inst.targettime > time then
            data.time = math.floor(inst.targettime - time)
        end
        data.cycles_left = inst.components.pickable.cycles_left
        data.workleft = inst.components.workable.workleft
    end
end

local function onload(inst, data)
    if data and data.workleft then
        inst.components.workable.workleft = data.workleft
    end

    if data and data.cycles_left then
        inst.components.pickable.cycles_left = data.cycles_left
    end

    if data and data.time then
        startregen(inst, data.time)
    end
end

local function LongUpdate(inst, dt)
    if inst.targettime then
        local time = GetTime()
        if inst.targettime > time + dt then
            local time_to_regen = inst.targettime - time - dt
            startregen(inst, time_to_regen)
        else
            onregen(inst)
        end
    end
end

local function onwake(inst)

end

local function TryColdness(v)
    if v.components.moisture ~= nil then
        v.components.moisture:DoDelta(3)
    end
end

local NOTAGS = { "playerghost", "INLIMBO", "wall" }

local function DoAreaColdness(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, NOTAGS, { "_health" })
    for i, v in ipairs(ents) do TryColdness(v) end

    if inst.components.workable.workleft and inst.components.workable.workleft > 1 then
        inst:AddTag("snowpile")

        local structures = TheSim:FindEntities(x, y, z, inst.components.aura.radius, { "structure" }, NOTAGS)
        for i, v1 in ipairs(structures) do v1:AddTag("INLIMBO") end
    else
        inst:RemoveTag("snowpile")

        local inlimbostructures = TheSim:FindEntities(x, y, z, inst.components.aura.radius, { "structure", "INLIMBO" },
            { "wall" })
        for i, v2 in ipairs(inlimbostructures) do v2:RemoveTag("INLIMBO") end
    end
end

local function onpickedfn(inst, picker)

    if picker.components.moisture then
        if picker.components.talker and picker == ThePlayer then
            ThePlayer.components.talker:Say(GetString(ThePlayer.prefab, "ANNOUNCE_COLD"))
        end

        picker.components.moisture:DoDelta(15)
    end

    if picker.components.temperature ~= nil then
        picker.components.temperature:DoDelta(-20)
        if picker.components.temperature.current > -3 then
            picker.components.temperature:SetTemperature(-3)
        end
    end
    TryColdMenace(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.components.workable.workleft > 0 then
        if inst.Transform:GetWorldPosition() ~= nil then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst.components.workable.workleft = inst.components.pickable.cycles_left
    else
        if inst.Transform:GetWorldPosition() ~= nil then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst:Remove()
    end


    startregen(inst)

end

local function makefullfn(inst)
    if inst.components.pickable.cycles_left <= 0 then
        inst.components.workable:SetWorkLeft(1)
    end
end

local function makebarrenfn(inst) inst:Remove() end

local function on_anim_over(inst)
    if inst.components.workable ~= nil then
        if inst.components.workable.workleft ~= 3 then
            inst.AnimState:PushAnimation(anims[inst.components.workable.workleft])
        else
            if math.random() < 0.95 or inst.mongproof then
                inst.AnimState:PushAnimation(anims[inst.components.workable.workleft])
            else
                if math.random() > 0.33 then
                    inst.AnimState:PushAnimation('teeth')
                else
                    if math.random() > 0.5 then
                        inst.AnimState:PushAnimation('eyes')
                    else
                        inst.AnimState:PushAnimation('teyes')
                    end
                end
            end
        end
    end
end

local function Init(inst)
    if FindEntity(inst, 5, nil, { "snowpileblocker" }) then
        if inst.Transform:GetWorldPosition() ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst:Remove()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local plants = TheSim:FindEntities(x, y, z, 1.5, { "farm_plant" })

    if #plants > 0 then
        for k, v in ipairs(plants) do
            if v.components.farmplantstress ~= nil then
                v.components.farmplantstress:SetStressed("happiness", true, inst)
            end
            if v.components.farmplanttendable ~= nil then
                v.components.farmplanttendable:SetTendable(v.components.growable:GetCurrentStageData().tendable)
            end
        end
    end
end

local function snowpilefn(Sim)
    -- print ('sandhillfn')
    local inst = CreateEntity()
    inst.OnLongUpdate = LongUpdate
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnEntityWake = onwake

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("snow_dune")
    inst.AnimState:SetBank("snow_dune")
    inst.AnimState:PlayAnimation("low")

    inst.entity:SetPristine()

    MakeObstaclePhysics(inst, 2.5, 0)
    RemovePhysicsColliders(inst)

    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("snowpileradius")
    inst:AddTag("snowpile_basic")
    inst:AddTag("snowpile")
    inst:AddTag("salt_workable")

    if not TheWorld.ismastersim then return inst end

    inst.nospawning = false

    inst:AddComponent("aura")
    inst.components.aura.radius = 2
    inst.components.aura.tickperiod = TUNING.TOADSTOOL_SPORECLOUD_TICK
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    inst._coldtask = inst:DoPeriodicTask(inst.components.aura.tickperiod / 2, DoAreaColdness,
        inst.components.aura.tickperiod / 2)

    inst:AddComponent("unevenground")
    inst.components.unevenground.radius = 2

    inst.OnLongUpdate = LongUpdate
    ----------------------
    inst:AddComponent("inspectable")
    ----------------------

    -- full, med, low
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(workcallback)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

    inst.components.pickable.getregentimefn = 0.1
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.max_cycles = 3
    inst.components.pickable.cycles_left = 1
    inst.components.pickable:SetUp("snowball_throwable", 0)
    inst.components.pickable.transplanted = true

    local x, y, z = inst.Transform:GetWorldPosition()

    SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
    inst:ListenForEvent("animover", on_anim_over)

    inst:ListenForEvent("onremove", function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local inlimbostructures = TheSim:FindEntities(x, y, z, inst.components.aura.radius, { "structure", "INLIMBO" },
            { "wall" })
        for i, v in ipairs(inlimbostructures) do v:RemoveTag("INLIMBO") end
    end)

    startregen(inst)
    inst:DoTaskInTime(0, Init)
    inst.DoColdMenace = DoColdMenace

    return inst
end

return Prefab("snowpile", snowpilefn, assets, prefabs)
