local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function RemoveFreezeProtection(inst)
	inst:RemoveTag("um_freezeprotection")
end

local function OnHitOtherFreeze(inst, data)
    local other = data.target
    if other ~= nil then
        if not (other.components.health ~= nil and other.components.health:IsDead()) then
            if not other:HasTag("um_freezeprotection") and other.components.freezable ~= nil and other:HasTag("player") and not other.components.freezable:IsFrozen() and not other.sg:HasStateTag("frozen") then
                other.components.freezable:AddColdness(2)
				
				if other.components.freezable:IsFrozen() then
					other:AddTag("um_freezeprotection")
					other:DoTaskInTime(3, RemoveFreezeProtection)
				end
            end
            if other.components.temperature ~= nil then
                local mintemp = math.max(other.components.temperature.mintemp, 0)
                local curtemp = other.components.temperature:GetCurrent()
                if mintemp < curtemp then
                    other.components.temperature:DoDelta(math.max(-5, mintemp - curtemp))
                end
            end
        end
        if other.components.freezable ~= nil then
            other.components.freezable:SpawnShatterFX()
        end
    end
end

env.AddPrefabPostInit("icehound", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if TUNING.DSTU.FROSTBITEHOUNDS == true then
    if inst.components.combat ~= nil then
        inst:ListenForEvent("onhitother", OnHitOtherFreeze)
    end
	end
end)

env.AddPrefabPostInit("glacialhound", function (inst)
	if not TheWorld.ismastersim then
		return
	end
	
    if inst.components.combat ~= nil then
        inst:ListenForEvent("onhitother", OnHitOtherFreeze)
    end
end)