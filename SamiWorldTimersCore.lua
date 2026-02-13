SamiWorldTimers.core = SamiWorldTimers.core or {}

local core = SamiWorldTimers.core
local util = SamiWorldTimers.util

local function markSortedDirty()
    SamiWorldTimers.sortedDirty = true
end

function core.getSortedBosses()
    if SamiWorldTimers.sortedDirty then
        local tab = {}
        for name in pairs(SamiWorldTimers.bossTimes) do
            tab[#tab + 1] = name
        end
        table.sort(tab, function(a, b) return SamiWorldTimers.bossTimes[a] < SamiWorldTimers.bossTimes[b] end)
        SamiWorldTimers.sortedBosses = tab
        SamiWorldTimers.sortedDirty = false
    end
    return SamiWorldTimers.sortedBosses
end

local function buildOutput()
    local outputLines = {}

    for _, name in ipairs(core.getSortedBosses()) do
        local timeLeft = SamiWorldTimers.bossTimes[name] - os.time()

        if timeLeft < -SamiWorldTimers.settings.timeoutDuration then
            SamiWorldTimers.bossTimes[name] = nil
            markSortedDirty()
            break
        end

        local line
        if timeLeft > 0 then
            line = util.formatTime(timeLeft) .. " " .. name .. "\n"
            if timeLeft < SamiWorldTimers.settings.alertDuration then
                line = util.colorText(line, SamiWorldTimers.settings.alertColour)
            elseif timeLeft < SamiWorldTimers.settings.warningDuration then
                line = util.colorText(line, SamiWorldTimers.settings.warningColour)
            end
        else
            line = "-" .. util.formatTime(math.abs(timeLeft)) .. " " .. name .. " is about to spawn!" .. "\n"
            line = util.colorText(line, SamiWorldTimers.settings.alertColour)
        end

        outputLines[#outputLines + 1] = line
    end

    return table.concat(outputLines)
end

function SamiWorldTimers.updateTimer()
    local output = buildOutput()

    if not next(SamiWorldTimers.bossTimes) then
        EVENT_MANAGER:UnregisterForUpdate(SamiWorldTimers.name .. "Boss Tracker")
    end

    SamiWorldTimers.ui.setText(output)
end

function SamiWorldTimers.addTimer(name, respawnTime)
    SamiWorldTimers.bossTimes[name] = os.time() + respawnTime
    markSortedDirty()
    EVENT_MANAGER:RegisterForUpdate(SamiWorldTimers.name .. "Boss Tracker", 500, SamiWorldTimers.updateTimer)
end

function SamiWorldTimers.manualAdd(name)
    local respawnTime = 300
    if util.getCurrentZoneId() == 1133 then respawnTime = 570 end

    if name == "" then
        local bossesAmount = 0
        for _ in pairs(SamiWorldTimers.bossTimes) do
            bossesAmount = bossesAmount + 1
        end

        name = "Boss" .. tostring(bossesAmount + 1)
    end

    SamiWorldTimers.addTimer(name, respawnTime)
end

ZO_CreateStringId("SI_BINDING_NAME_SAMI_WORLD_TIMERS_MANUAL_BOSS", "Add boss timer manually")

SLASH_COMMANDS["/swt"] = function(args)
    SamiWorldTimers.manualAdd(args)
end
