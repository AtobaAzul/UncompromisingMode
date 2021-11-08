-- Made by CunningFox
-- Thanks to Ysovuka/Kzisor for the base code

local env = env
GLOBAL.setfenv(1, GLOBAL)

local OFFICIAL_PREFABS = {}
if not rawget(_G, "MODDED_SKINS") then
	global("MODDED_SKINS")
	MODDED_SKINS = {}
end

local function IsSkinModded(skin)
	for _, skins in pairs(MODDED_SKINS) do
		for name, _ in pairs(skins) do
			if name == skin then
				return true
			end
		end
	end
	return false
end

local function HasSkins(item)
	return item and MODDED_SKINS[item.base_prefab or item.prefab] or false
end

local _RegisterPrefabs = ModManager.RegisterPrefabs
ModManager.RegisterPrefabs = function(self, ...)
	if not next(OFFICIAL_PREFABS) then
		for k, v in pairs(Prefabs) do
			OFFICIAL_PREFABS[v.name] = true
		end
	end
	return _RegisterPrefabs(self, ...)
end

local function IsOfficial(item)
	return OFFICIAL_PREFABS[item]
end

local function RecipePopupPostConstruct(self)
    local _GetSkinsList = self.GetSkinsList
    self.GetSkinsList = function(self, ...)
        if IsOfficial(self.recipe.product) then
            return _GetSkinsList(self, ...)
        end
        
        self.skins_list = {}
        if self.recipe and PREFAB_SKINS[self.recipe.name] then
            for _, item_type in pairs(PREFAB_SKINS[self.recipe.name]) do
                local data = {
				    type = type,
				    item = item_type,
				    -- timestamp = nil
				}
				table.insert(self.skins_list, data)
			end
	    end
	    
	    return self.skins_list
    end
    
    local _GetSkinOptions = self.GetSkinOptions
    self.GetSkinOptions = function(self, ...)
        if IsOfficial(self.recipe.product) then
            return _GetSkinOptions(self, ...)
        end
		
        local skin_options = {}

        table.insert(skin_options, 
        {
            text = STRINGS.UI.CRAFTING.DEFAULT,
            data = nil, 
            colour = SKIN_RARITY_COLORS.Common,
            new_indicator = false,
            image =  {self.recipe.atlas or "images/inventoryimages.xml", self.recipe.image or self.recipe.name..".tex", "default.tex"},
        })
		
        if self.skins_list and TheNet:IsOnlineMode() then 
			-- local recipe_timestamp = Profile:GetRecipeTimestamp(self.recipe.name)
            for i, data in ipairs(self.skins_list) do
                local item = data.item 
				
                local rarity = GetRarityForItem(item) or "Common"
                local colour = SKIN_RARITY_COLORS[rarity]
                local text_name = STRINGS.SKIN_NAMES[item] or STRINGS.SKIN_NAMES.missing
                -- local new_indicator = not data.timestamp or (data.timestamp > recipe_timestamp)

				local image_name = item
				local atlas = self.recipe.skin_img_data and self.recipe.skin_img_data[item].atlas or self.recipe.atlas or "images/inventoryimages.xml"
				
				if self.recipe.skin_img_data then
					image_name = self.recipe.skin_img_data[item].image
				else
					if image_name == "" then 
						image_name = "default"
					else
						image_name = string.gsub(image_name, "_none", "")
					end
					image_name = image_name .. ".tex"
				end

                table.insert(skin_options,  
                {
                    text = text_name, 
                    data = nil,
                    colour = colour,
                    -- new_indicator = new_indicator,
                    image = {atlas, image_name, "poop.tex"},
                })
            end
	    else 
    		self.spinner_empty = true
	    end

	    return skin_options
    end
end

local function BuilderSkinPostInit(self)
    local _MakeRecipeFromMenu = self.MakeRecipeFromMenu
    self.MakeRecipeFromMenu = function(self, recipe, skin, ...)
        if IsOfficial(recipe.product) then
            return _MakeRecipeFromMenu(self, recipe, skin, ...)
        end
		
		if not recipe.placer then
			if self:KnowsRecipe(recipe.name) then
				if self:IsBuildBuffered(recipe.name) or self:CanBuild(recipe.name) then
					self:MakeRecipe(recipe, nil, nil, skin)
				end
			elseif CanPrototypeRecipe(recipe.level, self.accessible_tech_trees) and
				self:CanLearn(recipe.name) and
				self:CanBuild(recipe.name) then
				self:MakeRecipe(recipe, nil, nil, skin, function()
					self:ActivateCurrentResearchMachine()
					self:UnlockRecipe(recipe.name)
				end)
			end
		end 
    end
	
    local _DoBuild = self.DoBuild
	-- Fox: We don't use Klei's skinned prefabs system, we just spawn a skin prefab
	-- Change the product of the prefab to a skin, call Build fn, revert changes.
    self.DoBuild = function(self, recname, pt, rotation, skin, ...)
		local rec = GetValidRecipe(recname)
        if rec and not IsOfficial(rec.product) then
            if skin then
                if not AllRecipes[recname]._product then
                    AllRecipes[recname]._product = AllRecipes[recname].product
                end
                AllRecipes[recname].product = skin
            else
                if AllRecipes[recname]._product then
                    AllRecipes[recname].product = AllRecipes[recname]._product
                end
            end
        end
        
        local val = {_DoBuild(self, recname, pt, rotation, skin, ...)}
		
		if AllRecipes[recname]._product then
			AllRecipes[recname].product = AllRecipes[recname]._product
		end
		AllRecipes[recname]._product = nil
		
		return unpack(val)
    end
end

env.AddClassPostConstruct("widgets/recipepopup", RecipePopupPostConstruct)
env.AddComponentPostInit("builder", BuilderSkinPostInit)

-- Apply item's skin to placer
env.AddComponentPostInit("playercontroller", function(self)
	local _StartBuildPlacementMode = self.StartBuildPlacementMode
	function self:StartBuildPlacementMode(...)
		local val = {_StartBuildPlacementMode(self, ...)}
		
		if self.placer and self.placer.ApplySkin and self.placer_recipe_skin then
			self.placer:ApplySkin(self.placer_recipe_skin)
		end
		
		return unpack(val)
	end
	-- ThePlayer.components.builder:GiveAllRecipes()
	-- Fix for sending skin's id since we don't have one
	-- local _RemoteMakeRecipeAtPoint = self.RemoteMakeRecipeAtPoint
	-- function self:RemoteMakeRecipeAtPoint(recipe, pt, rot, skin, ...)
		-- if skin and IsSkinModded(skin) then
			-- print(recipe, pt, rot, skin, ...)
			-- skin = nil
		-- end
		-- return _RemoteMakeRecipeAtPoint(self, recipe, pt, rot, skin, ...)
	-- end
end)

-- Patch inventory components so all moded skins are avalible to everyone
local _CheckClientOwnership = InventoryProxy.CheckClientOwnership
function InventoryProxy:CheckClientOwnership(userid, item, ...)
	if IsSkinModded(item) then
		return true
	end
	return _CheckClientOwnership(self, userid, item, ...)
end

-- SpawnSaveRecord
-- inst:GetSaveRecord

-- Fox: Since we're spawning different prefabs instead of applying skins, we can't really resking modded items
-- Sike! If item supports it, we can just GetSaveRecord, then change the prefab and SpawnSaveRecord right where the item is!
-- Keep in mind that the original entity will be removed, so all references must be cleared!
function ReskinModEntity(inst, skin)
	local data = inst:GetSaveRecord()
	data.prefab = skin
	
	inst:PushEvent("reskin", {skin = skin})
	inst:Remove()
	
	local new = SpawnSaveRecord(data)
	new:PushEvent("reskined_spawn")
	
	return new
end

env.AddPrefabPostInit("reskin_tool", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local spellcaster = inst.components.spellcaster
	
	local _can_cast_fn = spellcaster.can_cast_fn
	spellcaster.can_cast_fn = function(doer, target, ...)
		if HasSkins(target) then
			return true
		end
		
		return _can_cast_fn(doer, target, ...)
	end
	
	-- Our custom reskinner!
	local _spell = spellcaster.spell
	spellcaster.spell = function(inst, target, ...)
		if not HasSkins(target) then
			return _spell(inst, target, ...)
		end
		
		SpawnAt("explode_reskin", target)

		local prefab = target.base_prefab or target.prefab
		local skin = target.skinname or target.prefab
		
		if not inst._cached_reskinname[prefab] then
			inst._cached_reskinname[prefab] = skin
		end
		
		while inst._cached_reskinname[prefab] == skin do
			for item_type, _ in pairs(MODDED_SKINS[prefab]) do
				if item_type ~= skin then
					inst._cached_reskinname[prefab] = item_type
					break
				end
			end
		end
		
		ReskinModEntity(target, inst._cached_reskinname[prefab])
	end
end)

function CreateModPrefabSkin(item, info)
	-- Fox: This is never even gets called, but CreatePrefabSkin requires it
	if not rawget(_G, info.base_prefab.."_clear_fn") then
		rawset(_G, info.base_prefab.."_clear_fn", function(inst)  basic_clear_fn(inst, info.build_name_override) end)
	end
	
	if not PREFAB_SKINS[info.base_prefab] then
		PREFAB_SKINS[info.base_prefab] = {}
	end
	table.insert(PREFAB_SKINS[info.base_prefab], item)
	
	info.fn = info.fn or function(...) print("ERROR: Tried to create a skinned prefab without base fn!") end
	
	local prefab = CreatePrefabSkin(item, info)
	prefab.fn = function(...)
		local inst = info.fn(...)
		if not info.custom_name then
			inst:SetPrefabNameOverride(info.base_prefab)
		end
		
		inst.skinname = item
		inst.base_prefab = info.base_prefab
		inst.reskinable = info.reskinable or true
		
		return inst
	end
	
	if not MODDED_SKINS[info.base_prefab] then
		MODDED_SKINS[info.base_prefab] = {
			[info.base_prefab] = true, -- Base prefab counts as a skin!
		}
	end
	MODDED_SKINS[info.base_prefab][item] = true
	
	PREFAB_SKINS_IDS = {}
	for prefab, skins in pairs(PREFAB_SKINS) do
		PREFAB_SKINS_IDS[prefab] = {}
		for k,v in pairs(skins) do
			PREFAB_SKINS_IDS[prefab][v] = k
		end
	end
	
	return prefab
end

function MadeRecipeSkinnable(rec_name, data)
	local rec = AllRecipes[rec_name]
	if not rec then
		print("ERROR: Tried to make skinnable recipe but failed to find the recipe itself! Recipe:", rec_name)
		return
	end
	
	rec.skinnable = true
	
	if data then
		rec.skin_img_data = {}
		for name, img_data in pairs(data) do
			rec.skin_img_data[name] =
			{
				atlas = img_data.atlas,
				image = img_data.image,
			}
		end
	end
end

env.MadeRecipeSkinnable = MadeRecipeSkinnable