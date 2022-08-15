dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/gun/deck_types.lua")

local multicasts_2 = {
    "BURST_2",
    "SCATTER_2",
    "I_SHAPE",
    "Y_SHAPE"
}
local multicasts_3 = {
    "BURST_3",
    "SCATTER_3",
    "T_SHAPE",
    "W_SHAPE"
}
local multicasts_4 = {
    "BURST_4",
    "SCATTER_4",
    "CROSS_SHAPE"
}

--Generates a list of all single type trigger spells
function get_trigger_spells()
    local spell_list = {}
    local count = 0

    for i, v in ipairs(actions) do
        --print(v.id)
        local triggers, timers, death_triggers = count_trigger_types(v.id)
        local adds = find_amount_of_strings_in_string(v.id, "ADD_")

        if triggers + timers + death_triggers + adds == 1 then
            count = count + 1
            spell_list[count] = v.id
        end
    end

    return spell_list
end

--Gnerates a custom deck for the 4 starting wands
--See deck_types.lua for what it can generate

function generate_deck(tier, shuffle, deck_size, black_listed_projectiles, black_listed_modifiers, trigger_spells, x, y)
    --Seed Randomness
    SetRandomSeed(x, y)

    --debug print("WAND GEN - Tier: " .. tostring(tier) .. " Shuffle: " .. tostring(shuffle) .. " Deck Size: " .. tostring(deck_size))

    --Oversize Deck Handling
    if deck_size > 7 then
        deck_size = 7
    end

    --Get Deck Options
    local deck_options = {}
    if shuffle == 1 then
        deck_options = deck_types[deck_size].shuffle_decks
    else
        deck_options = deck_types[deck_size].non_shuffle_decks --TODO: Lua error: [string "mods/purgatory/files/scripts/gun/deck_generat..."]:61: attempt to index a nil value
    end

    --Randomly Pick a Deck Option
    local num = Random(1, #deck_options)
    local deck_to_build = deck_options[num].deck
    local use_same_projs = deck_options[num].same_projectiles

    --Gen Deck
    local deck = {}
    local last_proj_added = nil

    for pos, spell_type in ipairs(deck_to_build) do
        local spell_to_add = ""

        --If spell to add is a projectile
        if spell_type == "PROJECTILE" then
            if use_same_projs == false or last_proj_added == nil then
                local cond = true
                local iterations = 0

                while cond do
                    iterations = iterations + 1

                    --Get Random Spell
                    spell_to_add = GetRandomActionWithType(x + iterations, y + pos, tier, ACTION_TYPE_PROJECTILE, 0)

                    --Check if Blacklisted
                    local is_black_listed = false
                    for i, v in ipairs(black_listed_projectiles) do
                        if spell_to_add == v then
                            is_black_listed = true
                            break
                        end
                    end

                    --Check if is a trigger
                    for i, v in ipairs(trigger_spells) do
                        if spell_to_add == v then
                            is_black_listed = true
                            break
                        end
                    end

                    cond = is_black_listed --If projectile is blacklisted, loop will iterate and try again.

                    if iterations == 100 then
                        --clear blacklisted projectiles because no projectile is being selected
                        black_listed_projectiles = {}
                        iterations = 0
                        print("PURGATORY: WARNING! Projectile deck iterator reached limit!")
                    end
                end

                --Save Spell ID to be used later if deck type demands all projectiles be the same
                last_proj_added = spell_to_add
            elseif use_same_projs == true and last_proj_added ~= nil then
                spell_to_add = last_proj_added
            end
        end

        --If spell to add is a modifier
        if spell_type == "MODIFIER" then
            local cond = true
            local iterations = 0

            while cond do
                iterations = iterations + 1

                --Get Random Spell
                spell_to_add = GetRandomActionWithType(x + iterations, y + pos, tier, ACTION_TYPE_MODIFIER, 0)

                --Check if Blacklisted
                local is_black_listed = false
                for i, v in ipairs(black_listed_modifiers) do
                    if spell_to_add == v then
                        is_black_listed = true
                        break
                    end
                end

                cond = is_black_listed --If modfier is blacklisted, loop will iterate and try again.

                if iterations == 100 then
                    --clear blacklisted modifiers because no modifier is being selected
                    black_listed_modifiers = {}
                    iterations = 0
                    print("PURGATORY: WARNING! Modifier deck iterator reached limit!")
                end
            end
        end

        --If spell to add is a trigger
        if spell_type == "TRIGGER" then
            SetRandomSeed(x + pos, y)
            spell_to_add = trigger_spells[Random(1, #trigger_spells)]
        end

        --If spell to add is a draw 2
        if spell_type == "MULTICAST_2" then
            SetRandomSeed(x + pos, y)
            spell_to_add = multicasts_2[Random(1, #multicasts_2)]
        end

        --If spell to add is a draw 3
        if spell_type == "MULTICAST_3" then
            SetRandomSeed(x + pos, y)
            spell_to_add = multicasts_3[Random(1, #multicasts_3)]
        end

        --If spell to add is a draw 4
        if spell_type == "MULTICAST_4" then
            SetRandomSeed(x + pos, y)
            spell_to_add = multicasts_4[Random(1, #multicasts_4)]
        end

        --Add spell to deck
        deck[pos] = spell_to_add
    end

    return deck, black_listed_projectiles, black_listed_modifiers
end
