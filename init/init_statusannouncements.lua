local PlayerHud = GLOBAL.require("screens/playerhud")
local TUNING = GLOBAL.TUNING

local function AddStatAnnouncements(statusAnnouncer, statName, badge, currentMaxFn)
    statusAnnouncer:RegisterStat(
        statName,
        badge,
        CONTROL_ROTATE_LEFT,
        { .15, .35, .55, .75 },
        { "EMPTY", "LOW", "MID", "HIGH", "FULL" },
        currentMaxFn,
        nil
    )
end

local PlayerHud_SetMainCharacter = PlayerHud.SetMainCharacter
function PlayerHud:SetMainCharacter(maincharacter, ...)
    PlayerHud_SetMainCharacter(self, maincharacter, ...)
    self.inst:DoTaskInTime(0, function()
        if self._StatusAnnouncer then
            AddStatAnnouncements(self._StatusAnnouncer, "Adrenaline", self.controls.status.adrenaline,
                function(ThePlayer)
                    return ThePlayer.counter_current:value(), -- Adrenaline replica's GetCurrent() just returns 100. What.
                        ThePlayer.counter_max:value()
                end)

            -- WOBY_HUNGER changed to just WOBY in the quotes, otherwise we'll announce the underscore (Woby_Hunger: 25/100 ...)
            AddStatAnnouncements(self._StatusAnnouncer, "Woby", self.controls.status.WobyHungerDisplay,
                function(ThePlayer)
                    return ThePlayer.player_classified.WobyHunger:value(),
                        TUNING.WOBY_BIG_HUNGER -- I couldn't find a get max fn anywhere. Is this the right one? Both big and small have the same value.
                end)
        end
    end)
end