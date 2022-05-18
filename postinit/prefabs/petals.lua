local env = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPerish(inst)
	local owner = inst.components.inventoryitem.owner

	if owner ~= nil and owner.prefab == "sisturn" then
		inst.components.perishable.onperishreplacement = "ghostflower"
	end
end

env.AddPrefabPostInit("petals", function(inst)

	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.perishable ~= nil then
		inst.components.perishable:SetOnPerishFn(OnPerish)
	end
end)