local env = env
GLOBAL.setfenv(1, GLOBAL)

local VALID_TILES = table.invert(
{
        GROUND.DIRT,
        GROUND.FOREST,
        GROUND.GRASS,
        GROUND.MARSH,
		GROUND.ROCKY,
        GROUND.SAVANNA,
		GROUND.CAVE,
		GROUND.FUNGUS,
		GROUND.SINKHOLE,
		GROUND.UNDERROCK,
		GROUND.DECIDUOUS,
		GROUND.SANDY,
		GROUND.BADLANDS,
		GROUND.DESERTDIRT,
		GROUND.FUNGUS_GREEN,
		GROUND.FUNGUS_RED,
})

local function spawngeyser(inst)

	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 8, { "flamegeyser" })

	if ents == nil or #ents == 0 then
		if TheWorld.state.issummer and math.random() < 0.02 and VALID_TILES[TheWorld.Map:GetTileAtPoint(x, y, z)] then
			SpawnPrefab("flamegeyser").Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end
end

env.AddPrefabPostInit("ground_chunks_breaking", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	--if TheWorld.state.issummer then
		--if math.random() < 0.05 then
			inst:DoTaskInTime(0, spawngeyser)
		--end
	--end
end)