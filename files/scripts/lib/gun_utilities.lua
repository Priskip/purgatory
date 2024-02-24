--Utility functions for manipulating wands and spells.
--Author: Priskip
dofile_once("data/scripts/lib/utilities.lua")

--[[
    Description:
    Returns a table of a wand's stats.
    Only returns the characteristics of a wand like cast delay and mana regeneration.
    Does not return any information regarding spells on the wand.

    Inputs:
    gun_id = [int] : Entity ID of the wand. If the wand is in the player's inventory, use the child id of the wand and NOT the player's id.

    Return Types:
    nil : If this happens, check game's console for a printed error.
    table : Following table is returned if there are no errors.
    {
        shuffle =           [bool], --True = will be shuffle, false = no shuffle
        spells_per_cast =   [num], --Innate draw of each cast state
        cast_delay =        [int], --In Frames (Noita runs at 60 fps, so cast_delay = 30 means a cast delay of 0.5s)
        recharge_time =     [int], --In Frames (Noita runs at 60 fps, so recharge_time = 30 means a recharge time of 0.5s)
        mana_max =          [num], --Max mana in the wand
        current_mana =      [num], --How much mana is currently in the wand.
        mana_charge_speed = [num], --In mana/second
        capacity =          [num], --The amount of capacity in the wand. Can be a non-integer value, but the game will take math.floor(capacity)
        spread =            [num], --Spread in degrees
        speed =             [num] --Speed multiplier. This is a hidden stat on all wands. Normally it's 1 +/- 0.13. However, there can be some extreme outliers from 0.58 to 8.75.
    }
]]
function GetGunStats(gun_id)
    local ability_comp = EntityGetFirstComponentIncludingDisabled(gun_id, "AbilityComponent")
    local stats = {}

    if ability_comp ~= nil then
        stats.shuffle = ComponentObjectGetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty")
        stats.spells_per_cast = ComponentObjectGetValue2(ability_comp, "gun_config", "actions_per_round")
        stats.cast_delay = ComponentObjectGetValue2(ability_comp, "gunaction_config", "fire_rate_wait")
        stats.recharge_time = ComponentObjectGetValue2(ability_comp, "gun_config", "reload_time")
        stats.mana_max = ComponentGetValue2(ability_comp, "mana_max")
        stats.current_mana = ComponentGetValue2(ability_comp, "mana")
        stats.mana_charge_speed = ComponentGetValue2(ability_comp, "mana_charge_speed")
        stats.capacity = ComponentObjectGetValue2(ability_comp, "gun_config", "deck_capacity")
        stats.spread = ComponentObjectGetValue2(ability_comp, "gunaction_config", "spread_degrees")
        stats.speed = ComponentObjectGetValue2(ability_comp, "gunaction_config", "speed_multiplier")

        return stats
    end
    return nil
end

--[[
    Description:
    Sets a wand's stats to that given to it in a table.
    Only sets the characteristics of a wand like cast delay and mana regeneration.
    Does not set any spells on the wand.

    Inputs:
    gun_id = [int] : Entity ID of the wand. If the wand is in the player's inventory, use the child id of the wand and NOT the player's id.
    gun_stats = [table] :
    {
        shuffle =           [bool], --True = will be shuffle, false = no shuffle
        spells_per_cast =   [num], --Innate draw of each cast state
        cast_delay =        [int], --In Frames (Noita runs at 60 fps, so cast_delay = 30 means a cast delay of 0.5s)
        recharge_time =     [int], --In Frames (Noita runs at 60 fps, so recharge_time = 30 means a recharge time of 0.5s)
        mana_max =          [num], --Max mana in the wand
        current_mana =      [num], --How much mana is currently in the wand.
        mana_charge_speed = [num], --In mana/second
        capacity =          [num], --The amount of capacity in the wand. Can be a non-integer value, but the game will take math.floor(capacity)
        spread =            [num], --Spread in degrees
        speed =             [num] --Speed multiplier. This is a hidden stat on all wands. Normally it's 1 +/- 0.13. However, there can be some extreme outliers from 0.58 to 8.75.
    }
    NOTE: You do not need to specify EVERY stat in this table. This function will look to see which values are in it and only set the ones you provide.

    Return Types:
    none
]]
function SetGunStats(gun_id, gun_stats)
    local ability_comp = EntityGetFirstComponentIncludingDisabled(gun_id, "AbilityComponent")

    if ability_comp ~= nil then
        if gun_stats.shuffle ~= nil then
            ComponentObjectSetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty", gun_stats.shuffle)
        end
        if gun_stats.spells_per_cast ~= nil then
            ComponentObjectSetValue2(ability_comp, "gun_config", "actions_per_round", gun_stats.spells_per_cast)
        end
        if gun_stats.cast_delay ~= nil then
            ComponentObjectSetValue2(ability_comp, "gunaction_config", "fire_rate_wait", gun_stats.cast_delay)
        end
        if gun_stats.recharge_time ~= nil then
            ComponentObjectSetValue2(ability_comp, "gun_config", "reload_time", gun_stats.recharge_time)
        end
        if gun_stats.mana_max ~= nil then
            ComponentSetValue2(ability_comp, "mana_max", gun_stats.mana_max)
        end
        if gun_stats.current_mana ~= nil then
            ComponentSetValue2(ability_comp, "mana", gun_stats.current_mana)
        end
        if gun_stats.mana_charge_speed ~= nil then
            ComponentSetValue2(ability_comp, "mana_charge_speed", gun_stats.mana_charge_speed)
        end
        if gun_stats.capacity ~= nil then
            ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", gun_stats.capacity)
        end
        if gun_stats.spread ~= nil then
            ComponentObjectSetValue2(ability_comp, "gunaction_config", "spread_degrees", gun_stats.spread)
        end
        if gun_stats.speed ~= nil then
            ComponentObjectSetValue2(ability_comp, "gunaction_config", "speed_multiplier", gun_stats.speed)
        end
    end
end
