local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local valid_tiles = {
    WORLD_TILES.OCEAN_SWELL,
    WORLD_TILES.OCEAN_BRINEPOOL,
    WORLD_TILES.OCEAN_WATERLOG,
    WORLD_TILES.OCEAN_ROUGH,
    WORLD_TILES.OCEAN_HAZARDOUS,
}

env.AddComponentPostInit("schoolspawner", function(self)
    local _SpawnSchool = self.SpawnSchool
    function self:SpawnSchool(spawnpoint, target, override_spawn_offset)
        local map = TheWorld.Map

        local ret = _SpawnSchool(self, spawnpoint, target, override_spawn_offset)
        if math.random() > 0.995 then
            local sea_players = {}

            for k, v in pairs(AllPlayers) do
                if v:IsOnOcean(true) then
                    local ptx, pty, ptz = v.Transform:GetWorldPosition()
                    local tx, ty = map:GetTileCoordsAtPoint(ptx, 0, ptz)
                    local actual_tile = map:GetTile(tx, ty)

                    if table.contains(valid_tiles, actual_tile) then
                        table.insert(sea_players, v)
                    end
                end
            end
        
            if #sea_players ~= 0 then
                local targetted_player = sea_players[math.random(#sea_players)]
                local px, py, pz = targetted_player.Transform:GetWorldPosition()
                local randX, randY = math.random() > 0.5 and -1 or 1, math.random() > 0.5 and -1 or 1
                local x, y, z = px + (40 * randX), 0, pz - (40 * randY)
                local canSpawn = true

                for offsetX = -8, 8 do
                    for offsetZ = -8, 8 do
                        if not map:IsOceanTileAtPoint(x + offsetX, 0, z + offsetZ) then
                            canSpawn = false
                            break
                        end
                    end
                end

                if canSpawn then
                    local bigShadow = SpawnPrefab("sea_shadow")
                    bigShadow.Transform:SetPosition(x, y, z)
                end
            end
        end
        return ret
    end
end)
