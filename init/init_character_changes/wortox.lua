-----------------------------------------------------------------
--Remove souls from insects and arachnids
--Relevant: soulless tag, wortox_soul_common.lua
-----------------------------------------------------------------
local function MakeSoulless(prefab)
    AddPrefabPostInit(prefab, function(inst)
        if inst~= nil then
            --print("DSTU: made soulless")
            --print(prefab)
            inst:AddTag("soulless")
        end
    end)
end

print("DSTU: wortox")

local REMOVE_SOULS = 
{
    "spider",
    "mosquito",
    "bee",
    "killerbee",
    "butterfly",
    "birchnutdrake",
    "mole",
    "bat",
}

for k, v in pairs(REMOVE_SOULS) do
	MakeSoulless(v)
end

AddPrefabPostInit("wortox", function(inst)
    if inst ~= nil and inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.DSTU.WORTOX_HEALTH)
	end
end)