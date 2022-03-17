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

local function OnNonFullMoon(inst, isfullmoon)
	local node = TheWorld.Map:FindNodeAtPoint(inst.Transform:GetWorldPosition())
	
	if node ~= nil and node.tags ~= nil and not table.contains(node.tags, "lunacyarea") and not TheWorld.state.isfullmoon and not inst.components.health:IsDead() then
		inst:DoTaskInTime(math.random(2,5), function(inst)
			local mspuff = SpawnPrefab("halloween_moonpuff")
			mspuff.Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.components.halloweenmoonmutable:Mutate()
		end)
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

local function OnExplodeFn(inst)
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function Ricexplosion(inst, item)
	inst:AddComponent("explosive")
	inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
	inst.components.explosive.explosiverange = 1
	inst.components.explosive.explosivedamage = 0
	inst.components.explosive:OnBurnt()
end

local function OnEat(inst, data)
	if data.food.components.edible and math.random() < .2 then
        local poo = SpawnPrefab("guano")
        poo.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
	
	if data.food.prefab == "rice" or data.food.prefab == "rice_cooked" then
        inst:DoTaskInTime(1, function(inst) inst.sg:GoToState("taunt") end)
		
        inst:DoTaskInTime(2, Ricexplosion)
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
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetRetargetFunction(2, NewRetarget)
	end

	if TUNING.DSTU.MOON_TRANSFORMATIONS then
		inst:WatchWorldState("isfullmoon", OnFullMoon)
		OnFullMoon(inst, TheWorld.state.isfullmoon)
	end

	inst:ListenForEvent("oneat", OnEat)
end)

env.AddPrefabPostInit("mutated_penguin", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("penguin")
	inst.components.halloweenmoonmutable:SetOnMutateFn(OnMoonMutate)

	--inst:WatchWorldState("isfullmoon", OnNonFullMoon)
	--OnNonFullMoon(inst, TheWorld.state.isfullmoon)

end)
