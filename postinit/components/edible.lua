--[[
Documentation: KoreanWaffles

Please refer to postinit/components/foodaffinity for related changes
and further documentation regarding characters' favorite foods.

DoFoodEffects in postinit/components/eater was modified to check for
favorite foods.
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
            local prefab = eater.components.foodaffinity:GetFoodBasePrefab(self.inst)
            local affinity_bonus = eater.components.foodaffinity:HasAffinity(self.inst)
            local favorite_foods = eater.components.foodaffinity.favorite_foods
            local favorite_food_fn = eater.components.foodaffinity.favorite_food_fn
            return favorite_foods and favorite_foods[prefab] and true or affinity_bonus or favorite_food_fn and favorite_food_fn(self.inst)
        end
        return false
    end

    -- Reverse the bonus hunger granted by favorite foods.
    self.GetHunger = function(self, eater)
        local hungervalue = _GetHunger(self, eater)
        local multiplier = 1

        if eater and eater.components.foodaffinity then
            local affinity_bonus = eater.components.foodaffinity:GetAffinity(self.inst)
            if affinity_bonus then
                multiplier = multiplier / affinity_bonus
            end
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
        -- favorite foods will not incur sanity penalties
        sanityvalue = math.max(0, sanityvalue)
        local addend = 0
        if self:IsFavoriteFood(eater) then
            local prefab = eater.components.foodaffinity:GetFoodBasePrefab(self.inst)
            local affinity_bonus = eater.components.foodaffinity:HasAffinity(self.inst)
            local favorite_foods = eater.components.foodaffinity.favorite_foods
            local favorite_food_fn = eater.components.foodaffinity.favorite_food_fn
            local healthvalue = self.GetHealth(self, eater) or 0
            local hungervalue = self.GetHunger(self, eater) or 0
            addend = (favorite_foods and favorite_foods[prefab]) or 
                ((affinity_bonus or favorite_food_fn and favorite_food_fn(self.inst)) and 
                    math.max(5, healthvalue / 4, hungervalue / 5, sanityvalue / 3))
        end
        return sanityvalue + addend
    end
end)
