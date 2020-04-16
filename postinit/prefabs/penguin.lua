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

env.AddPrefabPostInit("penguin", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--inst:AddComponent("halloweenmoonmutable")
	if inst.components.halloweenmoonmutable ~= nil then
		inst.components.halloweenmoonmutable:SetPrefabMutated("mutated_penguin")
		inst.components.halloweenmoonmutable:SetOnMutateFn(OnMoonMutate)
	end
	
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