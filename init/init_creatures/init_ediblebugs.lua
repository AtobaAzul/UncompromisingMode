local EDIBLES = 
{
	"mosquito",
	"bee",
	"killerbee",
	"butterfly",
	"moonbutterfly",
	"aphid",
}

local function AddEdibles(prefab)
	AddPrefabPostInit(prefab, function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
		
		inst:AddComponent("edible")
		inst.components.edible.foodtype = GLOBAL.FOODTYPE.INSECT
		
	end)
end

for k, v in pairs(EDIBLES) do
	AddEdibles(v)
end