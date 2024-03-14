local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local Wathom_Sonar = Class(Widget, function(self, owner)
    self.owner = owner
    Widget._ctor(self, "Wathom_Sonar")
    self:SetClickable(false)

    self.bg2 = self:AddChild(Image("images/fx5.xml", "fog_over.tex"))
    self.bg2:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg2:SetVAnchor(ANCHOR_MIDDLE)
    self.bg2:SetHAnchor(ANCHOR_MIDDLE)
    self.bg2:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.alpha = 0
    self.alphagoal = 0
    self.transitiontime = 2.0
    self.transitiontimeIN = 0.2
    self.transitiontimeOUT = 5
    self.transitiontimeREST = 1    
    self.current_adrenaline = 25
    self.time = self.transitiontimeIN
    self.currentstate = "out"
    self:Hide()

    owner:ListenForEvent("counter_currentdirty",function(owner,data)
        self.current_adrenaline = owner.counter_current:value()
    end)  
	
	self:StartSonar()
end)

function Wathom_Sonar:StartSonar()
   
    if not self.active then
    self.time = self.transitiontimeIN
        self.alphagoal = 1
        self.active = true
        self:StartUpdating()
        self:Show()
    end
end


function Wathom_Sonar:SetSonar(off)
    if off and self.active then
            self.time = 0
            self.alphagoal = 0
            self.active = false
            self.alpha = 0
            self:StopUpdating()
            self:Hide()
    else
        if not self.active then
            self.time = 0
            self.alphagoal = 1
            self.active = true
            self.alpha = 1
            self:StartUpdating()
            self:Show()
        end
    end
end

function Wathom_Sonar:StopSonar()
    if self.active then
        self.time = self.transitiontime
        self.alphagoal = 0
        self.active = false
        self:StopUpdating()
        self:Hide()
    end
end

function Wathom_Sonar:UpdateAlpha(dt)

    if self.time > 0 then
        self.time = math.max(0, self.time - dt)
    else
        if self.currentstate == "out" then
			if self.owner:HasTag("WathomInDark") then
				TheFocalPoint.SoundEmitter:PlaySound("UCSounds/vets_heartbeat/heartbeat_single")
				
				local ring = SpawnPrefab("wathom_heartbeat_ringfx")
				ring.Transform:SetScale(2,2,2)
				ring.Transform:SetPosition(self.owner.Transform:GetWorldPosition())
				
				self.owner:DoTaskInTime(0.1, function()
						if self.active then
							local ring2 = SpawnPrefab("wathom_heartbeat_ringfx")
							ring2.Transform:SetScale(2,2,2)
							ring2.Transform:SetPosition(self.owner.Transform:GetWorldPosition())
						end
					end)
			end

            self.currentstate = "in"
            self.alphagoal = 0
            self.time = self.transitiontimeIN
        elseif self.currentstate == "in" and self.owner:HasTag("WathomInDark") then
            self.currentstate = "out"
            self.alphagoal = 1
            self.time = self.transitiontimeOUT - (self.current_adrenaline / 25)
        end                
    end

    local mapping = 0
    if self.currentstate == "out" then
        mapping = Remap(self.time, self.transitiontimeOUT, 0, 0, 1)
    else
        mapping = Remap(self.time, self.transitiontimeIN, 0, 1, 0)
    end
    self.alpha = mapping --math.sin(PI * mapping)
	print(self.alpha)
   -- if self.alpha > self.alphagoal then
    --    self.alpha = 0.0
    -- end
end

function Wathom_Sonar:OnUpdate(dt)
    if self.owner:HasTag("wathom") and not TheNet:IsServerPaused() then
		self:UpdateAlpha(dt)
		
        local r, g, b = TheSim:GetAmbientColour()
        local r1 = math.min(r * 1.5, 1)
        local g1 = math.min(g * 1.5, 1)
        local b1 = math.min(b * 1.5, 1)
		print("r1 = "..r1)
		print("g1 = "..g1)
		print("b1 = "..b1)
		
		local alpha_bonus = TheWorld.state.isday and .5 or TheWorld.state.isdusk and .25 or 0
		print(alpha_bonus)

        self.bg2:SetTint(0, 0, 0, (self.alpha - (self.current_adrenaline / 200)) - alpha_bonus)
    end
end

return Wathom_Sonar
