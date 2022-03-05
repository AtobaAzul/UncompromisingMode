local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local tiny =	--Tiny items are pretty much just reserved for eating ingredients... almost always a waste
{
	"honey", -- -1
	"redcap", -- -1
	"pepper", -- -9
	"rice_cooked", -- -1
}

local low =		--Honey Items and meaty stew are cheap... but they might be just enough to pass you by in a pollen-low environment. But not enough to provide significant impact.
{	
	"honeynuggets", -- -9
	"honeyham", -- -9
	"bonestew", -- -9
}

local lowmed =		--Low-Medium items are things like stinger, chili, and soups. Slightly more hefty than honey items... as they take considerably more effort to make. But also take longer to generate.
{
	"vegstinger", -- -18
	"asparagussoup", -- -18
	"lobsterbisque", -- -18
	"seafoodgumbo", -- -18
	"hotchili", -- -18
}

local med =		--Medium is reserved for special-case items like stuffed pepper poppers, and any other dish that is fit to be above the lowmed group
{
	"pepperpopper", -- -36 slower
	"mandrakesoup", -- -36 faster
}

local high =		--High Group is reserved for rice and cali king.
{
	"liceloaf", -- -50 faster
	"seafoodpaella", -- -75 slower
	"californiaking", -- -100 slower
}

local function MakeHayfeverFood(inst)
	if inst.components.edible and inst.components.edible.oneaten then
		inst._OnEaten = inst.components.edible.oneaten
	end
	
	local duration = inst.duration ~= nil and inst.duration or 1
	local intensity = inst.intensity ~= nil and inst.intensity or -1
	inst.duration,inst.intensity = nil,nil
	
	local function OnEat(inst, eater)
		if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
            not eater:HasTag("playerghost") then
				eater.components.debuffable:AddDebuff("hayfeverbuff_"..inst.prefab, "hayfeverbuff", {duration = duration, intensity = intensity})
			end
		if inst._OnEaten then
			inst._OnEaten(inst,eater)
		end
	end	
		
	if inst.components.edible then
		inst.components.edible:SetOnEatenFn(OnEat)
	end
end

for i, v in ipairs(tiny) do
	env.AddPrefabPostInit(v, function(inst)
		inst.duration = 1
		inst.intensity = -1
		if inst.prefab == "pepper" then
			inst.intensity = -9 -- Peppers have a more immediate boost, similar to the low category
		end
		MakeHayfeverFood(inst)
	end)
end

for i, v in ipairs(low) do
	env.AddPrefabPostInit(v, function(inst)
		inst.duration = 3
		inst.intensity = -2
		MakeHayfeverFood(inst)
	end)
end

for i, v in ipairs(lowmed) do
	env.AddPrefabPostInit(v, function(inst)
		inst.duration = 18
		inst.intensity = -1
		MakeHayfeverFood(inst)
	end)
end

for i, v in ipairs(med) do
	env.AddPrefabPostInit(v, function(inst)
		if inst.prefab == "mandrakesoup" then
			inst.duration = 6
			inst.intensity = -6	
		end
		if inst.prefab == "pepperpopper" then
			inst.duration = 36
			inst.intensity = -1	
		end
		MakeHayfeverFood(inst)
	end)
end

for i, v in ipairs(high) do
	env.AddPrefabPostInit(v, function(inst)
		if inst.prefab == "liceloaf" then
			inst.duration = 5
			inst.intensity = -10	
		end
		if inst.prefab == "seafoodpaella" then
			inst.duration = 25
			inst.intensity = -3	
		end
		if inst.prefab == "californiaking" then
			inst.duration = 50
			inst.intensity = -2	
		end
		MakeHayfeverFood(inst)
	end)
end