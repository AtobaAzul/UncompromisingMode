local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local UpvalueHacker = require("tools/upvaluehacker")

local function DisableThatStuff(inst)
	TheWorld:PushEvent("beequeenkilled")

	if TheWorld.net ~= nil then
		TheWorld.net:AddTag("queenbeekilled")
	end

	SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Stop"), nil)
end

env.AddPrefabPostInit("beeguard", function(inst)
	inst:AddTag("ignorewalkableplatforms")
end)

local function Wallcheck(inst)
	if inst.defensebees then
		for i, bee in ipairs(inst.defensebees) do
			if bee.components.health and not bee.components.health:IsDead() then
				return true
			end
		end
	end
end

local function StompHandler(inst, data)
	--TheNet:Announce(inst.stomprage)
	--[[if inst.components.health and inst.components.health:GetPercent() > 0.5 then --fast foward to the 3rd phase
		inst.components.health:SetPercent(0.49)
	end]]
	if inst.components.timer:GetTimeLeft("spawnguards_cd") and inst.components.timer:GetTimeLeft("spawnguards_cd") > 3 then
		local newtime = inst.components.timer:GetTimeLeft("spawnguards_cd") - data.damage / 50 --new code to adjust bq to speed up the fight if player is going through her really quickly, need to make sure her abilities actually get the chance to proc.
		if newtime < 3 then
			newtime = 3
		end
		inst.components.timer:SetTimeLeft("spawnguards_cd", newtime)
	end


	if inst.components.health and not inst.components.health:IsDead() then
		if inst.tiredcount then
			inst.tiredcount = inst.tiredcount - 0.5
		end
		if data.damage >= 100 then
			if inst.tiredcount then
				inst.tiredcount = inst.tiredcount - 2
			end
		end
		local soldiers = inst.components.commander:GetAllSoldiers()

		if inst.components.health and inst.components.health:GetPercent() < 0.5 and not inst.sg:HasStateTag("busy") then
			local soldiers = inst.components.commander:GetAllSoldiers()
			if #soldiers > 0 then
				inst.sg:GoToState("focustarget")
			end
			inst.should_shooter_rage = inst.should_shooter_rage - 1
		end
		if inst.components.health and inst.components.health:GetPercent() < 0.75 then
			if inst.sg:HasStateTag("tired") then
				inst.AnimState:PlayAnimation("tired_hit")
				inst.AnimState:PushAnimation("tired_loop", true)
			end

			inst.stomprage = inst.stomprage + 1

			if data.attacker and data.attacker.components.combat and inst.stompready then
				inst.prioritytarget = data.attacker
				if inst.components.combat.target ~= nil then
					if data.attacker ~= inst.components.combat.target then
						if inst.tiredcount then
							inst.tiredcount = inst.tiredcount - 0.5
						end
						inst.stomprage = inst.stomprage + 4
					end
				end
				local x, y, z = data.attacker.Transform:GetWorldPosition()
				if TheWorld.Map:GetPlatformAtPoint(x, z) ~= nil then
					inst.stomprage = inst.stomprage + 20
				end
				if inst.stomprage > 40 and not inst.sg:HasStateTag("ability") and inst.components.health and
					not inst.components.health:IsDead() and not inst:HasTag("doingability") then
					inst:ForceFacePoint(x, y, z)
					inst.stomprage = 0
					inst.stompready = false
					inst:DoTaskInTime(math.random(3, 5), function(inst) inst.stompready = true end)
					inst.sg:GoToState("stomp")
				end
			end
		end
	end
end

local function StompRageCalmDown(inst)
	if inst.stomprage < 3 then
		inst.stomprage = 0
	else
		inst.stomprage = inst.stomprage - 3
	end
end

local function SpawnShooterBeesLine(inst, time, back)
	local x, y, z = inst.Transform:GetWorldPosition()
	local LIMIT = 10
	local target = FindEntity(inst, 40 ^ 2, nil, { "player" }, { "playerghost" })
	if not target then
		target = FindEntity(inst, 40 ^ 2, nil, { "_combat" }, { "playerghost" })
	end
	local total = 8
	local dist = 13
	if back then
		dist = -dist
	end
	local spacing = 5
	local randomness = math.random()
	local aligned = math.random()
	if target and target:IsValid() then
		inst.shooterbeeline = {}
		for i = 1, total do
			inst.shooterbeeline[i] = SpawnPrefab("um_beeguard_shooter")
			if inst.prefab == "cherry_beequeen" then
				inst.shooterbeeline[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
				inst.shooterbeeline[i].AnimState:SetMultColour(1, 0.66, 1, 1)
			end
			inst.shooterbeeline[i].queen = inst
			inst.shooterbeeline[i].target = target

			inst.shooterbeeline[i].components.linearcircler:SetCircleTarget(inst)
			inst.shooterbeeline[i].components.linearcircler.grounded = true
			inst.shooterbeeline[i].components.linearcircler:Start()
			inst.shooterbeeline[i].components.linearcircler.randAng = i * 0.125
			inst.shooterbeeline[i].components.linearcircler.clockwise = false
			inst.shooterbeeline[i].components.linearcircler.distance_limit = LIMIT
			inst.shooterbeeline[i].components.linearcircler.setspeed = 0.05

			inst.shooterbeeline[i].components.timer:StartTimer("natural_death", time)
			inst.shooterbeeline[i].components.entitytracker:TrackEntity("queen", inst)
			inst.shooterbeeline[i].line = true
			inst.shooterbeeline[i]:DoTaskInTime(0.1, function(bee)
				if bee.components.health and not bee.components.health:IsDead() then
					local x, y, z = bee.Transform:GetWorldPosition()
					bee:RemoveComponent("linearcircler")
					bee.Transform:SetPosition(x, y, z)
					bee.sg:GoToState("flyup_shooter")
				end
			end)
			inst.shooterbeeline[i]:DoPeriodicTask(FRAMES, function(bee)
				if bee.target and bee:IsValid() then
					bee:ForceFacePoint(bee.target:GetPosition())
				end
			end)

			inst.shooterbeeline[i].pos1 = target:GetPosition()
			inst.shooterbeeline[i].pos1.x = inst.shooterbeeline[i].pos1.x + dist
			inst.shooterbeeline[i].pos2 = target:GetPosition()
			inst.shooterbeeline[i].pos2.x = inst.shooterbeeline[i].pos2.x - dist

			if aligned > 0.5 then
				inst.shooterbeeline[i].pos1.z = inst.shooterbeeline[i].pos1.z + spacing * ((i) - (total + 1) / 2) + randomness
				inst.shooterbeeline[i].pos2.z = inst.shooterbeeline[i].pos2.z + spacing * ((i) - (total + 1) / 2) + randomness
			else
				inst.shooterbeeline[i].pos1.z = inst.shooterbeeline[i].pos1.z + spacing * ((i) - (total) / 2)
				inst.shooterbeeline[i].pos2.z = inst.shooterbeeline[i].pos2.z + spacing * ((i) - (total) / 2)
			end
		end
		randomness = -math.random()
		for i = 1, total do
			local j = i + total
			inst.shooterbeeline[j] = SpawnPrefab("um_beeguard_shooter")
			if inst.prefab == "cherry_beequeen" then
				inst.shooterbeeline[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
				inst.shooterbeeline[i].AnimState:SetMultColour(1, 0.66, 1, 1)
			end
			inst.shooterbeeline[j].queen = inst
			inst.shooterbeeline[j].target = target

			inst.shooterbeeline[j].components.linearcircler:SetCircleTarget(inst)
			inst.shooterbeeline[j].components.linearcircler.grounded = true
			inst.shooterbeeline[j].components.linearcircler:Start()
			inst.shooterbeeline[j].components.linearcircler.randAng = i * 0.125
			inst.shooterbeeline[j].components.linearcircler.clockwise = false
			inst.shooterbeeline[j].components.linearcircler.distance_limit = LIMIT
			inst.shooterbeeline[j].components.linearcircler.setspeed = 0.05

			inst.shooterbeeline[j].components.timer:StartTimer("natural_death", time)
			inst.shooterbeeline[j].components.entitytracker:TrackEntity("queen", inst)
			inst.shooterbeeline[j].line = true
			inst.shooterbeeline[j]:DoTaskInTime(0.1, function(bee)
				if bee.components.health and not bee.components.health:IsDead() then
					local x, y, z = bee.Transform:GetWorldPosition()
					bee:RemoveComponent("linearcircler")
					bee.Transform:SetPosition(x, y, z)
					if bee.components.health and not bee.components.health:IsDead() then
						bee.sg:GoToState("flyup_shooter")
					end
				end
			end)
			inst.shooterbeeline[j]:DoPeriodicTask(FRAMES, function(bee)
				if bee.target and bee:IsValid() then
					bee:ForceFacePoint(bee.target:GetPosition())
				end
			end)

			inst.shooterbeeline[j].pos1 = target:GetPosition()
			inst.shooterbeeline[j].pos1.z = inst.shooterbeeline[j].pos1.z + dist
			inst.shooterbeeline[j].pos2 = target:GetPosition()
			inst.shooterbeeline[j].pos2.z = inst.shooterbeeline[j].pos2.z - dist

			if aligned < 0.5 then
				inst.shooterbeeline[j].pos1.x = inst.shooterbeeline[j].pos1.x + spacing * ((i) - (total + 1) / 2) + randomness
				inst.shooterbeeline[j].pos2.x = inst.shooterbeeline[j].pos2.x + spacing * ((i) - (total + 1) / 2) + randomness
			else
				inst.shooterbeeline[j].pos1.x = inst.shooterbeeline[j].pos1.x + spacing * ((i) - (total) / 2)
				inst.shooterbeeline[j].pos2.x = inst.shooterbeeline[j].pos2.x + spacing * ((i) - (total) / 2)
			end
		end
	end
end

local function SpawnShooterBeesCircle(inst, prioritytarget)
	local x, y, z = inst.Transform:GetWorldPosition()
	local LIMIT = 4
	local target = FindEntity(inst, 40 ^ 2, nil, { "player" }, { "playerghost" })
	if not target then
		target = FindEntity(inst, 40 ^ 2, nil, { "_combat" }, { "playerghost" })
	end
	if prioritytarget then
		--TheNet:Announce("setting priority target")
		target = prioritytarget
	end
	if target then
		inst.shooterbees = {}
		for i = 1, 8 do
			inst.shooterbees[i] = SpawnPrefab("um_beeguard_shooter")
			if inst.prefab == "cherry_beequeen" then
				inst.shooterbees[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
				inst.shooterbees[i].AnimState:SetMultColour(1, 0.66, 1, 1)
			end
			inst.shooterbees[i].queen = inst
			inst.shooterbees[i].target = target
			inst.shooterbees[i].components.linearcircler:SetCircleTarget(inst)
			inst.shooterbees[i].components.linearcircler.grounded = true
			inst.shooterbees[i].components.linearcircler:Start()
			inst.shooterbees[i].components.linearcircler.randAng = i * 0.125
			inst.shooterbees[i].components.linearcircler.clockwise = false
			inst.shooterbees[i].components.linearcircler.distance_limit = LIMIT
			inst.shooterbees[i].components.linearcircler.setspeed = 0.05
			inst.shooterbees[i].time = 1 + 0.5 * i
			if inst.defensivecircle then
				inst.shooterbees[i].components.timer:StartTimer("epic", 2 + 0.5 * i)
			end
			inst.shooterbees[i].count = i
			inst.shooterbees[i].components.entitytracker:TrackEntity("queen", inst)
			if not inst.defensivecircle then
				inst.shooterbees[i].circle = true
				inst.shooterbees[i]:DoTaskInTime(2,
					function(bee) if bee.components.health and not bee.components.health:IsDead() then bee.sg:GoToState("flyup_shooter") end end)
			end
			inst.shooterbees[i]:DoPeriodicTask(FRAMES, function(bee)
				if bee.target and bee:IsValid() then
					bee:ForceFacePoint(bee.target:GetPosition())
				end
			end)
			--inst.lavae[i].AnimState:PushAnimation("hover",true)
		end
	end
	if inst.defensivecircle then
		inst.defensivecircle = nil
	end
end

local function KillOffOldDefense(inst)
	for i, bee in ipairs(inst.defensebees) do
		if bee.components.health and not bee.components.health:IsDead() and bee.components.timer:TimerExists("natural_death") then
			bee.components.timer:SetTimeLeft("natural_death", math.random(0, 2))
		end
	end
end

local function SpawnDefensiveBeesII(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local LIMIT = 5
	if inst.defensebees then
		KillOffOldDefense(inst)
	end
	inst.defensebees = {}
	for i = 1, 8 do
		inst.defensebees[i] = SpawnPrefab("um_beeguard_blocker")
		if inst.prefab == "cherry_beequeen" then
			inst.defensebees[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
			inst.defensebees[i].AnimState:SetMultColour(1, 0.9, 0, 1)
		end
		inst.defensebees[i].queen = inst
		inst.defensebees[i].components.linearcircler:SetCircleTarget(inst)
		inst.defensebees[i].components.linearcircler:Start()
		inst.defensebees[i].components.linearcircler.randAng = i * 0.125 * 3 / 5
		inst.defensebees[i].components.linearcircler.clockwise = false
		inst.defensebees[i].components.linearcircler.distance_limit = LIMIT
		inst.defensebees[i].components.linearcircler.setspeed = 0.05
		inst.defensebees[i].components.timer:StartTimer("natural_death", math.random(60, 75))
		inst.defensebees[i].components.entitytracker:TrackEntity("queen", inst)
		--inst.lavae[i].AnimState:PushAnimation("hover",true)
	end
end

local function SpawnDefensiveBees(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local LIMIT = 4
	if inst.defensebees then
		KillOffOldDefense(inst)
	end
	inst.defensebees = {}
	for i = 1, 8 do
		inst.defensebees[i] = SpawnPrefab("um_beeguard_blocker")
		if inst.prefab == "cherry_beequeen" then
			inst.defensebees[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
			inst.defensebees[i].AnimState:SetMultColour(1, 0.9, 0, 1)
		end
		inst.defensebees[i].queen = inst
		inst.defensebees[i].components.linearcircler:SetCircleTarget(inst)
		inst.defensebees[i].components.linearcircler:Start()
		inst.defensebees[i].components.linearcircler.randAng = i * 0.125 * 4 / 5
		inst.defensebees[i].components.linearcircler.clockwise = false
		inst.defensebees[i].components.linearcircler.distance_limit = LIMIT
		inst.defensebees[i].components.linearcircler.setspeed = 0
		inst.defensebees[i].components.timer:StartTimer("natural_death", math.random(60, 75))
		inst.defensebees[i].components.entitytracker:TrackEntity("queen", inst)
		--inst.lavae[i].AnimState:PushAnimation("hover",true)
	end
end

local function SpawnSeekerBees(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local rangeLIMIT = 3
	if not inst.seekerbees then
		inst.seekerbees = {}
	end
	local totalseekers
	if inst.components.health:GetPercent() < 0.5 then
		totalseekers = 12
	else
		totalseekers = 8
	end
	for i = 1, totalseekers do
		inst.seekerbees[i] = SpawnPrefab("um_beeguard_seeker")
		if inst.prefab == "cherry_beequeen" then
			inst.seekerbees[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
			inst.seekerbees[i].AnimState:SetMultColour(1, 0.33, 0.33, 1)
		end
		inst.seekerbees[i].queen = inst
		inst.seekerbees[i].components.linearcircler:SetCircleTarget(inst)
		inst.seekerbees[i].components.linearcircler:Start()
		inst.seekerbees[i].components.linearcircler.randAng = i * 1 / totalseekers
		inst.seekerbees[i].components.linearcircler.clockwise = false
		inst.seekerbees[i].components.linearcircler.distance_limit = rangeLIMIT
		inst.seekerbees[i].components.linearcircler.setspeed = 0.1
		inst.seekerbees[i].components.entitytracker:TrackEntity("queen", inst)
	end
end

local function SpawnSupport(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local LIMIT = 4
	inst.extrabees = {}
	local MAXBEES = 1
	local players = TheSim:FindEntities(x, y, z, 30, { "player" }, { "playerghost" })
	if inst.components.health and inst.components.health:GetPercent() < 0.5 then
		MAXBEES = 2 * #players
	elseif inst.components.health then
		MAXBEES = #players
	end
	for i = 1, MAXBEES do
		local beetype
		if inst.components.health and inst.components.health:GetPercent() < 0.5 then
			if math.random() < 0.25 then
				beetype = "um_beeguard_seeker"
			else
				beetype = "um_beeguard_shooter"
			end
		elseif inst.components.health then
			beetype = "um_beeguard_seeker"
		end
		inst.extrabees[i] = SpawnPrefab(beetype)
		if inst.prefab == "cherry_beequeen" then
			inst.extrabees[i].AnimState:SetBuild("cherry_bee_guard_puffy_build")
		end
		inst.extrabees[i].queen = inst
		inst.extrabees[i].components.linearcircler:SetCircleTarget(inst)
		inst.extrabees[i].components.linearcircler:Start()
		inst.extrabees[i].components.linearcircler.randAng = i * 1 / MAXBEES
		inst.extrabees[i].components.linearcircler.clockwise = false
		inst.extrabees[i].components.linearcircler.distance_limit = LIMIT
		inst.extrabees[i].components.linearcircler.setspeed = 0.1
		if beetype == "um_beeguard_shooter" then
			inst.extrabees[i].components.timer:StartTimer("natural_death", i + math.random(2, 3))
		end
		inst.extrabees[i].components.entitytracker:TrackEntity("queen", inst)
		--inst.lavae[i].AnimState:PushAnimation("hover",true)
	end
end

local function RedoSpawnguard_cd(inst)
	inst.spawnguards_threshold = 20 --threshhold is primarily related ot the spawn times rather than number of bees now...
	local x, y, z = inst.Transform:GetWorldPosition()
	local players = TheSim:FindEntities(x, y, z, 30, { "player" })
	local count = math.sqrt(#players) * 10
	local time = math.random(100, 120) - count
	if time < 10 then
		time = 10
	end
	--TheNet:Announce(time)
	return time
end

local function ShouldChase(inst) --All the cases that BQ shouldn't chase the player: Grumble bees are alive, shooter bees are alive, extra bees are alive (extra bees are shooter/seeker)
	local soldiers = inst.components.commander:GetAllSoldiers()
	if #soldiers > 0 then
		return false
	else
		if inst.shooterbees then
			for i, bee in ipairs(inst.shooterbees) do
				if bee.components.health and not bee.components.health:IsDead() then
					return false
				end
			end
		end
		if inst.extrabees then
			for i, bee in ipairs(inst.extrabees) do
				if bee.components.health and not bee.components.health:IsDead() then
					return false
				end
			end
		end
		if inst.shooterbeeline then
			for i, bee in ipairs(inst.shooterbeeline) do
				if bee.components.health and not bee.components.health:IsDead() then
					return false
				end
			end
		end
		return true
	end
end

local function HasWall(inst)
	if Wallcheck(inst) then
		return true
	else
		return false
	end
end

local PHASE2_HEALTH = .75
local PHASE3_HEALTH = .5
local PHASE4_HEALTH = .25

local function FinalFormation(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.components.timer:PauseTimer("spawnguards_cd")
		inst.sg:GoToState("spawnguards_shooter_line")
		inst.ffcount = inst.ffcount - 1
		if inst.ffdir then
			inst.ffdir = nil
		else
			inst.ffdir = true
		end
		local time = 3.5
		if inst.ffcount > 0 then
			inst:DoTaskInTime(time, FinalFormation)
		else
			inst:DoTaskInTime(time, function(inst)
				inst.components.timer:ResumeTimer("spawnguards_cd")
				inst.tiredcount = 15
				if inst.components.health and not inst.components.health:IsDead() then
					inst.sg:GoToState("tired_pre")
				end
			end)
		end
	end
end

local function Wallcheck(inst)
	if inst.defensebees then
		for i, bee in ipairs(inst.defensebees) do
			if bee.components.health and not bee.components.health:IsDead() then
				return true
			end
		end
	end
end

local function MakeSeekerHitlist(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		local x, y, z = inst.Transform:GetWorldPosition()
		local players = TheSim:FindEntities(x, y, z, 40, { "_combat" }, { "playerghost", "smallcreature", "bee", "beehive" })
		inst.seeker_hitlist = players
	end
end

local function SeekerBeesRage(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.abilitybusy = true
		inst.previousability = "seeker"
		inst:AddTag("doingability")
		MakeSeekerHitlist(inst)
		inst.components.timer:PauseTimer("spawnguards_cd")
		inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnguards_seeker_quick") end)
	end
end

local function ShooterBeesRage(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.abilitybusy = true
		inst.previousability = "shooter"
		inst:AddTag("doingability")
		local x, y, z = inst.Transform:GetWorldPosition()
		local targets = TheSim:FindEntities(x, y, z, 40, { "player" }, { "playerghost", "bee" })
		inst.shoottargets = targets
		inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnguards_shooter_circle") end)
	end
end

local function DoFinalFormation(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.abilitybusy = true
		inst.should_final = false
		inst.previousability = "final"
		inst.ffcount = 5
		FinalFormation(inst)
	end
end

local function ActivateHitAbility(inst)
	local pct = inst.components.health:GetPercent()

	--[[if inst.should_ability then
		TheNet:Announce(inst.previousability)
	end]]
	if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("spawnguards") and not inst.sg:HasStateTag("ability") and not inst.sg:HasStateTag("tired") then
		if pct > 0.75 then
			--Nothing.... for now. There are no post-spawn abilities at 100%-75%
		elseif pct > 0.5 then -------------------------------------------------------------------------------------------------
			if Wallcheck(inst) then
				inst.defensivespincount = inst.defensivespincount - 1
				if inst.defensivespincount < 1 then -- This is the only time this is really used.... in Wall Bees I bq can manually rotate the bees
					inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("defensive_spin") end)
				end
			else
				if inst.should_ability then --First ability
					inst.should_ability = nil
					SeekerBeesRage(inst)
				end
			end
		elseif pct > 0.25 then ----------------------------------------------------------------------------------------------------
			if inst.should_ability then
				inst.should_ability = nil
				--TheNet:Announce(inst.previousability)
				if inst.previousability == "shooter" then --Two abilities now
					SeekerBeesRage(inst)
				else
					ShooterBeesRage(inst)
				end
			end
		else --------------------------------------------------------------------------------------------------------------
			if inst.should_ability then --Three abilities now
				inst.should_ability = nil
				if inst.should_final and not inst.previousability == "final" then
					DoFinalFormation(inst)
				else
					if inst.previousability == "shooter" or (math.random() > 0.5 and inst.previousability == "final") then --If the previous thing was a shooter, roll by %chance instead
						SeekerBeesRage(inst)
					else
						ShooterBeesRage(inst)
					end
				end
			end
		end
	end
end

local function SpawnGuardsSeeker(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.previousguardability = "seeker"
		inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnguards_seeker") end)
	end
end

local function SpawnWalls(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.previousguardability = "wall"
		inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnguards_wall") end)
	end
end

local function SpawnGuardsShooters(inst)
	if inst.components.health and not inst.components.health:IsDead() then
		inst.previousguardability = "shooter"
		inst:DoTaskInTime(0, function(inst) inst.sg:GoToState("spawnguards_wall_shooter") end)
	end
end

local function PstSummonHandler(inst)
	inst.should_focus = true
	inst.should_ability = true
	inst.spawnguards_cd = RedoSpawnguard_cd(inst)
	local pct = inst.components.health:GetPercent()
	inst.should_ability = true
	if pct > 0.75 then
		SpawnGuardsSeeker(inst)
	elseif pct > 0.5 then
		if inst.previousguardability == "seeker" then
			SpawnWalls(inst)
		else
			SpawnGuardsSeeker(inst)
		end
	elseif pct > 0.25 then
		if inst.previousguardability == "seeker" then
			if math.random() > 0.5 then
				SpawnWalls(inst)
			else
				SpawnGuardsShooters(inst)
			end
		elseif inst.previousguardability == "wall" then
			if math.random() > 0.5 then
				SpawnGuardsSeeker(inst)
			else
				SpawnGuardsShooters(inst)
			end
		else
			if math.random() > 0.5 then
				SpawnWalls(inst)
			else
				SpawnGuardsSeeker(inst)
			end
		end
	else
		inst.bonuswall = true
		if inst.previousguardability == "seeker" then
			SpawnGuardsShooters(inst)
		else
			SpawnGuardsSeeker(inst)
		end
	end
end

local function BeeQueenPost(inst)
	inst.Physics:CollidesWith(COLLISION.FLYERS)

	--if inst.components.health ~= nil then
		--inst.components.health:SetMaxHealth(TUNING.DSTU.BEEQUEEN_HEALTH)
	--end

	inst:AddComponent("groundpounder") --Groundpounder is visual only
	inst.components.groundpounder.destroyer = true
	inst.components.groundpounder.damageRings = 0
	inst.components.groundpounder.destructionRings = 1
	inst.components.groundpounder.platformPushingRings = 2
	inst.components.groundpounder.numRings = 1
	inst:ListenForEvent("death", DisableThatStuff)
	--inst:ListenForEvent("death", ReleasebeeHolders)

	inst.stomprage = 0
	inst.stompready = true
	inst:DoPeriodicTask(3, StompRageCalmDown)
	inst:ListenForEvent("attacked", StompHandler)
	inst.spawnguards_cd = RedoSpawnguard_cd(inst)

	-- No more honey when attacking

	if inst.prefab == "cherry_beequeen" then
		local OnMissOther = UpvalueHacker.GetUpvalue(Prefabs.cherry_beequeen.fn, "OnMissOther")
		local OnAttackOther = UpvalueHacker.GetUpvalue(Prefabs.cherry_beequeen.fn, "OnAttackOther")

		inst:RemoveEventCallback("onattackother", OnAttackOther)
		inst:RemoveEventCallback("onareaattackother", OnAttackOther)
		inst:RemoveEventCallback("onmissother", OnMissOther)

		local function OnAttackOther(inst, data)
			if data.target ~= nil then
				if data.target.components.inventory ~= nil then
					for k, eslot in pairs(EQUIPSLOTS) do
						local equip = data.target.components.inventory:GetEquippedItem(eslot)
						if equip ~= nil and equip.components.resistance ~= nil and
							equip.components.resistance:HasResistance(inst) and
							equip.components.resistance:ShouldResistDamage() then
							return
						elseif equip ~= nil and equip.components.armor ~= nil and
							equip.components.armor:GetAbsorption(inst) >= 1 then
							return
						end
					end
				end
			end

			if data.target.components.debuffable == nil then
				data.target:AddComponent("debuffable")
			end
			if not data.target.components.health:IsInvincible() and data.target.components.debuffable ~= nil and
				data.target.components.debuffable:IsEnabled() ~= nil then
				local poison = data.target.components.debuffable:AddDebuff("cherry_beepoisonbuff", "cherry_beepoisonbuff")
				if poison ~= nil and poison.stacks then
					poison.stacks = poison.stacks == 0 and inst.flowerbuffs.poisonstacks or
						poison.stacks + (inst.flowerbuffs.poisonstacks * 0.5)
				end
			end
		end

		inst:ListenForEvent("onattackother", OnAttackOther)
		inst:ListenForEvent("onareaattackother", OnAttackOther)
	else
		local OnMissOther = UpvalueHacker.GetUpvalue(Prefabs.beequeen.fn, "OnMissOther")
		local OnAttackOther = UpvalueHacker.GetUpvalue(Prefabs.beequeen.fn, "OnAttackOther")
		inst:RemoveEventCallback("onattackother", OnAttackOther)
		inst:RemoveEventCallback("onmissother", OnMissOther)
	end

	inst.ShouldChase = ShouldChase
	inst.SpawnDefensiveBees = SpawnDefensiveBees
	inst.SpawnDefensiveBeesII = SpawnDefensiveBeesII
	inst.components.healthtrigger:AddTrigger(PHASE2_HEALTH, function(inst)
		--TheNet:Announce("2nd Phase")
		inst.should_ability = nil
		SeekerBeesRage(inst)
	end)
	inst.components.healthtrigger:AddTrigger(PHASE3_HEALTH, function(inst)
		--TheNet:Announce("3rd Phase")
		inst.should_ability = nil
		ShooterBeesRage(inst)
	end)
	inst.components.healthtrigger:AddTrigger(PHASE4_HEALTH, function(inst)
		--TheNet:Announce("4th Phase")
		inst.should_ability = nil
		--DoFinalFormation(inst)
	end)

	inst.SpawnSeekerBees = SpawnSeekerBees
	inst.seekercount = math.random(4, 5)
	inst.defensivespincount = math.random(3, 5)
	inst.spawnguards_threshold = 20
	inst.should_shooter_rage = 20

	inst.SpawnShooterBeesCircle = SpawnShooterBeesCircle
	inst.SpawnSupport = SpawnSupport
	inst.SpawnShooterBeesLine = SpawnShooterBeesLine
	inst.FinalFormation = FinalFormation
	inst.previousability = "I don't recall my ability"
	inst.previousguardability = "I don't recall my guards"
	inst.ActivateHitAbility = ActivateHitAbility
	inst.PstSummonHandler = PstSummonHandler

	inst.components.combat:SetAttackPeriod(TUNING.BEEQUEEN_ATTACK_PERIOD + 1)
	inst.components.combat:SetRange(TUNING.BEEQUEEN_ATTACK_RANGE, TUNING.BEEQUEEN_HIT_RANGE) --Tune her attack.

	inst.hasWall = HasWall


	inst.StartHoney = function(inst) end

	inst:DoPeriodicTask(10, function(inst)
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 20, { "epic" }, { "beequeen", "cherrybeequeen", "lordfruitfly" } )
		
		for i, v in pairs(ents) do
			if v ~= nil and v.components.combat ~= nil and v.components.combat.target ~= nil and v.components.combat.target == inst then
				inst:PushEvent("flee")
			end
		end

		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") and
			inst.components.combat and inst.components.combat.target and not ShouldChase(inst) then
			inst.sg:GoToState("lob")
		end
	end)
	
	inst:DoTaskInTime(0, function(inst) inst.StopHoney(inst) end)
end

env.AddPrefabPostInit("cherry_beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
	end


	BeeQueenPost(inst)
end)

env.AddPrefabPostInit("beequeen", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	BeeQueenPost(inst)
end)

local function OnTagTimer(inst, data)
	if data.name == "hivegrowth" then
		TheWorld:PushEvent("beequeenrespawned")
		if TheWorld.net ~= nil then
			TheWorld.net:RemoveTag("queenbeekilled")
		end

		SendModRPCToShard(GetShardModRPC("UncompromisingSurvival", "Hayfever_Start"), nil)
	end
end

env.AddPrefabPostInit("beequeenhive", function(inst)
	inst:AddTag("um_beequeenhive")

	if not TheWorld.ismastersim then
		return
	end

	inst:ListenForEvent("timerdone", OnTagTimer)
end)
