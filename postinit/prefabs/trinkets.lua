local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local UMTRINKETS =
{
"cctrinket_don",
"cctrinket_jazzy",
"cctrinket_freddo",
"corncan", --Your welcome, Nikolai.
}

local function onfinishcallbackUM(inst, worker)
    inst.AnimState:PlayAnimation("dug")
    inst:RemoveComponent("workable")

    if worker ~= nil then
        if worker.components.sanity ~= nil then
            worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
        end
	end
local item = UMTRINKETS[math.random(#UMTRINKETS)]
inst.components.lootdropper:SpawnLootPrefab(item)
end
env.AddPrefabPostInit("mound", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local _OnFinishCallBack = inst.components.workable.onfinish

	inst.components.workable.onfinish = function(inst, worker)
		if math.random() > 0.95 then
			return onfinishcallbackUM(inst, worker)
		else
			return _OnFinishCallBack(inst, worker)
		end
	end
end)

--[[
env.AddPrefabPostInit("tumbleweed", function(inst)
	if not TheWorld.ismastersim then
		return
	end
for i = 1,10 do --This loop allows us to tune the chance of the UMTRINKETS dropping
	for i,v in ipairs(UMTRINKETS) do
	table.insert(inst.loot,v)
	end
end
end)]]
