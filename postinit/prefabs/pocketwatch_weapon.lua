local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
if TUNING.DSTU.WANDA_NERF == true then
    env.AddPrefabPostInit("pocketwatch_weapon", function(inst)
	    if not TheWorld.ismastersim then
		    return
	    end
        local function onattack(inst, attacker, target)
            if target ~= nil and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("stalkerminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker"))   and not target.components.health:IsDead() then
                target.components.health:DoDelta(TUNING.POCKETWATCH_SHADOW_DAMAGE/2,2,inst) --less efficient against shadows
            end
    
            if not inst.components.fueled:IsEmpty() then
                inst.components.fueled:DoDelta(-TUNING.TINY_FUEL)
    
                if attacker == nil or attacker.age_state == nil or attacker.age_state == "young" then
                    inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/weapon/shadow_attack")
                else
                    -- fx will handle sounds
                end
            else
                inst.SoundEmitter:PlaySound("wanda2/characters/wanda/watch/weapon/attack")
            end
        end

	    if inst.components.weapon ~= nil then
		    inst.components.weapon:SetOnAttack(onattack)
	    end
	
    end)
end
