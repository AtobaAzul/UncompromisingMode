local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local Menu = require "widgets/menu"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/templates"

local function NOTE(inst)
end

local function acceptance()
	TheFrontEnd:PopScreen()
end
			
local WixiePiano = Class(Screen, function(self, title, text, buttons, scale_bg, spacing_override, style)
	Screen._ctor(self, "WixiePiano")
	
    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,300,0)
	
    local buttons = {{ text = "Hm...", cb = acceptance }}
	
	self.code = 0
	
    self.menu = self.proot:AddChild(Menu(buttons, 225, true))
    self.menu:SetPosition(-25, -200, 0) 
	
    self.F = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.F.note = "F"
    self.F:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/F")
		end)
    self.F:SetPosition(-200,0,0)
    self.F.scale_on_focus = false
	
    self.G = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.G.note = "G"
    self.G:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/G")
		end)
    self.G:SetPosition(-150,0,0)
    self.G.scale_on_focus = false
	
    self.A = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.A.note = "A"
    self.A:SetOnClick(
		function()
			if self.code == 1 then
				self.code = 2
			else
				self.code = 0
			end
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/A")
		end)
    self.A:SetPosition(-100,0,0)
    self.A.scale_on_focus = false
	
    self.B = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.B.note = "B"
    self.B:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/B")
		end)
    self.B:SetPosition(-50,0,0)
    self.B.scale_on_focus = false
	
    self.C = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.C.note = "C"
    self.C:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/C")
		end)
    self.C:SetPosition(0,0,0)
    self.C.scale_on_focus = false
	
    self.D = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.D.note = "D"
    self.D:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/D")
		end)
    self.D:SetPosition(50,0,0)
    self.D.scale_on_focus = false
	
    self.E = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.E.note = "E"
    self.E:SetOnClick(
		function()
			if self.code == 6 then
				self.code = 7
			else
				self.code = 0
			end
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/E")
		end)
    self.E:SetPosition(100,0,0)
    self.E.scale_on_focus = false
	
    self.F2 = self.proot:AddChild(ImageButton("images/wixiepiano_whitekey.xml", "wixiepiano_whitekey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.F2.note = "F2"
    self.F2:SetOnClick(
		function()
			if self.code == 5 then
				self.code = 6
			else
				self.code = 0
			end
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/F2")
		end)
    self.F2:SetPosition(150,0,0)
    self.F2.scale_on_focus = false
	
    self.FSHARP = self.proot:AddChild(ImageButton("images/wixiepiano_blackkey.xml", "wixiepiano_blackkey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.FSHARP.note = "F#"
    self.FSHARP:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/F#")
		end)
    self.FSHARP:SetPosition(-175,50,0)
    self.FSHARP.scale_on_focus = false
	
    self.GSHARP = self.proot:AddChild(ImageButton("images/wixiepiano_blackkey.xml", "wixiepiano_blackkey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.GSHARP.note = "G#"
    self.GSHARP:SetOnClick(
		function()
			if self.code == 2 then
				self.code = 3
			else
				self.code = 0
			end
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/G#")
		end)
    self.GSHARP:SetPosition(-125,50,0)
    self.GSHARP.scale_on_focus = false
	
    self.ASHARP = self.proot:AddChild(ImageButton("images/wixiepiano_blackkey.xml", "wixiepiano_blackkey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.ASHARP.note = "A#"
    self.ASHARP:SetOnClick(
		function()
			if self.code == 0 then
				self.code = 1
			elseif self.code == 3 then
				self.code = 4
			else
				self.code = 0
			end
		
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/A#")
		end)
    self.ASHARP:SetPosition(-75,50,0)
    self.ASHARP.scale_on_focus = false
	
    self.CSHARP = self.proot:AddChild(ImageButton("images/wixiepiano_blackkey.xml", "wixiepiano_blackkey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.CSHARP.note = "C#"
    self.CSHARP:SetOnClick(
		function()
			if self.code == 4 then
				self.code = 5
			elseif self.code == 7 then
				SendModRPCToServer(GetModRPC("UncompromisingSurvival", "PianoPuzzleComplete"), nil)
			
				self.code = 0
				TheFocalPoint.SoundEmitter:PlaySound("dontstarve/sanity/creature2/dissappear")
			else
				self.code = 0
			end
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/C#")
		end)
    self.CSHARP:SetPosition(25,50,0)
    self.CSHARP.scale_on_focus = false
	
    self.DSHARP = self.proot:AddChild(ImageButton("images/wixiepiano_blackkey.xml", "wixiepiano_blackkey.tex", nil, nil, nil, nil, {1,1}, {0,0}))
    self.DSHARP.note = "D#"
    self.DSHARP:SetOnClick(
		function()
			self.code = 0
			
			TheFocalPoint.SoundEmitter:PlaySound("UCSounds/piano/D#")
		end)
    self.DSHARP:SetPosition(75,50,0)
    self.DSHARP.scale_on_focus = false
end)

function WixiePiano:SetTitleTextSize(size)
	self.title:SetSize(size)
end

function WixiePiano:SetButtonTextSize(size)
	self.menu:SetTextSize(size)
end

function WixiePiano:OnControl(control, down)
    if WixiePiano._base.OnControl(self,control, down) then return true end
--[[
    if control == CONTROL_CANCEL and not down then
        if #self.buttons > 1 and self.buttons[#self.buttons] then
            self.buttons[#self.buttons].cb()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            return true
        end
    end]]
end


function WixiePiano:Close()
	TheFrontEnd:PopScreen(self)
end

function WixiePiano:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}
	if #self.buttons > 1 and self.buttons[#self.buttons] then
        table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)
    end
	return table.concat(t, "  ")
end

return WixiePiano
