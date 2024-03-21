local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddComponentPostInit("slipperyfeet", function(self)

    local function OnOceanIce(inst, on_floodwater)
        local self = inst.components.slipperyfeet
        if on_floodwater then
            if not self.onicetile then
                self.onicetile = true
                if self._updating["checkice"] then
                    self:StopUpdating_Internal("checkice")
                else
                    inst.components.slipperyfeet:StartSlipperySource("ocean_ice")
                end
            end
        elseif self.onicetile then
            self.onicetile = false
            self:StartUpdating_Internal("checkice")
        end
    end

    local function OnInit(inst)
        local self = inst.components.slipperyfeet
        self.inittask2 = nil
        self.inst:ListenForEvent("on_UM_FLOODWATER_tile", OnOceanIce)
        if TheWorld.Map:GetTileAtPoint(inst.Transform:GetWorldPosition()) == WORLD_TILES.UM_FLOODWATER then
            OnOceanIce(inst, true)
        end
    end

    self.inittask2 = self.inst:DoTaskInTime(0, OnInit)

    local _OnLoad = self.OnLoad
    function self:OnLoad()
        _OnLoad(self)
        if self.inittask2 then
            self.inittask2:Cancel()
            OnInit(self.inst)
        end
    end

    local _OnRemoveFromEntity = self.OnRemoveFromEntity
    function self:OnRemoveFromEntity()
        _OnRemoveFromEntity(self)
        if self.inittask2 then
            self.inittask2:Cancel()
            self.inittask2 = nil
        else
            self.inst:RemoveEventCallback("on_UM_FLOODWATER_tile", OnOceanIce)
        end
        self:Stop_Internal()
    end

    local _OnUpdate = self.OnUpdate

    function self:OnUpdate(dt)
        _OnUpdate(self, dt)
        if self._updating["checkice"] then
            --if we're on ocean tile but also visual ground, then assume it's ice overhang
            local x, y, z = self.inst.Transform:GetWorldPosition()
            if not (TheWorld.Map:IsOceanTileAtPoint(x, y, z) and TheWorld.Map:IsVisualGroundAtPoint(x, y, z)) then
                self:StopUpdating_Internal("checkice")
                self:StopSlipperySource("um_floodwater")
            end
        end
    
        if self._updating["accumulate"] then
            self:DoDelta(self:CalcAccumulatingSpeed() * dt * (0.7 + 0.3 * math.random()))
        elseif self.slippiness > 0 then
            self:DoDecay(dt)
        end
    end
    
end)
