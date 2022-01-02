-- All character changes
AddPlayerPostInit(function(inst)
	inst:AddComponent("uncompromising_lungs")
	inst:AddComponent("uncompromising_voidtracker")
	inst:AddComponent("UM_hayfever")
	--[[if inst.components.sanity.custom_rate_fn then
		local _custom_sanity_rate = inst.components.sanity.custom_rate_fn
	end
	local function PollenAccountedRate(inst,dt)
		local passrate = 0
		if _custom_sanity_rate then
			passrate = _custom_sanity_rate
		end
		return passrate - inst.components.UM_hayfever:GetSanityLoss(inst)
	end
	inst.components.sanity.custom_rate_fn = PollenAccountedRate]]
end)