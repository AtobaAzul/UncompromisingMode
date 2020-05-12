local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnMoonMutate(inst, new_inst)
	new_inst.colonyNum = inst.colonyNum
end

local function OnFullMoon(self, inst, isfullmoon, new_inst)
	if TheWorld.state.isfullmoon and not self.components.health:IsDead() then
		self:DoTaskInTime(math.random(2,5), function(inst)
		local mspuff = SpawnPrefab("halloween_moonpuff")
		mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
			self.components.halloweenmoonmutable:Mutate()
			end)
	else
	--
	end

end

local function OnNonFullMoon(self, inst, isfullmoon, new_inst)
local node = TheWorld.Map:FindNodeAtPoint(self.Transform:GetWorldPosition())
	if node ~= nil and node.tags ~= nil and not table.contains(node.tags, "lunacyarea") and not TheWorld.state.isfullmoon and not self.components.health:IsDead() then
	self:DoTaskInTime(math.random(2,5), function(inst)
		local mspuff = SpawnPrefab("halloween_moonpuff")
		mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
			self.components.halloweenmoonmutable:Mutate()
			end)
	else
	
	end

end

local function MakeTeam(inst, attacker)
        local leader = SpawnPrefab("teamleader")
--print("<<<<<<<<================>>>>> Making TEAM:",attacker)
        leader:AddTag("penguin")
        leader.components.teamleader.threat = attacker
        leader.components.teamleader.radius = 10
        leader.components.teamleader:SetAttackGrpSize(5+math.random(1,3))
        leader.components.teamleader.timebetweenattacks = 0  -- first attack happens immediately
        leader.components.teamleader.attackinterval = 2  -- first attack happens immediately
        leader.components.teamleader.maxchasetime = 10
        leader.components.teamleader.min_team_size = 0
        leader.components.teamleader.max_team_size = 8
        leader.components.teamleader.team_type = inst.components.teamattacker.team_type
        leader.components.teamleader:NewTeammate(inst)
        leader.components.teamleader:BroadcastDistress(inst)
--print("<<<<<<<>>>>>")
end

local function NewRetarget(inst)

local icepuddle = FindEntity(inst, 15, nil, { "penguin_ice_puddle" })

	if icepuddle ~= nil then
	
		local newtarget = FindEntity(inst, 4, function(guy)
				return inst.components.combat:CanTarget(guy)
				end,
				nil,
				{"penguin","penguin_protection","the_mime"},
				{"character","monster","wall"}
				)

		local ta = inst.components.teamattacker
		if newtarget and ta and not ta.inteam and not ta:SearchForTeam() then
			--print("===============================MakeTeam on Retarget")
			MakeTeam(inst, newtarget)
		end

		if ta.inteam and not ta.teamleader:CanAttack() then
			return newtarget
		end
		
	else
	
		local ta = inst.components.teamattacker

		if inst.components.hunger and not inst.components.hunger:IsStarving() then
			return nil
		end

		local newtarget = FindEntity(inst, 3, function(guy)
				return inst.components.combat:CanTarget(guy)
				end,
				nil,
				{"penguin"},
				{"character","monster","wall"}
				)

		if newtarget and ta and not ta.inteam and not ta:SearchForTeam() then
			--print("===============================MakeTeam on Retarget")
			MakeTeam(inst, newtarget)
		end

		if ta.inteam and not ta.teamleader:CanAttack() then
			return newtarget
		end
		
	end

end

env.AddPrefabPostInit("penguin", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--inst:AddComponent("halloweenmoonmutable")
	if inst.components.halloweenmoonmutable ~= nil then
		inst.components.halloweenmoonmutable:SetPrefabMutated("mutated_penguin")
		inst.components.halloweenmoonmutable:SetOnMutateFn(OnMoonMutate)
	end
	
    inst.components.combat:SetRetargetFunction(2, NewRetarget)
	
	inst:WatchWorldState("isfullmoon", OnFullMoon)
	OnFullMoon(inst, TheWorld.state.isfullmoon)

end)

env.AddPrefabPostInit("mutated_penguin", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("penguin")
	inst.components.halloweenmoonmutable:SetOnMutateFn(OnMoonMutate)

	inst:WatchWorldState("isfullmoon", OnNonFullMoon)
	OnNonFullMoon(inst, TheWorld.state.isfullmoon)

end)