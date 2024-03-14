local env = env
GLOBAL.setfenv(1, GLOBAL)
-----------------------------------------------------------------

local TechTree = require("techtree")

local function CopyTechTrees(src, dest)
    for i, v in ipairs(TechTree.AVAILABLE_TECH) do
        dest[v] = src[v] or 0
    end
end

local PROTOTYPER_TAGS = { "prototyper" }


env.AddComponentPostInit("builder", function(self)
    table.remove(self.exclude_tags, 7)
    --local _EvaluateTechTrees = self.EvaluateTechTrees
    --cba to hook atm, this thing is a mess.
    function self:EvaluateTechTrees()
        local pos = self.inst:GetPosition()

        local ents
        if self.override_current_prototyper then
            if self.override_current_prototyper:IsValid()
                and self.override_current_prototyper:HasTags(PROTOTYPER_TAGS)
                and not self.override_current_prototyper:HasOneOfTags(self.exclude_tags)
                and (self.override_current_prototyper.components.prototyper.restrictedtag == nil or self.inst:HasTag(self.override_current_prototyper.components.prototyper.restrictedtag))
                and self.inst:IsNear(self.override_current_prototyper, TUNING.RESEARCH_MACHINE_DIST)
            then
                ents = { self.override_current_prototyper }
            else
                self.override_current_prototyper = nil
            end
        end

        if ents == nil then
            ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TUNING.RESEARCH_MACHINE_DIST, PROTOTYPER_TAGS, self.exclude_tags)
        end

        CopyTechTrees(self.accessible_tech_trees, self.old_accessible_tech_trees)
        local old_station_recipes = self.station_recipes
        local old_prototyper = self.current_prototyper
        self.current_prototyper = nil
        self.station_recipes = {}

        local prototyper_active = false
        for i, v in ipairs(ents) do
            if self.inst.prefab ~= "wickerbottom" then
               
               
               
            end
            if v ~= self.inst and v.components.prototyper ~= nil and (v.components.prototyper.restrictedtag == nil or self.inst:HasTag(v.components.prototyper.restrictedtag)) then
                if not prototyper_active then
                    --activate the first machine in the list. This will be the one you're closest to.
                    v.components.prototyper:TurnOn(self.inst)

                    --prototyper:GetTrees() returns a deepcopy, which we no longer want
                    CopyTechTrees(v.components.prototyper.trees, self.accessible_tech_trees)

                    if v.components.craftingstation ~= nil then
                        local recs = v.components.craftingstation:GetRecipes(self.inst)
                        for _, recname in ipairs(recs) do
                            local recipe = GetValidRecipe(recname)
                            if recipe ~= nil and recipe.nounlock then
                                --only nounlock recipes can be unlocked via crafting station
                                self.station_recipes[recname] = true
                            end
                        end
                    end

                    prototyper_active = true
                    self.current_prototyper = v
                else
                    --you've already activated a machine. Turn all the other machines off.
                    v.components.prototyper:TurnOff(self.inst)
                end
            end
        end

        --V2C: Hacking giftreceiver logic in here so we do
        --     not have to duplicate the same search logic
        if self.inst.components.giftreceiver ~= nil then
            self.inst.components.giftreceiver:SetGiftMachine(
                self.current_prototyper ~= nil and
                self.current_prototyper:HasTag("giftmachine") and
                CanEntitySeeTarget(self.inst, self.current_prototyper) and
                self.inst.components.inventory.isopen and --ignores .isvisible, as long as it's .isopen
                self.current_prototyper or
                nil)
        end

        --add any character specific bonuses to your current tech levels.
        CopyTechTrees(self.accessible_tech_trees, self.accessible_tech_trees_no_temp)
        if not prototyper_active then
            for i, v in ipairs(TechTree.AVAILABLE_TECH) do
                self.accessible_tech_trees_no_temp[v] = (self[string.lower(v) .. "_bonus"] or 0)
                self.accessible_tech_trees[v] = (self[string.lower(v) .. "_tempbonus"] or 0) + (self[string.lower(v) .. "_bonus"] or 0)
            end
        else
            for i, v in ipairs(TechTree.BONUS_TECH) do
                self.accessible_tech_trees_no_temp[v] = self.accessible_tech_trees_no_temp[v] + (self[string.lower(v) .. "_bonus"] or 0)
                self.accessible_tech_trees[v] = self.accessible_tech_trees[v] +
                    (self[string.lower(v) .. "_tempbonus"] or 0) +
                    (self[string.lower(v) .. "_bonus"] or 0)
            end
        end

        if old_prototyper ~= nil and
            old_prototyper ~= self.current_prototyper and
            old_prototyper.components.prototyper ~= nil and
            old_prototyper.entity:IsValid() then
            old_prototyper.components.prototyper:TurnOff(self.inst)
        end

        local trees_changed = false

        for recname, _ in pairs(self.station_recipes) do
            if old_station_recipes[recname] then
                old_station_recipes[recname] = nil
            else
                self.inst.replica.builder:AddRecipe(recname)
                trees_changed = true
            end
        end

        if next(old_station_recipes) ~= nil then
            for recname, _ in pairs(old_station_recipes) do
                self.inst.replica.builder:RemoveRecipe(recname)
            end
            trees_changed = true
        end

        if not trees_changed then
            for k, v in pairs(self.old_accessible_tech_trees) do
                if v ~= self.accessible_tech_trees[k] then
                    trees_changed = true
                    break
                end
            end
            --V2C: not required anymore; both trees should have the same keys now
            --[[if not trees_changed then
                for k, v in pairs(self.accessible_tech_trees) do
                    if v ~= self.old_accessible_tech_trees[k] then
                        trees_changed = true
                        break
                    end
                end
            end]]
        end

        if trees_changed then
            self.inst:PushEvent("techtreechange", { level = self.accessible_tech_trees })
            self.inst.replica.builder:SetTechTrees(self.accessible_tech_trees)
        end

        if self.override_current_prototyper ~= nil then
            if self.override_current_prototyper ~= self.current_prototyper then
                self.override_current_prototyper = nil
            elseif self.override_current_prototyper ~= old_prototyper then
                self.inst.replica.builder:OpenCraftingMenu()
            end
        end
    end

    function self:UsePrototyper(prototyper)
       
       
       
       
       

        if prototyper ~= nil then
            if not prototyper:HasTags(PROTOTYPER_TAGS)
                or prototyper:HasOneOfTags(self.exclude_tags)
                or (prototyper.components.prototyper ~= nil and prototyper.components.prototyper.restrictedtag ~= nil and not self.inst:HasTag(prototyper.components.prototyper.restrictedtag))
            then
                local fail_str = prototyper.components.prototyper and prototyper.components.prototyper.restrictedtag or nil
                return false, fail_str ~= nil and string.upper(fail_str) or nil
            end
        end

        self.override_current_prototyper = prototyper
        if prototyper ~= nil and prototyper == self.current_prototyper then
            self.inst.replica.builder:OpenCraftingMenu()
        end
        return true
    end
end)
