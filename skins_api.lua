local _G = GLOBAL
local require = _G.require
local assert = _G.assert
local PREFAB_SKINS = _G.PREFAB_SKINS
local PREFAB_SKINS_IDS = _G.PREFAB_SKINS_IDS
local IsValidClothing = _G.IsValidClothing
local TheInventory = _G.TheInventory
local TEMPLATES = require("widgets/redux/templates")
local SKINNABLE_CHARACTERS = {}

--Hornet: We need to do some changes before Klei's code runs
local function DoAddClassPostConstructBefore(classdef, postfn)
	local constructor = classdef._ctor
	classdef._ctor = function (self, ...)
		postfn(self, ...) --Put our post init BEFORE kleis code
		constructor(self, ...)
	end
end

local function AddClassPostConstructBefore(package, postfn)
	local classdef = require(package)
	assert(type(classdef) == "table", "Class file path '"..package.."' doesn't seem to return a valid class.")
	DoAddClassPostConstructBefore(classdef, postfn)
end

AddClassPostConstructBefore("widgets/redux/loadoutselect", function(self)
	local _OldLoadSavedSkins = self._LoadSavedSkins
	
	function self:_LoadSavedSkins(...)
		if SKINNABLE_CHARACTERS[self.currentcharacter] then
			self.have_base_option = true --Hornet: We do a nice little hijack here
		end
		return _OldLoadSavedSkins(self, ...)
	end
end)

AddClassPostConstruct("screens/redux/lobbyscreen", function(self, profile, cb)
	local function OnUserPickedCharacter(char, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
		local function doSpawn()
			_G.TheFrontEnd:PopScreen()
			_G.TheNet:SendSpawnRequestToServer(char, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
			SendModRPCToServer(GetModRPC(modname, "moddedskins"), skin_base)
		end

		_G.TheFrontEnd:Fade(_G.FADE_OUT, 1, doSpawn, nil, nil, "white")
	end

	if cb ~= nil then
		local _cb = self.cb
        self.cb = function(char, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
			if SKINNABLE_CHARACTERS[char] then
				self:StopLobbyMusic()
				OnUserPickedCharacter(char, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
			else
				_cb(char, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
			end
        end
	end
end)

AddClassPostConstruct("screens/redux/wardrobepopupgridloadout", function(self)
	local _Close = self.Close
	function self:Close(...)
		if self.owner_player and SKINNABLE_CHARACTERS[self.owner_player.prefab] then
			local skins = self.loadout.selected_skins
			local data = {}
			if _G.TheNet:IsOnlineMode() then
				data = skins
			end
											--Hornet: Again, it checks if we "own" our custom skins, which we technically dont so we gotta hijack that
			if not data.base or data.base == self.loadout.currentcharacter or data.base == "" then data.base = (self.loadout.currentcharacter.."_none") end
			if not IsValidClothing( data.body ) or not TheInventory:CheckOwnership(data["body"]) then data.body = "" end
			if not IsValidClothing( data.hand ) or not TheInventory:CheckOwnership(data["hand"]) then data.hand = "" end
			if not IsValidClothing( data.legs ) or not TheInventory:CheckOwnership(data["legs"]) then data.legs = "" end
			if not IsValidClothing( data.feet ) or not TheInventory:CheckOwnership(data["feet"]) then data.feet = "" end
			
			if not _G.TheWorld.ismastersim then
				_G.SendRPCToServer(_G.RPC.CloseWardrobe, data.base, data.body, data.hand, data.legs, data.feet)
			elseif self.owner_player ~= nil then
				self.owner_player:PushEvent("ms_closewardrobe", data)
			end
			
			self.timestamp = self:GetTimestamp()
			self.profile:SetCollectionTimestamp(self.timestamp)
			
			_G.TheFrontEnd:PopScreen(self)
		else
			_Close(self, ...)
		end
	end
end)

AddClassPostConstruct("screens/redux/skinpresetspopup", function(self) --For the base option to show up again for mod characters in the skin presets
	local Text = require "widgets/text"
	local Widget = require "widgets/widget"
	local TEMPLATES = require "widgets/redux/templates"
	local AccountItemFrame = require "widgets/redux/accountitemframe"
	
	local scroll_height = 460
    local content_width = 390
    local item_height = 60

	if SKINNABLE_CHARACTERS[self.character] then
		if self.scroll_list then
			self.scroll_list:Hide() --ew
		end
		
		local function ScrollWidgetsCtor(context, i)
			local item = Widget("item-"..i)
			item.root = item:AddChild(Widget("root"))
		
			item.row_label = item.root:AddChild(Text(_G.BODYTEXTFONT, 28))
			item.row_label:SetColour(_G.UICOLOURS.IVORY)
			item.row_label:SetHAlign(_G.ANCHOR_RIGHT)
		
			local x_start = -170
			local x_step = 50
		
			item.base_icon = item.root:AddChild( AccountItemFrame() )
			item.base_icon:SetStyle_Normal()
			item.base_icon:SetScale(0.4)
			item.base_icon:SetPosition(x_start + 0 * x_step,0)
				
			item.row_label:SetPosition(-210,-1)
			item.root:SetPosition(20,0)
		
			item.body_icon = item.root:AddChild( AccountItemFrame() )
			item.body_icon:SetStyle_Normal()
			item.body_icon:SetScale(0.4)
			item.body_icon:SetPosition(x_start + 1 * x_step,0)
		
			item.hand_icon = item.root:AddChild( AccountItemFrame() )
			item.hand_icon:SetStyle_Normal()
			item.hand_icon:SetScale(0.4)
			item.hand_icon:SetPosition(x_start + 2 * x_step,0)
		
			item.legs_icon = item.root:AddChild( AccountItemFrame() )
			item.legs_icon:SetStyle_Normal()
			item.legs_icon:SetScale(0.4)
			item.legs_icon:SetPosition(x_start + 3 * x_step,0)
		
			item.feet_icon = item.root:AddChild( AccountItemFrame() )
			item.feet_icon:SetStyle_Normal()
			item.feet_icon:SetScale(0.4)
			item.feet_icon:SetPosition(x_start + 4 * x_step,0)
		
		
			item.load_btn = item.root:AddChild(TEMPLATES.IconButton("images/button_icons.xml", "apply_skins.tex", nil, nil, nil, function(a) self:_LoadPreset(item.i) end, _G.STRINGS.UI.SKIN_PRESETS.LOAD))
			item.load_btn:SetPosition(105,-1)
			item.load_btn:SetScale(0.7)
		
			item.save_btn = item.root:AddChild(TEMPLATES.IconButton("images/button_icons.xml", "save.tex", nil, nil, nil, function() self:_SetPreset(item.i) end, _G.STRINGS.UI.SKIN_PRESETS.SAVE))
			item.save_btn:SetPosition(155,-1)
			item.save_btn:SetScale(0.7)
		
			item.load_btn:SetFocusChangeDir(_G.MOVE_RIGHT, item.save_btn)
			item.save_btn:SetFocusChangeDir(_G.MOVE_LEFT, item.load_btn)
		
			item.focus_forward = item.load_btn
		
			item:SetOnGainFocus(function()
				self.scroll_list:OnWidgetFocus(item)
			end)
		
			return item
		end
		local function ScrollWidgetApply(context, item, data, index)
			if data then            
				item.i = index
				item.row_label:SetString(tostring(index)..":")
		
				if data.base then
					item.base_icon:SetItem(data.base)
				else      
					item.base_icon:SetItem(self.character.."_none")
				end
		
				if data.body then
					item.body_icon:SetItem(data.body)
				else
					item.body_icon:SetItem("body_default1")
				end
		
				if data.hand then
					item.hand_icon:SetItem(data.hand)
				else
					item.hand_icon:SetItem("hand_default1" )
				end
		
				if data.legs then
					item.legs_icon:SetItem(data.legs)
				else
					item.legs_icon:SetItem("legs_default1")
				end
		
				if data.feet then
					item.feet_icon:SetItem(data.feet)
				else
					item.feet_icon:SetItem("feet_default1")
				end
		
				item.root:Show()
			else
				item.root:Hide()
			end
		end
		
		self.scroll_list = self.proot:AddChild(
			TEMPLATES.ScrollingGrid(
				self.list_items,
				{
					context = {},
					widget_width  = content_width + 40,
					widget_height =  item_height,
					num_visible_rows = math.floor(scroll_height/item_height) - 1,
					num_columns      = 1,
					item_ctor_fn = ScrollWidgetsCtor,
					apply_fn     = ScrollWidgetApply,
					scrollbar_height_offset = -60
				}
			))
		self.scroll_list:SetPosition(0, 30)
		
		self.scroll_list:SetFocusChangeDir(_G.MOVE_DOWN, self.dialog.actions)
		self.scroll_list:SetFocusChangeDir(_G.MOVE_RIGHT, self.dialog.actions)
		self.dialog.actions:SetFocusChangeDir(_G.MOVE_UP, self.scroll_list)
		
		self.default_focus = self.scroll_list
	end
end)

AddComponentPostInit("skinner", function(self)
	local _OnLoad = self.OnLoad
	function self:OnLoad(data, ...)
		_OnLoad(self, data, ...) --Hornet: The game checks if we own the item when we load in, But we don't really "own" the skins we are making
									--so we have to do a little hijack and put our skin item back on our character when they're loading in
		if SKINNABLE_CHARACTERS[self.inst.prefab] and data.skin_name ~= nil then
			self:SetSkinName(data.skin_name)
		end
	end
end)

local _IsDefaultSkinOwned = _G.IsDefaultSkinOwned
local _ValidateItemsLocal = _G.ValidateItemsLocal
local _SpawnNewPlayerOnServerFromSim = _G.SpawnNewPlayerOnServerFromSim

function _G.IsDefaultSkinOwned(item_key, ...)
	local index = item_key:find("_")
	local character = item_key:sub(1, index - 1)
	if SKINNABLE_CHARACTERS[character] then
		return true
	end
	
	return _IsDefaultSkinOwned(item_key, ...)
end

--Hornet: Like I said, over and over. We technically don't "own" our skin, and the game gets rid of the base from our character, so we need to save
--the base, run the original function, and then put our base back in place
function _G.ValidateItemsLocal(currentcharacter, selected_skins)
	local _base = selected_skins["base"]

	_ValidateItemsLocal(currentcharacter, selected_skins)
	
	if _base ~= nil and SKINNABLE_CHARACTERS[currentcharacter] then
		selected_skins["base"] = _base 
	end
end

function _G.SpawnNewPlayerOnServerFromSim(player_guid, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
	local player = _G.Ents[player_guid]
	if player ~= nil and SKINNABLE_CHARACTERS[player.prefab] then
		if player ~= nil then
			local skinner = player.components.skinner
			skinner:SetClothing(clothing_body)
			skinner:SetClothing(clothing_hand)
			skinner:SetClothing(clothing_legs)
			skinner:SetClothing(clothing_feet)
			skinner:SetSkinMode("normal_skin")
				
			player:DoTaskInTime(0, function()
				skinner:SetSkinName(player.components.skinner.skin_name)
			end)
		
			if player.OnNewSpawn ~= nil then
				player:OnNewSpawn()
				player.OnNewSpawn = nil
			end
			_G.TheWorld.components.playerspawner:SpawnAtNextLocation(_G.TheWorld, player)
			_G.SerializeUserSession(player, true)
		end
	else
		_SpawnNewPlayerOnServerFromSim(player_guid, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet)
	end
end

AddModRPCHandler(modname, "moddedskins", function(inst, base)
	inst.components.skinner.skin_name = base
end)

function AddSkinnableCharacter(name)
	SKINNABLE_CHARACTERS[name] = true
end