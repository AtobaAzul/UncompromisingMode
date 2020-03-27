local function RandomDiseaseChance(inst)
	local mushroomcheck = TheSim:FindFirstEntityWithTag("acidrain_mushroom")
	--print("disease chance")
	if inst.components.pickable ~= nil then
		if mushroomcheck ~= nil and math.random() < 0.15 and 
		GLOBAL.TheWorld.state.israining then
			--print("disease DO")
			
			if inst.components.diseaseable == nil then
				inst:AddComponent("diseaseable")
			end
			
			inst.components.diseaseable:Disease()
			inst.components.pickable:ChangeProduct("spoiled_food")
			inst.components.diseaseable:RestartNearbySpread()
			
			if inst.prefab == "rock_avocado_bush" then
				inst.AnimState:SetBuild("rock_avocado_diseased_build")
			else
				inst.AnimState:SetBuild(inst.prefab.."_diseased_build")
			end
		else
			inst.randomdisease_task = inst:DoTaskInTime(math.random(5,10), RandomDiseaseChance)
		end
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
	"rock_avocado_bush",
}

local function AddAcidDisease(prefab)
    AddPrefabPostInit(prefab, function (inst)
	
		if not GLOBAL.TheWorld.ismastersim then
			return
		end
	
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