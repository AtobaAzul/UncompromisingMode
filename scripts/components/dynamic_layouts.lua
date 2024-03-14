--this is, currently, used to handle the DL world things in component form, and to properly save things.
--world does not have onsave/load!

return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Dynamic Layouts should not exist on client")

    self.inst = inst
    self.layouts = {}

    inst:ListenForEvent("revertterraform", function(inst, group)
        self:RevertTerraform(group)
    end) --legacy compatibility, please just call the method itself.
    function self:OnSave()
        return {
            layouts = self.layouts
        }
    end

    function self:OnLoad(data)
        self.layouts = data.layouts
    end

    function self:RevertTerraform(group)
        if group == nil or group ~= nil and self.layouts[group] == nil then
            return
        end

        for k, v in pairs(self.layouts[group].tiles) do
            TheWorld.Map:SetTile(v.x, v.y, v.original_tile)
            if k == #self.layouts[group].tiles then
                TheWorld:DoTaskInTime(0, function()
                    TheWorld:PushEvent("finishedterraform")
                end)
            end
        end

        self.layouts[group].tiles = {}

        for k, v in pairs(self.layouts[group].prefabs) do
            if v ~= nil and v.prefab ~= nil then
                SpawnSaveRecord(v) --while spawnsaverecord provides the biggest fidelity, it is a lot of data to store onsave. I'm not sure if that's a problem
            end
        end

        self.layouts[group].prefabs = {}

        for k, v in pairs(Ents) do --kinda expensive. Is there any other way?
            if v.group == group then
                v:Remove()
            end
        end
    end
end)
