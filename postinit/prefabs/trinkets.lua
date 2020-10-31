local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnSave2(inst, data)
    if inst.components.workable == nil then
        data.dug = true
    end

	if TheWorld:HasTag("freddo_spawned") then
		data.freddotrinket = true
	end

	if TheWorld:HasTag("jazzy_spawned") then
		data.jazzytrinket = true
	end
	
	if TheWorld:HasTag("don_spawned") then
		data.dontrinket = true
	end
end
	
local function OnLoad2(inst, data)

    if data ~= nil and data.dug or inst.components.workable == nil then
        inst:RemoveComponent("workable")
        inst.AnimState:PlayAnimation("dug")
    end

    if data ~= nil then
		if data.freddotrinket ~= nil and data.freddotrinket then
			TheWorld:AddTag("freddo_spawned")
		end
		
		if data.jazzytrinket ~= nil and data.jazzytrinket then
			TheWorld:AddTag("jazzy_spawned")
		end
		
		if data.dontrinket ~= nil and data.dontrinket then
			TheWorld:AddTag("don_spawned")
		end
	end
end

env.AddPrefabPostInit("mound", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local _OnFinishCallBack = inst.components.workable.onfinish

	inst.components.workable.onfinish = function(inst, worker)
		if not TheWorld:HasTag("jazzy_spawned") and not TheSim:FindFirstEntityWithTag("specialtrinket_jazzy") then
			local item = "cctrinket_jazzy"
			inst.AnimState:PlayAnimation("dug")
				inst:RemoveComponent("workable")

			if worker ~= nil then
				if worker.components.sanity ~= nil then
					worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
				end

				if item ~= nil then
					inst.components.lootdropper:SpawnLootPrefab(item)
				end
			end
			--print("jazzy")
			TheWorld:AddTag("jazzy_spawned")
			return _OnFinishCallBack(inst, worker)
		elseif not TheWorld:HasTag("freddo_spawned") and TheSim:FindFirstEntityWithTag("specialtrinket_jazzy") and not TheSim:FindFirstEntityWithTag("specialtrinket_freddo") then
			local item = "cctrinket_freddo"
			inst.AnimState:PlayAnimation("dug")
			inst:RemoveComponent("workable")

			if worker ~= nil then
				if worker.components.sanity ~= nil then
					worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
				end

				if item ~= nil then
					inst.components.lootdropper:SpawnLootPrefab(item)
				end
			end
			--print("freddo")
			TheWorld:AddTag("freddo_spawned")
			return _OnFinishCallBack(inst, worker)
		elseif not TheWorld:HasTag("don_spawned") and TheSim:FindFirstEntityWithTag("specialtrinket_jazzy") and TheSim:FindFirstEntityWithTag("specialtrinket_freddo") and not TheSim:FindFirstEntityWithTag("specialtrinket_don") then
			local item = "cctrinket_don"
			inst.AnimState:PlayAnimation("dug")
			inst:RemoveComponent("workable")

			if worker ~= nil then
				if worker.components.sanity ~= nil then
					worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
				end

				if item ~= nil then
					inst.components.lootdropper:SpawnLootPrefab(item)
				end
			end
			--print("don")
			TheWorld:AddTag("don_spawned")
			_OnFinishCallBack(inst, worker)
		else
			--print("nothing")
			return _OnFinishCallBack(inst, worker)
		end
	end


	inst.OnSave = OnSave2
	inst.OnLoad = OnLoad2

end)




--[[
    local _PickRandomTrinket = PickRandomTrinket

	PickRandomTrinket = function()
--    local modded_trinkets = {"cctrinket_freddo", "cctrinket_jazzy", "cctrinket_don"}
    local modded_trinkets = {"ruinshat", "armorruins", "ruins_bat"}
    local chessunlocks = TheWorld.components.chessunlocks

    local has_locked_chess = chessunlocks ~= nil and (chessunlocks:GetNumLockedTrinkets() > 0)
    local is_hallowednights = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)

    local unlocked_trinkets = {}
	for i = 1, NUM_TRINKETS do
			if (not has_locked_chess or not chessunlocks:IsLocked("trinket_"..i))
				and (is_hallowednights or not(i >= HALLOWEDNIGHTS_TINKET_START and i <= HALLOWEDNIGHTS_TINKET_END)) then

				table.insert(unlocked_trinkets, i)
			end
		end
		--note: # only counts integer keys
		if math.random(#modded_trinkets + #unlocked_trinkets) <= #modded_trinkets then
			return modded_trinkets[math.random(#modded_trinkets)]
		else
			return _PickRandomTrinket()
		end
	end
]]