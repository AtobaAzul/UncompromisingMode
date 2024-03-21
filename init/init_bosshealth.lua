local bosses = {
    "MINOTAUR",
    "STALKER_ATRIUM",
    "BEARGER",
    "MUTATED_BEARGER",
    "BEEQUEEN",
    "ALTERGUARDIAN",
    "DEERCLOPS",
    "MUTATED_DEERCLOPS",
    "DRAGONFLY",
    "EYEOFTERROR",
    "TWINOFTERROR",
    "SHARKBOI",
    "LORDFRUITFLY",
    "MALBATROSS",
    "MOOSE",
    "DAYWALKER",
    --"WARG" WARG IS NOT A BOSS.
    "MUTATED_WARG",
    "SPIDERQUEEN",
    "TOADSTOOL",
    "TOADSTOOL_DARK",
    "KLAUS",
    "ANTLION",
    "CRABKING",
    "LEIF"
}

for k, v in pairs(bosses) do
    if v == "ALTERGUARDIAN" then
        TUNING["ALTERGUARDIAN_PHASE1_HEALTH"] = TUNING["ALTERGUARDIAN_PHASE1_HEALTH"] * GetModConfigData("alterguardian_health_")
        TUNING["ALTERGUARDIAN_PHASE2_MAXHEALTH"] = TUNING["ALTERGUARDIAN_PHASE2_MAXHEALTH"] * GetModConfigData("alterguardian_health_")
        TUNING["ALTERGUARDIAN_PHASE2_STARTHEALTH"] = TUNING["ALTERGUARDIAN_PHASE2_STARTHEALTH"] * GetModConfigData("alterguardian_health_")
        TUNING["ALTERGUARDIAN_PHASE3_STARTHEALTH"] = TUNING["ALTERGUARDIAN_PHASE3_STARTHEALTH"] * GetModConfigData("alterguardian_health_")
        TUNING["ALTERGUARDIAN_PHASE3_MAXHEALTH"] = TUNING["ALTERGUARDIAN_PHASE3_MAXHEALTH"] * GetModConfigData("alterguardian_health_")
    elseif v == "TWINOFTERROR" then
        TUNING["TWIN1_HEALTH"] = TUNING["TWIN1_HEALTH"] * GetModConfigData("twinofterror_health_")
        TUNING["TWIN2_HEALTH"] = TUNING["TWIN2_HEALTH"] * GetModConfigData("twinofterror_health_")
    elseif v == "LEIF" then
        TUNING["LEIF_HEALTH"] = TUNING["LEIF_HEALTH"] * GetModConfigData("leif_health")
    else
        TUNING[v .. "_HEALTH"] = TUNING[v .. "_HEALTH"] * GetModConfigData(string.lower(v) .. "_health_")
    end
end

TUNING.STALKER_ATRIUM_PHASE2_HEALTH = TUNING.STALKER_ATRIUM_PHASE2_HEALTH * GetModConfigData("stalker_atrium_health_")
TUNING.SHADOW_ROOK.HEALTH = { (1000 * GetModConfigData("shadowpieces_health_")), (4000 * GetModConfigData("shadowpieces_health_")), (10000 * GetModConfigData("shadowpieces_health_")) }
TUNING.SHADOW_KNIGHT.HEALTH = { (900 * GetModConfigData("shadowpieces_health_")), (2700 * GetModConfigData("shadowpieces_health_")), (8100 * GetModConfigData("shadowpieces_health_")) }
TUNING.SHADOW_BISHOP.HEALTH = { (800 * GetModConfigData("shadowpieces_health_")), (2500 * GetModConfigData("shadowpieces_health_")), (7500 * GetModConfigData("shadowpieces_health_")) }
