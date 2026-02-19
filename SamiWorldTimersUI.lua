SamiWorldTimers.ui = SamiWorldTimers.ui or {}

local ui = SamiWorldTimers.ui
local util = SamiWorldTimers.util

function ui.init()
    if not ui.mainFragment then
        ui.mainFragment = ZO_SimpleSceneFragment:New(SamiWorldTimersTLC)
    end

    HUD_SCENE:AddFragment(ui.mainFragment)
    HUD_UI_SCENE:AddFragment(ui.mainFragment)

    SamiWorldTimersTLC:ClearAnchors()
    SamiWorldTimersTLC:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SamiWorldTimers.settings.offsetX,
        SamiWorldTimers.settings.offsetY)
    
    -- Create background if it doesn't exist
    if not SamiWorldTimersTLCBackground then
        local bg = WINDOW_MANAGER:CreateControl("SamiWorldTimersTLCBackground", SamiWorldTimersTLC, CT_TEXTURE)
        bg:SetDimensions(200, 100)
        bg:SetAnchor(TOPLEFT, SamiWorldTimersTLC, TOPLEFT, 0, 0)
        bg:SetDrawLevel(-1)
        SamiWorldTimersTLCBackground = bg
    end
    
    -- Create title if it doesn't exist
    if not SamiWorldTimersTLCTitle then
        local title = WINDOW_MANAGER:CreateControl("SamiWorldTimersTLCTitle", SamiWorldTimersTLC, CT_LABEL)
        title:SetFont("ZoFontWinH5")
        title:SetColor(1, 1, 1)
        title:SetText("Boss Timers")
        title:SetAnchor(TOP, SamiWorldTimersTLC, TOP, 0, 2)
        SamiWorldTimersTLCTitle = title
    end
    
    -- Adjust label to position below title
    SamiWorldTimersTLCLabel:ClearAnchors()
    SamiWorldTimersTLCLabel:SetAnchor(TOPLEFT, SamiWorldTimersTLC, TOPLEFT, 8, 20)
    
    -- Set default text color
    local r, g, b = util.hexToRgb(SamiWorldTimers.settings.defaultTextColour)
    SamiWorldTimersTLCLabel:SetColor(r, g, b)
    
    -- Set up the background
    local bg = SamiWorldTimersTLCBackground
    local r, g, b = util.hexToRgb(SamiWorldTimers.settings.backgroundColor)
    bg:SetColor(r, g, b, SamiWorldTimers.settings.backgroundOpacity)
    bg:SetHidden(false)
    
    -- Set title visibility
    ui.updateTitleVisibility()
end

function ui.setText(text)
    SamiWorldTimersTLCLabel:SetText(text or "")
    
    -- Resize background to match label with padding
    local label = SamiWorldTimersTLCLabel
    local width = label:GetWidth()
    local height = label:GetHeight()
    
    if width == 0 or height == 0 then
        -- If dimensions are 0, use the control's set dimensions
        width = 200
        height = 100
    end
    
    -- Add padding: 8px left/right, 4px top/bottom
    width = width + 16
    height = height + 8
    
    local bg = SamiWorldTimersTLCBackground
    bg:SetDimensions(width, height)
    
    -- Recenter title after resizing
    local title = SamiWorldTimersTLCTitle
    if title then
        title:ClearAnchors()
        title:SetAnchor(TOP, SamiWorldTimersTLCBackground, TOP, 0, 2)
    end
end

function SamiWorldTimers.savePosition()
    SamiWorldTimers.settings.offsetX = SamiWorldTimersTLC:GetLeft()
    SamiWorldTimers.settings.offsetY = SamiWorldTimersTLC:GetTop()
end

function ui.updateBackgroundColor()
    local bg = SamiWorldTimersTLCBackground
    if bg then
        local r, g, b = util.hexToRgb(SamiWorldTimers.settings.backgroundColor)
        bg:SetColor(r, g, b, SamiWorldTimers.settings.backgroundOpacity)
    end
end

function ui.updateBackgroundOpacity()
    local bg = SamiWorldTimersTLCBackground
    if bg then
        local r, g, b = util.hexToRgb(SamiWorldTimers.settings.backgroundColor)
        bg:SetColor(r, g, b, SamiWorldTimers.settings.backgroundOpacity)
    end
end

function ui.updateTextColors()
    -- Refresh the timers to apply any color changes
    local r, g, b = util.hexToRgb(SamiWorldTimers.settings.defaultTextColour)
    SamiWorldTimersTLCLabel:SetColor(r, g, b)
    SamiWorldTimers.updateTimer()
end

function ui.updateTitleVisibility()
    local title = SamiWorldTimersTLCTitle
    if title then
        title:SetHidden(not SamiWorldTimers.settings.showTitle)
    end
end
