local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[
local function ResetLavae2(inst)
    --Despawn all lavae
    local lavae = inst.components.rampingspawner.spawns
    for k, v in pairs(lavae) do
        k.components.combat:SetTarget(nil)
        k.components.locomotor:Clear()
        k.reset = true
    end
end

local function ResetOnSummer(inst)
print("wat the h")
    ResetLavae2(inst)

    inst.reset = true

    --No longer start the respawn task here - was possible to duplicate this if the exiting failed.
end

local function OnSummerChange(inst)

print("wat the h")
    if TheWorld.state.issummer then
		ResetLavae2(inst)

		inst.reset = true
	end
end
--]]
env.AddPrefabPostInit("dragonfly", function(inst)

    inst.Physics:CollidesWith(COLLISION.FLYERS)
	
	if not TheWorld.ismastersim then
		return
	end
	
	
    --inst:WatchWorldState("issummer", OnSummerChange)
	--[[
	inst:ListenForEvent("seasontick", function() 
		if TheWorld.state.issummer then 
			ResetOnSummer()
		end 
	end)--]]
	
end)