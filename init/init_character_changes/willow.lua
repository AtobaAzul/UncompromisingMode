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
	

	inst.proptask = nil
	
	if inst.proptask == nil then
		inst.proptask = inst:DoTaskInTime(30, function(inst) if not inst.components.burnable:IsBurning() then MakeSmallPropagator(inst) end end)
	end

end

local function OnRespawnedFromGhost2(inst)
	inst.proptask = nil
	
	if inst.proptask == nil then
		inst.proptask = inst:DoTaskInTime(30, function(inst) if not inst.components.burnable:IsBurning() then MakeSmallPropagator(inst) end end)
	end
end

local function OnBurnt(inst)
	--will this stop her from losing her burning effect?
	inst.proptask = nil
	
	if inst.proptask == nil then
		inst.proptask = inst:DoTaskInTime(30, function(inst) if not inst.components.burnable:IsBurning() then MakeSmallPropagator(inst) end end)
	end
end

env.AddPrefabPostInit("willow", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.proptask = nil
	
	if inst.components.burnable ~= nil then
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		MakeSmallPropagator(inst)
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	end
	
    inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost2)
	
end)