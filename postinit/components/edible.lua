--[[
Documentation: KoreanWaffles

Characters can have three types of food affinity: Prefab Affinity, Tag Affinity, and Foodtype Affinity
Prefab Affinity is specifying a prefab to give bonus hunger (e.g. Bacon and Eggs for Wilson)
Tag Affinity is specifying all foods with a certain tag to give bonus hunger (not used in base game)
Foodtype Affinity is specifying all foods of a certain type to give bonus hunger (e.g. veggies for Wurt)

It is assumed that any prefab affinity is considered a character's favorite food, and thus will be
converted into bonus sanity, but not tag affinity or foodtype affinity (if foodtype affinity was included,
Wurt would gain sanity from eating any vegetable!). If you want to specify a character to have all
foods of a certain tag or foodtype to be their favorite foods, please use the favorite_food_fn function
in the foodaffinity component.

Please refer to postinit/components/foodaffinity for related changes and further documentation 
regarding characters' favorite foods.

DoFoodEffects in postinit/components/eater was modified to check for favorite foods.
]]

if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("edible", function(self)
    local _GetHealth = self.GetHealth
    local _GetHunger = self.GetHunger
    local _GetSanity = self.GetSanity

    --- NEW FUNCTION
    --- Determines if this food is a character's favorite food.
    --- @eater: The character eating this food.
    function self:IsFavoriteFood(eater)
        if eater and eater.components.foodaffinity then
            foodaffinity = eater.components.foodaffinity
            local prefab = foodaffinity:GetFoodBasePrefab(self.inst)
            local prefab_affinity = foodaffinity:HasPrefabAffinity(self.inst)
            local favorite_foods = foodaffinity.favorite_foods
            local favorite_food_fn = foodaffinity.favorite_food_fn
            return favorite_foods and favorite_foods[prefab] and true or prefab_affinity or favorite_food_fn and favorite_food_fn(self.inst)
        end
        return false
    end

    -- Reverse the bonus hunger granted by favorite foods.
    self.GetHunger = function(self, eater)
        local hungervalue = _GetHunger(self, eater)
        local multiplier = 1

        foodaffinity = eater.components.foodaffinity
        local found_affinities = {}

        if foodaffinity.prefab_affinities[self.inst.prefab] ~= nil then
            table.insert(found_affinities, foodaffinity.prefab_affinities[self.inst.prefab])
        end
    
        local basefood = foodaffinity:GetFoodBasePrefab(self.inst)
        local prefabaffinity = foodaffinity.prefab_affinities[basefood]
        if prefabaffinity ~= nil then
            table.insert(found_affinities, prefabaffinity)
        end

        if #found_affinities > 0 then
            if #found_affinities > 1 then
                -- Sort the found_affinities so we return the biggest bonus
                table.sort(found_affinities, function(a,b) return a > b end)
            end
            multiplier = multiplier / found_affinities[1]
        end

        return hungervalue * multiplier
    end

    -- Prevent favorite foods from reducing health.
    self.GetHealth = function(self, eater)
        local healthvalue = _GetHealth(self, eater) or 0
        if self:IsFavoriteFood(eater) then
            -- favorite foods will not incur health penalties
            healthvalue = math.max(0, healthvalue)
        end
        return healthvalue
    end

    function self:GetSanity(eater, ...)--scuffed af but I don't really know how to integrate that with the next GetSanity lmao
        if eater ~= nil and eater:HasTag("ratwhisperer") then --if winky
            return self.sanityvalue --return the normal sanity val with no multipliers
        else
            return _GetSanity(self, eater, ...) -- return the vanilla behaviour otherwise
        end
    end

    -- Calculations for favorite food sanity.
    local _GetSanity = self.GetSanity
    self.GetSanity = function(self, eater)
        local sanityvalue = _GetSanity(self, eater) or 0
        local addend = 0
        if self:IsFavoriteFood(eater) then
            -- favorite foods will not incur sanity penalties
            sanityvalue = math.max(0, sanityvalue)
            local prefab = eater.components.foodaffinity:GetFoodBasePrefab(self.inst)
            local favorite_foods = eater.components.foodaffinity.favorite_foods
            local healthvalue = self.GetHealth(self, eater) or 0
            local hungervalue = self.GetHunger(self, eater) or 0
            addend = favorite_foods and favorite_foods[prefab] or math.max(5, healthvalue / 4, hungervalue / 5, sanityvalue / 3)
        end
        return sanityvalue + addend
    end
end)
