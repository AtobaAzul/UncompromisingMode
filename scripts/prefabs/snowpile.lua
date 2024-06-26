local assets = {Asset("ANIM", "anim/snowpile.zip")}

local anims = {"low", "med", "full"}

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
    if math.random() > 0.9 and (inst.components.workable.workleft > 2 or inst.components.pickable.cycles_left > 2) and not inst.mongproof then -- This chance could be adjusted or scale with time.
        inst:DoColdMenace(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        if math.random() > 0.3 then -- Have a good chance of spawning buddies with them.
            local sno = TheSim:FindEntities(x, y, z, 10, {"snowpile"})
            local nummongs = math.random(1, 3)
            for i, pile in ipairs(sno) do
                if nummongs > 0 then
                    nummongs = nummongs - 1
                    pile:DoColdMenace(pile)
                end
            end
        end
        local sno = TheSim:FindEntities(x, y, z, 20, {"snowpile"})
        for i, pile in ipairs(sno) do
            pile.mongproof = true
        end
    end
end

TUNING.SNOW_X_SCALE = 0 + math.random(0.3, 0.5)
TUNING.SNOW_Y_SCALE = 0 + math.random(0.1, 0.3)
TUNING.SNOW_REGROW_TIME = 180
TUNING.SNOW_REGROW_VARIANCE = 60
TUNING.SNOW_DEPLETE_CHANCE = 0.25

local AURA_EXCLUDE_TAGS = {"noauradamage", "INLIMBO", "notarget", "noattack", "flight", "invisible"}

local INVALID_TILES = table.invert({GROUND.SCALE})

local startregen

local function FindSpreadSpot(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local angle = math.random(0, 8 * RADIANS)

    x = x + 4 * math.cos(angle)
    z = z + 4 * math.sin(angle)

    inst.redo = false

    for i = -2, 2 do
        for k = -2, 2 do
            if TheWorld.Map:GetTileAtPoint(x + i, y, z + k) == GROUND.SCALE or not TheWorld.Map:IsPassableAtPoint(x + i, y, z + k) then
                inst.redo = true
                break
            end
        end
    end

    if #TheSim:FindEntities(x, y, z, 4, {"snowpile"}) > 2 then -- Don't want to be close to a single pile
        inst.redo = true
    end

    if #TheSim:FindEntities(x, y, z, 6, {"snowpile"}) > 3 then -- Don't want to clog the piles all in one location either
        inst.redo = true
    end

    if #TheSim:FindEntities(x, y, z, 6, {"snowpileblocker"}) > 1 then -- Snowpile blockers
        inst.redo = true
    end

    if #TheSim:FindEntities(x, y, z, 64, {"snowpile"}) > 48 then -- limit all snowpiles in a big radius
        inst.redo = true
        inst.count = 9
    end

    if inst.count > 8 then -- give up if you try too much.
        return nil
    elseif not inst.redo then
        return x, y, z
    else
        inst.redo = nil
        inst.count = inst.count + 1
        return FindSpreadSpot(inst)
    end
end

local function SpreadSno(inst)
    inst:DoTaskInTime(math.random() + math.random(), function()
        inst.count = 0
        inst.redo = nil
        local x, y, z = FindSpreadSpot(inst)
        if x ~= nil then
            inst.components.workable.workleft = 2
            inst.components.pickable.cycles_left = 2
            inst.AnimState:PlayAnimation(anims[inst.components.workable.workleft])
            local sno = SpawnPrefab("snowpile")
            sno.Transform:SetPosition(x, y, z)
            sno:DoTaskInTime(0, function(inst)
                local x, y, z = inst.Transform:GetWorldPosition()
                if #TheSim:FindEntities(x, y, z, 2, {"snowpile"}) > 1 then
                    inst:Remove()
                end
            end)
        end
    end)
end

local function onregen(inst)
    local my_x, my_y, my_z = inst.Transform:GetWorldPosition()
    local tile
    if my_x ~= nil and my_y ~= nil and my_z ~= nil then
        tile = TheWorld.Map:GetTileAtPoint(my_x, 0, my_z)
    end
    if TheWorld.state.iswinter and TheWorld.state.issnowing and not (tile ~= nil and INVALID_TILES[tile]) then -- or ents2 ~= nil and #ents2 < 0 then
        if inst.components.workable.workleft < 3 then
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(my_x, 0, my_z)
            inst.components.workable:SetWorkLeft(inst.components.workable.workleft + 1)
            inst.components.pickable.cycles_left = inst.components.pickable.cycles_left + 1
            startregen(inst)
        else
            SpreadSno(inst)
            startregen(inst)
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
    local plants = TheSim:FindEntities(x, y, z, 1.5, {"farm_plant"})

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

        if TheWorld.state.issnowing or ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) then
            regentime = regentime / 2
        elseif TheWorld.state.iswinter and not TheWorld.state.issnowing and not ((TheWorld.net ~= nil and TheWorld.net:HasTag("snowstormstartnet")) or TheWorld:HasTag("snowstormstart")) then
            regentime = regentime
        else
            regentime = regentime / 2
        end

        if inst.task then
            inst.task:Cancel()
        end
		
		inst.task = nil
		
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
end

local function workcallback(inst, worker, workleft)
    if worker ~= nil and worker:HasTag("wereplayer") and worker.components.moisture then
        worker.components.moisture:DoDelta(5)
    end

    if worker ~= nil and worker:HasTag("wereplayer") and worker.components.health ~= nil and not worker.components.health:IsDead() then
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
	inst.components.lootdropper:SpawnLootPrefab("snowball_throwable")
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then --IT'S INSANE HOW JOLLY AND FESTIVE I AM BRAGHHGGH
		local more_balls = math.floor(math.random(1.5,4))
		for i = 1, more_balls do
			local ball = inst.components.lootdropper:SpawnLootPrefab("snowball_throwable")
			local strength = math.random(1, 2.25)
			Launch(ball, inst, strength)
		end
	end
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
local function TryColdness(v)
    if v.components.moisture ~= nil then
        if v.components.inventory ~= nil and (v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ~= nil and v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY).prefab ~= "beargervest" or v.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil) or v.components.inventory == nil then
            v.components.moisture:DoDelta(5)
        end
    end
end

local NOTAGS = {"playerghost", "wall"}

local function DoAreaColdness(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, NOTAGS)
	
    for i, v in ipairs(ents) do
		if v:HasTag("player") then
			TryColdness(v)
		elseif v:HasTag("structure") then
			if inst.components.workable.workleft and inst.components.workable.workleft > 1 then
				inst:AddTag("snowpile")

				v:AddTag("NOCLICK")
			else
				inst:RemoveTag("snowpile")

				if v:HasTag("NOCLICK") then
					v:RemoveTag("NOCLICK")
				end
			end
		end
    end
end

local function onpickedfn(inst, picker)
    if picker ~= nil and picker:IsValid() then
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
    end

    if TheWorld.state.iswinter then
        TryColdMenace(inst)
    end

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
    if FindEntity(inst, 5, nil, {"snowpileblocker"}) then
        if inst.Transform:GetWorldPosition() ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
        end
        inst:Remove()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local plants = TheSim:FindEntities(x, y, z, 1.5, {"farm_plant"})

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

local function OnSeasonChange(inst)
    if not TheWorld.state.iswinter then
        inst.persists = false
        inst:Remove()
    end
end

local function onwake(inst)
	if inst._coldtask == nil then
		inst._coldtask = inst:DoPeriodicTask(inst.components.aura.tickperiod, DoAreaColdness, inst.components.aura.tickperiod / 2)
	end
end

local function onsleep(inst)
	if inst._coldtask ~= nil then
		inst._coldtask:Cancel()
		inst._coldtask = nil
	end
end


local function snowpilefn(Sim)
    -- print ('sandhillfn')
    local inst = CreateEntity()

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

    if not TheWorld.ismastersim then
        return inst
    end

    inst.nospawning = false

    inst:AddComponent("aura")
    inst.components.aura.radius = 2
    inst.components.aura.tickperiod = TUNING.TOADSTOOL_SPORECLOUD_TICK
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    inst._coldtask = inst:DoPeriodicTask(inst.components.aura.tickperiod, DoAreaColdness, inst.components.aura.tickperiod)

    inst:AddComponent("unevenground")
    inst.components.unevenground.radius = 2
	
    ----------------------
    inst:AddComponent("inspectable")
    ----------------------

    -- full, med, low
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(workcallback)


    local balls_count = 1
    if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then balls_count = math.floor(math.random(2, 4.5)) end --THIS IS SO JOLLY GRAAAH
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"

    inst.components.pickable.getregentimefn = 0.1
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.max_cycles = 3
    inst.components.pickable.cycles_left = 1
    inst.components.pickable:SetUp("snowball_throwable", 0, balls_count)
    inst.components.pickable.transplanted = true

    local x, y, z = inst.Transform:GetWorldPosition()

    SpawnPrefab("splash_snow_fx").Transform:SetPosition(x, 0, z)
    inst:ListenForEvent("animover", on_anim_over)

    inst:ListenForEvent("onremove", function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local inlimbostructures = TheSim:FindEntities(x, y, z, inst.components.aura.radius, {"structure", "NOCLICK"}, {"wall"})
        for i, v in ipairs(inlimbostructures) do
            v:RemoveTag("NOCLICK")
        end
    end)

    inst:WatchWorldState("season", OnSeasonChange)

    startregen(inst)
    inst:DoTaskInTime(0, Init)
    inst.DoColdMenace = DoColdMenace
	
    inst.OnLongUpdate = LongUpdate
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.OnEntityWake = onwake
    inst.OnEntitySleep = onsleep

    inst:DoPeriodicTask(10, function(inst)
        if TheWorld.state.israining and not TheWorld.state.iswinter then
            inst.components.pickable:Pick()
        end
    end)

    return inst
end

return Prefab("snowpile", snowpilefn, assets, prefabs)
