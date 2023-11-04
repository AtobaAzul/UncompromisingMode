local env = env
GLOBAL.setfenv(1, GLOBAL)

local function MakeWaterSource(inst)
	inst:AddTag("watersource")
	inst:AddComponent("watersource")
	--inst:RemoveComponent("trader")
end

local function ItemTradeTest(inst, item, giver)
	if not (inst.hastear ~= nil and inst.hastear) and item.prefab == "moon_tear" then
		inst.hastear = true
	--	MakeWaterSource(inst)
		item:Remove()
		SpawnPrefab("halloween_moonpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		inst.AnimState:SetBuild("moondialtear_build")
		inst.AnimState:SetBank("moondialtear")
		return true
	elseif (inst.hastear ~= nil and inst.hastear) and not item:HasTag("fillable") and (item.components.halloweenmoonmutable ~= nil) then
		SpawnPrefab("halloween_moonpuff").Transform:SetPosition(inst.Transform:GetWorldPosition())
		item.components.halloweenmoonmutable:Mutate() -- Moon Mutate using vanilla function...for now.
		return true
	else
		return false
	end
end

local function OnAccept(inst)
--	inst:RemoveComponent("tradable")
end

env.AddPrefabPostInit("moondial", function(inst)
	inst:AddTag("alltrader")
	
	if not TheWorld.ismastersim then
		return
	end
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad
	local _onmoonphasechagned = inst.onmoonphasechagned
	
	local function onmoonphasechagned(inst, phase)
		if inst.is_glassed then
			inst.components.watersource.available = false
			
			return _onmoonphasechagned(inst, phase)
		end
		
		if not TheWorld.state.iswaxingmoon and TheWorld.state.moonphase == "new" then
			inst.components.watersource.available = false
		else
			inst.components.watersource.available = true
		end
		
		return _onmoonphasechagned(inst, phase)
	end

	local function OnSave(inst, data)
		if inst.hastear ~= nil then
			data.hastear = inst.hastear
		end
		
		return _OnSave(inst, data)
	end

	local function OnLoad(inst, data)
		if data ~= nil then
			if data.hastear ~= nil and data.hastear then
				inst.hastear = true
			--	MakeWaterSource(inst)
				
			--	if inst.components.trader ~= nil then
			--		inst:RemoveComponent("trader")
			--	end
				
				inst.AnimState:SetBuild("moondialtear_build")
				inst.AnimState:SetBank("moondialtear")
			end
		end
		
		return _OnLoad(inst, data)
	end
	
	inst:AddComponent("trader")
	inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
	inst.components.trader.onaccept = OnAccept
	inst.components.trader.deleteitemonaccept = false
	
	MakeWaterSource(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end)
