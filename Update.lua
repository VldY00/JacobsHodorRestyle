local HRF = HodorReflexes
local LH = LibHyper
local HR = HodorRestyle
local LCI = LibCustomIcons
local LCN = LibCustomNames
local LGCS = LibGroupCombatStats

local MAX_ROWS = 12

local DAMAGE_UNKNOWN = LGCS and LGCS.DAMAGE_UNKNOWN or 0
local DAMAGE_BOSS = LGCS and LGCS.DAMAGE_BOSS or 1
local DAMAGE_TOTAL = LGCS and LGCS.DAMAGE_TOTAL or 2

local classRoleIcons = {
    [1] = {
        [0] = '/esoui/art/icons/ability_dragonknight_009.dds',
        [1] = '/esoui/art/icons/ability_dragonknight_001_b.dds',
        [2] = '/esoui/art/icons/ability_dragonknight_007_b.dds',
        [4] = '/esoui/art/icons/ability_dragonknight_002_b.dds',
    },
    [2] = {
        [0] = '/esoui/art/icons/ability_sorcerer_bolt_escape.dds',
        [1] = '/esoui/art/icons/ability_sorcerer_thunderstomp.dds',
        [2] = '/esoui/art/icons/ability_sorcerer_unstable_clannfear.dds',
        [4] = '/esoui/art/icons/ability_sorcerer_storm_prey_summoned.dds',
    },
    [3] = {
        [0] = '/esoui/art/icons/ability_nightblade_004_b.dds',
        [1] = '/esoui/art/icons/ability_nightblade_007_a.dds',
        [2] = '/esoui/art/icons/ability_nightblade_013_a.dds',
        [4] = '/esoui/art/icons/ability_nightblade_012_b.dds',
    },
    [4] = {
        [0] = '/esoui/art/icons/ability_warden_018.dds',
        [1] = '/esoui/art/icons/ability_warden_013_a.dds',
        [2] = '/esoui/art/icons/ability_warden_002.dds',
        [4] = '/esoui/art/icons/ability_warden_008.dds',
    },
    [5] = {
        [0] = '/esoui/art/icons/ability_necromancer_003.dds',
        [1] = '/esoui/art/icons/ability_necromancer_001.dds',
        [2] = '/esoui/art/icons/ability_necromancer_008_b.dds',
        [4] = '/esoui/art/icons/ability_necromancer_013.dds',
    },
    [6] = {
        [0] = '/esoui/art/icons/ability_templar_returning_spear.dds',
        [1] = '/esoui/art/icons/ability_templar_over_exposure.dds',
        [2] = '/esoui/art/icons/ability_templar_radiant_ward.dds',
        [4] = '/esoui/art/icons/ability_templar_breath_of_life.dds',
    },
    [117] = {
        [0] = '/esoui/art/icons/ability_arcanist_001.dds',
        [1] = '/esoui/art/icons/ability_arcanist_006_b.dds',
        [2] = '/esoui/art/icons/ability_arcanist_008_b.dds',
        [4] = '/esoui/art/icons/ability_arcanist_013_b.dds',
    },
}

local function SafeGetClassIcon(groupMemberNumber)
    local classId = GetUnitClass('group' .. tostring(groupMemberNumber))
    if classId then
        return '/esoui/art/icons/class/gamepad/gp_class_' .. tostring(classId) .. '.dds'
    end
    return '/esoui/art/icons/class/gamepad/gp_class_1.dds'
end

local function SafeGetClassRoleIcon(groupMemberNumber)
    local unitTag = 'group' .. tostring(groupMemberNumber)
    local classId = GetUnitClassId(unitTag)
    local roleId = GetGroupMemberSelectedRole(unitTag)

    if classId and classRoleIcons[classId] and classRoleIcons[classId][roleId] then
        return classRoleIcons[classId][roleId]
    end

    return SafeGetClassIcon(groupMemberNumber)
end

local iconTypeFunctions = {
    ['hodor'] = function(groupMemberName, groupMemberNumber, icon)
        if not icon then return end
        if LCI and LCI.HasStatic and LCI.GetStatic and LCI.HasStatic(groupMemberName) then
            icon:SetTexture(LCI.GetStatic(groupMemberName))
        else
            icon:SetTexture(SafeGetClassIcon(groupMemberNumber))
        end
    end,

    ['class'] = function(_, groupMemberNumber, icon)
        if not icon then return end
        icon:SetTexture(SafeGetClassIcon(groupMemberNumber))
    end,

    ['classRole'] = function(_, groupMemberNumber, icon)
        if not icon then return end
        icon:SetTexture(SafeGetClassRoleIcon(groupMemberNumber))
    end,
}

local textColorFunctions = {
    ['hodor'] = function(groupMemberName, label, i)
        if not label or not groupMemberName then return end
        if LCN and LCN.HasCustomName and LCN.Get and LCN.HasCustomName(groupMemberName) then
            label:SetText(i .. '. ' .. tostring(LCN.Get(groupMemberName)))
        else
            label:SetText(i .. '. ' .. tostring(groupMemberName):gsub("^@", ""))
        end
    end,

    ['white'] = function(groupMemberName, label, i)
        if not label or not groupMemberName then return end
        label:SetText(i .. '. ' .. tostring(groupMemberName):gsub("^@", ""))
    end,
}

local function HideRow(container, i)
    local backgroundOutline = container:GetNamedChild('backgroundOutline' .. i)
    local background = container:GetNamedChild('background' .. i)
    local iconBackground = container:GetNamedChild('iconBackground' .. i)
    local icon = container:GetNamedChild('icon' .. i)
    local bar = container:GetNamedChild('bar' .. i)
    local damage = container:GetNamedChild('damage' .. i)
    local label = container:GetNamedChild('label' .. i)

    if backgroundOutline then backgroundOutline:SetHidden(true) end
    if background then background:SetHidden(true) end
    if iconBackground then iconBackground:SetHidden(true) end
    if icon then icon:SetHidden(true) end
    if bar then bar:SetHidden(true) end
    if label then label:SetHidden(true) end
    if damage then damage:SetHidden(true) end
end

local function BuildPlayersTable()
    if not HRF or not HRF.playersData then
        return {}, 1
    end

    local filteredTable = {}
    local maxDamageK = 0

    for _, playerData in pairs(HRF.playersData) do
        if playerData and not playerData.hideDamage and (playerData.dmg or 0) > 0 then
            table.insert(filteredTable, playerData)
            local damageK = (playerData.dmg or 0) / 10
            if damageK > maxDamageK then
                maxDamageK = damageK
            end
        end
    end

    table.sort(filteredTable, function(a, b)
        local ad = (a and a.dmg) or 0
        local bd = (b and b.dmg) or 0
        if ad == bd then
            local an = (a and (a.name or a.userId or "")) or ""
            local bn = (b and (b.name or b.userId or "")) or ""
            return an > bn
        end
        return ad > bd
    end)

    if maxDamageK <= 0 then
        maxDamageK = 1
    end

    return filteredTable, maxDamageK
end

local function ResolveDisplayName(playerData)
    if not playerData then return nil end
    if playerData.userId and playerData.userId ~= "" then return playerData.userId end
    if playerData.name and playerData.name ~= "" then return playerData.name end
    return nil
end

local function ResolveGroupMemberNumber(playerData)
    if not playerData then return nil end

    if playerData.tag and type(playerData.tag) == "string" then
        local n = tonumber(playerData.tag:match("^group(%d+)$"))
        if n then return n end
    end

    local targetName = ResolveDisplayName(playerData)
    if not targetName then return nil end

    for i = 1, MAX_ROWS do
        local tag = 'group' .. i
        local displayName = GetUnitDisplayName(tag)
        local unitName = GetUnitName(tag)

        if displayName == targetName or unitName == targetName then
            return i
        end
    end

    return nil
end

local function GetCombatTimeSafe()
    if HRF and HRF.combat and HRF.combat.GetCombatTime then
        return HRF.combat:GetCombatTime() or 0
    end
    return 0
end

local function FormatDamageValue(dmgType, dmg, dps)
    dmg = dmg or 0
    dps = dps or 0

    if dmgType == DAMAGE_TOTAL then
        return string.format('%.2fM || %dK', dmg / 100, dps)
    elseif dmgType == DAMAGE_BOSS then
        return string.format('%.1fk (%dK)', dmg / 10, dps)
    else
        return string.format('%.1fk (%dK)', dmg / 10, dps)
    end
end

local function ShouldShowRestyle()
    if not HR.savedVariables then
        return true
    end

    if HR.savedVariables.unlocked then
        return true
    end

    if HR.savedVariables.showOnlyInGroup then
        if not IsUnitGrouped("player") or GetGroupSize() <= 1 then
            return false
        end
    end

    if HR.savedVariables.hideInOpenWorld then
        if not IsUnitInDungeon("player") then
            return false
        end
    end

    return true
end

local function newUpdateDamage()
    if not HodorRestyleContainer then
        return
    end

    local container = HodorRestyleContainer:GetNamedChild('container')
    if not container then
        return
    end

    local timer = container:GetNamedChild('timer')

    if not ShouldShowRestyle() then
        container:SetHidden(true)
        return
    end

    if not HR.savedVariables.unlocked then
        if IsUnitInCombat("player") or not (HR.savedVariables and HR.savedVariables.hideOutOfCombat) then
            container:SetHidden(false)
        else
            container:SetHidden(true)
            return
        end
    else
        container:SetHidden(false)
    end

    local filteredTable, maxDamageK = BuildPlayersTable()
    local visibleCount = #filteredTable
    if visibleCount > MAX_ROWS then
        visibleCount = MAX_ROWS
    end

    HR.currentVisibleRows = visibleCount

    if HR.UpdateLayout then
        HR.UpdateLayout(visibleCount, false)
    end

    if timer then
        local combatTime = GetCombatTimeSafe()
        timer:SetText(combatTime > 0 and string.format('%d:%04.1f|u0:2::|u', combatTime / 60, combatTime % 60) or '')
    end

    for i = 1, MAX_ROWS do
        HideRow(container, i)
    end

    for i = 1, visibleCount do
        local uiIndex = i
        local row = filteredTable[i]

        local backgroundOutline = container:GetNamedChild('backgroundOutline' .. uiIndex)
        local background = container:GetNamedChild('background' .. uiIndex)
        local iconBackground = container:GetNamedChild('iconBackground' .. uiIndex)
        local icon = container:GetNamedChild('icon' .. uiIndex)
        local bar = container:GetNamedChild('bar' .. uiIndex)
        local damage = container:GetNamedChild('damage' .. uiIndex)
        local label = container:GetNamedChild('label' .. uiIndex)

        if row then
            local dmgType = row.dmgType or DAMAGE_UNKNOWN
            local dps = row.dps or 0
            local dmg = row.dmg or 0
            local groupMemberName = ResolveDisplayName(row) or ""
            local groupMemberNumber = ResolveGroupMemberNumber(row)
            local classId = row.classId or (groupMemberNumber and GetUnitClassId('group' .. tostring(groupMemberNumber))) or 0

            local textMode = (HR.savedVariables and HR.savedVariables.textColor) or 'white'
            local iconMode = (HR.savedVariables and HR.savedVariables.iconType) or 'class'

            if textColorFunctions[textMode] then
                textColorFunctions[textMode](groupMemberName, label, i)
            elseif label then
                label:SetText(i .. '. ' .. tostring(groupMemberName):gsub("^@", ""))
            end

            if icon then
                if groupMemberNumber and iconTypeFunctions[iconMode] then
                    iconTypeFunctions[iconMode](groupMemberName, groupMemberNumber, icon)
                else
                    icon:SetTexture(SafeGetClassIcon(groupMemberNumber or 1))
                end
            end

            if damage then
                damage:SetText(FormatDamageValue(dmgType, dmg, dps))
            end

            if bar then
                local ratio = (dmg / 10) / maxDamageK
                if ratio < 0 then ratio = 0 end
                if ratio > 1 then ratio = 1 end

                local barWidth = (HR.savedVariables and HR.savedVariables.barWidth) or 200
                local barHeight = (HR.savedVariables and HR.savedVariables.barHeight) or 24

                bar:SetDimensions(barWidth * ratio, barHeight)
                bar:SetTextureCoords(0, ratio, 0, 1)

                if LH and LH.classColors and LH.classColors[classId] then
                    bar:SetColor(unpack(LH.classColors[classId]))
                else
                    bar:SetColor(1, 1, 1, 1)
                end
            end

            if backgroundOutline then backgroundOutline:SetHidden(false) end
            if background then background:SetHidden(false) end
            if iconBackground then iconBackground:SetHidden(false) end
            if icon then icon:SetHidden(false) end
            if bar then bar:SetHidden(false) end
            if label then label:SetHidden(false) end
            if damage then damage:SetHidden(false) end
        end
    end
end

local function RegisterUpdater()
    local interval = 200
    if HR.savedVariables and HR.savedVariables.updateIntervalMs then
        interval = HR.savedVariables.updateIntervalMs
    end

    if interval < 50 then interval = 50 end
    if interval > 1000 then interval = 1000 end

    EVENT_MANAGER:RegisterForUpdate(HR.name .. "_UpdateDamage", interval, function()
        local ok, err = pcall(newUpdateDamage)
        if not ok then
            d("[HodorRestyle] Update loop failed: " .. tostring(err))
        end
    end)

    d("[HodorRestyle] Started DPS updater (" .. tostring(interval) .. " ms).")
end

function HodorRestyle.RestartUpdater()
    EVENT_MANAGER:UnregisterForUpdate(HR.name .. "_UpdateDamage")
    RegisterUpdater()
end

function HodorRestyle.StartUpdater()
    if HR._updaterStarted then
        return
    end

    HR._updaterStarted = true
    RegisterUpdater()
end