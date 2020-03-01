local function RandomDiseaseChance(inst)
	local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
	print("disease chance")
	--if inst.components.diseaseable ~= nil and inst.components.pickable ~= nil and 
	if mushroomcheck ~= nil and math.random(1,15) == 1 and 
	GLOBAL.TheWorld.state.israining then
		print("disease DO")
		inst:AddComponent("diseaseable")
		inst.components.diseaseable:Disease()
		inst.components.pickable:ChangeProduct("spoiled_food")
		inst.components.diseaseable:RestartNearbySpread()
		inst.AnimState:SetBuild(inst.prefab.."_diseased_build")
	else
		inst.randomdisease_task = inst:DoTaskInTime(math.random(5,10), RandomDiseaseChance)
	end
end

local function onnear(inst, target)
	if GLOBAL.TheWorld.state.isautumn and GLOBAL.TheWorld.state.cycles > TUNING.DSTU.WEATHERHAZARD_START_DATE then
		inst.randomdisease_task = inst:DoTaskInTime(math.random(5,10), RandomDiseaseChance)
	end
end

local function onfar(inst, target)
	if inst.randomdisease_task ~= nil then
        inst.randomdisease_task:Cancel()
	end
end

local DISEASABLES = 
{
    "berrybush",
    "berrybush_juicy",
    "grass", --is it really grass? or grass tuft?
    "sapling",
}

local function AddAcidDisease(prefab)
    AddPrefabPostInit(prefab, function (inst)
        inst.randomdisease_task = nil
        if inst.components.playerprox == nil then
            inst:AddComponent("playerprox")
        end
        inst.components.playerprox:SetDist(40, 43) --set specific values
        inst.components.playerprox:SetOnPlayerNear(onnear)
        inst.components.playerprox:SetOnPlayerFar(onfar)
    end)

    AddPrefabPostInit(prefab, shake, onnear, onfar)
end

for k, v in pairs(DISEASABLES) do
	AddAcidDisease(v)
end