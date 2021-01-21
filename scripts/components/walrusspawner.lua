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
		if v.prefab == "walrus_camp" then
			table.insert(camps, v)
		end
	end

	return camps
end

--------------------------------------------------------------------------
--[[ Public member functions ]]
--------------------------------------------------------------------------


function self:InitializeNest(camp)
camp.chosen = true
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
local function OnSpringChange(inst, isSpring)
	if isSpring then
	local camps = FindCamps()
	for _, camp in ipairs(camps) do
		camp.chosen = false
	end	
	end	
end
inst:WatchWorldState("isspring", OnSpringChange)
inst:WatchWorldState("iswinter", OnWinterChange)

end)
