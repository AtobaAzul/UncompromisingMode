
local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("playerspawner", function(self)
	local _SpawnAtLocation = self.SpawnAtLocation
	
	local SPAWNLIGHT_TAGS = { "spawnlight" }
	function self:SpawnAtLocation(inst, player, x, y, z, isloading, platform_uid, rx, ry, rz)
        if player:HasTag("troublemaker") and not isloading and TheSim:FindFirstEntityWithTag("wixie_wardrobe") ~= nil then

			player.sg:GoToState("wixie_spawn")
			
			player.components.playercontroller:Enable(false)
			
			player:DoTaskInTime(6*FRAMES+FRAMES, function(inst)
				player:Hide()
				
				player.components.playercontroller:Enable(false)
				
				local ux, uy, uz = player.Transform:GetWorldPosition()
					
				if not TheWorld.state.isday and #TheSim:FindEntities(ux, uy, uz, 4, SPAWNLIGHT_TAGS) <= 0 then
					
					SpawnPrefab("spawnlight_multiplayer").Transform:SetPosition(ux, uy, uz)
				end
			end)
			
            return _SpawnAtLocation(self, inst, player, x, y, z, true)
        else
            return _SpawnAtLocation(self, inst, player, x, y, z, true, platform_uid, rx, ry, rz)
		end
    end
end)