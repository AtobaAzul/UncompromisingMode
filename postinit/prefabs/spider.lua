local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

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
	
	if inst.components.combat ~= nil then
    inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE, TUNING.SPIDER_WARRIOR_HIT_RANGE)
		--inst.components.combat:SetRetargetFunction(2, WarriorRetarget)
	end
	
	if inst.components.locomotor ~= nil then
		inst.components.locomotor.walkspeed = TUNING.SPIDER_WARRIOR_WALK_SPEED
		inst.components.locomotor.runspeed = TUNING.SPIDER_WARRIOR_RUN_SPEED
	end
	
	inst:WatchWorldState("isfullmoon", OnFullMoon)
	OnFullMoon(inst, TheWorld.state.isfullmoon)

	inst.DoSpikeAttack = DoSpikeAttack
end)
env.AddPrefabPostInit("spider_warrior", function(inst)
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
    inst.components.health:SetMaxHealth(300)
	inst.sg:GoToState("taunt")
end)
env.AddPrefabPostInit("spider_dropper", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	inst.sg:GoToState("taunt")
end)