require "prefabutil"
local CANOPY_SHADOW_DATA = require("prefabs/canopyshadows")

local function removecanopyshadow(inst)
    if inst.canopy_data ~= nil then
        for _, shadetile_key in ipairs(inst.canopy_data.shadetile_keys) do
            if TheWorld.shadetiles[shadetile_key] ~= nil then
                TheWorld.shadetiles[shadetile_key] = TheWorld.shadetiles[shadetile_key] - 1

                if TheWorld.shadetiles[shadetile_key] <= 0 then
                    if TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] ~= nil then
                        DespawnLeafCanopy(TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key])
                        TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] = nil
                    end
                end
            end
        end

        for _, ray in ipairs(inst.canopy_data.lightrays) do
            ray:Remove()
        end
    end
end

local function makefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddDynamicShadow()
    inst.entity:SetPristine()

	inst:AddTag("NOBLOCK")
	inst:AddTag("shadecanopysmall")
	if not TheNet:IsDedicated() then
		inst:AddComponent("distancefade")
		inst.components.distancefade:Setup(15,25)
	end
    
	inst._hascanopy = net_bool(inst.GUID, "oceantree_pillar._hascanopy", "hascanopydirty")
	inst._hascanopy:set(true)    
	inst:DoTaskInTime(0, function()    
		inst.canopy_data = CANOPY_SHADOW_DATA.spawnshadow(inst, math.floor(TUNING.SHADE_CANOPY_RANGE_SMALL/4), true)
	end)

	inst:ListenForEvent("hascanopydirty", function()
        if not inst._hascanopy:value() then 
            removecanopyshadow(inst) 
        end
    end)	
	
    if not TheWorld.ismastersim then
        return inst
    end
    return inst
end

return Prefab("extracanopyspawner", makefn)

