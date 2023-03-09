_G = GLOBAL

local function AddDescriptors()
    if not _G.rawget(_G, "Insight") then return end

    _G.Insight.descriptors.uncompromising_deerclopsspawner = _G.require("descriptors/uncompromising_deerclopsspawner")
    _G.Insight.descriptors.mock_dragonflyspawner = _G.require("descriptors/mock_dragonflyspawner")
    _G.Insight.descriptors.gmoosespawner = _G.require("descriptors/gmoosespawner")
end

AddSimPostInit(AddDescriptors) -- _G.Insight.descriptors may not exist yet, but it will exist at AddSimPostInit.