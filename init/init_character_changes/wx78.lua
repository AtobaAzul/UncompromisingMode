-----------------------------------------------------------------
-- WX damage changes during wet
-----------------------------------------------------------------

table.insert(GLOBAL.TUNING.WX78_CHARGING_FOODS, {zaspberry = 1})
table.insert(GLOBAL.TUNING.WX78_CHARGING_FOODS, {zaspberryparfait = 1})

local ModuleDefs = require("wx78_moduledefs")

ModuleDefs.AddCreatureScanDataDefinition("dreadeye", "maxsanity", 3)
ModuleDefs.AddCreatureScanDataDefinition("creepingfear", "maxsanity", 6)
ModuleDefs.AddCreatureScanDataDefinition("trepidation", "maxsanity", 6)
ModuleDefs.AddCreatureScanDataDefinition("mock_dragonfly", "heat", 10)
ModuleDefs.AddCreatureScanDataDefinition("viperworm", "light", 6)
ModuleDefs.AddCreatureScanDataDefinition("shockworm", "light", 6)
ModuleDefs.AddCreatureScanDataDefinition("magmahound", "heat", 4)
ModuleDefs.AddCreatureScanDataDefinition("glacialhound", "cold", 4)
ModuleDefs.AddCreatureScanDataDefinition("lightninghound", "taser", 5)

--TODO, reimplement dorainsparks to do based on wetness from min to max damage
    --add rate too
	
local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnLightningStrike(inst)
    if inst.components.health ~= nil and not (inst.components.health:IsDead() or inst.components.health:IsInvincible()) then
        if inst.components.inventory:IsInsulated() then
            inst:PushEvent("lightningdamageavoided")
        else
            inst.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

            inst.components.upgrademoduleowner:AddCharge(1)
        end
    end
end

env.AddPrefabPostInit("wx78", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:AddTag("automaton")

    if TUNING.DSTU.WX78_CONFIG then
		if inst.components.playerlightningtarget ~= nil then
			inst.components.playerlightningtarget:SetOnStrikeFn(OnLightningStrike)
		end
    end
end)