local LAM = LibAddonMenu2
local HR = HodorRestyle
local LH = LibHyper

local screenWidth, screenHeight = GuiRoot:GetDimensions()
local MAX_ROWS = 12

local function GetRowPitch()
    return (HR.savedVariables.barHeight + 2)
end

local function GetRowsHeight(rowCount)
    return GetRowPitch() * rowCount
end

local function GetHeaderHeight()
    return HR.savedVariables.barHeight
end

local function ReanchorContainer(previewMode, rowCount)
    if not HodorRestyleContainer then
        return
    end

    local x = HR.savedVariables.xPosition or 0
    local y = HR.savedVariables.yPosition or 0

    local containerTop = y
    if HR.savedVariables.growFromBottom then
        containerTop = y - GetRowsHeight(rowCount or 0)
    end

    -- While unlocked, do not fight user dragging.
    if HR.savedVariables.unlocked and not previewMode then
        return
    end

    HodorRestyleContainer:ClearAnchors()
    HodorRestyleContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, x, containerTop)
end

local function updateFont()
    local container = HodorRestyleContainer:GetNamedChild("container")
    if not container then return end

    local font = HR.savedVariables.fontStyle .. "|" .. tostring(HR.savedVariables.fontSize) .. "|" .. HR.savedVariables.fontWeight

    local damageLabel = container:GetNamedChild("damageLabel")
    local timer = container:GetNamedChild("timer")
    if damageLabel then damageLabel:SetFont(font) end
    if timer then timer:SetFont(font) end

    for i = 1, MAX_ROWS do
        local damage = container:GetNamedChild("damage" .. i)
        local label = container:GetNamedChild("label" .. i)
        if damage then damage:SetFont(font) end
        if label then label:SetFont(font) end
    end
end

local function updateBar()
    local container = HodorRestyleContainer:GetNamedChild("container")
    if not container then return end

    for i = 1, MAX_ROWS do
        local background = container:GetNamedChild("background" .. i)
        local bar = container:GetNamedChild("bar" .. i)

        if background then
            background:SetCenterTexture(HR.savedVariables.backgroundBarTexture)
        end
        if bar then
            bar:SetTexture(HR.savedVariables.barTexture)
        end
    end
end

local function updateBackgroundAlpha()
    local container = HodorRestyleContainer:GetNamedChild("container")
    if not container then return end

    local topBar = container:GetNamedChild("topBar")
    local bottomBar = container:GetNamedChild("bottomBar")
    local alpha = HR.savedVariables.backgroundAlpha or 0.75

    if topBar then topBar:SetAlpha(alpha) end
    if bottomBar then bottomBar:SetAlpha(alpha) end

    for i = 1, MAX_ROWS do
        local backgroundOutline = container:GetNamedChild("backgroundOutline" .. i)
        local background = container:GetNamedChild("background" .. i)
        local iconBackground = container:GetNamedChild("iconBackground" .. i)

        if backgroundOutline then backgroundOutline:SetAlpha(alpha) end
        if background then background:SetAlpha(alpha) end
        if iconBackground then iconBackground:SetAlpha(alpha) end
    end
end

function HodorRestyle.ApplyUnlockedState()
    if not HodorRestyleContainer then
        return
    end

    local unlocked = HR.savedVariables.unlocked

    HodorRestyleContainer:SetMovable(unlocked)
    HodorRestyleContainer:SetMouseEnabled(unlocked)

    if unlocked then
        HodorRestyleContainer:SetHidden(false)
    end
end

function HodorRestyle.UpdateLayout(visibleRows, previewMode)
    if not HodorRestyleContainer or not HodorRestyleContainer.GetNamedChild then
        return
    end

    local container = HodorRestyleContainer:GetNamedChild("container")
    if not container then
        return
    end

    local topBar = container:GetNamedChild("topBar")
    local damageLabel = container:GetNamedChild("damageLabel")
    local timer = container:GetNamedChild("timer")
    local bottomBar = container:GetNamedChild("bottomBar")

    local barWidth = HR.savedVariables.barWidth
    local barHeight = HR.savedVariables.barHeight

    local rows = visibleRows
    if rows == nil then rows = MAX_ROWS end
    if rows < 0 then rows = 0 end
    if rows > MAX_ROWS then rows = MAX_ROWS end

    if previewMode then
        rows = MAX_ROWS
    end

    local rowsHeight = GetRowsHeight(rows)
    local totalWidth = barWidth + barHeight + 6
    local totalHeight = rowsHeight + GetHeaderHeight()

    container:SetDimensions(totalWidth, totalHeight)
    HodorRestyleContainer:SetDimensions(totalWidth, totalHeight)

    if topBar then
        topBar:SetDimensions(totalWidth, barHeight)
        topBar:ClearAnchors()
    end

    if bottomBar then
        bottomBar:SetDimensions(totalWidth, rowsHeight)
        bottomBar:ClearAnchors()
    end

    if damageLabel then
        damageLabel:SetDimensions(barWidth * 0.75, barHeight)
        damageLabel:ClearAnchors()
    end

    if timer then
        timer:SetDimensions(barWidth * 0.5, barHeight)
        timer:ClearAnchors()
    end

    if HR.savedVariables.growFromBottom then
        if topBar then
            topBar:SetAnchor(BOTTOMLEFT, container, BOTTOMLEFT, 0, 0)
        end
        if bottomBar and topBar then
            bottomBar:SetAnchor(BOTTOMLEFT, topBar, TOPLEFT, 0, 0)
        end
    else
        if topBar then
            topBar:SetAnchor(TOPLEFT, container, TOPLEFT, 0, 0)
        end
        if bottomBar and topBar then
            bottomBar:SetAnchor(TOPLEFT, topBar, BOTTOMLEFT, 0, 0)
        end
    end

    if damageLabel and topBar then
        damageLabel:SetAnchor(LEFT, topBar, LEFT, 6, 0)
    end
    if timer and topBar then
        timer:SetAnchor(RIGHT, topBar, RIGHT, -6, 0)
    end

    for i = 1, MAX_ROWS do
        local backgroundOutline = container:GetNamedChild("backgroundOutline" .. i)
        local background = container:GetNamedChild("background" .. i)
        local iconBackground = container:GetNamedChild("iconBackground" .. i)
        local icon = container:GetNamedChild("icon" .. i)
        local bar = container:GetNamedChild("bar" .. i)
        local damage = container:GetNamedChild("damage" .. i)
        local label = container:GetNamedChild("label" .. i)

        if backgroundOutline then
            backgroundOutline:SetDimensions(barWidth + barHeight + 6, barHeight + 4)
            backgroundOutline:ClearAnchors()
            if bottomBar then
                backgroundOutline:SetAnchor(TOP, bottomBar, TOP, 0, GetRowPitch() * (i - 1))
            end
        end

        if background then
            background:SetDimensions(barWidth + barHeight + 2, barHeight)
        end
        if iconBackground then
            iconBackground:SetDimensions(barHeight + 4, barHeight + 4)
        end
        if icon then
            icon:SetDimensions(barHeight, barHeight)
        end
        if bar then
            bar:SetDimensions(barWidth, barHeight)
        end
        if damage then
            damage:SetDimensions(0.66 * barWidth, barHeight)
        end
        if label then
            label:SetDimensions(barWidth * 0.66, barHeight)
        end
    end

    ReanchorContainer(previewMode, rows)
    updateBackgroundAlpha()
end

local function updateSize()
    HodorRestyle.UpdateLayout(MAX_ROWS, true)
end

function HodorRestyle.InitializeSettings()
    local panelData = {
        type = "panel",
        name = "JacobsHodorRestyle",
        displayName = "JacobsHodorRestyle",
        author = "@iJacobs sources by Hyperioxes",
        version = HR.version,
        registerForRefresh = true,
        registerForDefaults = false,
    }

    local optionsTable = {}

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Unlock window",
        tooltip = "Unlock to move the window safely. Lock it back when finished.",
        width = "full",
        getFunc = function()
            return HR.savedVariables.unlocked
        end,
        setFunc = function(var)
            HR.savedVariables.unlocked = var
            HR.ApplyUnlockedState()
            HR.UpdateLayout(HR.currentVisibleRows or 0, false)
        end,
        default = false,
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Position",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Anchor to:",
        choices = LH.getTableKeys(LH.anchors),
        choicesValues = LH.getTableValues(LH.anchors),
        getFunc = function() return TOPLEFT end,
        setFunc = function(var)
            local x = HR.savedVariables.xPosition or 0
            local y = HR.savedVariables.yPosition or 0

            HodorRestyleContainer:ClearAnchors()
            HodorRestyleContainer:SetAnchor(var, GuiRoot, var, x, y)

            HR.savedVariables.xPosition = HodorRestyleContainer:GetLeft()
            HR.savedVariables.yPosition = HodorRestyleContainer:GetTop()
            updateSize()
        end,
        width = "full",
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "X position",
        min = 0,
        max = screenWidth,
        step = 1,
        getFunc = function() return HR.savedVariables.xPosition end,
        setFunc = function(value)
            HR.savedVariables.xPosition = value
            updateSize()
        end,
        width = "half",
        reference = "HodorRestyleXSlider",
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Y position",
        min = 0,
        max = screenHeight,
        step = 1,
        getFunc = function() return HR.savedVariables.yPosition end,
        setFunc = function(value)
            HR.savedVariables.yPosition = value
            updateSize()
        end,
        width = "half",
        reference = "HodorRestyleYSlider",
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Bar Width",
        min = 160,
        max = 460,
        step = 1,
        getFunc = function() return HR.savedVariables.barWidth end,
        setFunc = function(value)
            HR.savedVariables.barWidth = value
            updateSize()
        end,
        width = "half",
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Bar Height",
        min = 16,
        max = 64,
        step = 1,
        getFunc = function() return HR.savedVariables.barHeight end,
        setFunc = function(value)
            HR.savedVariables.barHeight = value
            updateSize()
        end,
        width = "half",
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Font",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Style:",
        choices = LH.getTableKeys(LH.fonts),
        choicesValues = LH.getTableValues(LH.fonts),
        getFunc = function() return HR.savedVariables.fontStyle end,
        setFunc = function(var)
            HR.savedVariables.fontStyle = var
            updateFont()
        end,
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Weight:",
        choices = LH.fontWeights,
        getFunc = function() return HR.savedVariables.fontWeight end,
        setFunc = function(var)
            HR.savedVariables.fontWeight = var
            updateFont()
        end,
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Size:",
        choices = LH.fontSizes,
        getFunc = function() return HR.savedVariables.fontSize end,
        setFunc = function(var)
            HR.savedVariables.fontSize = var
            updateFont()
        end,
    })

    table.insert(optionsTable, {
        type = "header",
        name = "Bar",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "iconpicker",
        name = "Bar Texture:",
        choices = LH.getTableValues(LH.barTextures),
        iconSize = 64,
        maxColumns = 3,
        visibleRows = 3,
        getFunc = function() return HR.savedVariables.barTexture end,
        setFunc = function(var)
            HR.savedVariables.barTexture = var
            updateBar()
            for i = 1, 6 do
                _G["HodorRestyleBarTexturePreview" .. i].texture:SetTexture(HR.savedVariables.barTexture)
            end
        end,
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Background Opacity",
        tooltip = "Adjust transparency of the dark background panels.",
        min = 0,
        max = 100,
        step = 1,
        getFunc = function()
            return math.floor((HR.savedVariables.backgroundAlpha or 0.75) * 100)
        end,
        setFunc = function(value)
            HR.savedVariables.backgroundAlpha = value / 100
            updateBackgroundAlpha()
        end,
        width = "half",
    })

    for _, v in pairs(LH.classIds) do
        table.insert(optionsTable, {
            type = "description",
            title = GetClassName(GENDER_MALE, v),
            width = "half",
        })

        table.insert(optionsTable, {
            type = "texture",
            image = HR.savedVariables.barTexture,
            imageWidth = 250,
            imageHeight = 32,
            width = "half",
            reference = "HodorRestyleBarTexturePreview" .. v,
        })
    end

    table.insert(optionsTable, {
        type = "header",
        name = "Other",
        width = "full",
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Icon Type:",
        choices = {"Hodor", "Class", "Class and Role"},
        choicesValues = {"hodor", "class", "classRole"},
        getFunc = function() return HR.savedVariables.iconType end,
        setFunc = function(var)
            HR.savedVariables.iconType = var
        end,
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Text Color:",
        choices = {"Hodor", "Always White"},
        choicesValues = {"hodor", "white"},
        getFunc = function() return HR.savedVariables.textColor end,
        setFunc = function(var)
            HR.savedVariables.textColor = var
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Hide out of combat",
        width = "full",
        getFunc = function() return HR.savedVariables.hideOutOfCombat end,
        setFunc = function(var)
            HR.savedVariables.hideOutOfCombat = var
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Show only in group",
        tooltip = "Hide Restyle when you are not grouped.",
        width = "full",
        getFunc = function() return HR.savedVariables.showOnlyInGroup end,
        setFunc = function(var)
            HR.savedVariables.showOnlyInGroup = var
        end,
        default = false,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Hide in open world",
        tooltip = "Show Restyle only inside dungeon, trial, arena or other instanced group content.",
        width = "full",
        getFunc = function() return HR.savedVariables.hideInOpenWorld end,
        setFunc = function(var)
            HR.savedVariables.hideInOpenWorld = var
        end,
        default = false,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Grow from bottom",
        tooltip = "Header goes to bottom and the list grows upward.",
        width = "full",
        getFunc = function() return HR.savedVariables.growFromBottom end,
        setFunc = function(var)
            HR.savedVariables.growFromBottom = var
            HR.UpdateLayout(HR.currentVisibleRows or 0, false)
        end,
        default = true,
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Update interval (ms)",
        tooltip = "How often Restyle refreshes from Hodor data.",
        min = 50,
        max = 1000,
        step = 10,
        getFunc = function()
            return HR.savedVariables.updateIntervalMs or 200
        end,
        setFunc = function(value)
            HR.savedVariables.updateIntervalMs = value
            if HR.RestartUpdater then
                HR.RestartUpdater()
            end
        end,
        width = "full",
    })

    LAM:RegisterOptionControls("HodorRestyleSettings", optionsTable)
    local hodorRestylePanel = LAM:RegisterAddonPanel("HodorRestyleSettings", panelData)

    CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(panel)
        if panel ~= hodorRestylePanel then
            return
        end

        HodorRestyleContainer:SetHidden(false)
        HR.ApplyUnlockedState()

        updateSize()
        updateBackgroundAlpha()

        for _, v in pairs(LH.classIds) do
            _G["HodorRestyleBarTexturePreview" .. v].texture:SetColor(unpack(LH.classColors[v]))
        end
    end)

    CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(panel)
        if panel ~= hodorRestylePanel then
            return
        end

        if not HR.savedVariables.unlocked then
            HodorRestyleContainer:SetHidden(true)
        end

        HodorRestyleContainer:SetMovable(false)
        HodorRestyleContainer:SetMouseEnabled(false)
    end)

    HodorRestyleContainer:SetHandler("OnMoveStop", function(self)
        local left = self:GetLeft()
        local top = self:GetTop()

        HR.savedVariables.xPosition = left

        if HR.savedVariables.growFromBottom then
            -- header bar is at the bottom of the container
            HR.savedVariables.yPosition = top + self:GetHeight() - GetHeaderHeight()
        else
            -- header bar is at the top of the container
            HR.savedVariables.yPosition = top
        end
    end)

    HR.ApplyUnlockedState()
    updateSize()
end