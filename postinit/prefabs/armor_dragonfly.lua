local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSave(inst, data)
data.lavaecond1 = inst.lavaecond1
data.lavaecond2 = inst.lavaecond2
data.lavaecond3 = inst.lavaecond3
data.owner = inst.owner
end

local function OnLoad(inst, data)
if data ~= nil then
	if data.lavaecond1 ~= nil then
	inst.lavaecond1 = data.lavaecond1
	end
	if data.lavaecond2 ~= nil then
	inst.lavaecond2 = data.lavaecond2
	end
	if data.lavaecond3 ~= nil then
	inst.lavaecond3 = data.lavaecond3
	end
	if data.owner ~= nil then
	inst.owner = data.owner
	end
end
end

local function InitializeLavae(inst,owner)
if inst.lavaecond1 == nil then
inst.lavaecond1 = "alive"
end
if inst.lavaecond2 == nil then
inst.lavaecond2 = "alive"
end
if inst.lavaecond3 == nil then
inst.lavaecond3 = "alive"
end
end

local function OneDead(inst)
inst.lavaecond1 = "dead"
inst.lavae1 = nil
inst.components.timer:StartTimer("1revive", 10)
end
local function TwoDead(inst)
inst.lavaecond2 = "dead"
inst.lavae2 = nil
inst.components.timer:StartTimer("2revive", 10)
end
local function ThreeDead(inst)
inst.lavaecond3 = "dead"
inst.lavae3 = nil
inst.components.timer:StartTimer("3revive", 10)
end


local function newonequip(inst, owner)
inst.owner = owner

InitializeLavae(inst,owner)
local x,y,z = owner.Transform:GetWorldPosition()
if inst.lavaecond1 == "alive" then
local lavae1 = SpawnPrefab("armorlavae")
lavae1.number = 1
lavae1.Transform:SetPosition(x,y,z)
inst.lavae1 = lavae1
owner.components.leader:AddFollower(lavae1)
lavae1.components.follower.leader = owner
else

end
if inst.lavaecond2 == "alive" then
local lavae2 = SpawnPrefab("armorlavae")
lavae2.number = 2
lavae2.Transform:SetPosition(x,y,z)
inst.lavae2 = lavae2
owner.components.leader:AddFollower(lavae2)
lavae2.components.follower.leader = owner
else

end
if inst.lavaecond3 == "alive" then
local lavae3 = SpawnPrefab("armorlavae")
lavae3.number = 3
lavae3.Transform:SetPosition(x,y,z)
inst.lavae3 = lavae3
owner.components.leader:AddFollower(lavae3)
lavae3.components.follower.leader = owner
else

end
end

local function newonunequip(inst, owner)
if inst.owner ~= nil then
inst.owner = nil
end
if inst.lavae1 ~= nil then
inst.lavae1:Remove()
inst.lavae1 = nil
end
if inst.lavae2 ~= nil then
inst.lavae2:Remove()
inst.lavae2 = nil
end
if inst.lavae3 ~= nil then
inst.lavae3:Remove()
inst.lavae3 = nil
end

end

local function OnTimerDone(inst,data)
if data ~= nil then
	if data.name == "1revive" then
	inst.lavae1 = "alive"
		if inst.owner ~= nil then
			local owner = inst.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local lavae1 = SpawnPrefab("armorlavae")
			lavae1.number = 1
			lavae1.Transform:SetPosition(x,y,z)
			inst.lavae1 = lavae1
			owner.components.leader:AddFollower(lavae1)
			lavae1.components.follower.leader = owner
		end
	end
	if data.name == "2revive" then
	inst.lavae2 = "alive"
		if inst.owner ~= nil then
			local owner = inst.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local lavae2 = SpawnPrefab("armorlavae")
			lavae2.number = 2
			lavae2.Transform:SetPosition(x,y,z)
			inst.lavae2 = lavae2
			owner.components.leader:AddFollower(lavae2)
			lavae2.components.follower.leader = owner
		end	
	end
	if data.name == "3revive" then
	inst.lavae3 = "alive"
		if inst.owner ~= nil then
			local owner = inst.owner
			local x,y,z = owner.Transform:GetWorldPosition()
			local lavae3 = SpawnPrefab("armorlavae")
			lavae3.number = 1
			lavae3.Transform:SetPosition(x,y,z)
			inst.lavae3 = lavae3
			owner.components.leader:AddFollower(lavae3)
			lavae3.components.follower.leader = owner
		end	
	end
end
end
env.AddPrefabPostInit("armordragonfly", function(inst)


	if not TheWorld.ismastersim then
		return
	end
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	local oldequipfn = inst.components.equippable.onequipfn
	local oldunequipfn = inst.components.equippable.onunequipfn
	
	local function CombinedEquip(inst,owner)
	newonequip(inst, owner)
	oldequipfn(inst,owner)
	end
	
	local function CombinedUnequip(inst,owner)
	newonunequip(inst, owner)
	oldunequipfn(inst,owner)
	end
	
    inst.components.equippable:SetOnEquip(CombinedEquip)
    inst.components.equippable:SetOnUnequip(CombinedUnequip)
	
	inst.components.armor:InitCondition(1500, 0.6)
	
	inst.OneDead = OneDead
	inst.TwoDead = TwoDead
	inst.ThreeDead = ThreeDead
	
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
	
end)