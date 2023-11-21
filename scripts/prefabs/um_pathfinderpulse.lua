-- Make sure to add your pulse types here.
local typelist = {
	"type_scan",
	"type_scanlunar",
	"type_scanshadow",
	"type_aurora"
}

local prefabs = {}
for _,v in pairs(typelist) do
	table.insert(prefabs, "um_pathfinderpulse_" .. v)
end


local function SetScale(inst)
	if inst.scalemod == nil then
		inst.scalemod = 1
	end
	if math.random() > 0.8 then
		inst.Transform:SetScale((math.random() * 0.5) + 0.8, (math.random() * 0.5) + 0.8, (math.random() * 0.5) + 0.8)
	else
		inst.Transform:SetScale((math.random() * 0.2) + 0.2, (math.random() * 0.2) + 0.2, (math.random() * 0.2) + 0.2)
	end
	
	local pulsescale = inst.Transform:GetScale() * inst.scalemod
	inst.Transform:SetScale(pulsescale, pulsescale, pulsescale)
end

local function SetTraits(inst)
	if inst.pulsetype == "type_scan" then
		local colormod = math.random() * 0.05
		inst.AnimState:SetMultColour(0.9 + colormod, 0.9 + colormod, 0.9 + colormod, 0.5)
		inst.scalemod = 0.3
	elseif inst.pulsetype == "type_scanlunar" then
		local colormod = math.random() * 0.05
		inst.AnimState:SetMultColour(0.6 + colormod, 0.95 + colormod, 0.9 + colormod, 0.8)
		inst.scalemod = 0.75
	elseif inst.pulsetype == "type_scanshadow" then
		inst.AnimState:SetMultColour(0, 0, 0, 0.4)
		inst.scalemod = 0.75
	elseif inst.pulsetype == "type_aurora" then
		local colormod = math.random() * 0.5
		inst.AnimState:SetMultColour(0, 0.3 + colormod, 0.8 - colormod, 0.5)
	-- If you're adding a new pulse type, put an elseif here.
	end
	
	SetScale(inst)
end

local function SpawnNextPulse(inst)
	if inst.pulsetarget ~= nil then
		local startpos = Vector3(inst.Transform:GetWorldPosition())
		local targetpos = Vector3(inst.pulsetarget.Transform:GetWorldPosition())
		local angle = GetRandomMinMax(-12.5, 12.5) * 0.01 + inst:GetAngleToPoint(targetpos.x, 0, targetpos.z)
		if angle > 1 then
			angle = angle - 1
		end
		local range = 0.25 * inst.scalemod
		local offset = FindWalkableOffset(startpos, angle, range, nil, true, true, nil, true, true)
		
		local pulsespawn = SpawnPrefab("um_pathfinderpulse_" .. inst.pulsetype)
		pulsespawn.Transform:SetPosition(startpos.x + offset.x, 0, startpos.z + offset.z)
		pulsespawn.pulsetarget = inst.pulsetarget
		pulsespawn.pulsenumber = inst.pulsenumber + 1
	end
end

local function ContinuePath(inst)
	if inst.pulsenumber == nil then
		inst.pulsenumber = 1
	else
		inst.pulsenumber = inst.pulsenumber + 1
	end
	
	if inst.pulsenumber < 100 then -- Number of pulse prefabs that can be spawned in one chain.
		SpawnNextPulse(inst)
	end
end


local function TypeSpawner(name, SpawnType)
	local SpawnType = SpawnType or "type_scan"
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		inst:AddTag("NOCLICK")
		
		inst.pulsetype = SpawnType
		
		inst.AnimState:SetBank("um_pathfinderpulse")
		inst.AnimState:SetBuild("um_pathfinderpulse")
		inst.AnimState:PlayAnimation("pulse")
		inst.AnimState:SetLightOverride(1)
		
		SetTraits(inst)
		
		inst:ListenForEvent("animover", inst.Remove)
		
		inst:AddTag("scarytoprey")
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end	
		
		
		inst:DoTaskInTime(0.025, ContinuePath)
		
		inst.persists = false
		
		return inst
	end
	
	return Prefab(name, fn, nil, prefabs)
end



---------------------------
--- BEGIN TESTING STICK ---
---------------------------
-- This function spawns the initial pulse.
local function testingstick_SpawnPulse(inst, owner)
	if owner ~= nil then
		local startpos = Vector3(owner.Transform:GetWorldPosition())
		
		local pulsetargets = TheSim:FindEntities(startpos.x, 0, startpos.z, 120, { "moonbase" }) -- A pulse 'chain' will path toward each nearby prefab with this tag.
		for i, pulsetarget in ipairs(pulsetargets) do
			if pulsetarget ~= inst and pulsetarget.entity:IsVisible() then
				local pulsetype = "type_aurora" -- The type (color) of pulse to spawn.
				
				local pulsespawn = SpawnPrefab("um_pathfinderpulse_" .. pulsetype)
				pulsespawn.Transform:SetPosition(startpos.x, 0, startpos.z)
				pulsespawn.pulsetarget = pulsetarget
			end
		end
	end
end

local function testingstick_OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_um_staff_meteor", "swap_um_staff_meteor")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
	
	-- Start the periodic pulses.
	if inst.PulsingTask == nil then
		inst.PulsingTask = inst:DoPeriodicTask(4.5, testingstick_SpawnPulse, 1, owner)
	end
end

local function testingstick_OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	
	-- Stop the periodic pulses.
	if inst.PulsingTask ~= nil then
		inst.PulsingTask:Cancel()
		inst.PulsingTask = nil
	end
end

local function testingstick_fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("um_staff_meteor")
	inst.AnimState:SetBuild("um_staff_meteor")
	inst.AnimState:PlayAnimation("idle")
	
	local floater_swap_data = {
		sym_build = "um_staff_meteor",
		sym_name = "um_staff_meteor",
		bank = "um_staff_meteor",
		anim = "idle"
	}
	
	MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.4, 1.1}, true, -19, floater_swap_data)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "um_staff_meteor"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/um_staff_meteor.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(testingstick_OnEquip)
	inst.components.equippable:SetOnUnequip(testingstick_OnUnequip)
	
	MakeHauntableLaunch(inst)
	
	return inst
end
-------------------------
--- END TESTING STICK ---
-------------------------



-- If you added your new pulse type to the 'typelist' table at the top of this file, you don't need to do anything below this line.
-- The prefab will build itself.
local pathfinderpulse_prefabs = {}
for _,v in pairs(typelist) do
	table.insert(pathfinderpulse_prefabs, TypeSpawner("um_pathfinderpulse_" .. v, v))
end
table.insert(pathfinderpulse_prefabs, Prefab("um_pathfinderpulse_testingstick", testingstick_fn))

return unpack(pathfinderpulse_prefabs)
