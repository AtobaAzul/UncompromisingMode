local Widget = require "widgets/widget"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"

local BGCOLOR = {0 / 255, 132 / 255, 0 / 255, 255 / 255}

local Um_StormOver = Class(Widget, function(self, owner, storm_overlays)
    self.owner = owner
    Widget._ctor(self, "Um_StormOver")

    self:SetClickable(false)

    self.minscale = .9 -- min scale supported by art size
    self.maxscale = 1.20625
    --[[
    self.storm_overlays = storm_overlays
    self.storm_root = storm_overlays:GetParent()
--]]
    self.bg = self:AddChild(Widget("zap_root"))
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.bg = self.bg:AddChild(UIAnim())
    self.bg:GetAnimState():SetBank("moonstorm_over_static")
    self.bg:GetAnimState():SetBuild("moonstorm_over_static")
    self.bg:GetAnimState():PlayAnimation("static_loop", true)
    -- self.bg:SetTint(1,1,1,.8)

    self.bg2 = self:AddChild(Widget("rain_root"))
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
    self.bg2 = self.bg2:AddChild(UIAnim())
    self.bg2:GetAnimState():SetBank("um_storm_over")
    self.bg2:GetAnimState():SetBuild("um_storm_over")
    self.bg2:GetAnimState():PlayAnimation("rain_loop", true)

    self.bg4 = self:AddChild(Widget("rain_root"))
    self.bg4:SetHAnchor(ANCHOR_MIDDLE)
    self.bg4:SetVAnchor(ANCHOR_MIDDLE)
    self.bg4:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
    self.bg4 = self.bg4:AddChild(UIAnim())
    self.bg4:GetAnimState():SetBank("um_storm_over")
    self.bg4:GetAnimState():SetBuild("um_storm_over")
    self.bg4:GetAnimState():PlayAnimation("rain_loop", true)
    self.bg4:SetScale(1.5)

    self.bg3 = self:AddChild(Widget("cloud_root"))
    self.bg3:SetHAnchor(ANCHOR_MIDDLE)
    self.bg3:SetVAnchor(ANCHOR_MIDDLE)
    self.bg3:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
    self.bg3 = self.bg3:AddChild(UIAnim())
    self.bg3:GetAnimState():SetBank("um_storm_over")
    self.bg3:GetAnimState():SetBuild("um_storm_over")
    self.bg3:GetAnimState():PlayAnimation("cloud_loop", true)

    self.changed = 0

    self:Hide()
    self:OnUpdate(0)
    self:StartUpdating()

    if owner ~= nil then
        self.inst:ListenForEvent("seasontick", function(owner) return self:ToggleUpdating() end, owner)
    end
end)

function Um_StormOver:OnUpdate(dt)
    local tornado = FindClosestEntity(self.owner, 300, true, {"um_tornado"})

    if --[[TheWorld.state.isspring and]] tornado ~= nil and tornado:IsValid() then
        if self.changed < 1 then
            self:Show()
            self.changed = self.changed + 0.002
            self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg2:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg3:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg4:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)

            TheFocalPoint.SoundEmitter:PlaySound("UCSounds/um_tornado/um_heavy_rain_layer", "um_storm_rain")
			TheFocalPoint.SoundEmitter:SetParameter("um_storm_rain", "volume", self.changed)
        end
    else
        if self.changed > 0 then
            self.changed = self.changed - 0.002
            self.bg:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg2:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg3:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)
            self.bg4:GetAnimState():SetMultColour(1, 1, 1, self.changed / 2)

			TheFocalPoint.SoundEmitter:SetParameter("um_storm_rain", "volume", self.changed)
        else
            self:Hide()
            TheFocalPoint.SoundEmitter:KillSound("um_storm_rain")
        end
    end
end

function Um_StormOver:ToggleUpdating()
    if TheWorld.state.isspring then
        self:StartUpdating()
    else
        self:Hide()
        -- TheFocalPoint.SoundEmitter:KillSound("um_storm_rain")
        self:StopUpdating()
    end
end

return Um_StormOver
