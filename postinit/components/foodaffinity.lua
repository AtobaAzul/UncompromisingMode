if not GLOBAL.TheNet:GetIsServer() then return end

AddComponentPostInit("foodaffinity", function(self)
    self.favoritefood_sanity = nil
end)
