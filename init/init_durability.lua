if TUNING.DSTU.SEWING_KIT then
	AddPrefabPostInit("sewing_kit", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.finiteuses ~= nil and inst.components.sewing ~= nil then
			inst.components.finiteuses:SetMaxUses(10)
			inst.components.finiteuses:SetUses(10)
			inst.components.sewing.repair_value = 1200
		end
	end)
end

local function onfuelchangehigh(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.waterproofer:SetEffectiveness(0.3)
    elseif newsection <= 2 then
		inst.components.waterproofer:SetEffectiveness(0.5)
    elseif newsection <= 3 then
		inst.components.waterproofer:SetEffectiveness(0.7)
    elseif newsection <= 4 then
		inst.components.waterproofer:SetEffectiveness(0.9)
    end
end

local function onfuelchangeabsolute(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.waterproofer:SetEffectiveness(0.4)
    elseif newsection <= 2 then
		inst.components.waterproofer:SetEffectiveness(0.6)
    elseif newsection <= 3 then
		inst.components.waterproofer:SetEffectiveness(0.8)
    elseif newsection <= 4 then
		inst.components.waterproofer:SetEffectiveness(1)
    end
end

local function onfuelchangemedium(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.waterproofer:SetEffectiveness(0.15)
    elseif newsection <= 2 then
		inst.components.waterproofer:SetEffectiveness(0.3)
    elseif newsection <= 3 then
		inst.components.waterproofer:SetEffectiveness(0.5)
    elseif newsection <= 4 then
		inst.components.waterproofer:SetEffectiveness(0.7)
    end
end

--

local function onfuelchangeinsulationmedium(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.insulator:SetInsulation(45)
    elseif newsection <= 2 then
		inst.components.insulator:SetInsulation(50)
    elseif newsection <= 3 then
		inst.components.insulator:SetInsulation(55)
    elseif newsection <= 4 then
		inst.components.insulator:SetInsulation(60)
    end
end

local function onfuelchangeinsulationmedhigh(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.insulator:SetInsulation(90)
    elseif newsection <= 2 then
		inst.components.insulator:SetInsulation(100)
    elseif newsection <= 3 then
		inst.components.insulator:SetInsulation(110)
    elseif newsection <= 4 then
		inst.components.insulator:SetInsulation(120)
    end
end

local function onfuelchangeinsulationhigh(newsection, oldsection, inst, doer)
    if newsection <= 1 then
		inst.components.insulator:SetInsulation(150)
    elseif newsection <= 2 then
		inst.components.insulator:SetInsulation(180)
    elseif newsection <= 3 then
		inst.components.insulator:SetInsulation(210)
    elseif newsection <= 4 then
		inst.components.insulator:SetInsulation(240)
    end
end

if TUNING.DSTU.CLOTHINGDEGREDATION then
	AddPrefabPostInit("rainhat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.waterproofer ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangemedium)
		end
	end)

	AddPrefabPostInit("umbrella", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.waterproofer ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangehigh)
		end
	end)

	AddPrefabPostInit("eyebrellahat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.waterproofer ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeabsolute)
		end
	end)

	AddPrefabPostInit("raincoat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.waterproofer ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeabsolute)
		end
	end)

	AddPrefabPostInit("walrushat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationmedhigh)
		end
	end)

	AddPrefabPostInit("winterhat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationmedhigh)
		end
	end)

	AddPrefabPostInit("wintergoggles", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationmedhigh)
		end
	end)

	AddPrefabPostInit("trunkvest_summer", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationmedhigh)
		end
	end)

	AddPrefabPostInit("trunkvest_winter", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationhigh)
		end
	end)

	AddPrefabPostInit("beargervest", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationhigh)
		end
	end)

	AddPrefabPostInit("beefalohat", function (inst)
		if inst ~= nil and inst.components ~= nil and inst.components.insulator ~= nil then
			inst.components.fueled:SetSections(4)
				inst.components.fueled:SetSectionCallback(onfuelchangeinsulationhigh)
		end
	end)
end