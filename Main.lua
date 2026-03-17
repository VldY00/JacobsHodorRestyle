local HR = HodorRestyle

local function SafeHideOriginalHodor()
    if HodorReflexes_Share_Damage and HodorReflexes_Share_Damage.SetAlpha then
        HodorReflexes_Share_Damage:SetAlpha(0)
        return true
    end
    return false
end

local function OnAddOnLoaded(_, addonName)
    if addonName ~= HR.name then
        return
    end

    EVENT_MANAGER:UnregisterForEvent(HR.name, EVENT_ADD_ON_LOADED)

    HR.savedVariables = ZO_SavedVars:NewAccountWide("HodorRestyleSV", 1, nil, HR.defaultSavedVariables)

    if type(HR.InitializeUI) == "function" then
        HR.InitializeUI()
    end

    if type(HR.InitializeSettings) == "function" then
        HR.InitializeSettings()
    end

    if type(HR.registerChangingVisibilityOnCombatChange) == "function" then
        HR.registerChangingVisibilityOnCombatChange()
    end

    if type(HR.StartUpdater) == "function" then
        HR.StartUpdater()
    end

    zo_callLater(function()
        SafeHideOriginalHodor()
    end, 1000)
end

EVENT_MANAGER:RegisterForEvent(HR.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)