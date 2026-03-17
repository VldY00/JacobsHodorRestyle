local LAM = LibAddonMenu2
local HR = HodorRestyle
local LH = LibHyper

local screenWidth, screenHeight = GuiRoot:GetDimensions()

local function updateFont()
    local container = HodorRestyleContainer:GetNamedChild('container')
    local damageLabel = container:GetNamedChild('damageLabel')
    local timer = container:GetNamedChild('timer')
    damageLabel:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    timer:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    for i=1, 12 do
        local damage = container:GetNamedChild('damage' .. i)
        local label = container:GetNamedChild('label' .. i)
        damage:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
        label:SetFont(HR.savedVariables.fontStyle.."|"..tostring(HR.savedVariables.fontSize).."|"..HR.savedVariables.fontWeight)
    end
end

local function updateBar()
    local container = HodorRestyleContainer:GetNamedChild('container')
    for i=1, 12 do
        local background = container:GetNamedChild('background' .. i)
        local bar = container:GetNamedChild('bar' .. i)
        background:SetCenterTexture(HR.savedVariables.backgroundBarTexture)
        bar:SetTexture(HR.savedVariables.barTexture)
    end
end

local function updateSize()
    local container = HodorRestyleContainer:GetNamedChild('container')
    local topBar = container:GetNamedChild('topBar')
    local damageLabel = container:GetNamedChild('damageLabel')
    local timer = container:GetNamedChild('timer')
    local bottomBar = container:GetNamedChild('bottomBar')
    container:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, ((HR.savedVariables.barHeight + 2) * 12) + HR.savedVariables.barHeight)
    topBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, HR.savedVariables.barHeight)
    damageLabel:SetDimensions(HR.savedVariables.barWidth * 0.75, HR.savedVariables.barHeight)
    timer:SetDimensions(HR.savedVariables.barWidth * 0.5, HR.savedVariables.barHeight)
    bottomBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, (HR.savedVariables.barHeight + 2) * 12)
    for i=1, 12 do
        local backgroundOutline = container:GetNamedChild('backgroundOutline' .. i)
        local background = container:GetNamedChild('background' .. i)
        local iconBackground = container:GetNamedChild('iconBackground' .. i)
        local icon = container:GetNamedChild('icon' .. i)
        local bar = container:GetNamedChild('bar' .. i)
        local damage = container:GetNamedChild('damage' .. i)
        local label = container:GetNamedChild('label' .. i)
        backgroundOutline:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, HR.savedVariables.barHeight + 4)
        backgroundOutline:ClearAnchors()
        backgroundOutline:SetAnchor(TOP, bottomBar, TOP, 0, (HR.savedVariables.barHeight+2) * (i-1))
        background:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 2, HR.savedVariables.barHeight)
        iconBackground:SetDimensions(HR.savedVariables.barHeight + 4, HR.savedVariables.barHeight + 4)
        icon:SetDimensions(HR.savedVariables.barHeight, HR.savedVariables.barHeight)
        bar:SetDimensions(HR.savedVariables.barWidth, HR.savedVariables.barHeight)
        damage:SetDimensions(0.66*HR.savedVariables.barWidth, HR.savedVariables.barHeight)
        label:SetDimensions(HR.savedVariables.barWidth * 0.66, HR.savedVariables.barHeight)
    end
end

function HodorRestyle.InitializeSettings()
    local panelData = {
        type = "panel",
        name = "HodorRestyle",
        displayName = "HodorRestyle",
        author = "Hyperioxes",
        version = HR.version,
        registerForRefresh = true,
        registerForDefaults = false,
    }



    local optionsTable = {}

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
            HodorRestyleContainer:ClearAnchors()
            HodorRestyleContainer:SetAnchor(var, GuiRoot, var, 0, 0)
            HR.savedVariables.xPosition = HodorRestyleContainer:GetLeft()
            HR.savedVariables.yPosition = HodorRestyleContainer:GetTop()
        end,
        width = "full",
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "X position",
        min = 0,
        max = screenWidth,
        step = 1,	--(optional)
        getFunc = function() return HR.savedVariables.xPosition end,
        setFunc = function(value) HR.savedVariables.xPosition = value
            HodorRestyleContainer:ClearAnchors()
            HodorRestyleContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HR.savedVariables.xPosition, HR.savedVariables.yPosition)
        end,
        width = "half",	--or "half" (optional)
        reference = 'HodorRestyleXSlider',	--unique global reference to control (optional)
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Y position",
        min = 0,
        max = screenHeight,
        step = 1,	--(optional)
        getFunc = function() return HR.savedVariables.yPosition end,
        setFunc = function(value) HR.savedVariables.yPosition = value
            HodorRestyleContainer:ClearAnchors()
            HodorRestyleContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, HR.savedVariables.xPosition, HR.savedVariables.yPosition)
        end,
        width = "half",	--or "half" (optional)
        reference = 'HodorRestyleYSlider',	--unique global reference to control (optional)
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Bar Width",
        min = 160,
        max = 460,
        step = 1,	--(optional)
        getFunc = function() return HR.savedVariables.barWidth end,
        setFunc = function(value) HR.savedVariables.barWidth = value
            updateSize()
        end,
        width = "half",	--or "half" (optional)
    })

    table.insert(optionsTable, {
        type = "slider",
        name = "Bar Height",
        min = 16,
        max = 64,
        step = 1,	--(optional)
        getFunc = function() return HR.savedVariables.barHeight end,
        setFunc = function(value) HR.savedVariables.barHeight = value
            updateSize()
        end,
        width = "half",	--or "half" (optional)
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
        setFunc = function(var) HR.savedVariables.fontStyle = var
            updateFont()
        end,
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Weight:",
        choices = LH.fontWeights,
        getFunc = function() return HR.savedVariables.fontWeight end,
        setFunc = function(var) HR.savedVariables.fontWeight = var
            updateFont()
        end,
    })
    table.insert(optionsTable, {
        type = "dropdown",
        name = "Font Size:",
        choices = LH.fontSizes,
        getFunc = function() return HR.savedVariables.fontSize end,
        setFunc = function(var) HR.savedVariables.fontSize = var
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
        setFunc = function(var) HR.savedVariables.barTexture = var
            updateBar()
            for i=1, 6 do
                _G['HodorRestyleBarTexturePreview'..i].texture:SetTexture(HR.savedVariables.barTexture)
            end
        end,
    })

    for _,v in pairs(LH.classIds) do
        table.insert(optionsTable, {
            type = "description",
            title = GetClassName(GENDER_MALE , v),
            width = "half",	--or "half" (optional)
        })

        table.insert(optionsTable, {
            type = "texture",
            image = HR.savedVariables.barTexture,
            imageWidth = 250,	--max of 250 for half width, 510 for full
            imageHeight = 32,	--max of 100
            width = "half",	--or "half" (optional)
            reference = 'HodorRestyleBarTexturePreview'..v,	--unique global reference to control (optional)
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
        choices = {'Hodor', 'Class', 'Class and Role'},
        choicesValues = {'hodor', 'class', 'classRole'},
        getFunc = function() return HR.savedVariables.iconType end,
        setFunc = function(var) HR.savedVariables.iconType = var
        end,
    })

    table.insert(optionsTable, {
        type = "dropdown",
        name = "Text Color:",
        choices = {'Hodor', 'Always White'},
        choicesValues = {'hodor', 'white'},
        getFunc = function() return HR.savedVariables.textColor end,
        setFunc = function(var) HR.savedVariables.textColor = var
        end,
    })

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Hide out of combat",
        width = "full",
        getFunc = function() return HR.savedVariables.hideOutOfCombat end,
        setFunc = function(var) HR.savedVariables.hideOutOfCombat = var
        end,
    })

    LAM:RegisterOptionControls("HodorRestyleSettings", optionsTable)
    local hodorRestylePanel = LAM:RegisterAddonPanel("HodorRestyleSettings", panelData)

    CALLBACK_MANAGER:RegisterCallback("LAM-PanelOpened", function(panel)
        if panel ~= hodorRestylePanel then return end
        HodorRestyleContainer:SetHidden(false)
        HodorRestyleContainer:SetMovable(true)

        for _,v in pairs(LH.classIds) do
            _G['HodorRestyleBarTexturePreview'..v].texture:SetColor(unpack(LH.classColors[v]))
        end
    end)

    CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", function(panel)
        if panel ~= hodorRestylePanel then return end
        HodorRestyleContainer:SetHidden(true)
        HodorRestyleContainer:SetMovable(false)
    end)
end