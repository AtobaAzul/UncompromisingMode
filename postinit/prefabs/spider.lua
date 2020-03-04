local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function HalloweenMoonMutate(inst, new_inst)
	local leader = inst ~= nil and inst.components.follower ~= nil
		and new_inst ~= nil and new_inst.components.follower ~= nil
		and inst.components.follower:GetLeader()
		or nil

	if leader ~= nil then
		new_inst.components.follower:SetLeader(leader)
		new_inst.components.follower:AddLoyaltyTime(
			inst.components.follower:GetLoyaltyPercent()
			* (new_inst.components.follower.maxfollowtime or inst.components.follower.maxfollowtime)
		)
	end
end

local function OnFullMoon(self, inst, isfullmoon, new_inst)
	if TheWorld.state.isfullmoon then
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
	if not TheWorld.state.isfullmoon then
		self:DoTaskInTime(math.random(2,5), function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, 40, { "moonspiderden" })
			
			if not inst.components.areaaware:CurrentlyInTag("lunacyarea") and #ents < 1 then
				local mspuff = SpawnPrefab("halloween_moonpuff")
				mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
				self.components.halloweenmoonmutable:Mutate()
			end
		end)
	else
	
	end

end

env.AddPrefabPostInit("spider", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("spider_moon")
	inst.components.halloweenmoonmutable:SetOnMutateFn(HalloweenMoonMutate)

	inst:WatchWorldState("isfullmoon", OnFullMoon)
	OnFullMoon(inst, TheWorld.state.isfullmoon)

end)

env.AddPrefabPostInit("spider_moon", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:AddComponent("areaaware")
    inst.components.areaaware:SetUpdateDist(2)
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("spider")
	inst.components.halloweenmoonmutable:SetOnMutateFn(HalloweenMoonMutate)

	inst:WatchWorldState("isfullmoon", OnNonFullMoon)
	OnNonFullMoon(inst, TheWorld.state.isfullmoon)

end)