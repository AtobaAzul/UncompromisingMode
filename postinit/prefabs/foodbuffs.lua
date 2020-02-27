local env = env
GLOBAL.setfenv(1, GLOBAL)
env.AddPrefabPostInit("foodbuffs", function(inst)
MakeBuff("lesserelectricattack", electric_attach, electric_extend, electric_detach, TUNING.BUFF_ELECTRICATTACK_DURATION/2, 2, { "electrichitsparks", "electricchargedfx" })
end)