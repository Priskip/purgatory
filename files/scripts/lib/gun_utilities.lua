--Utility functions for manipulating wands and spells.
--Author: Priskip
dofile_once("data/scripts/lib/utilities.lua")

--[[
    Returns a table of a wand's stats.
    Only returns the characteristics of a wand like cast delay and mana regeneration.
    Does not return any information regarding spells on the wand.

    Inputs:
    gun_id = [int] : Entity ID of the wand. If the wand is in the player's inventory, use the child id of the wand and NOT the player's id.

    Return Types:
    nil : If this happens, check game's console for any printed error.
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
function getGunStats(gun_id)
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
function setGunStats(gun_id, gun_stats)
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

--[[
    Returns two tables.
    The first is a list of spell ids on the wand.
    The second is a list of spell ids that are always casts on the wand.

    Inputs:
    wand_id = [int] : entity id of the wand you want to get the spells off of.

    Return Types
    spells =       {"", "", ... , ""} Table of Strings
    always_casts = {"", "", ... , ""} Table of Strings
]]
function getAllSpellsOnWand(wand_id)
    local spells = {}
    local always_casts = {}
    local children = EntityGetAllChildren(wand_id)

    for i, v in ipairs(children) do
        local item_action_comp = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")
        local spell_id = ComponentGetValue2(item_action_comp, "action_id")

        local item_comp = EntityGetFirstComponentIncludingDisabled(v, "ItemComponent")
        local is_always_cast = ComponentGetValue2(item_comp, "permanently_attached")

        if is_always_cast then
            always_casts[#always_casts + 1] = spell_id
        else
            spells[#spells + 1] = spell_id
        end
    end

    return spells, always_casts
end

--[[
    Gets the spell id (string) and entity id [int] of the action item in a wand's slot.
    Returns nil if there is no spell in this slot.
]]
function getSpell(wand_id, spell_slot)
end

--[[
    Functions that are still needed.
    getSpell(wand_id, spell_slot)
    getAlwaysCast(wand_id, always_cast_slot)
    setSpell(wand_id, spell_slot, spell_id) --Set a spell in a slot - will overwrite an existing spell
    injectSpell(wand_id, spell_slot, spell_id) --Sets a spell in a slot - will push an existing spell to later slots in the wand if capacity is there.
    setAlwaysCast(wand_id, always_cast_slot, always_cast_id) 
    injectAlwaysCast(wand_id, always_cast_slot, always_cast_id)
    removeSpell(wand_id, spell_slot) --Removes a spell from the wand. Spell card disappears into the ether.
    removeAlwaysCast(wand_id, spell_slot)
    dropSpell(wand_id, spell_slot) --Makes a spell card come off the wand and drop as a physical item.
    dropAlwaysCast(wand_id, always_cast_slot)
    spellGetCharges(wand_id, spell_slot)
    spellGetMaxCharges(wand_id, spell_slot)
    spellSetCharges(wand_id, spell_slot, charges)
]]