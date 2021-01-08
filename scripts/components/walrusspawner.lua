--------------------------------------------------------------------------
--[[ Dependencies ]]
--------------------------------------------------------------------------
local easing = require("easing")


--------------------------------------------------------------------------
--[[ BaseHassler class definition ]]
--------------------------------------------------------------------------
return Class(function(self, inst)

assert(TheWorld.ismastersim, "WalrusSpawner should not exist on client")

--------------------------------------------------------------------------
--[[ Public Member Variables ]]
--------------------------------------------------------------------------

self.inst = inst

--------------------------------------------------------------------------
--[[ Private Member Variables ]]
--------------------------------------------------------------------------

local _walrusdensity = 0.5 --This number is what % of nests in the world the moose will occupy.
local _seasonalcamps = nil

--------------------------------------------------------------------------
--[[ Private member functions ]]
--------------------------------------------------------------------------

local function FindCamps()
	local camps = {}

	for k,v in pairs(Ents) do
		if v.prefab == "walrus_camp_empty" then
			table.insert(camps, v)
		end
	end

	return camps
end

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------
function self:DoSoftSpawn(camp)
	--Spawn the camp
	camp.mooseIncoming = false
	local spawnpt = camp:GetPosition()
	local camp = SpawnPrefab("walrus_camp")
	camp.Transform:SetPosition(spawnpt:Get())

	camp.components.timer:StopTimer("CallMoose")
end

function self:DoHardSpawn(camp)

	camp.mooseIncoming = false

	local spawnpt = camp:GetPosition()

	local camp = SpawnPrefab("walrus_camp")
	camp.Transform:SetPosition(spawnpt:Get())
end

function self:InitializeNest(camp)
	camp.components.timer:StartTimer("CallMoose", 3)--TUNING.SEG_TIME * math.random(8, 24))
	camp.mooseIncoming = true
end

function self:InitializeNests()
	--print("MooseSpawner - InitializeNests")
	local camps = FindCamps()
	local num_to_spawn = math.ceil(#camps * _walrusdensity)
	_seasonalcamps = PickSome(num_to_spawn, camps)

	for _, camp in ipairs(_seasonalcamps) do
		self:InitializeNest(camp)
	end
end

local function OnWinterChange(inst, isWinter)
	if isWinter then
		self:InitializeNests()	
	end
end

inst:WatchWorldState("iswinter", OnWinterChange)

end)
