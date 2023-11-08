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

    -- Initialize as the player. 
    local most_health_lost = OPTI_GetUnitLostHealthPercent("player")
    local player_with_most_health_lost = "player"

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


function has_debuff_name(unit, debuff)
    local data = {UnitDebuff(unit, debuff)}
    local name = data[1]
    print("Spell name is " .. name)
    if not name then
        return false
    end

    return true
end


function get_ally_without_debuff(debuff)
    -- Gets a party member who doesn't have the debuff
    local num_group_members = GetNumGroupMembers()

    -- Initialize as the player. 
    if not has_debuff_name("player", debuff) then
        return "player"
    end

    for i = 1, num_group_members do
        local unit = "party" .. i
        if not has_debuff_name(unit, debuff) then
            return unit
        end
    end

    return nil

end


function _G.OPTI_GroupHealing(percent)
    local targetFound = false

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


function _G.OPTI_GroupBuffing(debuff)
    local targetFound = false

    -- If the player does not fall below the threshold and he is in a group,
    -- then check the rest of the group members
    if not targetFound and IsInGroup() then
        
        local person_to_buff = get_ally_without_debuff(debuff)
        if person_to_buff then
            UnlockedTargetUnit(person_to_buff)
            targetFound = true
        end
    end
    return targetFound
end