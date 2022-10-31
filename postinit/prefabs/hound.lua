local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local sounds =
{
    pant = "dontstarve/creatures/hound/pant",
    attack = "dontstarve/creatures/hound/attack",
    bite = "dontstarve/creatures/hound/bite",
    bark = "dontstarve/creatures/hound/bark",
    death = "dontstarve/creatures/hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "dontstarve/creatures/hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
    hurt = "dontstarve/creatures/hound/hurt",
}

local sounds_mutated =
{
    pant = "turnoftides/creatures/together/mutated_hound/pant",
    attack = "turnoftides/creatures/together/mutated_hound/attack",
    bite = "turnoftides/creatures/together/mutated_hound/bite",
    bark = "turnoftides/creatures/together/mutated_hound/bark",
    death = "turnoftides/creatures/together/mutated_hound/death",
    sleep = "dontstarve/creatures/hound/sleep",
    growl = "turnoftides/creatures/together/mutated_hound/growl",
    howl = "dontstarve/creatures/together/clayhound/howl",
    hurt = "turnoftides/creatures/together/mutated_hound/hurt",
}

local function OnFullMoon(self, inst, isfullmoon, new_inst)
	
	local node = TheWorld.Map:FindNodeAtPoint(self.Transform:GetWorldPosition())

	if TheWorld.state.isfullmoon and not self.components.health:IsDead() then
		self:DoTaskInTime(math.random(2,5), function(inst)
		local mspuff = SpawnPrefab("halloween_moonpuff")
		mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
			inst:AddTag("horrorhound")
			inst.AnimState:SetBank("hound")
			inst.AnimState:SetBuild("hound_mutated")
			inst.sounds = sounds_mutated
			inst.components.combat:SetHurtSound(inst.sounds.hurt)
			inst.components.lootdropper:SetChanceLootTable('mutatedhound')
			inst.components.locomotor.runspeed = TUNING.MOONHOUND_SPEED * 1.2
			inst.sg:GoToState("taunt")
		end)
	elseif node ~= nil and node.tags ~= nil and not table.contains(node.tags, "lunacyarea") and not self.components.health:IsDead() then
		self:DoTaskInTime(math.random(2,5), function(inst)
			if inst:HasTag("horrorhound") then
				local mspuff = SpawnPrefab("halloween_moonpuff")
				mspuff.Transform:SetPosition(self.Transform:GetWorldPosition())
				inst:RemoveTag("horrorhound")
				
				inst.AnimState:SetBank("hound")
				inst.AnimState:SetBuild("hound_ocean")
				inst.sounds = sounds
				inst.components.combat:SetHurtSound(inst.sounds.hurt)
				inst.components.lootdropper:SetChanceLootTable('hound')
				inst.components.locomotor.runspeed = TUNING.HOUND_SPEED
				inst.sg:GoToState("taunt")
			end
		end)
	end

end
--[[
if TUNING.DSTU.MOON_TRANSFORMATIONS then
	env.AddPrefabPostInit("hound", function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:WatchWorldState("isfullmoon", OnFullMoon)
		OnFullMoon(inst, TheWorld.state.isfullmoon)

	end)
end]]