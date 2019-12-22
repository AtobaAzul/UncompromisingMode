local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function OnHitOtherBurn(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if other.components.burnable ~= nil then
                other.components.burnable:Ignite(nil, inst)
            end
        end
    end
end

env.AddPrefabPostInit("firehound", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.combat ~= nil then
        inst:ListenForEvent("onhitother", OnHitOtherBurn)
    end
end)