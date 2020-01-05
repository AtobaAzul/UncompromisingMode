local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
env.AddComponentPostInit("quaker", function(self)
--[[
local _BreakDebris = _ismastersim and function(debris)
    local x, y, z = debris.Transform:GetWorldPosition()
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, 0, z)
    SpawnPrefab("flamegeyser").Transform:SetPosition(x, 0, z)
    debris:Remove()
end or nil
--]]
end)