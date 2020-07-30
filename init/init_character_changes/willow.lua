local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
local function propegation(inst)
	if inst.components.burnable and not inst.components.burnable:IsBurning() then
		MakeSmallPropagator(inst)
	else
		inst:DoTaskInTime(5, propegation)
	end 
end

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
	
	--propegation(inst)

end

local function OnBurnt(inst)
	--will this stop her from losing her burning effect?
	inst:DoTaskInTime(0, function(inst) 
		if inst.components.health and not inst.components.health:IsDead() then 
			MakeSmallPropagator(inst)
			inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
			inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
			inst.components.burnable:SetOnBurntFn(OnBurnt)
		end 
	end)
end

local function OnRespawnedFromGhost2(inst)
	inst:DoTaskInTime(0, function(inst) 
		if inst.components.health and not inst.components.health:IsDead() then 
			MakeSmallPropagator(inst) 
			inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
			inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
			inst.components.burnable:SetOnBurntFn(OnBurnt)
		end 
	end)
end

env.AddPrefabPostInit("willow", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	inst.proptask = nil
	
	--if inst.components.burnable ~= nil then
		--propegation(inst)
		MakeSmallPropagator(inst)
		inst.components.burnable:SetBurnTime(TUNING.WORMWOOD_BURN_TIME * 2)
		inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	--end
	
	
    inst:ListenForEvent("ms_respawnedfromghost", OnRespawnedFromGhost2)
	
end)