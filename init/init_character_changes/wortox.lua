-----------------------------------------------------------------
--Remove souls from insects and arachnids
--Relevant: soulless tag, wortox_soul_common.lua
-----------------------------------------------------------------
local function MakeSoulless(prefab)
    AddPrefabPostInit(prefab, function(inst)
        if inst~= nil then
            inst:AddTag("soulless")
        end
    end)
end

--print("DSTU: wortox")

local REMOVE_SOULS = 
{
    --""spider",
    --""mosquito",
    "bee",
    "killerbee",
    "butterfly",
    --""birchnutdrake",
    --""mole",
    --""beeguard",
    --""bat",
}

for k, v in pairs(REMOVE_SOULS) do
	MakeSoulless(v)
end
