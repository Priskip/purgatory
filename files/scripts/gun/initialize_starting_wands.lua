dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/gun/gun_generation_custom.lua")
dofile_once("mods/purgatory/files/scripts/gun/deck_generator.lua")

function num_to_bool(num)
    if num == 0 then
        return false
    elseif num == 1 then
        return true
    end
    return false
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

function get_wand_tier(tier_chances)
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
        level = 11 --if level = 7, then you get a tier 10
    end

    return level
end

function get_wand_mana_type(chance_for_flipped)
    --Not going to allow HIGH-LOW wands to spawn at the start because they suck
    --chance_for_flipped should be a number between 1 and 100 (aka a percent)
    local num = Random(1, 100)
    local mana_type = "NORMAL"
    if num <= chance_for_flipped then
        mana_type = "FLIPPED"
    end

    return mana_type
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
    SetRandomSeed(x + GameGetFrameNum(), y)

    --Get Wand IDs
    local blue_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_blue")[1]
    local red_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_red")[1]
    local yellow_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_yellow")[1]
    local green_wand_id = EntityGetInRadiusWithTag(x, y, 24, "starting_wand_green")[1]

    --Used to Force one starting wand to be a non-shuffle
    local unshufflers = {false, false, false, false}
    unshufflers[Random(1, 4)] = true

    --Get Tier to Gen
    SetRandomSeed(x, y + 5)
    local blue_tier = get_wand_tier({500, 300, 100, 70, 24, 5, 1})
    SetRandomSeed(x, y + 10)
    local red_tier = get_wand_tier({200, 500, 200, 70, 24, 5, 1})
    SetRandomSeed(x, y + 15)
    local yellow_tier = get_wand_tier({100, 100, 600, 170, 20, 9, 1})
    SetRandomSeed(x, y + 20)
    local green_tier = get_wand_tier({50, 50, 400, 400, 74, 25, 1})

    --Get Wand Mana Types
    SetRandomSeed(x, y + 25)
    local blue_mana_type = get_wand_mana_type(5)
    SetRandomSeed(x, y + 30)
    local red_mana_type = get_wand_mana_type(10)
    SetRandomSeed(x, y + 35)
    local yellow_mana_type = get_wand_mana_type(15)
    SetRandomSeed(x, y + 40)
    local green_mana_type = get_wand_mana_type(20)

    --Gen Gun Stats
    local gun_blue = generate_gun_stats(blue_tier, blue_mana_type, unshufflers[1], x, y)
    local gun_red = generate_gun_stats(red_tier, red_mana_type, unshufflers[2], x, y + 5)
    local gun_yellow = generate_gun_stats(yellow_tier, yellow_mana_type, unshufflers[3], x, y + 10)
    local gun_green = generate_gun_stats(green_tier, green_mana_type, unshufflers[4], x, y + 15)

    --Set Gun Stats
    set_gun_stats(blue_wand_id, gun_blue)
    set_gun_stats(red_wand_id, gun_red)
    set_gun_stats(yellow_wand_id, gun_yellow)
    set_gun_stats(green_wand_id, gun_green)

    --Generate list of trigger spells from actions in gun_actions.lua
    --This is done this way so if other modders use "TRIGGER", "TIMER", and "DEATH_TRIGGER" in their
    --  spell's id, then it will be added to purgatory's starting wand algorithm
    local trigger_spells = get_trigger_spells()

    --Generate gun decks
    local black_listed_projectiles = {}
    local black_listed_modifiers = {}
    local blue_deck, red_deck, yellow_deck, green_deck = {}, {}, {}, {}

    blue_deck, black_listed_projectiles, black_listed_modifiers =
        generate_deck(blue_tier, gun_blue.shuffle_deck_when_empty, math.floor(gun_blue.deck_capacity * 0.75), black_listed_projectiles, black_listed_modifiers, trigger_spells, x + 5, y + 5, "blue")
    red_deck, black_listed_projectiles, black_listed_modifiers =
        generate_deck(red_tier, gun_red.shuffle_deck_when_empty, math.floor(gun_red.deck_capacity * 0.75), black_listed_projectiles, black_listed_modifiers, trigger_spells, x + 10, y + 10, "red")
    yellow_deck, black_listed_projectiles, black_listed_modifiers =
        generate_deck(yellow_tier, gun_yellow.shuffle_deck_when_empty, math.floor(gun_yellow.deck_capacity * 0.75), black_listed_projectiles, black_listed_modifiers, trigger_spells, x + 15, y + 15, "yellow")
    green_deck, black_listed_projectiles, black_listed_modifiers =
        generate_deck(green_tier, gun_green.shuffle_deck_when_empty, math.floor(gun_green.deck_capacity * 0.75), black_listed_projectiles, black_listed_modifiers, trigger_spells, x + 20, y + 20, "green")

    --Place decks on guns
    put_deck_on_wand(blue_wand_id, blue_deck, gun_blue)
    put_deck_on_wand(red_wand_id, red_deck, gun_red)
    put_deck_on_wand(yellow_wand_id, yellow_deck, gun_yellow)
    put_deck_on_wand(green_wand_id, green_deck, gun_green)
end
