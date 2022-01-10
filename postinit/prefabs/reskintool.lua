local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

env.AddPrefabPostInit("reskin_tool", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local spellcaster = inst.components.spellcaster
    
    local _can_cast_fn = spellcaster.can_cast_fn
    spellcaster.can_cast_fn = function(doer, target, ...)
        if HasSkins(target) then
            return true
        end
        
        return _can_cast_fn(doer, target, ...)
    end
    
    -- Our custom reskinner!
    local _spell = spellcaster.spell
    spellcaster.spell = function(inst, target, ...)
        if not HasSkins(target) then
            return _spell(inst, target, ...)
        end
        
        local fx_prefab = "explode_reskin"
        local skin_fx = SKIN_FX_PREFAB[inst:GetSkinName()]
        if skin_fx ~= nil and skin_fx[1] ~= nil then
            fx_prefab = skin_fx[1]
        end
        
        SpawnAt(fx_prefab, target)

        local prefab = target.base_prefab or target.prefab
        local skin = target.skinname or target.prefab
        
        if not inst._cached_reskinname[prefab] then
            inst._cached_reskinname[prefab] = skin
        end
        
        while inst._cached_reskinname[prefab] == skin do
            for item_type, _ in pairs(UNCOMP_SKINS[prefab]) do
                if item_type ~= skin then
                    inst._cached_reskinname[prefab] = item_type
                    break
                end
            end
        end
        
        ReskinModEntity(target, inst._cached_reskinname[prefab])
    end
end)