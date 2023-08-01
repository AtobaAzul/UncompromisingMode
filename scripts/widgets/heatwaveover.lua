local Widget = require "widgets/widget"
local Image = require "widgets/image"

local HeatwaveOver = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "FlareOver")

    self._alpha = 0.0
    self._alpha_target = 0.0
    self._alpha_speed = 0.5 -- rate of change from alpha=1 to alpha=0

    self:SetClickable(false)

    self.bg = self:AddChild(Image("images/fx4.xml", "flare_over.tex"))
    self.bg:SetVRegPoint(ANCHOR_TOP)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_TOP)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FIXEDPROPORTIONAL)
    self.bg:SetTint(1, 1, 0, self._alpha)
    self:Show()
    self:StartUpdating()

    if owner ~= nil then
        self.inst:ListenForEvent("seasontick", function(owner) return self:ToggleUpdating() end, owner)
    end
end)

function HeatwaveOver:ToggleUpdating()
    if TheWorld.state.issummer then
        self:StartUpdating()
    else
        self:Hide()
        -- TheFocalPoint.SoundEmitter:KillSound("um_storm_rain")
        self:StopUpdating()
    end
end

function HeatwaveOver:OnUpdate(dt)
    if TheWorld.net ~= nil and (TheWorld.net:HasTag("heatwavestartnet") or TheWorld:HasTag("heatwavestart")) and not TheWorld.state.isnight then
        local delta = dt * self._alpha_speed
        self._alpha = math.clamp(self._alpha + delta, 0, 0.75)
    else
        local delta = dt * self._alpha_speed
        self._alpha = math.clamp((1 - delta) * self._alpha, 0, 0.75)
    end

    -- Delay our alpha fade until the second half of the update period.
    -- That is, we display at full alpha for the first half of our period,
    -- and fade from 1 to 0 in the other half.
    self.bg:SetTint(255 / 255, 165 / 255, 0, self._alpha)
    self.bg:SetFadeAlpha(self._alpha / 0.5)

    if self._alpha <= 0.01 then
        self:Hide()
    else
        self:Show()
    end
end

return HeatwaveOver
