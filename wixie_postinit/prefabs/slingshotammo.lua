local AMMO = 
{
	"slingshotammo_rock",
	"slingshotammo_gold",
	"slingshotammo_marble",
	"slingshotammo_thulecite",
	"slingshotammo_freeze",
	"slingshotammo_slow",
	"slingshotammo_poop",
	"trinket_1",
}

for k, v in pairs(AMMO) do
	AddPrefabPostInit(k, function(inst)
		if not TheWorld.ismastersim then
			return
		end
	
		if inst.components.edible ~= nil then
			inst.components.edible.hungervalue = 0
		end
	end)
end