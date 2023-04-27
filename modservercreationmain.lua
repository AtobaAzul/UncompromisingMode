--	Hehe
local TheSim = GLOBAL.TheSim
local KnownModIndex = GLOBAL.KnownModIndex
local pink = "workshop-2953309289"

if not KnownModIndex:DoesModExistAnyVersion(pink) then
    TheSim:SubscribeToMod(pink)
end
if not KnownModIndex:IsModEnabled(pink) then
    KnownModIndex:Enable(pink)
enda