SamiWorldTimers.ui = SamiWorldTimers.ui or {}

local ui = SamiWorldTimers.ui

function ui.init()
    if not ui.mainFragment then
        ui.mainFragment = ZO_SimpleSceneFragment:New(SamiWorldTimersTLC)
    end

    HUD_SCENE:AddFragment(ui.mainFragment)
    HUD_UI_SCENE:AddFragment(ui.mainFragment)

    SamiWorldTimersTLC:ClearAnchors()
    SamiWorldTimersTLC:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, SamiWorldTimers.settings.offsetX,
        SamiWorldTimers.settings.offsetY)
end

function ui.setText(text)
    SamiWorldTimersTLCLabel:SetText(text or "")
end

function SamiWorldTimers.savePosition()
    SamiWorldTimers.settings.offsetX = SamiWorldTimersTLC:GetLeft()
    SamiWorldTimers.settings.offsetY = SamiWorldTimersTLC:GetTop()
end
