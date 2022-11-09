-- this is responsible for selecting which biomes will be which, and ensuring the 3 sirens exist.
-- current idea I have for the biomes is this:
-- 6-9 biomes, 3 of which become "active" in spring and have the sirens
-- the other biomes are "inactive" and don't have the sirens, but have a bit of the biome's resources
-- and an alt threat (so, for example, SS has sirens on the active ver, but ghoasts on the inactive?)
-- relevant events (to listen in the area handler prefab):
-- generate_inactive
-- generate_main
-- clear
local types = {"siren_throne", "ocean_speaker", "siren_bird_nest"}

local function shuffle(tab)
    local len = #tab
    local r
    for i = 1, len do
        r = math.random(i, len)
        tab[i], tab[r] = tab[r], tab[i]
    end
    return tab
end

local AreaHandler = Class(function(self, inst)
    self.inst = inst
    self.sirens = {}
    self.handlers = {}

end, nil, {})

function AreaHandler:GetHandlers() return self.handlers end

function AreaHandler:GetSirens()
    --print("GetSirens")
    if self.handlers ~= {} then
        for k, v in ipairs(self.handlers) do
            if v.sirenpoint ~= nil then
                table.insert(self.sirens, v.sirenpoint)
                --TheNet:Announce("Getting all sirens... " .. v.sirenpoint)
            else
                --TheNet:Announce("sirenpoint was nil!")
            end
        end
    end
    return self.sirens
end

-- Inactive biomes are random placeholders so the biomes can move around.
function AreaHandler:GenerateInactiveBiomes()
    for k, v in ipairs(self.handlers) do
        if v.sirenpoint == nil then -- any area handlers without a siren.
            v:PushEvent("generate_inactive")
        end
    end
end

-- spawns the main biomes with the sirens (Speaker, Bird & Fish)
function AreaHandler:SelectMainBiomes()
    -- initial selection
    --TheNet:Announce("SelectMainBiomes")
    -- TODO: make it randomize which biomes will be sirens!!
    self.handlers = shuffle(self.handlers)
    if not table.contains(self.sirens, "siren_throne") then
        for k, v in ipairs(self.handlers) do
            if v.sirenpoint == nil then
                v.sirenpoint = "siren_throne"
                v:PushEvent("generate_main")
                --TheNet:Announce("no siren throne, selecting...")
                self:GetSirens()
                break
            end
        end
    end

    if not table.contains(self.sirens, "ocean_speaker") then
        for k, v in ipairs(self.handlers) do
            if v.sirenpoint == nil then
                v.sirenpoint = "ocean_speaker"
                v:PushEvent("generate_main")
                --TheNet:Announce("no ocean speaker, selecting...")
                self:GetSirens()
                break
            end
        end
    end

    if not table.contains(self.sirens, "siren_bird_nest") then
        for k, v in ipairs(self.handlers) do
            if v.sirenpoint == nil then
                v.sirenpoint = "siren_bird_nest"
                v:PushEvent("generate_main")
                --TheNet:Announce("no bird nest, selecting...")
                self:GetSirens()
                break
            end
        end
    end
end

-- Clears all area handler areas, empties sirens table.
-- For generating a new set of biomes.
-- Pushes an event for deleting prefabs around.
function AreaHandler:Clear()
    for k, v in ipairs(self.handlers) do
        v.sirenpoint = nil
        v:PushEvent("clear")
    end
    self.sirens = {}
    -- self:GetSirens()
    --TheNet:Announce("cleared sirens.")
end

-- Clears biomes, selects main biomes and then creates inactive biomes.
function AreaHandler:FullGenerate()
    self:Clear()
    self:SelectMainBiomes()
    self:GenerateInactiveBiomes()
end

-- Turns any active biomes into inactive
function AreaHandler:DeactivateMainBiomes()
    for k, v in ipairs(self.handlers) do
        if v.sirenpoint ~= nil then
            v.sirenpoint = nil
            v:PushEvent("clear")
            v:PushEvent("generate_inactive")
        end
    end
    self.sirens = {}
    self:GetSirens()
end

return AreaHandler
