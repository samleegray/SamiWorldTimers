SamiWorldTimers = {
    name = "SamiWorldTimers",
    version = "1.0.0",
    author = "@samihaize",
}

SamiWorldTimers.settings = {}

SamiWorldTimers.defaults = {
    offsetX = 100,
    offsetY = 200,
    timeoutDuration = 8,
    warningDuration = 60,
    alertDuration = 15,
    warningColour = "FFAA00",
    alertColour = "FF0000",
    trackDragons = true,
    dragonRespawnTime = 600,
    wipeOnZoneChange = false,
    debug = false,
}

SamiWorldTimers.bossTimes = {}
SamiWorldTimers.blacklist = {
    --Geysers
    "Ruella Many-Claws",
    "Churug of the Abyss",
    "Sheefar of the Depths",
    "Girawell the Erratic",
    "Muustikar Wave-Eater",
    "Reefhammer",
    "Darkstorm the Alluring",
    "Eejoba the Radiant",
    "Tidewrack",
    "Vsskalvor",
    --Vents
    "Flame Hound Alpha",
    "Ashen Spriggan",
    "Fire Behemoth",
    "Molten Destroyer",
    "Fissure Goliath",
    --Mirrormoor Mosaic
    "Shrakkaher",
    "Rrarrvok",
    "Krrazzak"
}
SamiWorldTimers.dragonZones = {
    1086, -- Northern Elsweyr
    1133, -- Southern Elsweyr
}
SamiWorldTimers.sortedBosses = {}
SamiWorldTimers.sortedDirty = true
