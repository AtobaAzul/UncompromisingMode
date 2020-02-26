local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

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

env.AddPrefabPostInit("hound", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("mutatedhound")

	inst:WatchWorldState("isfullmoon", OnFullMoon)
	OnFullMoon(inst, TheWorld.state.isfullmoon)

end)