local env = env
GLOBAL.setfenv(1, GLOBAL)
local function RedoSpeed(inst)
if inst.components.container ~= nil then
	local count = 0
                for k = 1, 12 do
                    local other_item = inst.components.container.slots[k]
					if other_item ~= nil then
					count = count + 1
					end
				end
	if inst.components.equippable ~= nil then
	inst.components.equippable.walkspeedmult = 1 - (count * 0.01)
	end
end
end
env.AddPrefabPostInit("piggyback", function(inst)
	if not TheWorld.ismastersim then
		return
	end
inst.components.equippable.walkspeedmult = 1	
inst:ListenForEvent("itemget", RedoSpeed)
inst:ListenForEvent("itemlose", RedoSpeed)

--return inst
end)