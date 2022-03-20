local env = env
GLOBAL.setfenv(1, GLOBAL)

local function RandomThreatSpring(inst)
if math.random() > 0 then  --This'll ensure that only hayfevers occur in any updates until monsoons are finished, to test monsoons, simply change to math.random() > 2
--TheWorld:AddTag("hayfever")
--TheWorld.net:AddTag("hayfever")
else
TheWorld:AddTag("monsoons")
TheWorld.net:AddTag("monsoons")
end
end
local function UndoRandomThreatSpring(inst)
if	TheWorld:HasTag("hayfever") then
TheWorld:RemoveTag("hayfever")
TheWorld.net:RemoveTag("hayfever")
end
if	TheWorld:HasTag("monsoons") then
TheWorld:RemoveTag("monsoons")
TheWorld.net:RemoveTag("monsoons")
end
end
env.AddPrefabPostInit("forest", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	--inst:AddComponent("UM_springweather")
	--inst:AddComponent("monsoons")
	--inst:WatchWorldState("isspring", RandomThreatSpring)
	--inst:WatchWorldState("issummer", UndoRandomThreatSpring)
end)

env.AddPrefabPostInit("cave", function(inst)
    if not TheWorld.ismastersim then
        return
    end
	
	--inst:AddComponent("UM_springweather") --Shouldn't do this, need to add the receiver component instead
	
end)

local function HayFeverEater(inst, data)
	local SugarBuff = data.food:HasTag("antihistamine_sugar") and 60 or 0
	local Antihistamine = data.food:HasTag("antihistamine_low") and 60 or 
		data.food:HasTag("antihistamine_high") and 300 or 
		data.food:HasTag("antihistamine_super") and 800 or
		0
	
	if data.food ~= nil and data.food:HasTag("antihistamine") and inst.components.hayfever and inst.components.hayfever.enabled then
		print(SugarBuff)
		print(Antihistamine)
		
		inst.components.hayfever:SetNextSneezeTime(Antihistamine + SugarBuff)			
	end	
end

env.AddPlayerPostInit(function(inst)

	inst:ListenForEvent("oneat", HayFeverEater)

	if inst:HasTag("scp049") then
		inst:AddTag("hasplaguemask")
		inst:AddTag("has_gasmask")
	end
	
	if not TheWorld.ismastersim then
            return inst
        end
		
	inst:AddComponent("hayfever")
end)

local ANTIHISTAMINES = 
{
    "honey",
    "onion",
	"acorn_cooked",
	"red_cap",
	"red_cap_cooked",
}

local function AddAntihistamine(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
		inst:AddTag("antihistamine_low")
    end)
end

for k, v in pairs(ANTIHISTAMINES) do
	AddAntihistamine(v)
end

--------------------------------------------
--[[
local HISTAMINES = 
{
    "butterflywings",
	"petals",
}

local function item_oneatenhistamine(inst, eater)
	if eater.components.hayfever and eater.components.hayfever.enabled then
		eater.components.hayfever:SetNextSneezeTime(5)			
	end	
end

local function AddHistamine(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
	
	inst.components.edible:SetOnEatenFn(item_oneatenhistamine)
    end)
end

for k, v in pairs(HISTAMINES) do
	AddHistamine(v)
end
]]
--------------------------------------------

local ANTIHISTAMINES_HIGH = 
{
    "honeynuggets",
	"honeyham",
	"asparagussoup",
	"bonesoup",
	"dragonchilisalad",
	"moqueca",
	"seafoodgumbo",
	"lobsterbisque",
	"hotchili",
	"vegstinger",
	"pepperpopper",
	"sweettea",
}

local function AddAntihistamineHigh(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
		inst:AddTag("antihistamine_high")
    end)
end

local function AddAntihistamineHighSugar(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
		inst:AddTag("antihistamine_high")
		inst:AddTag("antihistamine_sugar")
    end)
end

for k, v in pairs(ANTIHISTAMINES_HIGH) do
	AddAntihistamineHigh(v)
	AddAntihistamineHigh(v.."_spice_chili")
	AddAntihistamineHigh(v.."_spice_garlic")
	AddAntihistamineHigh(v.."_spice_salt")
	AddAntihistamineHighSugar(v.."_spice_sugar")
end

-------------------------------------------------------

local ANTIHISTAMINES_SUPER = 
{
    "mandrakesoup",
}

local function AddAntihistamineSuper(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
		inst:AddTag("antihistamine_super")
    end)
end

local function AddAntihistamineSuperSugar(prefab)
    env.AddPrefabPostInit(prefab, function (inst)
		inst:AddTag("antihistamine")
		inst:AddTag("antihistamine_super")
		inst:AddTag("antihistamine_sugar")
    end)
end

for k, v in pairs(ANTIHISTAMINES_SUPER) do
	AddAntihistamineSuper(v)
	AddAntihistamineSuper(v.."_spice_chili")
	AddAntihistamineSuper(v.."_spice_garlic")
	AddAntihistamineSuper(v.."_spice_salt")
	AddAntihistamineSuperSugar(v.."_spice_sugar")
end