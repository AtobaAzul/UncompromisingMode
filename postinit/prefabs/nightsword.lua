local env = env
GLOBAL.setfenv(1, GLOBAL)

local function CalcDapperness(inst, owner)
if owner:HasTag("Funny_Words_Magic_Man") then
    return TUNING.CRAZINESS_MED/4 -- This ends up being about -5/min + 3.3/min from the hat itself
else
	return TUNING.CRAZINESS_MED
end
end
env.AddPrefabPostInit("nightsword", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
if inst.components.equippable ~= nil then
inst.components.equippable.dapperfn = CalcDapperness
end
--return inst
end)