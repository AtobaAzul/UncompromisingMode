local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local EFFECTS =
{
    hot = "dr_hot_loop",
    warmer = "dr_warmer_loop",
    warm = "dr_warm_loop_2",
    cold = "dr_warm_loop_1",
}

local SPIDER_DIVINING_DISTANCES =
        {
            {maxdist=10, describe="hot", pingtime=1},
            {maxdist=15, describe="warmer", pingtime=2},
            {maxdist=20, describe="warm", pingtime=3},
            {maxdist=30, describe="cold", pingtime=5},
        }
		
local SPIDER_DIVINING_MAXDIST = 30000
local SPIDER_DIVINING_DEFAULTPING = 3

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
    --if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner then
		inst.SoundEmitter:KillSound("ping")
        local intensity = 0
        local closeness = nil
        local fxname = nil
        local target = FindClosestPart(inst)
        local nextpingtime = SPIDER_DIVINING_DEFAULTPING
        if target ~= nil then
            local distsq = inst:GetDistanceSqToInst(target)
			
			if distsq < 50 then
				intensity = 1
			elseif distsq < 80 and distsq >= 50 then
				intensity = 0.8
			elseif distsq < 120 and distsq >= 80 then
				intensity = 0.6
			elseif distsq < 150 and distsq >= 120 then
				intensity = 0.4
			else
				intensity = 0.2
			end
            --intensity = math.max(0, 1 - (distsq/(SPIDER_DIVINING_MAXDIST*SPIDER_DIVINING_MAXDIST) ))
            for k,v in ipairs(SPIDER_DIVINING_DISTANCES) do
                closeness = v
                fxname = EFFECTS[v.describe]

                if v.maxdist and distsq <= v.maxdist*v.maxdist then
                    nextpingtime = closeness.pingtime
                    break
                end
            end
        end


        if fxname ~= nil then
            --Don't care if there is still a reference to previous fx...
            --just let it finish on its own and remove itself
            inst.fx = SpawnPrefab(fxname)
            inst.fx.entity:SetParent(inst.entity)
        end

        --inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping")
        inst.SoundEmitter:PlaySound("dontstarve/common/diviningrod_ping", "ping")
        inst.SoundEmitter:SetParameter("ping", "intensity", intensity)
		inst.task:Cancel()
		inst.task = nil
		if not inst.components.health:IsDead() then
			inst.task = inst:DoTaskInTime(nextpingtime or 1, CheckTargetPiece)
		end
        --inst.alarmtask = inst:DoTaskInTime(2, CheckTargetPiece)
    --end 
end


local function GenerateSpiralSpikes(inst)
    local spawnpoints = {}
    local source = inst
    local x, y, z = source.Transform:GetWorldPosition()
    local spacing = 2
    local radius = 5
    local deltaradius = .2
    local angle = 2 * PI * math.random()
    local deltaanglemult = (inst.reversespikes and -2 or 2) * PI * spacing
    inst.reversespikes = not inst.reversespikes
    local delay = 0
    local deltadelay = 2 * FRAMES
    local num = 16
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
				
				spike:WatchWorldState("isday", function()
					spike:DoTaskInTime(0.5 + math.random(), function(spike)
						local despawnfx = SpawnPrefab("shadow_despawn")
						despawnfx.Transform:SetPosition(spike.Transform:GetWorldPosition())
						spike.AnimState:PlayAnimation("shrink")
						spike:ListenForEvent("animover", spike.Remove)
					end)
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
            inst:DoTaskInTime(v.t, DoSpawnSpikes, v.pts, v.level, cache)
        end

    end
end

local function onnear(inst, target)
    SpawnSpikes(target)
end








local variations = {1, 2, 3, 4, 5}

local function DoSpikeAttack(inst, pt)
	local x, y, z = pt:Get()
	local inital_r = 1
	x = GetRandomWithVariance(x, inital_r)
	z = GetRandomWithVariance(z, inital_r)

	shuffleArray(variations)

	local num = math.random(2, 4)
    local dtheta = PI * 2 / num
    local thetaoffset = math.random() * PI * 2
    local delaytoggle = 0
	for i = 1, num do
		local r = 1.1 + math.random() * 1.75
		local theta = i * dtheta + math.random() * dtheta * 0.8 + dtheta * 0.2
        local x1 = x + r * math.cos(theta)
        local z1 = z + r * math.sin(theta)
        if TheWorld.Map:IsVisualGroundAtPoint(x1, 0, z1) and not TheWorld.Map:IsPointNearHole(Vector3(x1, 0, z1)) then
            local spike = SpawnPrefab("minimoonspider_spike")
            spike.Transform:SetPosition(x1, 0, z1)
			spike:SetOwner(inst)
			if variations[i + 1] ~= 1 then
				spike.AnimState:OverrideSymbol("spike01", "spider_spike", "spike0"..tostring(variations[i + 1]))
			end
        end
    end
end

local function OnFullMoon(self, inst, isfullmoon)

	local node = TheWorld.Map:FindNodeAtPoint(self.Transform:GetWorldPosition())

	if TheWorld.state.isfullmoon and not self.sg:HasStateTag("jumping") and not self.components.health:IsDead() then
		self:DoTaskInTime(math.random(2,5), function(inst)
		local mspuff = SpawnPrefab("halloween_moonpuff")
		mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
			--self.components.halloweenmoonmutable:Mutate()
			inst:AddTag("spider_moon")
			inst:RemoveTag("spider_regular")	
			inst.AnimState:SetBank("spider_moon")
			inst.AnimState:SetBuild("DS_spider_moon")
			
			inst.sg:GoToState("taunt")
			end)
	elseif node ~= nil and node.tags ~= nil and not table.contains(node.tags, "lunacyarea") and not self.sg:HasStateTag("jumping") and not self.components.health:IsDead() then
		
		self:DoTaskInTime(math.random(2,5), function(inst)
			if inst:HasTag("spider_moon") then
				local mspuff = SpawnPrefab("halloween_moonpuff")
				mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
				inst:RemoveTag("spider_moon")
				inst:AddTag("spider_regular")
				inst.AnimState:SetBank("spider")
				inst.AnimState:SetBuild("spider_build")
				
				inst.sg:GoToState("taunt")
			end
		end)
	end

end

local function FindTarget(inst, radius)
    return FindEntity(
        inst,
        SpringCombatMod(radius),
        function(guy)
            return (not guy:HasTag("monster") or guy:HasTag("player"))
                and inst.components.combat:CanTarget(guy)
                and not (inst.components.follower ~= nil and inst.components.follower.leader == guy)
        end,
        { "_combat", "character" },
        { "spiderwhisperer", "spiderdisguise", "INLIMBO" }
    )
end
--[[
local function WarriorRetarget(inst)
    return FindTarget(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST)
end--]]

env.AddPrefabPostInit("spider", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	--[[
	inst:RemoveComponent("lootdropper")
	
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("monstermorsel", 1)
    inst.components.lootdropper:AddRandomLoot("silk", .5)
    inst.components.lootdropper:AddRandomLoot("spidergland", .5)
    inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
    inst.components.lootdropper.numrandomloot = 1
	--]]
	inst:AddTag("spider_regular")
	
	if inst.components.combat ~= nil and TUNING.DSTU.REGSPIDERJUMP then
        inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE*0.5, TUNING.SPIDER_WARRIOR_HIT_RANGE*0.8)
		--inst.components.combat:SetRetargetFunction(2, WarriorRetarget)
	end
	
	if inst.components.locomotor ~= nil and TUNING.DSTU.REGSPIDERJUMP then --I don't know if this actually does anything, I'm just adding config in JIC -AXE
		inst.components.locomotor.walkspeed = TUNING.SPIDER_WARRIOR_WALK_SPEED
		inst.components.locomotor.runspeed = TUNING.SPIDER_WARRIOR_RUN_SPEED
	end
	
   --[[ inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 13) --set specific values
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetPlayerAliveMode(inst.components.playerprox.AliveModes.AliveOnly)]]
	
	if TUNING.DSTU.MOON_TRANSFORMATIONS then
		inst:WatchWorldState("isfullmoon", OnFullMoon)
		OnFullMoon(inst, TheWorld.state.isfullmoon)
	end
	
    --inst.task = inst:DoTaskInTime(3, CheckTargetPiece)

	inst.DoSpikeAttack = DoSpikeAttack
	
	inst:AddComponent("tradable") -- For Moondial Mutation.
end)

SetSharedLootTable( 'spider_warrior',
{
    {'monstermeat',  1.00},
})

env.AddPrefabPostInit("spider_warrior", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:RemoveComponent("lootdropper")
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("silk", 1)
    inst.components.lootdropper:AddRandomLoot("spidergland", 1)
    inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
    inst.components.lootdropper.numrandomloot = 1
	inst.components.lootdropper:SetChanceLootTable('spider_trapdoor')
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE * 1.05)
	end
	
	if inst.components.health ~= nil and TUNING.DSTU.SPIDERWARRIORCOUNTER then
		inst.components.health:SetMaxHealth(300)
	end
	
	inst:AddComponent("tradable") -- For Moondial Mutation.
end)

env.AddPrefabPostInit("spider_dropper", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE * 1.05)
	end
	
end)