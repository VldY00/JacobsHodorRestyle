local HR = HodorRestyle

function HR.registerGroupMemberUpdated()
    EVENT_MANAGER:RegisterForEvent("registerGroupMemberJoined", EVENT_GROUP_MEMBER_JOINED, function()
        local container = HodorRestyleContainer:GetNamedChild('container')
        local bottomBar = container:GetNamedChild('bottomBar')
        bottomBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, (HR.savedVariables.barHeight + 2) * GetGroupSize())
    end)
    EVENT_MANAGER:RegisterForEvent("registerGroupMemberLeft", EVENT_GROUP_MEMBER_LEFT, function()
        local container = HodorRestyleContainer:GetNamedChild('container')
        local bottomBar = container:GetNamedChild('bottomBar')
        bottomBar:SetDimensions(HR.savedVariables.barWidth + HR.savedVariables.barHeight + 6, (HR.savedVariables.barHeight + 2) * GetGroupSize())
    end)
end