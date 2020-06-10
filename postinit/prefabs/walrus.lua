local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
SetSharedLootTable( 'walrus_summer',
{
    {'meat',            1.00},
    {'blowdart_pipe',   1.00},
    {'sunglasses',       0.25},
    {'walrus_tusk',     0.50},
    {'hawaiianshirt',     0.05},
})

local function OnIsSummer(inst, issummer)
    if issummer then
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_build_summer")
		inst.components.lootdropper:SetChanceLootTable('walrus_summer')
    else
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_build")
		inst.components.lootdropper:SetChanceLootTable('walrus')
    end
end


env.AddPrefabPostInit("walrus", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("issummer", OnIsSummer)
    if TheWorld.state.issummer then
        OnIsSummer(inst, true)
    end
	
    if inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(TUNING.WALRUS_HEALTH*TUNING.DSTU.MONSTER_MCTUSK_HEALTH_INCREASE)
    end
end)

local function OnIsSummerBaby(inst, issummer)
    if issummer then
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_baby_build_summer")
    else
		inst.AnimState:SetBank("walrus")
        inst.AnimState:SetBuild("walrus_baby_build")
    end
end


env.AddPrefabPostInit("little_walrus", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:WatchWorldState("issummer", OnIsSummerBaby)
    if TheWorld.state.issummer then
        OnIsSummerBaby(inst, true)
    end
end)