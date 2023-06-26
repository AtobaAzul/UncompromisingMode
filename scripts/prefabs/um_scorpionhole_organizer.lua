local function on_save(inst, data)

end

local function on_load(inst, data)

end

local function CalculateNextHoleTime(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local scorpionHoles = #TheSim:FindEntities(x, y, z, 30, { "scorpionhole" })
	local timermult = 8 * 60 * 10 + 8 * 60 * 2 * scorpionHoles
	inst.components.timer:StartTimer("moreden", timermult)
end

local function IsOcean(x, y, z)
	return not TheWorld.Map:IsVisualGroundAtPoint(x, y, z)
end


local function Init(inst)
	if not inst.components.timer:TimerExists("moreholes") then
		CalculateNextHoleTime(inst)
	end
	--TheNet:Announce("Init")
	if TheWorld.components.UM_scorpionholes and TheWorld.components.UM_scorpionholes.homesites then
		local i_am_in_table = false
		for i, v in ipairs(TheWorld.components.UM_scorpionholes.homesites) do
			if inst == v then
				i_am_in_table = true
			end
		end
		if i_am_in_table ~= true then
			--TheNet:Announce("Added myself to table")
			table.insert(TheWorld.components.UM_scorpionholes.homesites, inst)
		end
	else
		TheNet:Announce("something wasn't right...")
	end
end

local function GetHoleSpot(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local mult = 0
	if #TheSim:FindEntities(x, y, z, 10, { "scorpionhole" }) > 2 then
		mult = 1
	end
	if #TheSim:FindEntities(x, y, z, 20, { "scorpionhole" }) > 3 then
		mult = 2
	end
	local x1 = math.random(10 * (mult), 10 * 4)
	local z1 = math.random(10 * (mult), 10 * 4)
	if math.random() > 0.5 then
		x1 = -x1
	end
	if math.random() > 0.5 then
		z1 = -z1
	end
	x1 = x + x1
	z1 = z + z1
	if (#TheSim:FindEntities(x1, y, z1, 7, { "scorpionhole" }) == 0 or inst.failsafe > 5) and TheWorld.Map:IsVisualGroundAtPoint(x1, y, z1) then
		return x1, y, z1
	else
		inst.failsafe = inst.failsafe + 1
		return GetHoleSpot(inst)
	end
end

local function DigHole(inst)
	inst.failsafe = 0
	local x, y, z = GetHoleSpot(inst)
	SpawnPrefab("um_scorpionhole").Transform:SetPosition(x, y, z)
	SpawnPrefab("sinkhole_warn_fx_" .. math.random(3)).Transform:SetPosition(x, y, z)
	SpawnPrefab("sinkhole_warn_fx_" .. math.random(3)).Transform:SetPosition(x + math.random(-0.5, 0.5), y,
		z + math.random(-0.5, 0.5))
	SpawnPrefab("sinkhole_warn_fx_" .. math.random(3)).Transform:SetPosition(x + math.random(-0.5, 0.5), y,
		z + math.random(-0.5, 0.5))
	SpawnPrefab("sinkhole_warn_fx_" .. math.random(3)).Transform:SetPosition(x + math.random(-0.5, 0.5), y,
		z + math.random(-0.5, 0.5))
	--CalculateNextHoleTime(inst)
end

local function CreateScorpzone(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local angle = nil
	local radius = nil
	for i = 1, 4 do
		radius = math.random(12, 16)
		angle = i / 2 * PI + math.random(-PI / 8, PI / 8)
		local x1 = x + radius * math.cos(angle)
		local z1 = z + radius * math.sin(angle)

		SpawnPrefab("umss_scorpionoutskirts" .. math.random(1, 4)).Transform:SetPosition(x1, y, z1)
	end
	SpawnPrefab("umss_scorpioncenter1").Transform:SetPosition(x, y, z)
end

local function SummerDigging(inst)
	if TheWorld.state.issummer then
		local x, y, z = inst.Transform:GetWorldPosition()
		local scorpionHoles = TheSim:FindEntities(x, y, z, 30, { "scorpionhole" })
		if scorpionHoles ~= nil and #scorpionHoles < 3 then
			for i = 1, (3 - #scorpionHoles) do
				DigHole(inst)
			end
		end
	end
end

local function scorpionhole_organizer_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddNetwork()


	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end



	inst.OnSave = on_save
	inst.OnLoad = on_load

	inst:AddComponent("timer")
	--inst:DoTaskInTime(0,Init)
	inst.CalculateNextHoleTime = CalculateNextHoleTime
	inst:ListenForEvent("timerdone", DigHole)
	inst.failsafe = 0

	if not TUNING.DSTU.DESERTSCORPIONS then
		inst:Remove()
	end

	inst.CreateScorpzone = CreateScorpzone
	inst:WatchWorldState("issummer", SummerDigging)
	--inst:DoTaskInTime(0,CreateScorpzone)

	return inst
end

return Prefab("um_scorpionhole_organizer", scorpionhole_organizer_fn)
