local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
--[[local function is_berry(item)
    return item.components.edible ~= nil and (item.prefab == "berries" or item.prefab == "berries_juicy" or item.prefab == "berries_cooked" or item.prefab == "berries_juicy_cooked")
end]]

local function is_berry(item)
    return item.components.edible ~= nil and (item.prefab == "berries" or item.prefab == "berries_cooked" or item.prefab == "berries_juicy" or item.prefab == "berries_juicy_cooked")
end

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_ONEOF_TAGS = { "companion", "player" }
--[[local function retargetfn(inst)
    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                TUNING.PIG_TARGET_DIST,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy.components.inventory ~= nil and
                                guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
                                guy.components.inventory:FindItem(is_berry) ~= nil))
                end,
                RETARGET_MUST_TAGS, -- see entityreplica.lua
                nil,
                RETARGET_ONEOF_TAGS
            )
        or nil
end]]

local function NormalRetargetFn(inst)
    return not inst:IsInLimbo()
        and FindEntity(
                inst,
                30,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy.components.inventory ~= nil and
                                guy:IsNear(inst, TUNING.BUNNYMAN_SEE_MEAT_DIST) and
                                guy.components.inventory:FindItem(is_berry) ~= nil)
                end,
                RETARGET_MUST_TAGS, -- see entityreplica.lua
                nil,
                RETARGET_ONEOF_TAGS
            )
        or FindEntity(
                inst,
                5,
                function(guy)
                    return inst.components.combat:CanTarget(guy)
                        and (guy.components.health ~= nil and
						not guy.components.health:IsDead())
                end,
                { "wall" }
            )
		or nil
end

local function NormalKeepTargetFn(inst, target)
    return not inst.attacked and target ~= nil and target.components ~= nil and target.components.inventory and target.components.inventory:FindItem(is_berry)
end

local BERRIES =
{
	"berries",
	"berries_cooked",
	"berries_juicy",
	"berries_juicy_cooked",
}

local function FindBerries(inst)
	if inst.components.inventory then
		return inst.components.inventory:FindItems(function(item) return (item.prefab == "berries" or item.prefab == "berries_cooked" or item.prefab == "berries_juicy" or item.prefab == "berries_juicy_cooked") end)
	end
end

local function OnHitOther(inst, other, damage)
	local berries = FindBerries(other)
	while berries and (#berries > 0) do
		for i, berry in ipairs(berries) do     
			inst.components.thief:StealItem(other, berry, nil, nil, 4)
		end

		berries = FindBerries(other)
	end
end

local function hungycounter(inst)
	inst.mehungy = inst.mehungy + 1
	if inst.mehungy >= 5 then
		inst.components.named:SetName("Gobbler")
	end
end

local function OnAttacked(inst, data)
    --print("ON ATTACKED")
    local attacker = data.attacker
    inst:ClearBufferedAction()
    inst.attacked = true
    local attacker = data and data.attacker
    inst.components.combat:SetTarget(attacker)
	
	if inst.clearattackertask ~= nil then
		inst.clearattackertask:Cancel()
		inst.clearattackertask = nil
	end
	
	inst.clearattackertask = inst:DoTaskInTime(10, function(inst) inst.attacked = false
		inst.clearattackertask:Cancel()
		inst.clearattackertask = nil
	end)
end

env.AddPrefabPostInit("perd", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	local _OnSave = inst.OnSave

	local function OnSave(inst, data)
		if inst.mehungy ~= nil then
			data.mehungy = inst.mehungy
		end
		
		_OnSave(inst, data)
	end

	local function OnLoad(inst, data)
		if data then
			if data.mehungy ~= nil then
				inst.mehungy = data.mehungy
				if inst.mehungy >= 5 then
					inst.components.named:SetName("Gobbler")
				end
			end
		end
	end

	inst.mehungy = 0
	inst.attacker = false
	
    inst:AddComponent("thief")
	
    inst:AddComponent("named")
    inst.components.named:SetName("Starving Gobbler")
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(TUNING.BUNNYMAN_HEALTH)
	end
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetRange(3)
		inst.components.combat:SetDefaultDamage(20)
		inst.components.combat:SetAttackPeriod(TUNING.BEARDLORD_ATTACK_PERIOD)
		inst.components.combat:SetRetargetFunction(2, NormalRetargetFn)
		inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
		inst.components.combat.onhitotherfn = OnHitOther
	end
	
    inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("oneat", hungycounter)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

end)