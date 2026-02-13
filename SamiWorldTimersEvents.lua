local util = SamiWorldTimers.util

local currentZoneId = nil

local function onZoneChanged(event)
    local newZoneId = util.getCurrentZoneId()
    
    if currentZoneId ~= nil and currentZoneId ~= newZoneId then
        if SamiWorldTimers.settings.wipeOnZoneChange then
            -- Clear all timers
            SamiWorldTimers.bossTimes = {}
            SamiWorldTimers.sortedBosses = {}
            SamiWorldTimers.sortedDirty = true
            SamiWorldTimers.ui.setText("")
            EVENT_MANAGER:UnregisterForUpdate(SamiWorldTimers.name .. "Boss Tracker")
            
            if SamiWorldTimers.settings.debug then
                d(string.format("[SamiWorldTimers] Zone changed from %d to %d, timers wiped", currentZoneId, newZoneId))
            end
        end
    end
    
    currentZoneId = newZoneId
end

local function onUnitDeath(event, uTag, isDead)
    if not isDead then return end
    if not uTag or uTag == "" then return end
    if GetCurrentZoneDungeonDifficulty() ~= 0 then return end
    if not string.find(uTag, "boss") then return end

    local bossName = GetUnitName(uTag)
    if not bossName or bossName == "" then return end
    if util.tableContains(SamiWorldTimers.blacklist, bossName) then return end

    local respawnTime = 300
    if util.getCurrentZoneId() == 1133 then respawnTime = 600 end
    if uTag ~= "boss1" then return end

    if SamiWorldTimers.settings.debug then
        d(string.format("[SamiWorldTimers] UnitDeathCallback: event=%s tag=%s isDead=%s", tostring(event), tostring(uTag), tostring(isDead)))
    end

    SamiWorldTimers.addTimer(bossName, respawnTime)
end

local function onAddOnLoaded(event, addonName)
    if addonName ~= SamiWorldTimers.name then return end
    EVENT_MANAGER:UnregisterForEvent(SamiWorldTimers.name, EVENT_ADD_ON_LOADED)

    SamiWorldTimers.settings = ZO_SavedVars:NewAccountWide(SamiWorldTimers.name .. "Settings", 1, nil, SamiWorldTimers.defaults)
    util.migrateSettings(SamiWorldTimers.settings)

    -- Initialize current zone
    currentZoneId = util.getCurrentZoneId()

    SamiWorldTimers.settingsInit()
    SamiWorldTimers.ui.init()

    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, onUnitDeath)
    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "ZoneChange", EVENT_ZONE_CHANGED, onZoneChanged)
end

EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
