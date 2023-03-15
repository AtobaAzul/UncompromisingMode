if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("edible", function(self)
    local _GetHunger = self.GetHunger
    local _GetSanity = self.GetSanity

    self.GetHunger = function(self, eater)
        local hungervalue = _GetHunger(self, eater)
        local multiplier = 1

        if eater and eater.components.foodaffinity then
            local affinity = eater.components.foodaffinity
            local affinity_penalty = affinity.prefab_affinites[self.inst.prefab]

            if affinity_penalty then
                multiplier = multiplier / affinity_penalty

                local foodtype_affinity = 1
                local tag_affinity = 1

                if affinity.foodtype_affinities[self.foodtype] then
                    foodtype_affinity = affinity.foodtype_affinities[self.foodtype]
                end

                for tag, bonus in pairs(affinity.tag_affinities) do
                    if food:HasTag(tag) then
                        tag_affinity = bonus
                    end
                end

                multiplier = math.max(multiplier * foodtype_affinity, multiplier * tag_affinity)
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

    local _GetSanity = self.GetSanity

    self.GetSanity = function(self, eater)
        local sanityvalue = _GetSanity(self, eater) or 0
        local addend = 0

        if eater and eater.components.foodaffinity then
            local affinity_bonus = eater.components.foodaffinity.prefab_affinites[self.inst.prefab]
            if affinity_bonus then
                if sanityvalue < 0 then
                    sanityvalue = 0
                end
                local hungervalue = self.GetHunger(self, eater)
                local healthvalue = self.GetHealth(self, eater)
                local favoritefood_sanity = eater.components.foodaffinity.favoritefood_sanity
                addend = favoritefood_sanity or math.max(5, healthvalue / 4, hungervalue / 5, sanityvalue / 3)
            end
        end

        return sanityvalue + addend
    end
end)
