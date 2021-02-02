local assets=
{
--[[
	Asset("ANIM", "anim/uncompromising_pawn_build.zip"),

	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
	Asset("INV_IMAGE", "crabbit_beardling"),
	]]
}

local prefabs =
{
}

local EFFECTS =
{
    hot = "dr_hot_loop",
    warmer = "dr_warmer_loop",
    warm = "dr_warm_loop_2",
    cold = "dr_warm_loop_1",
}

SetSharedLootTable('um_pawn',
{
    {'nightmarefuel',    0.2},
    {'thulecite_pieces', 0.1},
    {'trinket_6',      0.4},
})

local PAWN_DIVINING_DISTANCES = 
		{
		    {maxdist=12, describe="hot", pingtime=1},
		    {maxdist=24, describe="warmer", pingtime=2},
		    {maxdist=48, describe="warm", pingtime=4},
		    {maxdist=98, describe="cold", pingtime=8},
		}
local PAWN_DIVINING_MAXDIST = 72
local PAWN_DIVINING_DEFAULTPING = 1.8
local function FindClosestPart(inst)

    if inst.tracking_parts == nil then
        inst.tracking_parts = {}
        for k,v in pairs(Ents) do
            if v:HasTag("player") then
                table.insert(inst.tracking_parts, v)
            end
        end
    end

    if inst.tracking_parts then
        local closest = nil
        local closest_dist = nil
        for k,v in pairs(inst.tracking_parts) do
            if v:IsValid() and not v:IsInLimbo() then
                local dist = v:GetDistanceSqToInst(inst)
                if not closest_dist or dist < closest_dist then
                    closest = v
                    closest_dist = dist
                end
            end
        end
		
        return closest
    end
end

local function CheckTargetPiece(inst)
	--inst.SoundEmitter:KillSound("ping")
		
	if not inst.components.health:IsDead() then
        local intensity = 0
        local closeness = nil
        local fxname = nil
        local target = FindClosestPart(inst)
        local nextpingtime = PAWN_DIVINING_DEFAULTPING
        if target ~= nil then
            local distsq = inst:GetDistanceSqToInst(target)
            intensity = math.max(0, 1 - (distsq/(PAWN_DIVINING_MAXDIST*PAWN_DIVINING_MAXDIST) ))
			
            for k,v in ipairs(PAWN_DIVINING_DISTANCES) do
                closeness = v
                fxname = EFFECTS[v.describe]
		
                if v.maxdist and distsq <= v.maxdist*v.maxdist then
                    nextpingtime = closeness.pingtime
                    break
                end
            end
        end

        if fxname ~= nil then
            inst.fx = SpawnPrefab(fxname)
            inst.fx.entity:AddFollower()
            inst.fx.Follower:FollowSymbol(inst.GUID, "body", 0, -40, 0)
			
            inst.fxlight = SpawnPrefab(fxname.."_light")
            inst.fxlight.entity:AddFollower()
            inst.fxlight.Follower:FollowSymbol(inst.GUID, "body", 0, -40, 0)
        end
		
		if inst.task ~= nil then
			inst.task:Cancel()
		end
		
		inst.task = nil
        inst.task = inst:DoTaskInTime(nextpingtime or PAWN_DIVINING_DEFAULTPING, CheckTargetPiece)
	end
end

local function OnWake(inst)
end

local function OnSleep(inst)
end

local function StartDusk(inst)
end

local function OnAttacked(inst, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 30, {'uncompromising_pawn'})
    
    local num_friends = 0
    local maxnum = 5
    for k,v in pairs(ents) do
        v:PushEvent("gohome")
        num_friends = num_friends + 1
        
        if num_friends > maxnum then
            break
        end
    end
end

local function DisplayName(inst)
    if inst.sg:HasStateTag("invisible") then
        return --STRINGS.NAMES.CRAB_HIDDEN
    end
    return --STRINGS.NAMES.CRAB
end

local function getstatus(inst)
    if inst.sg:HasStateTag("invisible") then 
        return "HIDDEN"
    end
end

local function GenerateSpiralSpikes(inst)
    local spawnpoints = {}
    local source = inst
    local x, y, z = source.Transform:GetWorldPosition()
    local spacing = 2.7
    local radius = 15
    local deltaradius = .2
    local angle = 2 * PI * math.random()
    local deltaanglemult = (inst.reversespikes and -2 or 2) * PI * spacing
    inst.reversespikes = not inst.reversespikes
    local delay = 0
    local deltadelay = 2 * FRAMES
    local num = 35
    local map = TheWorld.Map
    for i = 1, num do
        local oldradius = radius
        radius = radius --+ deltaradius
        local circ = PI * (oldradius + radius)
        local deltaangle = deltaanglemult / circ
        angle = angle + deltaangle
        local x1 = x + radius * math.cos(angle)
        local z1 = z + radius * math.sin(angle)
        if map:IsPassableAtPoint(x1, 0, z1) then
            table.insert(spawnpoints, {
                t = delay,
                level = i / num,
                pts = { Vector3(x1, 0, z1) },
            })
            delay = delay + deltadelay
        end
    end
    return spawnpoints, source
end

local function DoSpawnSpikes(inst, pts, level, cache)
    if not inst.components.health:IsDead() then
        for i, v in ipairs(pts) do
            local variation = table.remove(cache.vars, math.random(#cache.vars))
            table.insert(cache.used, variation)
            if #cache.used > 3 then
                table.insert(cache.queued, table.remove(cache.used, 1))
            end
            if #cache.vars <= 0 then
                local swap = cache.vars
                cache.vars = cache.queued
                cache.queued = swap
            end

            local spike = SpawnPrefab("nightmaregrowth")
				spike.Transform:SetPosition(v:Get())
				spike:growfn()
				spike.persists = false
				
					spike:DoTaskInTime(20 + (5*math.random()), function(spike)
						local despawnfx = SpawnPrefab("shadow_despawn")
						despawnfx.Transform:SetPosition(spike.Transform:GetWorldPosition())
						spike.AnimState:PlayAnimation("shrink")
						spike:ListenForEvent("animover", spike.Remove)
					end)
				
			local x, y, z = spike.Transform:GetWorldPosition()
			if #TheSim:FindEntities(x, y, z, 5, {"structure", "tree", "boulder"}) > 0 then
				spike:Remove()
			end
        end
    end
end

local function SpawnSpikes(inst)

    local spikes, source = GenerateSpiralSpikes(inst)
	
    if #spikes > 0 then
        local cache =
        {
            vars = { 1, 2, 3, 4, 5, 6, 7 },
            used = {},
            queued = {},
        }
        local flameperiod = .8
        for i, v in ipairs(spikes) do
            inst:DoTaskInTime((v.t / 1.5), DoSpawnSpikes, v.pts, v.level, cache)
        end

    end
end

local function OnExplodeFn(inst)
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function SpawnAmalgams(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local knook = SpawnPrefab("knook")
	local roship = SpawnPrefab("roship")
	local bight = SpawnPrefab("bight")
	
	
	local amalgams = { knook }
	
	if math.random() > 0.5 then
		amalgams = { knook, roship }
	else
		amalgams = { roship, bight }
	end
	
	for q, v in pairs(amalgams) do
		for k = 1, 4 do
			local x, y, z = inst.Transform:GetWorldPosition()
			local offset = 10

			local x2 = x + math.random(-8, 8)
			local z2 = z + math.random(-8, 8)

			if TheWorld.Map:IsPassableAtPoint(x2, 0, z2) then
				v.Transform:SetPosition(x2, 0, z2)
				v.sg:GoToState("zombie")
				v.components.lootdropper:SetChanceLootTable('um_pawn')
				break
			end
			
			v.Transform:SetPosition(x, 0, z)
			v.sg:GoToState("zombie")
			v.components.lootdropper:SetChanceLootTable('um_pawn')
		end
	end
	--[[
	knook.Transform:SetPosition(x, 0, z)
	roship.Transform:SetPosition(x, 0, z)
	bight.Transform:SetPosition(x, 0, z)
	knook.sg:GoToState("zombie")
	roship.sg:GoToState("zombie")
	bight.sg:GoToState("zombie")]]
end

local function onnear(inst, target)
    SpawnSpikes(target)
	
	SpawnAmalgams(target)
	
    inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = 0
    inst.components.explosive:OnBurnt()
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddPhysics()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
		
		
	shadow:SetSize( 1.5, .5 )
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 1, 0.5)

    anim:SetBank("uncompromising_pawn")
    anim:SetBuild("uncompromising_pawn_build")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.runspeed = 5.5
    inst.components.locomotor.walkspeed = 2.5
    inst:SetStateGraph("SGuncompromising_pawn")

    inst:AddTag("cavedweller") 
    inst:AddTag("uncompromising_pawn") 
    inst:AddTag("smallcreature")
    inst:AddTag("chess")

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("sanityaura")

    inst:AddComponent("knownlocations")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chest"
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)

    MakeTinyFreezableCharacter(inst, "chest")

    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('um_pawn')

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(7, 13) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)
	
	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep

    --inst.displaynamefn = DisplayName

    local brain = require "brains/uncompromising_pawnbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
	
	if inst.checktask == nil then
        inst.checktask = inst:DoTaskInTime(1, CheckTargetPiece)
	end
	
	inst.sg:GoToState("hide_post")

    return inst
end

local function create_common(r, g, b)
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(.7)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(r / 255, g / 255, b / 255)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.radius = 2

    inst.persists = false
	inst:DoPeriodicTask(0.1, function(inst) 
		inst.radius = inst.radius - 0.1
		inst.Light:SetRadius(inst.radius)
	end)
	
	inst:DoTaskInTime(1, inst.Remove)

    return inst
end

local function redlight()
    local inst = create_common(255,0,0)

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("UCSounds/pawn/ping_hot")

    return inst
end

local function orangelight()
    local inst = create_common(255,125,0)

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("UCSounds/pawn/ping_warmer")

    return inst
end


local function yellowlight()
    local inst = create_common(255,255,0)

    if not TheWorld.ismastersim then
        return inst
    end

	inst.SoundEmitter:PlaySound("UCSounds/pawn/ping_warm")

    return inst
end


local function bluelight()
    local inst = create_common(0,0,255)

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("UCSounds/pawn/ping_cold")

    return inst
end


return Prefab("um_pawn", fn, assets, prefabs),
		Prefab("dr_hot_loop_light", redlight),
		Prefab("dr_warmer_loop_light", orangelight),
		Prefab("dr_warm_loop_2_light", yellowlight),
		Prefab("dr_warm_loop_1_light", bluelight)
