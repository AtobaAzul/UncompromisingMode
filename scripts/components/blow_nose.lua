local Blow_Nose = Class(function(self, inst)
    self.inst = inst
    self.onplayed = nil
end)

function Blow_Nose:SetOnHeardFn(fn)
    self.onheard = fn
end

function Blow_Nose:SetOnPlayedFn(fn)
    self.onplayed = fn
end

function Blow_Nose:Play(noseblower)
    if self.onplayed ~= nil then
        self.onplayed(self.inst, noseblower)
    end
    if self.onheard ~= nil then
        local x, y, z = noseblower.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, self.range, nil, { "FX", "DECOR", "INLIMBO" })
        for i, v in ipairs(ents) do
            if v ~= self.inst then
                self.onheard(v, noseblower, self.inst)
            end
        end
    end
    return true
end

return Blow_Nose
