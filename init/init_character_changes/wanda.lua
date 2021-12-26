
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if TUNING.DSTU.WANDA_NERF == true then
 --[[   env.AddPrefabPostInit("wanda", function(inst)
        if not TheWorld.ismastersim then
		    return
	    end
        if inst.age_state == "old" then 
            inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * TUNING.ARMOR_MARBLE_SLOW --slower when old
        else
            inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
        end
    end)]]
end
