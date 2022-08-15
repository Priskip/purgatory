dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")

function get_random_from(target)
    local rnd = Random(1, #target)

    return tostring(target[rnd])
end

function get_multiple_random_from(target, amount_)
    local amount = amount_ or 1

    local result = {}

    for i = 1, amount do
        local rnd = Random(1, #target)

        table.insert(result, tostring(target[rnd]))
    end

    return result
end

function get_random_between_range(target)
    local minval = target[1]
    local maxval = target[2]

    return Random(minval, maxval)
end

--Start
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x, y + GameGetFrameNum())

--Get Component
local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

--Gen Gun Stats
local gun = {}
gun.name = "Pit Boss Wand"                                               --name
gun.shuffle_deck_when_empty = false                                      --shuffle
gun.actions_per_round = 1                                                --spells/cast
gun.fire_rate_wait = get_random_between_range({0, 15})                   --cast delay
gun.reload_time = gun.fire_rate_wait + get_random_between_range({0, 15}) --recharge time
gun.mana_max = get_random_between_range({1000, 1500})                    --mana max
gun.mana_charge_speed = get_random_between_range({500, 750})             --mana charge speed
gun.deck_capacity = get_random_between_range({20, 25})                   --capacity
gun.spread_degrees = get_random_between_range({-5, 5})                   --spread
gun.speed_multiplier = 1.0                                               --speed

gun.actions = {"ENLIGHTENED_LASER_DARKBEAM"}

--Set Gun Stats
ComponentSetValue2(ability_comp, "ui_name", gun.name)                                                        --name
ComponentObjectSetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty", gun.shuffle_deck_when_empty) --shuffle
ComponentObjectSetValue2(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round)             --spells/cast
ComponentObjectSetValue2(ability_comp, "gunaction_config", "fire_rate_wait", gun.fire_rate_wait)             --cast delay
ComponentObjectSetValue2(ability_comp, "gun_config", "reload_time", gun.reload_time)                         --recharge time
ComponentSetValue2(ability_comp, "mana_max", gun.mana_max)                                                   --mana max
ComponentSetValue2(ability_comp, "mana", gun.mana_max)                                                       --current mana
ComponentSetValue2(ability_comp, "mana_charge_speed", gun.mana_charge_speed)                                 --mana charge speed
ComponentObjectSetValue2(ability_comp, "gun_config", "deck_capacity", gun.deck_capacity)                     --capacity
ComponentObjectSetValue2(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees)             --spread
ComponentObjectSetValue2(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier)         --speed

--Set Gun Spells
local has_flag = HasFlagPersistent("miniboss_pit")

if has_flag then
    for i, spell in ipairs(gun.actions) do
        AddGunAction(entity_id, spell)
    end
end

--Custom Name
--local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
--ComponentSetValue2(item_comp, "item_name", "$item_wand_good_3")
--ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)

--Set Wand Sprite and shooting offset
local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")
local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent") --Get SpriteComponent
ComponentSetValue2(sprite_comp, "image_file", "mods/purgatory/files/entities/animals/boss_pit/trapped_wand_sprite.xml")
ComponentSetValue2(ability_comp, "sprite_file", "mods/purgatory/files/entities/animals/boss_pit/trapped_wand_sprite.xml")

local hotspot_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HotspotComponent") --Get HotspotComponent
ComponentSetValueVector2(hotspot_comp, "offset", 16, .6)
