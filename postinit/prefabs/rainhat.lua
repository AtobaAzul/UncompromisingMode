local env = env
GLOBAL.setfenv(1, GLOBAL)
local UpvalueHacker = require("tools/upvaluehacker")

env.AddPrefabPostInit("rainhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.waterproofer ~= nil then
        inst.components.waterproofer:SetEffectiveness(0.8)
	end
end)