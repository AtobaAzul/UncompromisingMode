--------------------------------------------------------------------------
--[[ Shard_Sinkholes ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "sproutcounter should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst

--Private
local _world = TheWorld
local _ismastershard = _world.ismastershard

--Network
local shrooms = {}

--------------------------------------------------------------------------
--[[ Private event listeners ]]
--------------------------------------------------------------------------

local OnSproutDeath(shrooms)
    for i, v in ipairs(shrooms) do
        shrooms = shrooms - 1
end or nil

local OnSproutGrown(shrooms)
    for i, v in ipairs(shrooms) do
        shrooms = shrooms + 1
end or nil

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

inst:ListenForEvent("shroomdeath", OnSproutDeath, TheWorld)
inst:ListenForEvent("shroomgrow", OnSproutGrown, TheWorld)

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
