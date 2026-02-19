local util = SamiWorldTimers.util

local currentZoneId = nil

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

local function updateDeathEventState()
    local inDungeonOrTrial = GetCurrentZoneDungeonDifficulty() ~= 0
    
    if inDungeonOrTrial then
        if SamiWorldTimers.settings.debug then
            d(string.format("Unregistering Death event..."))
        end
        EVENT_MANAGER:UnregisterForEvent(SamiWorldTimers.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED)
        SamiWorldTimersTLC:SetHidden(true)
    else
        if SamiWorldTimers.settings.debug then
            d(string.format("Registering Death event..."))
        end
        EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "Death", EVENT_UNIT_DEATH_STATE_CHANGED, onUnitDeath)
        SamiWorldTimersTLC:SetHidden(false)
    end
end

local function wipeTimersOnZoneChange(oldZoneId, newZoneId)
    if not SamiWorldTimers.settings.wipeOnZoneChange then return end
    
    if oldZoneId ~= nil and oldZoneId ~= newZoneId then
        -- Clear all timers
        SamiWorldTimers.bossTimes = {}
        SamiWorldTimers.sortedBosses = {}
        SamiWorldTimers.sortedDirty = true
        SamiWorldTimers.ui.setText("")
        EVENT_MANAGER:UnregisterForUpdate(SamiWorldTimers.name .. "Boss Tracker")
        
        if SamiWorldTimers.settings.debug then
            d(string.format("[SamiWorldTimers] Zone changed from %s to %s, timers wiped", tostring(oldZoneId), tostring(newZoneId)))
        end
    end
end

local function onZoneChanged(initial)
    local newZoneId = util.getCurrentZoneId()

    updateDeathEventState()
    wipeTimersOnZoneChange(currentZoneId, newZoneId)
    
    currentZoneId = newZoneId
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

    updateDeathEventState()
    EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name .. "ZoneChange", EVENT_PLAYER_ACTIVATED, onZoneChanged)
end

EVENT_MANAGER:RegisterForEvent(SamiWorldTimers.name, EVENT_ADD_ON_LOADED, onAddOnLoaded)
