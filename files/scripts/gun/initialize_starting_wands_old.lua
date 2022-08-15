dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("mods/purgatory/files/scripts/gun/gun_generation_custom.lua")

function num_to_bool(num)
    if num == 0 then
        return false
    elseif num == 1 then
        return true
    end
    return false
end

function wandClearActions(wand_id)
    local children = EntityGetAllChildren(wand_id) or {}
    for i, v in ipairs(children) do
        local item = EntityGetFirstComponentIncludingDisabled(v, "ItemComponent")
        local item_action = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")
        if item and item_action then
            EntityRemoveFromParent(v)
            EntityKill(v)
        end
    end
end

function get_wand_cost_and_level(tier_chances)
    SetRandomSeed(x, y)

    --tier_chances = [1,2,3,4,5,6,10] each number is the weight for that tier
    local sum = 0
    for i, v in ipairs(tier_chances) do
        sum = sum + v
    end

    local num = Random(1, sum)
    local count = 0
    local level = 0

    for i, v in ipairs(tier_chances) do
        if in_range(num, count, count + v) then
            level = i
            break
        else
            count = count + v
        end
    end

    if level == 7 then
        level = 11 --if level = 7, then you get a tier 10 wand which is level 11
    end

    --local costs = {30, 40, 60, 80, 100, 120, 0, 0, 0, 0, 200}
    local cost = 0

    if level == 1 then
        cost = 30
    elseif level == 2 then
        cost = 40
    elseif level == 3 then
        cost = 60
    elseif level == 4 then
        cost = 80
    elseif level == 5 then
        cost = 100
    elseif level == 6 then
        cost = 120
    elseif level == 11 then
        cost = 200
    end

    return cost, level
end

function set_gun_stats(wand_id, gun)
    --Feed the wand's entity id and the gun stats and this function will update the wand stats
    local ability_comp = EntityGetFirstComponentIncludingDisabled(wand_id, "AbilityComponent")

    ComponentObjectSetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty", num_to_bool(gun.shuffle_deck_when_empty)) --shuffle
    ComponentObjectSetValue2(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round) --spells per cast
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "fire_rate_wait", gun.fire_rate_wait) --cast delay
    ComponentObjectSetValue2(ability_comp, "gun_config", "reload_time", gun.reload_time) --recharge time
    ComponentSetValue2(ability_comp, "mana_max", gun.mana_max) --mana max
    ComponentSetValue2(ability_comp, "mana", gun.mana_max) -- current mana
    ComponentSetValue2(ability_comp, "mana_charge_speed", gun.mana_charge_speed) --mana charge speed
    ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", gun.deck_capacity) --capacity
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees) --spread
    ComponentObjectSetValue2(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier) --speed
end

function get_random_action_with_type_without_repeats(x, y, level, action_type, projectiles_to_avoid, modifiers_to_avoid)
    local spell = ""
    local cond = true
    local count = 0
    local max_count = 100

    if action_type == ACTION_TYPE_PROJECTILE then
        while cond and count < max_count do
            spell = GetRandomActionWithType(x + count, y - count, level, ACTION_TYPE_PROJECTILE, 0)

            --see if spell is in projectiles to avoid
            if #projectiles_to_avoid ~= 0 then
                for i, v in ipairs(projectiles_to_avoid) do
                    if spell == v then
                        cond = true
                        break
                    else
                        cond = false
                    end
                end

                if cond == true then
                    count = count + 1
                else
                    projectiles_to_avoid[#projectiles_to_avoid + 1] = spell
                end
            else
                cond = false
                projectiles_to_avoid[1] = spell
            end
        end

        if count == max_count then
            print("Purgatory: get_random_action_with_type_without_repeats: Projectile generated with overflow max iterations")
            projectiles_to_avoid = {} --clear spells to avoid list because we're going to hit repeats
        end
    elseif action_type == ACTION_TYPE_MODIFIER then
        while cond and count < max_count do
            spell = GetRandomActionWithType(x + count, y - count, level, ACTION_TYPE_MODIFIER, 0)

            --see if spell is in projectiles to avoid
            if #modifiers_to_avoid ~= 0 then
                for i, v in ipairs(modifiers_to_avoid) do
                    if spell == v then
                        cond = true
                        break
                    else
                        cond = false
                    end
                end

                if cond == true then
                    count = count + 1
                else
                    modifiers_to_avoid[#modifiers_to_avoid + 1] = spell
                end
            else
                cond = false
                modifiers_to_avoid[1] = spell
            end
        end

        if count == max_count then
            print("Purgatory: get_random_action_with_type_without_repeats: Modifier generated with overflow max iterations")
            modifiers_to_avoid = {} --clear spells to avoid list because we're going to hit repeats
        end
    else
        spell = GetRandomActionWithType(x, y, level, action_type, 0)
    end

    return spell
end

function generate_deck(x, y, wand_id, gun, level, projectiles_picked, modifiers_picked)
    local orig_x, orig_y, orig_level = x, y, level
    level = level - 1
    local deck = {}
    local deck_capacity = math.ceil(gun["deck_capacity"])
    local actions_per_round = gun["actions_per_round"]
    local shuffle = gun["shuffle_deck_when_empty"]

    if shuffle == 1 then
        --Wand is a shuffle wan
        local rand_cap_num = Random(1, 100)
        local cap_percent = 1

        if rand_cap_num <= 20 then
            cap_percent = 0.8
        elseif rand_cap_num <= 50 and rand_cap_num > 20 then
            cap_percent = 0.4
        else
            cap_percent = 0.6
        end

        local fill_capacity = math.ceil(cap_percent * deck_capacity)

        --fill all slots with random projectile spells
        for i = 1, fill_capacity, 1 do
            deck[i] = get_random_action_with_type_without_repeats(x + i, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
        end

        --chance to change first projectiles in deck to modifiers
        if deck_capacity >= 2 then
            local num = Random(1, 100)
            if num <= 80 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)

                if deck_capacity >= 3 then
                    local num = Random(1, 100)
                    if num <= 50 then
                        deck[2] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)

                        if deck_capacity >= 4 then
                            local num = Random(1, 100)
                            if num <= 35 then
                                deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                            end
                        end
                    end
                end
            end
        end
    else
        --Wand is a non shuffle wand
        local trig_time_rand_num = Random(1, 100)
        local trigger_type = "NONE"

        if trig_time_rand_num <= 20 then
            trigger_type = "TRIGGER"
        elseif trig_time_rand_num <= 50 and trig_time_rand_num > 20 then
            trigger_type = "TIMER"
        end

        local trigger_spell = ""
        if trigger_type == "TRIGGER" then
            local trigger_spell_list = {
                "LIGHT_BULLET_TRIGGER",
                "BULLET_TRIGGER",
                "HEAVY_BULLET_TRIGGER",
                "BUBBLESHOT_TRIGGER",
                "GRENADE_TRIGGER",
                "MINE_DEATH_TRIGGER"
            }

            trigger_spell = trigger_spell_list[Random(1, #trigger_spell_list)]
        elseif trigger_type == "TIMER" then
            local timer_spell_list = {
                "LIGHT_BULLET_TIMER",
                "BULLET_TIMER",
                "HEAVY_BULLET_TIMER",
                "SPITTER_TIMER",
                "SPITTER_TIER_2_TIMER",
                "SPITTER_TIER_3_TIMER",
                "BOUNCY_ORB_TIMER",
                "LASER_LUMINOUS_DRILL",
                "TENTACLE_TIMER"
            }

            trigger_spell = timer_spell_list[Random(1, #timer_spell_list)]
        end

        if trigger_type ~= "NONE" then
            --Build a trigger wand
            if deck_capacity == 1 then
                deck[1] = trigger_spell
            end

            if deck_capacity == 2 then
                deck[1] = trigger_spell
                deck[2] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
            end

            if deck_capacity == 3 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                deck[2] = trigger_spell
                deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
            end

            if deck_capacity == 4 then
                if Random(1, 2) == 1 then
                    deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                    deck[2] = trigger_spell
                    deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                    deck[4] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
                else
                    deck[1] = trigger_spell
                    if Random(1, 2) == 1 then
                        deck[2] = "BURST_2"
                    else
                        deck[2] = "SCATTER_2"
                    end
                    deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                    deck[4] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
                end
            end

            if deck_capacity >= 5 then
                local projectiles_to_add = math.min(deck_capacity - 4, 4)
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                deck[2] = trigger_spell
                if projectiles_to_add == 2 then
                    if Random(1, 2) == 1 then
                        deck[3] = "BURST_2"
                    else
                        deck[3] = "SCATTER_2"
                    end
                elseif projectiles_to_add == 3 then
                    if Random(1, 2) == 1 then
                        deck[3] = "BURST_3"
                    else
                        deck[3] = "SCATTER_3"
                    end
                else
                    if Random(1, 2) == 1 then
                        deck[3] = "BURST_4"
                    else
                        deck[3] = "SCATTER_4"
                    end
                end

                local projectile_spell_to_add = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
                for i = 1, projectiles_to_add, 1 do
                    deck[3 + i] = projectile_spell_to_add
                end
            end
        else
            --Build a non trigger wand
            if deck_capacity == 1 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
            end

            if deck_capacity == 2 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                deck[2] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
            end

            if deck_capacity == 3 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                deck[2] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
            end

            if deck_capacity == 4 then
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                if Random(1, 2) == 1 then
                    deck[2] = "BURST_2"
                else
                    deck[2] = "SCATTER_2"
                end
                deck[3] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
                deck[4] = deck[3]
            end

            if deck_capacity >= 5 then
                local projectiles_to_add = math.min(deck_capacity - 3, 4)
                deck[1] = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_MODIFIER, projectiles_picked, modifiers_picked)
                if projectiles_to_add == 2 then
                    if Random(1, 2) == 1 then
                        deck[2] = "BURST_2"
                    else
                        deck[2] = "SCATTER_2"
                    end
                elseif projectiles_to_add == 3 then
                    if Random(1, 2) == 1 then
                        deck[2] = "BURST_3"
                    else
                        deck[2] = "SCATTER_3"
                    end
                else
                    if Random(1, 2) == 1 then
                        deck[2] = "BURST_4"
                    else
                        deck[2] = "SCATTER_4"
                    end
                end

                local projectile_spell_to_add = get_random_action_with_type_without_repeats(x, y, level, ACTION_TYPE_PROJECTILE, projectiles_picked, modifiers_picked)
                for i = 1, projectiles_to_add, 1 do
                    deck[2 + i] = projectile_spell_to_add
                end
            end
        end
    end

    return deck, projectiles_picked, modifiers_picked
end

function put_deck_on_wand(wand_id, deck, gun)
    local deck_capacity = math.ceil(gun["deck_capacity"])

    wandClearActions(wand_id)

    if deck ~= nil or #deck == 0 then
        for i, spell in ipairs(deck) do
            if i <= deck_capacity then
                AddGunAction(wand_id, spell)
            else
                break
            end
        end
    end
end

function initialize_starting_wands(player_entity)
    --Get World Seed for seeding Randomness
    local x, y = EntityGetTransform(player_entity)
    SetRandomSeed(x, y)

    --Used to Force one starting wand to be a non-shuffle
    local unshufflers = {false, false, false, false}
    unshufflers[Random(1, 4)] = true

    --Get Wand IDs
    local blue_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_blue")[1]
    local red_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_red")[1]
    local yellow_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_yellow")[1]
    local green_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_green")[1]

    --Get Tier to Gen
    local blue_cost, blue_level = get_wand_cost_and_level({500, 300, 100, 70, 20, 9, 1})
    local red_cost, red_level = get_wand_cost_and_level({200, 500, 200, 70, 20, 9, 1})
    local yellow_cost, yellow_level = get_wand_cost_and_level({100, 100, 600, 170, 20, 9, 1})
    local green_cost, green_level = get_wand_cost_and_level({50, 50, 400, 400, 50, 49, 1})

    --Generate gun data
    local gun_blue = get_gun_data(blue_cost, blue_level, unshufflers[1])
    local gun_red = get_gun_data(red_cost, red_level, unshufflers[2])
    local gun_yellow = get_gun_data(yellow_cost, yellow_level, unshufflers[3])
    local gun_green = get_gun_data(green_cost, green_level, unshufflers[4])

    --Set gun stats
    set_gun_stats(blue_wand_id, gun_blue)
    set_gun_stats(red_wand_id, gun_red)
    set_gun_stats(yellow_wand_id, gun_yellow)
    set_gun_stats(green_wand_id, gun_green)

    --Generate decks
    local projectiles_picked = {}
    local modifiers_picked = {}
    local blue_deck, red_deck, yellow_deck, green_deck

    blue_deck, projectiles_picked, modifiers_picked = generate_deck(x, y, blue_wand_id, gun_blue, blue_level, projectiles_picked, modifiers_picked)
    red_deck, projectiles_picked, modifiers_picked = generate_deck(x, y, red_wand_id, gun_red, red_level, projectiles_picked, modifiers_picked)
    yellow_deck, projectiles_picked, modifiers_picked = generate_deck(x, y, yellow_wand_id, gun_yellow, yellow_level, projectiles_picked, modifiers_picked)
    green_deck, projectiles_picked, modifiers_picked = generate_deck(x, y, green_wand_id, gun_green, green_level, projectiles_picked, modifiers_picked)

    --Bandaid fix for now
    if #blue_deck > gun_blue.deck_capacity then
        gun_blue.deck_capacity = #blue_deck
        set_gun_stats(blue_wand_id, gun_blue)
    end

    if #red_deck > gun_red.deck_capacity then
        gun_red.deck_capacity = #red_deck
        set_gun_stats(red_wand_id, gun_red)
    end

    if #yellow_deck > gun_yellow.deck_capacity then
        gun_yellow.deck_capacity = #yellow_deck
        set_gun_stats(yellow_wand_id, gun_yellow)
    end

    if #green_deck > gun_green.deck_capacity then
        gun_green.deck_capacity = #green_deck
        set_gun_stats(green_wand_id, gun_green)
    end


    --Put decks on wands
    put_deck_on_wand(blue_wand_id, blue_deck, gun_blue)
    put_deck_on_wand(red_wand_id, red_deck, gun_red)
    put_deck_on_wand(yellow_wand_id, yellow_deck, gun_yellow)
    put_deck_on_wand(green_wand_id, green_deck, gun_green)
end
