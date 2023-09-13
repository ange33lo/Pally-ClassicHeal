function _G.OPTI_GetUnitLostHealthPercent(unit)
    local currentHealth = UnitHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    if maxHealth > 0 then
        return (1 - (currentHealth / maxHealth)) * 100
    else
        return 0
    end
end


function get_ally_lowest_health()
    -- Gets the party member who has lost the most health so far
    local num_group_members = GetNumGroupMembers()

    local most_health_lost = 0
    local player_with_most_health_lost = "party" .. 1

    for i = 1, num_group_members do
        local unit = "party" .. i
        local health_lost = OPTI_GetUnitLostHealthPercent(unit)

        if health_lost >= most_health_lost then
            most_health_lost = health_lost
            player_with_most_health_lost = unit
        end
    end

    return player_with_most_health_lost

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
        
        local person_to_heal = get_ally_lowest_health()
        local health_percent = OPTI_GetUnitLostHealthPercent(person_to_heal)

        if health_percent >= percent then
            UnlockedTargetUnit(person_to_heal)
            targetFound = true
        end
    end
    return targetFound
end