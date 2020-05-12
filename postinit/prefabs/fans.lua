local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnUse2(inst, target)
    local x, y, z = target.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.FEATHERFAN_RADIUS, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost" }, { "smolder", "fire", "player" })
    for i, v in pairs(ents) do
        if v.components.burnable ~= nil then
            -- Extinguish smoldering/fire and reset the propagator to a heat of .2
            v.components.burnable:Extinguish(true, 0)
        end
        if v.components.temperature ~= nil then
            -- cool off yourself and any other nearby players
            v.components.temperature:DoDelta(math.clamp(TUNING.FEATHERFAN_MINIMUM_TEMP - v.components.temperature:GetCurrent(), TUNING.FEATHERFAN_COOLING, 0))
        end
		if v.components.hayfever ~= nil then
            v.components.hayfever:SetNextSneezeTime(300)	
        end
    end
end

env.AddPrefabPostInit("featherfan", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	if inst.components.fan ~= nil then
		inst.components.fan:SetOnUseFn(OnUse2)
	end

end)

env.AddPrefabPostInit("perdfan", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	if inst.components.fan ~= nil then
		inst.components.fan:SetOnUseFn(OnUse2)
	end

end)