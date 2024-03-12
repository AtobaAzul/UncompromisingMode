--[[
Documentation: KoreanWaffles

Please refer to postinit/components/foodaffinity for related changes
and further documentation regarding characters' favorite foods.
]]

if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("edible", function(self)
    local _GetHunger = self.GetHunger
    local _GetSanity = self.GetSanity

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
        
        if eater and eater.components.foodaffinity then
            local prefab = eater.components.foodaffinity:GetFoodBasePrefab(self.inst)
            local affinity_bonus = eater.components.foodaffinity.prefab_affinites[prefab]
            local favorite_foods = eater.components.foodaffinity.favorite_foods
            local favorite_food_fn = eater.components.foodaffinity.favorite_food_fn
            -- check if this food is already defined as the character's favorite food
            if favorite_foods and favorite_foods[prefab] then
                addend = favorite_foods[prefab]
            -- check for the affinity bonus or if this food satisfies the eater's favorite food function
            elseif affinity_bonus or favorite_food_fn and favorite_food_fn(self.inst) then
                -- favorite foods will not incur sanity penalties
                if sanityvalue < 0 then
                    sanityvalue = 0
                end
                local hungervalue = self.GetHunger(self, eater)
                local healthvalue = self.GetHealth(self, eater)
                -- Since no sanity value was specified in favorite_foods, bonus sanity will be
                -- calculated dynamically based on the stats of the food, with a minumum value of 5.
                addend = math.max(5, healthvalue / 4, hungervalue / 5, sanityvalue / 3)
            end
        end

        return sanityvalue + addend
    end
end)
