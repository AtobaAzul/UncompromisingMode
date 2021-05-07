local TRAPIMMUNE = 
{
	"hound",
	"icehound",
	"firehound",
	"lightninghound",
	"sporehound",
	"glacialhound",
	"magmahound",
	"walrus",
	"little_walrus",
}

local function AddBearTrapImmune(prefab)
	AddPrefabPostInit(prefab, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		
		inst:AddTag("bear_trap_immune")
		
	end)
end

for k, v in pairs(TRAPIMMUNE) do
	AddBearTrapImmune(v)
end

local FEATHERS = 
{
	"feather_crow",
	"feather_robin",
	"feather_robin_winter",
	"feather_canary",
}

local function AddFeatherTag(prefab)
	AddPrefabPostInit(prefab, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		
		inst:AddTag("wingsuit_feather")
		
	end)
end

for k, v in pairs(FEATHERS) do
	AddFeatherTag(v)
end