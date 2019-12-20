local InventoryItem = Class(function(self, inst)
    self.inst = inst
end)

function Hayfever:SetNextSneezeTime(newsneezetime)
    self.inst:PushEvent("updatepollen", {sneezetime = newsneezetime})
end

return Hayfever