local env = env
GLOBAL.setfenv(1, GLOBAL)
------------------------------------------------------------------------------------------
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function TentacleErupt(inst,owner,target)
	local pt
	if target ~= nil and target:IsValid() then
		pt = target:GetPosition()
	else
		pt = owner:GetPosition()
		target = nil
	end
	local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 2, 3, false, true, NoHoles, false, true)
	if offset ~= nil then
		inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_1")
		inst.SoundEmitter:PlaySound("dontstarve/common/shadowTentacleAttack_2")
		local tentacle = SpawnPrefab("shadowtentacle")
		if tentacle ~= nil then
			tentacle.Transform:SetPosition(pt.x + offset.x, 0, pt.z + offset.z)
			tentacle.components.combat:SetTarget(target)
			tentacle.ruinsbat = inst
			tentacle.ruinsbatowner = owner
		end
	end
end

local function NewOnAttack(inst, owner, target)
	if target and target.components.combat and target.components.combat.defaultdamage > 0 then
		if target.components.combat.ruinsbatstack then
			target.components.combat.ruinsbatstack = target.components.combat.ruinsbatstack + 1
			if target.components.combat.ruinsbatstack > 3.1 then
				TentacleErupt(inst,owner,target)
				target.components.combat.ruinsbatstack = nil
			end
		else
			target.components.combat.ruinsbatstack = 1
		end
	end
end


env.AddPrefabPostInit("ruins_bat", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.weapon ~= nil then
		inst.components.weapon:SetOnAttack(NewOnAttack) --The old one doesn't have anything that's really useful to this new version. Replacing.
	end
end)
