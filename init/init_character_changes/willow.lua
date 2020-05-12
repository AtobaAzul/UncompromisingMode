local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local function OnIgniteFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
	
	local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, nil, { "INLIMBO", "player", "abigail" })

    for i, v in ipairs(ents) do
        if v ~= inst and v:IsValid() and not v:IsInLimbo() then
            if v.components.workable ~= nil and v.components.workable:CanBeWorked() then
                v.components.workable:WorkedBy(inst, 10)
            end

            --Recheck valid after work
            if v:IsValid() and not v:IsInLimbo() then
                if v.components.fueled == nil and
                    v.components.burnable ~= nil and
                    not v.components.burnable:IsBurning() and
                    not v:HasTag("burnt") then
                    v.components.burnable:Ignite()
                end
				
				if v.components.combat ~= nil and not (v.components.health ~= nil and v.components.health:IsDead()) then
                    local dmg = 40
                    if v.components.explosiveresist ~= nil then
                        dmg = dmg * (1 - v.components.explosiveresist:GetResistance())
                        v.components.explosiveresist:OnExplosiveDamage(dmg, inst)
                    end
                    v.components.combat:GetAttacked(inst, dmg, nil)
                end
            end
        end
    end
	
	
	MakeSmallPropagator(inst)
	
end

env.AddPrefabPostInit("willow", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.burnable ~= nil then
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		MakeSmallPropagator(inst)
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
	end
end)