local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function onequip(inst, owner)
	owner:AddTag("shadowdominant")
end

local function onunequip(inst, owner)
	owner:RemoveTag("shadowdominant")
end
	
env.AddPrefabPostInit("skeletonhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
	
end)