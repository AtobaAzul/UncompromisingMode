local assets = 
{
	Asset("ANIM", "anim/phonograph.zip"),
	Asset("SOUND", "sound/UCSounds_bank00.fsb"),
}

local function GetSpawnPoint(pt, radius, hunt)
    --print("Hunter:GetSpawnPoint", tostring(pt), radius)

    local angle = hunt.direction
    if angle then
        local offset = Vector3(radius * math.cos( angle ), 0, -radius * math.sin( angle ))
        local spawn_point = pt + offset
        --print(string.format("Hunter:GetSpawnPoint RESULT %s, %2.2f", tostring(spawn_point), angle/DEGREES))
        return spawn_point
    end
end

local function GetSpawnPointSuprise(pt, radius, hunt)
    --print("Hunter:GetSpawnPoint", tostring(pt), radius)

    local angle = hunt.direction
    if angle then
        local offset = Vector3(radius * math.cos( angle ) + math.random(1, 3), 0, -radius * math.sin( angle ) - math.random(1, 3))
        local spawn_point = pt + offset
        --print(string.format("Hunter:GetSpawnPoint RESULT %s, %2.2f", tostring(spawn_point), angle/DEGREES))
        return spawn_point
    end
end

local function SpawnDirt(pt,hunt)

    local spawn_pt = GetSpawnPoint(pt, TUNING.HUNT_SPAWN_DIST * 2, hunt)
    local spawn_pt_suprise = GetSpawnPointSuprise(pt, TUNING.HUNT_SPAWN_DIST / 5, hunt)
    if spawn_pt ~= nil then
        local spawned = SpawnPrefab("charliephonograph_"..hunt.track)
        if spawned ~= nil then
            spawned.Transform:SetPosition(spawn_pt:Get())
		else
			hunt.components.lootdropper:DropLoot()
			
			for i = 1, math.random(2,3) do
				if math.random() >= 0.5 then
					local x, y, z = hunt.Transform:GetWorldPosition()
					if math.random() >= 0.33 then
						SpawnPrefab("crawlingnightmare").Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
					else
						SpawnPrefab("nightmarebeak").Transform:SetPosition(x + math.random(-10, 10), y, z + math.random(-10, 10))
					end
				else
					--lucky break
				end
			end
        end
    end
end

local function GetRunAngle(pt, angle, radius)
    local offset, result_angle = FindWalkableOffset(pt, angle, radius, 14, true)
    return result_angle
end

local function GetNextSpawnAngle(pt, direction, radius)
    --print("Hunter:GetNextSpawnAngle", tostring(pt), radius)

    local base_angle = direction or math.random() * 2 * PI
    local deviation = math.random(-TUNING.TRACK_ANGLE_DEVIATION, TUNING.TRACK_ANGLE_DEVIATION)*DEGREES

    local start_angle = base_angle + deviation
    --print(string.format("   original: %2.2f, deviation: %2.2f, starting angle: %2.2f", base_angle/DEGREES, deviation/DEGREES, start_angle/DEGREES))

    --[[local angle =]] return GetRunAngle(pt, start_angle, radius)
    --print(string.format("Hunter:GetSpawnPoint RESULT %s", tostring(angle and angle/DEGREES)))
    --return angle
end

local function removephonograph(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local despawnfx = SpawnPrefab("shadow_despawn")
	despawnfx.Transform:SetPosition(x, y, z)
		
    inst:Remove()
end

local function StartDirt(hunt,position)

    local pt = position --Vector3(player.Transform:GetWorldPosition())

    hunt.direction = GetNextSpawnAngle(pt, nil, TUNING.HUNT_SPAWN_DIST * 2)
    if hunt.direction ~= nil then
        --print(string.format("   first angle: %2.2f", hunt.direction/DEGREES))

        --print("    numtrackstospawn", hunt.numtrackstospawn)

        -- it's ok if this spawn fails, because we'll keep trying every HUNT_UPDATE
        local spawnRelativeTo =  pt
        if SpawnDirt(spawnRelativeTo, hunt) then
        end
    --else
        --print("Failed to find suitable dirt placement point")
    end
end

local function play(inst)
	inst.AnimState:PlayAnimation("play_loop", true)
   	inst.SoundEmitter:PlaySound(inst.songToPlay, "UCSounds/gramaphone_music/gramaphone_0")
   	if inst.components.playerprox then
   		inst:RemoveComponent("playerprox")
   	end
   	inst:PushEvent("turnedon")
end

local function stop(inst)
	inst.AnimState:PlayAnimation("idle")
        inst.SoundEmitter:KillSound("UCSounds/gramaphone_music/gramaphone_0")
        inst.SoundEmitter:PlaySound("UCSounds/gramaphone_music/gramaphone_end")

    inst:PushEvent("turnedoff")
	if inst:GetNearestPlayer(true) ~= nil then
		local position = inst:GetNearestPlayer(true):GetPosition()
		if position ~= nil then
			StartDirt(inst, position)
			inst:DoTaskInTime(0.1, removephonograph)
			
		end
	end
end

local function MakePhonographFn(track)
    return function()

			local inst = CreateEntity()
			local trans = inst.entity:AddTransform()
			local anim = inst.entity:AddAnimState()
			local sound = inst.entity:AddSoundEmitter()
			
			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddSoundEmitter()
			inst.entity:AddNetwork()
			
			MakeObstaclePhysics(inst, 0.1)
			anim:SetBank("phonograph")
			anim:SetBuild("phonograph")		
			anim:PlayAnimation("idle")

			inst:AddTag("charliephonograph")
			
			if track == 100 then
				inst.AnimState:SetMultColour(1, 1, 1, 1)
				inst:AddComponent("inspectable")
			else
				inst.AnimState:SetMultColour(0, 0, 0, 0.4)
			end

			inst.entity:SetPristine()

			if not TheWorld.ismastersim then
				return inst
			end

			inst.songToPlay = "UCSounds/gramaphone_music/gramaphone_"..track

			--inst:AddComponent("inspectable")
			
			inst:AddComponent("lootdropper")
			inst.components.lootdropper:AddRandomLoot("armor_sanity", 1)
			inst.components.lootdropper:AddRandomLoot("nightsword", 1)
			inst.components.lootdropper.numrandomloot = 1

			inst:AddComponent("machine")
			inst.components.machine.turnonfn = play
			inst.components.machine.turnofffn = stop

			inst.entity:SetCanSleep(false)
			
			inst.track = track + 20
			
			inst:DoTaskInTime(0, function(inst) SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition()) end)
				
			inst:AddComponent("playerprox")
			inst.components.playerprox:SetDist(600, 615)
			inst.components.playerprox:SetOnPlayerNear(function() inst.components.machine:TurnOn() end)
			
			inst:WatchWorldState("isday", function() 
				local x, y, z = inst.Transform:GetWorldPosition()
				local despawnfx = SpawnPrefab("shadow_despawn")
				despawnfx.Transform:SetPosition(x, y, z)
				
				inst:Remove()
			end)
			
			inst.persists = false

		return inst
	end
end
return Prefab("charliephonograph", MakePhonographFn(0), assets),
		Prefab("charliephonograph_20", MakePhonographFn(20), assets),
		Prefab("charliephonograph_40", MakePhonographFn(40), assets),
		Prefab("charliephonograph_60", MakePhonographFn(60), assets),
		Prefab("charliephonograph_80", MakePhonographFn(80), assets),
		Prefab("charliephonograph_100", MakePhonographFn(100), assets)
