local env = env
GLOBAL.setfenv(1, GLOBAL)

local function MakeWaterSource(inst)
	inst:AddTag("watersource")
	inst:AddComponent("watersource")
	--inst:RemoveComponent("trader")
end

local function ItemTradeTest(inst, item, giver)
	if item.prefab == "moon_tear" then
			inst.hastear = true
			MakeWaterSource(inst)
			item:Remove()
			inst.AnimState:SetBuild("moondialtear_build")
			inst.AnimState:SetBank("moondialtear")
			return true
		else
			return false
		
	end
end

local function OnAccept(inst)
	inst:RemoveComponent("tradable")
end

env.AddPrefabPostInit("moondial", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _OnSave = inst.OnSave
	local _OnLoad = inst.OnLoad

	local function OnSave(inst, data)
		if inst.hastear ~= nil then
			data.hastear = inst.hastear
		end
		
		_OnSave(inst, data)
	end

	local function OnLoad(inst, data)
		if data ~= nil then
			if data.hastear ~= nil and data.hastear == true then
				inst.hastear = true
				MakeWaterSource(inst)
				
				if inst.components.trader ~= nil then
					inst:RemoveComponent("trader")
				end
				
				inst.AnimState:SetBuild("moondialtear_build")
				inst.AnimState:SetBank("moondialtear")
			end
		end

		_OnLoad(inst, data)
	end
	
	inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
	inst.components.trader.onaccept = OnAccept
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
end)