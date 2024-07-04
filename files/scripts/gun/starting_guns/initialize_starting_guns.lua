dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/gun/starting_guns/deck_types.lua")
dofile_once("mods/purgatory/files/scripts/gun/starting_guns/get_spell_types.lua")

-- Clears all spells on a wand
function gun_clear_actions(gun_id)
    local children = EntityGetAllChildren(gun_id) or {}
    for i, v in ipairs(children) do
        local item = EntityGetFirstComponentIncludingDisabled(v, "ItemComponent")
        local item_action = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")
        if item and item_action then
            EntityRemoveFromParent(v)
            EntityKill(v)
        end
    end
end

-- Puts list of spells on a wand
function put_deck_on_gun(gun_id, deck, gun)
    local deck_capacity = math.ceil(gun["deck_capacity"])

    gun_clear_actions(gun_id)

    if deck ~= nil or #deck == 0 then
        for i, spell in ipairs(deck) do
            if i <= deck_capacity then
                AddGunAction(gun_id, spell)
            else
                break
            end
        end
    end
end

-- Removes all limited use trigger spells from the list of trigger spells available to spawn on the starting wands
function remove_limited_use_triggers(trigger_spells)
    local new_list_of_trigger_spells = {}

    for i, spell in ipairs(actions) do
        if isInTable(trigger_spells, spell.id) then
            --spell is a trigger spell, see if it has limited uses
            if spell.max_uses == nil then
                --spell is an unlimited use spell, add to table
                new_list_of_trigger_spells[#new_list_of_trigger_spells + 1] = spell.id
            end
        end
    end
    -- note priskip: is there a more effecient way of doing this?

    return new_list_of_trigger_spells
end

-- 1 = true, 0 = false
function num_to_bool(num)
    if num == 0 then
        return false
    elseif num == 1 then
        return true
    end
    return false
end

-- Sets all stats on a gun
function set_gun_stats(gun_id, gun)
    local ability_comp = EntityGetFirstComponentIncludingDisabled(gun_id, "AbilityComponent")
    ComponentObjectSetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty",
        num_to_bool(gun.shuffle_deck_when_empty))                                                        --shuffle
    ComponentObjectSetValue2(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round)     --spells per cast
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "fire_rate_wait", gun.fire_rate_wait)     --cast delay
    ComponentObjectSetValue2(ability_comp, "gun_config", "reload_time", gun.reload_time)                 --recharge time
    ComponentSetValue2(ability_comp, "mana_max", gun.mana_max)                                           --mana max
    ComponentSetValue2(ability_comp, "mana", gun.mana_max)                                               -- current mana
    ComponentSetValue2(ability_comp, "mana_charge_speed", gun.mana_charge_speed)                         --mana charge speed
    ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", gun.deck_capacity)             --capacity
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees)     --spread
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier) --speed
end

-- tier to cost and level based on how nolla generates guns
function tier_to_cost_and_level(gun_tier)
    if gun_tier == 1 then
        return 30, 1
    end

    if gun_tier == 2 then
        return 40, 2
    end

    if gun_tier == 3 then
        return 60, 3
    end

    if gun_tier == 4 then
        return 80, 4
    end

    if gun_tier == 5 then
        return 100, 5
    end

    if gun_tier == 6 then
        return 120, 6
    end

    if gun_tier == 10 then
        return 200, 11
    end

    return nil
end

-- Is a gun's stats "good"?
function is_satisfactory_gun(gun)
    --[[
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠖⠛⠋⠁⠈⠉⠉⠋⠛⠛⠛⠓⠒⠦⣄⡀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⢀⡴⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣦⡀⠀⠀⠀⠀
    ⠀⠀⠀⠀⢀⠔⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠪⠹⣆⠀⠀⠀
    ⠀⠀⠀⡴⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣧⠀⠀
    ⠀⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⠀⠀⠀⠀⢻⡆⠀
    ⠀⠰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⢀⣠⣤⣤⣀⠀⠀⠀⠀⠀⠀⣳⠀
    ⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣷⠀⠀⢀⣴⣾⣿⣿⡿⢿⣧⠀⢀⣴⣾⣿⣿⡄
    ⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣆⠀⠈⠉⢹⣿⡟⠁⢀⡄⢠⡼⡟⣿⣿⠿⡇
    ⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠀⠀⠬⠁⠀⠈⠀⢸⣧⢇⠈⠁⠀⡇
    ⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⢸⠻⣸⡀⠀⢸⡇
    ⢻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⢠⠜⠀⠁⢧⠀⣿⠁
    ⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣷⣶⣤⣦⠾⢸⡏⠀
    ⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠟⠀⠀⣾⠃⠀
    ⠀⢹⡄⠀⠀⠀⠀⠀⠀⢀⣀⣀⡀⠀⠀⠀⠀⠀⠀⢶⠀⠀⠀⢠⣤⣤⣿⣧⣴⣶⣾⡟⠀⠀
    ⠀⠀⣧⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣷⣦⣄⠀⠀⠀⠘⣧⠀⠀⠀⠈⠻⠿⠛⠉⢠⡿⠁⠀⠀
    ⠀⠀⠸⡆⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣧⣤⣀⠀⠘⢇⡀⠀⠀⠀⠀⠀⢠⡟⠁⠀⠀⠀
    ⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠹⠿⠿⠿⣿⣿⣿⣿⣿⣷⣦⡀⠡⠀⠀⠀⠀⣄⣾⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣷⣦⣤⣤⣼⡿⠃⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⣿⣿⣿⡏⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠏⣽⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⣼⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠃⠀⢻⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠁⠀⠀⠈⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠸⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠀⠀⠀⠀⢠⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠈⠛⠿⢷⣿⣶⣶⣶⣶⣶⣦⣤⣤⣤⣤⣤⣶⠾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀Ah yes. A satisfactory

    ]]
    local is_satisfactory_gun = true

    if gun.actions_per_round ~= 1 then
        is_satisfactory_gun = false
    end

    if gun.fire_rate_wait > 60 then
        is_satisfactory_gun = false
    end

    if gun.reload_time > 60 then
        is_satisfactory_gun = false
    end

    if gun.mana_max / gun.mana_charge_speed > 10 then
        is_satisfactory_gun = false
    end

    if math.abs(gun.spread_degrees) > 10 then
        is_satisfactory_gun = false
    end

    return is_satisfactory_gun
end

--Generates custom decks for the starting wands
function generate_deck(x, y, randomness_offset, gun_tier, gun_shuffle_deck_when_empty, gun_capacity, trigger_spells,
                       draw_2_spells, draw_3_spells, draw_4_spells, used_spells, all_trigger_spells)
    local deck = {}
    local deck_gen_type = nil

    --Seed Randomness
    randomness_offset = randomness_offset + 1
    SetRandomSeed(x + randomness_offset, y + randomness_offset)

    --Generate a deck that is about 2/3 the size of the gun's capacity
    local deck_size = math.min(roundToInt(2 * gun_capacity / 3), 7)

    --Get available options for the deck depending on if it's shuffle or not
    if gun_shuffle_deck_when_empty == 1 then
        --Shuffle Deck
        deck_gen_type = shuffle_decks
            [deck_size] --the math.min(cap, 7) ensures that we only generate decks with 7 spells in them
    else
        --Non Shuffle Deck
        deck_gen_type = non_shuffle_decks[deck_size]
    end

    --Select one of the deck types available at random
    local deck_to_gen = random_from_array(deck_gen_type)

    local deck_index = 0 --used to count what position of the deck we're adding cards to
    for i, v in ipairs(deck_to_gen) do
        if v.type == "PROJECTILE" then
            --Generate projectiles to put in the deck
            local spell_to_add = ""
            local cond = false
            local iter_count = 0

            if v.same_projectiles == true then
                --use same projectiles in generation
                while not cond do
                    spell_to_add = GetRandomActionWithType(x + randomness_offset, y + randomness_offset, gun_tier,
                        ACTION_TYPE_PROJECTILE, 0)

                    if isInTable(used_spells.projectiles, spell_to_add) or isInTable(all_trigger_spells, spell_to_add) then
                        --spell is in the list of already used spells or is a trigger spell itself, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.projectiles = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.projectiles[#used_spells.projectiles + 1] = spell_to_add
                        cond = true
                    end
                end

                for j = 1, v.amount do
                    deck_index = deck_index + 1
                    deck[deck_index] = spell_to_add
                end
            else
                --use different projectiles in generation
                for j = 1, v.amount do
                    spell_to_add = ""
                    cond = false
                    iter_count = 0

                    while not cond do
                        spell_to_add = GetRandomActionWithType(x + randomness_offset, y + randomness_offset, gun_tier,
                            ACTION_TYPE_PROJECTILE, 0)

                        if isInTable(used_spells.projectiles, spell_to_add) or isInTable(all_trigger_spells, spell_to_add) then
                            --spell is in the list of already used spells or is a trigger spell itself, generate a new one by incrementing randomness_offset
                            randomness_offset = randomness_offset + 1
                            iter_count = iter_count + 1

                            --check for excessive recursion
                            if iter_count > 420 then
                                --dump spells used deck and reset iter_count
                                iter_count = 0
                                used_spells.projectiles = {}
                            end
                        else
                            --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                            used_spells.projectiles[#used_spells.projectiles + 1] = spell_to_add
                            cond = true
                        end
                    end
                    deck_index = deck_index + 1
                    deck[deck_index] = spell_to_add
                end
            end
        end

        if v.type == "MODIFIER" then
            --Generate modifiers to put in the deck

            for j = 1, v.amount do
                local spell_to_add = ""
                local cond = false
                local iter_count = 0

                while not cond do
                    spell_to_add = GetRandomActionWithType(x + randomness_offset, y + randomness_offset, gun_tier,
                        ACTION_TYPE_MODIFIER, 0)

                    if isInTable(used_spells.modifiers, spell_to_add) then
                        --spell is in the list of already used spells, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.modifiers = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.modifiers[#used_spells.modifiers + 1] = spell_to_add
                        cond = true
                    end
                end

                deck_index = deck_index + 1
                deck[deck_index] = spell_to_add
            end
        end

        if v.type == "DRAW_2" then
            --Generate a multicast with 2 draw to put in the deck
            for j = 1, v.amount do
                local spell_to_add = ""
                local cond = false
                local iter_count = 0

                while not cond do
                    SetRandomSeed(x + randomness_offset, y + randomness_offset)
                    spell_to_add = random_from_array(draw_2_spells)

                    if isInTable(used_spells.draw_2s, spell_to_add) then
                        --spell is in the list of already used spells, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.draw_2s = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.draw_2s[#used_spells.draw_2s + 1] = spell_to_add
                        cond = true
                    end
                end

                deck_index = deck_index + 1
                deck[deck_index] = spell_to_add
            end
        end

        if v.type == "DRAW_3" then
            --Generate a multicast with 3 draw to put in the deck
            for j = 1, v.amount do
                local spell_to_add = ""
                local cond = false
                local iter_count = 0

                while not cond do
                    SetRandomSeed(x + randomness_offset, y + randomness_offset)
                    spell_to_add = random_from_array(draw_3_spells)

                    if isInTable(used_spells.draw_3s, spell_to_add) then
                        --spell is in the list of already used spells, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.draw_3s = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.draw_3s[#used_spells.draw_3s + 1] = spell_to_add
                        cond = true
                    end
                end

                deck_index = deck_index + 1
                deck[deck_index] = spell_to_add
            end
        end

        if v.type == "DRAW_4" then
            --Generate a multicast with 4 draw to put in the deck
            for j = 1, v.amount do
                local spell_to_add = ""
                local cond = false
                local iter_count = 0

                while not cond do
                    SetRandomSeed(x + randomness_offset, y + randomness_offset)
                    spell_to_add = random_from_array(draw_4_spells)

                    if isInTable(used_spells.draw_4s, spell_to_add) then
                        --spell is in the list of already used spells, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.draw_4s = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.draw_4s[#used_spells.draw_4s + 1] = spell_to_add
                        cond = true
                    end
                end

                deck_index = deck_index + 1
                deck[deck_index] = spell_to_add
            end
        end

        if v.type == "TRIGGER" then
            --Generate a trigger type spell to put in the deck

            for j = 1, v.amount do
                local spell_to_add = ""
                local cond = false
                local iter_count = 0

                while not cond do
                    SetRandomSeed(x + randomness_offset, y + randomness_offset)
                    spell_to_add = random_from_array(trigger_spells)

                    if isInTable(used_spells.triggers, spell_to_add) then
                        --spell is in the list of already used spells, generate a new one by incrementing randomness_offset
                        randomness_offset = randomness_offset + 1
                        iter_count = iter_count + 1

                        --check for excessive recursion
                        if iter_count > 420 then
                            --dump spells used deck and reset iter_count
                            iter_count = 0
                            used_spells.triggers = {}
                        end
                    else
                        --spell is NOT in the list of already used spells, use this one and add it to the list of used spells
                        used_spells.triggers[#used_spells.triggers + 1] = spell_to_add
                        cond = true
                    end
                end

                deck_index = deck_index + 1
                deck[deck_index] = spell_to_add
            end
        end
    end

    return deck, used_spells, randomness_offset
end

--Does the magic
function initialize_starting_guns(player_id)
    local debug_mode = ModSettingGet("purgatory.debug_mode")

    if not debug_mode then
        local player = {}
        player.id = player_id
        player.x = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X")
        player.y = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y")

        --Get gun ids
        local gun_ids = {} --blue = gun_ids[1], red = gun_ids[2], yellow = gun_ids[3], green = gun_ids[4]
        local ents_near_player = EntityGetInRadius(player.x, player.y, 24)
        for i, ent_id in ipairs(ents_near_player) do
            local ability_comp = EntityGetFirstComponentIncludingDisabled(ent_id, "AbilityComponent")
            if ability_comp ~= nil then
                local ui_name = ComponentGetValue2(ability_comp, "ui_name")

                if ui_name == "$item_starting_gun_blue" then
                    gun_ids[1] = ent_id
                end

                if ui_name == "$item_starting_gun_red" then
                    gun_ids[2] = ent_id
                end

                if ui_name == "$item_starting_gun_yellow" then
                    gun_ids[3] = ent_id
                end

                if ui_name == "$item_starting_gun_green" then
                    gun_ids[4] = ent_id
                end
            end
        end

        --Distribute Tiers
        local gun_tiers = { 1, 1, 1, 1 }
        local costs, levels = {}, {}
        local guns = {}

        for i = 1, 7 do
            SetRandomSeed(player.x + 10 * i, player.y - 10 * i)
            local num = Random(1, 100)

            if 1 <= num and num <= 10 then
                gun_tiers[1] = math.min(gun_tiers[1] + 1, 4)
            elseif 11 <= num and num <= 30 then
                gun_tiers[2] = math.min(gun_tiers[2] + 1, 4)
            elseif 31 <= num and num <= 60 then
                gun_tiers[3] = math.min(gun_tiers[3] + 1, 4)
            elseif 61 <= num and num <= 100 then
                gun_tiers[4] = math.min(gun_tiers[4] + 1, 4)
            end
            --10%, 20%, 30%, 40% for the wands to get an additional tier
        end

        --Force one unshuffle
        local force_unshuffles = { false, false, false, false }
        force_unshuffles[Random(1, 4)] = true

        --Generate Guns
        local randomness_offset = 0 --used to offset random functions so 2 of the same guns don't get generated

        for i = 1, 4 do
            local is_satisfactory = false

            while not is_satisfactory do
                randomness_offset = randomness_offset + 1
                SetRandomSeed(player.x + randomness_offset, player.y - randomness_offset)

                costs[i], levels[i] = tier_to_cost_and_level(gun_tiers[i])
                guns[i] = get_gun_data(costs[i], levels[i], force_unshuffles[i])

                is_satisfactory = is_satisfactory_gun(guns[i])
            end
        end

        --Cap Capacity
        for i = 1, 4 do
            guns[i].deck_capacity = roundToInt(guns[i].deck_capacity) --for some reason capacity is not generated as an interger value
            guns[i].deck_capacity = math.min(guns[i].deck_capacity, 12)
            guns[i].deck_capacity = math.max(guns[i].deck_capacity, 3)
        end

        --Set stats on guns
        for i = 1, 4 do
            set_gun_stats(gun_ids[i], guns[i])
        end

        --Get List of all available trigger spells
        local spell_types = get_spell_types() -- ==> {triggers = {}, timers = {}, death_triggers = {}, draw_2s = {}, draw_3s = {}, draw_4s = {}}
        local all_trigger_spells = concatenateTables(concatenateTables(spell_types.triggers, spell_types.timers),
            spell_types.death_triggers)

        --Remove limited use triggers from list
        local useable_trigger_spells = remove_limited_use_triggers(all_trigger_spells)

        --Generate Decks and put them on guns
        local decks = {}
        local used_spells = {} --used for making it so deck generation doesn't repeat the same spells
        used_spells.projectiles = {}
        used_spells.modifiers = {}
        used_spells.draw_2s = {}
        used_spells.draw_3s = {}
        used_spells.draw_4s = {}
        used_spells.triggers = {}

        for i = 1, 4 do
            decks[i], used_spells, randomness_offset =
                generate_deck(
                    player.x,
                    player.y,
                    randomness_offset,
                    gun_tiers[i],
                    guns[i].shuffle_deck_when_empty,
                    guns[i].deck_capacity,
                    useable_trigger_spells,
                    spell_types.draw_2s,
                    spell_types.draw_3s,
                    spell_types.draw_4s,
                    used_spells,
                    all_trigger_spells
                )
            put_deck_on_gun(gun_ids[i], decks[i], guns[i])
        end
    else --ELSE DEBUG MODE
        local player = {}
        player.id = player_id
        player.x = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X")
        player.y = MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y")

        --Get gun ids
        local gun_ids = {} --blue = gun_ids[1], red = gun_ids[2], yellow = gun_ids[3], green = gun_ids[4]
        local ents_near_player = EntityGetInRadius(player.x, player.y, 24)
        for i, ent_id in ipairs(ents_near_player) do
            local ability_comp = EntityGetFirstComponentIncludingDisabled(ent_id, "AbilityComponent")
            if ability_comp ~= nil then
                local ui_name = ComponentGetValue2(ability_comp, "ui_name")

                if ui_name == "$item_starting_gun_blue" then
                    gun_ids[1] = ent_id
                end

                if ui_name == "$item_starting_gun_red" then
                    gun_ids[2] = ent_id
                end

                if ui_name == "$item_starting_gun_yellow" then
                    gun_ids[3] = ent_id
                end

                if ui_name == "$item_starting_gun_green" then
                    gun_ids[4] = ent_id
                end
            end
        end

        local blue_gun = {}
        blue_gun.shuffle_deck_when_empty = 0
        blue_gun.actions_per_round = 1
        blue_gun.fire_rate_wait = 10
        blue_gun.reload_time = 30
        blue_gun.mana_max = 1000
        blue_gun.mana_charge_speed = 300
        blue_gun.deck_capacity = 25
        blue_gun.spread_degrees = 0
        blue_gun.speed_multiplier = 1

        local red_gun = {}
        red_gun.shuffle_deck_when_empty = 0
        red_gun.actions_per_round = 1
        red_gun.fire_rate_wait = 5
        red_gun.reload_time = 10
        red_gun.mana_max = 1000
        red_gun.mana_charge_speed = 300
        red_gun.deck_capacity = 25
        red_gun.spread_degrees = 0
        red_gun.speed_multiplier = 1

        local yellow_gun = {}
        yellow_gun.shuffle_deck_when_empty = 0
        yellow_gun.actions_per_round = 1
        yellow_gun.fire_rate_wait = 10
        yellow_gun.reload_time = 30
        yellow_gun.mana_max = 1000
        yellow_gun.mana_charge_speed = 300
        yellow_gun.deck_capacity = 25
        yellow_gun.spread_degrees = 0
        yellow_gun.speed_multiplier = 1

        local green_gun = {}
        green_gun.shuffle_deck_when_empty = 0
        green_gun.actions_per_round = 1
        green_gun.fire_rate_wait = 10
        green_gun.reload_time = 30
        green_gun.mana_max = 1000
        green_gun.mana_charge_speed = 300
        green_gun.deck_capacity = 25
        green_gun.spread_degrees = 0
        green_gun.speed_multiplier = 1

        set_gun_stats(gun_ids[1], blue_gun)
        set_gun_stats(gun_ids[2], red_gun)
        set_gun_stats(gun_ids[3], yellow_gun)
        set_gun_stats(gun_ids[4], green_gun)

        local blue_deck =
        {
            "SPEED",
            "SPEED",
            "SPEED",
            "SPEED",
            "LAVA_TO_BLOOD",
            "MONEY_MAGIC",
            "HITFX_CRITICAL_WATER",
            "HEAVY_SHOT",
            "BURST_2",
            "LIGHT_BULLET",
            "MATERIAL_WATER",
        }

        local red_deck =
        {
            "TELEPORT_PROJECTILE_SHORT"
        }

        local yellow_deck =
        {
            "BLOOD_MAGIC",

        }

        local green_deck =
        {
            "VACUUM_BLOOD",
            --[[ "DIVIDE_2",
            "DIVIDE_3",
            "DIVIDE_4",
            "DIVIDE_10",
            "GAMMA",
            "TAU",
            "OMEGA",
            "ZETA" ]]
        }

        put_deck_on_gun(gun_ids[1], blue_deck, blue_gun)
        put_deck_on_gun(gun_ids[2], red_deck, red_gun)
        put_deck_on_gun(gun_ids[3], yellow_deck, yellow_gun)
        put_deck_on_gun(gun_ids[4], green_deck, green_gun)
    end
end
