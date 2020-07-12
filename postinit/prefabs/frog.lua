local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable('toad',
{
    {'sporecloud_toad', .5},
})

SetSharedLootTable('frog',
{
})

local function OnIsAutumn(inst, isautumn)
    if isautumn and TheWorld.state.cycles >= TUNING.DSTU.WEATHERHAZARD_START_DATE then
		inst.components.lootdropper:SetChanceLootTable('toad')
        inst.AnimState:SetBuild("frog_yellow_build")
		inst:SetPrefabNameOverride("toad")
    else
		inst.components.lootdropper:SetChanceLootTable('frog')
        inst.AnimState:SetBuild("frog")
		inst:SetPrefabNameOverride("frog")
    end
end

local function NewRetargetfn(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        return FindEntity(inst, TUNING.FROG_TARGET_DIST, function(guy) 
            if not guy.components.health:IsDead() then
                return guy.components.inventory ~= nil
            end
        end,
        {"_combat","_health"}, -- see entityreplica.lua
        {"frog","toadstool","toad"} -- see entityreplica.lua
        )
    end
end

env.AddPrefabPostInit("frog", function (inst)
    if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("isautumn", OnIsAutumn)
    if TheWorld.state.isautumn then
        OnIsAutumn(inst, true)
    end

	if inst.components.combat ~= nil then
		inst.components.combat:SetRetargetFunction(2, NewRetargetfn)
	end
	
	if not inst.components.eater then
		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
		inst.components.eater:SetCanEatHorrible()
		inst.components.eater:SetCanEatRaw()
		inst.components.eater.strongstomach = true -- can eat monster meat!
	end

end)

env.AddPrefabPostInit("toad", function (inst)
    if not TheWorld.ismastersim then
		return
	end

	if not inst.components.eater then
		inst:AddComponent("eater")
		inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
		inst.components.eater:SetCanEatHorrible()
		inst.components.eater:SetCanEatRaw()
		inst.components.eater.strongstomach = true -- can eat monster meat!
	end

end)