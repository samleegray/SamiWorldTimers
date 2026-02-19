local LAM2 = LibAddonMenu2
local util = SamiWorldTimers.util

function SamiWorldTimers.settingsInit()
    local panelData = {
        type = "panel",
        name = "Sami's World Timers",
        author = "@|cf500e2s|r|ceb00e5a|r|ce100e9m|r|cd700edi|r|cce00f0h|r|cc400f4a|r|cba00f8i|r|cb000fbz|r|ca600ffe|r",
        version = SamiWorldTimers.version,
        website = "https://lethalrejection.com"
    }

    LAM2:RegisterAddonPanel("SamiWorldTimersOptions", panelData)

    local optionsData = {}
    optionsData[#optionsData + 1] = {
        type = "description",
        text = "This addon automatically tracks overland world boss respawn timers. When a boss dies, a countdown timer will appear on your screen. You can also manually add a timer using the /samiwt command followed by an optional boss name (e.g., /samiwt or /samiwt Boss Name).",
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Timeout Duration",
        tooltip = "How long to keep a boss in the list after the timer ran out (Default: 8 seconds)",
        getFunc = function() return SamiWorldTimers.settings.timeoutDuration end,
        setFunc = function(value) SamiWorldTimers.settings.timeoutDuration = value end,
        min = 0,
        max = 60,
        step = 1,
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Warning Duration",
        tooltip = "When remaining time is below this, use the warning color (Default: 60 seconds)",
        getFunc = function() return SamiWorldTimers.settings.warningDuration end,
        setFunc = function(value) SamiWorldTimers.settings.warningDuration = value end,
        min = 1,
        max = 300,
        step = 1,
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Alert Duration",
        tooltip = "When remaining time is below this, use the alert color (Default: 15 seconds)",
        getFunc = function() return SamiWorldTimers.settings.alertDuration end,
        setFunc = function(value) SamiWorldTimers.settings.alertDuration = value end,
        min = 1,
        max = 120,
        step = 1,
    }
    optionsData[#optionsData + 1] = {
        type = "colorpicker",
        name = "Warning Color",
        tooltip = "Color used for warning timers",
        getFunc = function() return util.hexToRgb(SamiWorldTimers.settings.warningColour) end,
        setFunc = function(r, g, b) 
            SamiWorldTimers.settings.warningColour = util.rgbToHex(r, g, b)
            SamiWorldTimers.ui.updateTextColors()
        end,
    }
    optionsData[#optionsData + 1] = {
        type = "colorpicker",
        name = "Alert Color",
        tooltip = "Color used for alert timers",
        getFunc = function() return util.hexToRgb(SamiWorldTimers.settings.alertColour) end,
        setFunc = function(r, g, b) 
            SamiWorldTimers.settings.alertColour = util.rgbToHex(r, g, b)
            SamiWorldTimers.ui.updateTextColors()
        end,
    }
    optionsData[#optionsData + 1] = {
        type = "colorpicker",
        name = "Default Text Color",
        tooltip = "Default color for timer text",
        getFunc = function() return util.hexToRgb(SamiWorldTimers.settings.defaultTextColour) end,
        setFunc = function(r, g, b) 
            SamiWorldTimers.settings.defaultTextColour = util.rgbToHex(r, g, b)
            SamiWorldTimers.ui.updateTextColors()
        end,
    }
    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = "Wipe Timers on Zone Change",
        tooltip = "Clear all tracked timers when changing zones",
        getFunc = function() return SamiWorldTimers.settings.wipeOnZoneChange end,
        setFunc = function(value) SamiWorldTimers.settings.wipeOnZoneChange = value end,
        default = SamiWorldTimers.defaults.wipeOnZoneChange,
    }
    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = "Debug",
        tooltip = "Enable debug output in chat",
        getFunc = function() return SamiWorldTimers.settings.debug end,
        setFunc = function(value) SamiWorldTimers.settings.debug = value end,
        default = SamiWorldTimers.defaults.debug,
    }
    optionsData[#optionsData + 1] = {
        type = "colorpicker",
        name = "Background Color",
        tooltip = "Color of the background behind timers",
        getFunc = function() return util.hexToRgb(SamiWorldTimers.settings.backgroundColor) end,
        setFunc = function(r, g, b) 
            SamiWorldTimers.settings.backgroundColor = util.rgbToHex(r, g, b)
            SamiWorldTimers.ui.updateBackgroundColor()
        end,
    }
    optionsData[#optionsData + 1] = {
        type = "slider",
        name = "Background Opacity",
        tooltip = "Opacity of the background (0 = transparent, 1 = opaque)",
        getFunc = function() return SamiWorldTimers.settings.backgroundOpacity end,
        setFunc = function(value) 
            SamiWorldTimers.settings.backgroundOpacity = value
            SamiWorldTimers.ui.updateBackgroundOpacity()
        end,
        min = 0,
        max = 1,
        step = 0.05,
    }
    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = "Show Title",
        tooltip = "Show or hide the 'Boss Timers' title text",
        getFunc = function() return SamiWorldTimers.settings.showTitle end,
        setFunc = function(value) 
            SamiWorldTimers.settings.showTitle = value
            SamiWorldTimers.ui.updateTitleVisibility()
        end,
        default = SamiWorldTimers.defaults.showTitle,
    }
    LAM2:RegisterOptionControls("SamiWorldTimersOptions", optionsData)
end
