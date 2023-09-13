function _G.OPTI_GetUnitLostHealthPercent(unit)
    local currentHealth = UnitHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    if maxHealth > 0 then
        return (1 - (currentHealth / maxHealth)) * 100
    else
        return 0
    end
end

function _G.OPTI_GroupHealing(percent)
    local targetFound = false

    -- Check player Health
    local playerHealthPercent = OPTI_GetUnitLostHealthPercent("player")
    if playerHealthPercent >= percent then
        UnlockedTargetUnit("player")
        targetFound = true
    end

    -- If the player does not fall below the threshold and he is in a group,
    -- then check the rest of the group members
    if not targetFound and IsInGroup() then
        local numGroupMembers = GetNumGroupMembers()

        for i = 1, numGroupMembers do
            local unit = "party" .. i
            local healthPercent = OPTI_GetUnitLostHealthPercent(unit)
            if healthPercent >= percent then
                UnlockedTargetUnit(unit)
                targetFound = true
                break
            end
        end
    end
    return targetFound
end