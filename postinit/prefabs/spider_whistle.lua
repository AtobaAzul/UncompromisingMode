local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnHerd(whistle, leader)
    local x, y, z = leader.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, TUNING.SPIDER_WHISTLE_RANGE, {"trapdoor"})
    
    for _, den in pairs(ents) do
        if not TheWorld.state.iswinter and den.components.childspawner and den.components.childspawner.childreninside > 0 and den.SummonChildren then
            den:SummonChildren()
        end
    end

    return whistle.OldOnHerd(whistle, leader)
end


env.AddPrefabPostInit("spider_whistle", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.OldOnHerd = inst.components.followerherder.onherfn
	
	
    inst.components.followerherder:SetOnHerdFn(OnHerd)
	
end)
