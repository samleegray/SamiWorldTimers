local util = SamiWorldTimers.util

local currentZoneId = nil
local lastDragonZoneId = nil
local dragonUnits = {}

local function GetNextWorldEventInstanceIdIter(state, var1)
	return GetNextWorldEventInstanceId(var1)
end

local function refreshDragonUnits(force)
    local zoneId = util.getCurrentZoneId()
    if not force and lastDragonZoneId == zoneId then return end

    lastDragonZoneId = zoneId
    dragonUnits = {}

    if util.tableContains(SamiWorldTimers.dragonZones, zoneId) then
        for worldEventInstanceId in GetNextWorldEventInstanceIdIter do
            local unitTag = GetWorldEventInstanceUnitTag(worldEventInstanceId, 1)
            if unitTag and unitTag ~= "" then
                local dragonName = GetUnitName(unitTag)
                dragonUnits[unitTag] = dragonName
                if dragonName and dragonName ~= "" then
                    d(string.format("[SamiWorldTimers] Dragon found: %s (%s)", tostring(dragonName), tostring(unitTag)))
                end
            end
        end
    end
end

local function onWorldEventUnitChanged()
    refreshDragonUnits(true)
end

local function onZoneChanged(initial)
    if not SamiWorldTimers.settings.wipeOnZoneChange then return end

    local newZoneId = util.getCurrentZoneId()
    
    if currentZoneId ~= nil and currentZoneId ~= newZoneId then
        -- Clear all timers
        SamiWorldTimers.bossTimes = {}
        SamiWorldTimers.sortedBosses = {}
        SamiWorldTimers.sortedDirty = true
        SamiWorldTimers.ui.setText("")
        EVENT_MANAGER:UnregisterForUpdate(SamiWorldTimers.name .. "Boss Tracker")
        
        if SamiWorldTimers.settings.debug then
            d(string.format("[SamiWorldTimers] Zone changed from %s to %s, timers wiped", tostring(currentZoneId), tostring(newZoneId)))
        end
    end
    
    currentZoneId = newZoneId
    refreshDragonUnits()
end

local function onUnitDeath(event, uTag, isDead)
    local zoneId = util.getCurrentZoneId()
    local isDragonZone = util.tableContains(SamiWorldTimers.dragonZones, zoneId)
    local allowNonPrimaryBoss = SamiWorldTimers.settings.trackDragons and isDragonZone
    local bossName = GetUnitName(uTag)

    d(string.format("[SamiWorldTimers] MISC unit death detected: uTag=%s bossName=%s", tostring(uTag), tostring(bossName)))


    if not isDead then return end
    if not uTag or uTag == "" then return end
    if GetCurrentZoneDungeonDifficulty() ~= 0 then return end
    local isBossTag = string.find(uTag, "boss") ~= nil
    local isWorldEventTag = string.find(uTag, "worldevent") ~= nil
    if not isBossTag and not isWorldEventTag then return end

    if isWorldEventTag then
        d(string.format("[SamiWorldTimers] WorldEvent unit death detected: uTag=%s", tostring(uTag)))
    end

    if isWorldEventTag and not allowNonPrimaryBoss then return end

    if (not bossName or bossName == "") and dragonUnits[uTag] and dragonUnits[uTag] ~= "" then
        bossName = dragonUnits[uTag]
    end
    if not bossName or bossName == "" then return end
    if util.tableContains(SamiWorldTimers.blacklist, bossName) then return end

    local respawnTime = 300
    if zoneId == 1133 then respawnTime = 600 end
    if uTag ~= "boss1" and not allowNonPrimaryBoss then return end
    if uTag ~= "boss1" and allowNonPrimaryBoss then
        respawnTime = SamiWorldTimers.settings.dragonRespawnTime
        if dragonUnits[uTag] and dragonUnits[uTag] ~= "" then
            bossName = dragonUnits[uTag]
        end
    end

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
    refreshDragonUnits()

    SamiWorldTimers.settingsInit()
    SamiWorldTimers.ui.init()

    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, onUnitDeath)
    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "ZoneChange", EVENT_PLAYER_ACTIVATED, onZoneChanged)
    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "WorldEventUnitCreated", EVENT_WORLD_EVENT_UNIT_CREATED, onWorldEventUnitChanged)
    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "WorldEventUnitDestroyed", EVENT_WORLD_EVENT_UNIT_DESTROYED, onWorldEventUnitChanged)
end

EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
