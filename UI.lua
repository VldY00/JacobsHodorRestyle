local HR = HodorRestyle
local LH = LibHyper
local SM = SCENE_MANAGER

local function onSceneChange(_,scene)
    if scene == SCENE_SHOWN then
        HodorRestyleContainer:SetHidden(HR.savedVariables.hideOutOfCombat and not IsUnitInCombat('player'))
    else
        HodorRestyleContainer:SetHidden(true)
    end
end

function HR.InitializeUI()
    local WM = GetWindowManager()
    local HodorRestyleContainer = WM:CreateTopLevelWindow("HodorRestyleContainer")

    HodorRestyleContainer:SetMovable(false)
    HodorRestyleContainer:SetMouseEnabled(true)
    HodorRestyleContainer:SetHidden(HR.savedVariables.hideOutOfCombat and not IsUnitInCombat('player'))
    HodorRestyleContainer:SetResizeToFitDescendents(true)

    local container = WM:CreateControl("$(parent)container", HodorRestyleContainer, CT_CONTROL)
    container:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, ((HR.savedVariables.barHeight + 2) * 12) + HR.savedVariables.barHeight)
    container:SetAnchor(TOPLEFT, HodorRestyleContainer, TOPLEFT, 0, 0)

    local topBar = WM:CreateControl("$(parent)topBar", container, CT_TEXTURE, 4)
    topBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, HR.savedVariables.barHeight)
    topBar:SetAnchor(TOP, container, TOP, 0,0)
    topBar:SetColor(unpack(LH.colors.transparentBlack))
    topBar:SetHidden(false)
    topBar:SetDrawLayer(0)
    topBar:SetTexture("")

    local damageLabel = WM:CreateControl("$(parent)damageLabel",container,CT_LABEL)
    damageLabel:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    damageLabel:SetDrawLayer(2)
    damageLabel:SetAnchor(LEFT, topBar, LEFT, 6, 0)
    damageLabel:SetDimensions(HR.savedVariables.barWidth * 0.75, HR.savedVariables.barHeight)
    damageLabel:SetHidden(false)
    damageLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
    damageLabel:SetVerticalAlignment(1)
    damageLabel:SetText('Damage Done')

    local timer = WM:CreateControl("$(parent)timer",container,CT_LABEL)
    timer:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    timer:SetDrawLayer(2)
    timer:SetAnchor(RIGHT, topBar, RIGHT, -6, 0)
    timer:SetDimensions(HR.savedVariables.barWidth * 0.5, HR.savedVariables.barHeight)
    timer:SetHidden(false)
    timer:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
    timer:SetVerticalAlignment(1)

    local bottomBar = WM:CreateControl("$(parent)bottomBar", container, CT_TEXTURE, 4)
    bottomBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, (HR.savedVariables.barHeight + 2) * 12)
    bottomBar:SetAnchor(TOP, topBar, BOTTOM, 0,0)
    bottomBar:SetColor(unpack(LH.colors.transparentBlack2))
    bottomBar:SetHidden(false)
    bottomBar:SetDrawLayer(0)
    bottomBar:SetTexture("")

    for i=1, 12 do
        local backgroundOutline = WM:CreateControl("$(parent)backgroundOutline" .. i, container, CT_BACKDROP, 4)
        backgroundOutline:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, HR.savedVariables.barHeight + 4)
        backgroundOutline:SetAnchor(TOP, bottomBar, TOP, 0, (HR.savedVariables.barHeight+2) * (i-1))
        backgroundOutline:SetEdgeColor(unpack(LH.colors.black))
        backgroundOutline:SetCenterColor(unpack(LH.colors.transparent))
        backgroundOutline:SetHidden(true)
        backgroundOutline:SetDrawLayer(0)
        backgroundOutline:SetEdgeTexture("", 2, 2)

        local background = WM:CreateControl("$(parent)background" .. i, container, CT_BACKDROP, 4)
        background:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 2, HR.savedVariables.barHeight)
        background:SetAnchor(CENTER, backgroundOutline, CENTER, 0, 0)
        background:SetEdgeColor(unpack(LH.colors.transparent))
        background:SetCenterColor(unpack(LH.colors.transparentBlack))
        background:SetHidden(true)
        background:SetDrawLayer(0)
        background:SetCenterTexture(HR.savedVariables.backgroundBarTexture)

        local iconBackground = WM:CreateControl("$(parent)iconBackground" .. i, container, CT_BACKDROP, 4)
        iconBackground:SetDimensions(HR.savedVariables.barHeight + 4, HR.savedVariables.barHeight + 4)
        iconBackground:SetAnchor(LEFT, backgroundOutline, LEFT, 0, 0)
        iconBackground:SetEdgeColor(unpack(LH.colors.black))
        iconBackground:SetCenterColor(unpack(LH.colors.transparent))
        iconBackground:SetHidden(true)
        iconBackground:SetDrawLayer(0)
        iconBackground:SetEdgeTexture("", 2, 2)

        local icon = WM:CreateControl("$(parent)icon" .. i, container, CT_TEXTURE, 4)
        icon:SetDimensions(HR.savedVariables.barHeight, HR.savedVariables.barHeight)
        icon:SetAnchor(CENTER, iconBackground, CENTER, 0, 0)
        icon:SetHidden(true)
        icon:SetDrawLayer(1)

        local bar = WM:CreateControl("$(parent)bar" .. i, container, CT_TEXTURE, 4)
        bar:SetDimensions(HR.savedVariables.barWidth, HR.savedVariables.barHeight)
        bar:SetAnchor(LEFT, iconBackground, RIGHT, 0,0)
        bar:SetColor(1, 1, 1, 1)
        bar:SetHidden(true)
        bar:SetDrawLayer(1)
        bar:SetTexture(HR.savedVariables.barTexture)

        local damage = WM:CreateControl("$(parent)damage" .. i,container,CT_LABEL)
        damage:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
        damage:SetDrawLayer(2)
        damage:SetAnchor(RIGHT, background, RIGHT, -4, 0)
        damage:SetDimensions(0.66*HR.savedVariables.barWidth, HR.savedVariables.barHeight)
        damage:SetHidden(true)
        damage:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        damage:SetVerticalAlignment(1)

        local label = WM:CreateControl("$(parent)label" .. i,container,CT_LABEL)
        label:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
        label:SetDrawLayer(2)
        label:SetAnchor(LEFT, iconBackground, RIGHT, 6, 0)
        label:SetDimensions(HR.savedVariables.barWidth * 0.66, HR.savedVariables.barHeight)
        label:SetHidden(true)
        label:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        label:SetVerticalAlignment(1)
    end

    HodorRestyleContainer:ClearAnchors()
    HodorRestyleContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HR.savedVariables.xPosition, HR.savedVariables.yPosition)
    SM:GetScene("hud"):RegisterCallback("StateChange", onSceneChange)
    SM:GetScene("hudui"):RegisterCallback("StateChange", onSceneChange)
    HodorRestyleContainer:SetHandler("OnMoveStop", function(control)
        HR.savedVariables.xPosition = HodorRestyleContainer:GetLeft()
        HR.savedVariables.yPosition  = HodorRestyleContainer:GetTop()
        HodorRestyleXSlider:UpdateValue()
        HodorRestyleYSlider:UpdateValue()
    end)
end

function HR.registerChangingVisibilityOnCombatChange()
    EVENT_MANAGER:RegisterForEvent(HR.name .. "CombatState", EVENT_PLAYER_COMBAT_STATE, function()
        HodorRestyleContainer:SetHidden(HR.savedVariables.hideOutOfCombat and not IsUnitInCombat('player'))
    end)
end
