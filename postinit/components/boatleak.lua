local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------
-- Not sure how I'd do this without overwriting
env.AddComponentPostInit("boatleak", function(self)
    local _SetState = self.SetState
    function self:SetState(state, skip_open)
        local ret = _SetState(self, state, skip_open)
        if state == "repaired_sludge" then
            self:ChangeToRepaired("boat_repair_sludge_build")
        elseif state == "repaired_driftwood" then
            self:ChangeToRepaired("boat_repair_cork_build")
            self.inst.Transform:SetScale(0.9,0.9,0.9)
        end
        return ret
    end

    local _Repair = self.Repair
    function self:Repair(doer, patch_item)
        --print(doer, patch_item)
        if patch_item.components.finiteuses ~= nil then
            patch_item.components.finiteuses:Use()

            local repair_state = "repaired"
            local patch_type = (patch_item.components.boatpatch ~= nil and patch_item.components.boatpatch:GetPatchType()) or nil
            if patch_type ~= nil then
                repair_state = repair_state.."_"..patch_type
            end
        
            self.inst.AnimState:PlayAnimation("leak_small_pst")
            self.inst:DoTaskInTime(0.4, function(inst)
                self:SetState(repair_state)
            end)
        
            return true
        elseif patch_item.components.repairer ~= nil and patch_item.components.repairer.repairmaterial ~= MATERIALS.WOOD then
            --Hack to get past the item not removing.
            --Vanilla boat patches get removed from being used as a repair and have the MATERIALS.WOOD material
            --however, sludge has MATERIALS.SLUDGE, which doesn't work for WOOD.
            
            --BY GOD'S LIGHT I SMITE YOOOUUU!!!!
            local ret = _Repair(self, doer, patch_item)
            if patch_item.components.stackable ~= nil then
                patch_item.components.stackable:Get():Remove()
            else
                patch_item:Remove()
            end
            return ret
        else
            return _Repair(self, doer, patch_item)
        end
    end
end)
