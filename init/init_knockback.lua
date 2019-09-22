local GIANTS = 
{
	["bearger"] =
    {
        radius = 125,
    },
	["dragonfly"] =
    {
        radius = 75,
    },
	["leif"] =
    {
        radius = 75,
    },
	["minotaur"] =
    {
        radius = 200,
    },
	["rook"] =
    {
        radius = 150,
    },
	["krampus"] =
    {
        radius = 150,
    },
}

for k, v in pairs(GIANTS) do
	AddPrefabPostInit(k, function(inst)
		local function OnHitOther(inst, other)
			if other ~= nil then
				other:PushEvent("knockback", {knocker = inst, radius = v.radius})
			end
		end
	
		inst.components.combat.onhitotherfn = OnHitOther
	end)
end