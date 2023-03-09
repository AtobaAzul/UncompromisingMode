local SMALLFISH = 
{
	"fish",
	"fishmeat_small",
	"eel",
	"fish_tropical"
}

for k, v in pairs(SMALLFISH) do
	AddPrefabPostInit(v, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
	
		if inst.components.dryable then
			inst.components.dryable:SetDriedBuildFile("driedfishmeat")
			inst.components.dryable:SetProduct("smallfishmeat_dried")
		end
	end)
end

local LARGEFISH = 
{
	"fishmeat",
	"solofish_dead",
	"swordfish_dead"
}

for n, b in pairs(LARGEFISH) do
	AddPrefabPostInit(b, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		
		if inst.components.dryable then
			inst.components.dryable:SetDriedBuildFile("driedfishmeat")
			inst.components.dryable:SetProduct("fishmeat_dried")
		end
	end)
end