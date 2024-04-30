--[[
    Documentation: KoreanWaffles

All characters can use Warly's Portable Crock Pot to cook normal Crock Pot dishes.
Only Warly (i.e. characters with the "masterchef" tag) can cook his exclusive dishes.

Crock Pot recipes are calculated based on the cooking device's prefab. If the character 
using the pot isn't Warly, then we can spoof the recipe calculation by temporarily 
changing the prefab name of the Portable Crock Pot into a normal Crock Pot.

Refer to init/init_actions for related changes to the Rummage and Store actions.

-- KoreanWaffles
]]

if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("stewer", function(self)
    _StartCooking = self.StartCooking
    self.StartCooking = function(self, doer)
        if self.inst.prefab == "portablecookpot" and not doer:HasTag("masterchef") then
            self.inst.prefab = "cookpot"
            ret = _StartCooking(self, doer)
            self.inst.prefab = "portablecookpot"
            return ret
        end
        return _StartCooking(self, doer)
    end
end)
