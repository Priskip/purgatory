dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--Start
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player_id = getPlayerEntity()
local is_holding_wands = true
SetRandomSeed(x, y + GameGetFrameNum())

--Get Wand Player is Holding
local player_wand = get_held_wand_id()

if player_wand == -1 then
    --GamePrint("Player is not holding a wand")

    local all_wands_held = find_all_wands_held(player_id)
    if #all_wands_held ~= 0 then
        --GamePrint("Selected wand number " .. tostring(num))
        is_holding_wands = true

        --GamePrint("Player has " .. tostring(#all_wands_held) .. " wands in their inventory. Selecting one at random.")
        local num = Random(1, #all_wands_held)
        player_wand = all_wands_held[num]
    else
        is_holding_wands = false
    end
end

if is_holding_wands then
    --Get player's wand's stats
    local player_wand_ability_comp = EntityGetFirstComponentIncludingDisabled(player_wand, "AbilityComponent")

    local player_gun = {}
    player_gun.name = ComponentGetValue2(player_wand_ability_comp, "ui_name") --name
    player_gun.shuffle_deck_when_empty = ComponentObjectGetValue2(player_wand_ability_comp, "gun_config", "shuffle_deck_when_empty") --shuffle
    player_gun.actions_per_round = ComponentObjectGetValue2(player_wand_ability_comp, "gun_config", "actions_per_round") --spells/cast
    player_gun.fire_rate_wait = ComponentObjectGetValue2(player_wand_ability_comp, "gunaction_config", "fire_rate_wait") --cast delay
    player_gun.reload_time = ComponentObjectGetValue2(player_wand_ability_comp, "gun_config", "reload_time") --recharge time
    player_gun.mana_max = ComponentGetValue2(player_wand_ability_comp, "mana_max") --mana max
    player_gun.mana_charge_speed = ComponentGetValue2(player_wand_ability_comp, "mana_charge_speed") --mana charge speed
    player_gun.deck_capacity = ComponentObjectGetValue2(player_wand_ability_comp, "gun_config", "deck_capacity") --capacity
    player_gun.spread_degrees = ComponentObjectGetValue2(player_wand_ability_comp, "gunaction_config", "spread_degrees") --spread
    player_gun.speed_multiplier = ComponentObjectGetValue2(player_wand_ability_comp, "gunaction_config", "speed_multiplier") --speed

    --Set mimic wand stats
    local mimic_wand_ability_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "AbilityComponent")

    ComponentSetValue2(mimic_wand_ability_comp, "ui_name", player_gun.name) --name
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gun_config", "shuffle_deck_when_empty", player_gun.shuffle_deck_when_empty) --shuffle
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gun_config", "actions_per_round", player_gun.actions_per_round) --spells/cast
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gunaction_config", "fire_rate_wait", player_gun.fire_rate_wait) --cast delay
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gun_config", "reload_time", player_gun.reload_time) --recharge time
    ComponentSetValue2(mimic_wand_ability_comp, "mana_max", player_gun.mana_max) --mana max
    ComponentSetValue2(mimic_wand_ability_comp, "mana", player_gun.mana_max) --current mana
    ComponentSetValue2(mimic_wand_ability_comp, "mana_charge_speed", player_gun.mana_charge_speed) --mana charge speed
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gun_config", "deck_capacity", player_gun.deck_capacity) --capacity
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gunaction_config", "spread_degrees", player_gun.spread_degrees) --spread
    ComponentObjectSetValue2(mimic_wand_ability_comp, "gunaction_config", "speed_multiplier", player_gun.speed_multiplier) --speed

    --Get player wand sprite comp
    local player_wand_sprite_comp = EntityGetFirstComponentIncludingDisabled(player_wand, "SpriteComponent") --Get SpriteComponent
    local image_file = ComponentGetValue2(player_wand_sprite_comp, "image_file")
    local sprite_file = ComponentGetValue2(player_wand_ability_comp, "sprite_file")

    --Set mimic Wand Sprite
    local mimic_wand_sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent") --Get SpriteComponent
    ComponentSetValue2(mimic_wand_sprite_comp, "image_file", image_file)
    ComponentSetValue2(mimic_wand_ability_comp, "sprite_file", sprite_file)

    --Get player wand hotspot
    local player_wand_hotspot_comp = EntityGetFirstComponentIncludingDisabled(player_wand, "HotspotComponent") --Get HotspotComponent
    local hotspot_x, hot_spot_y = ComponentGetValue2(player_wand_hotspot_comp, "offset")

    --Set mimic wand hotspot
    local mimic_wand_hotspot_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "HotspotComponent") --Get HotspotComponent
    ComponentSetValueVector2(mimic_wand_hotspot_comp, "offset", hotspot_x, hot_spot_y)

    --Get player wands spells
    local wand_deck = {}
    local always_casts_deck = {}
    local wand_deck_children = EntityGetAllChildren(player_wand)

    for i, v in ipairs(wand_deck_children) do
        local item_comp = EntityGetFirstComponentIncludingDisabled(v, "ItemComponent")
        local item_action_comp = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")
        local action_id = ComponentGetValue2(item_action_comp, "action_id")
        local is_always_cast = ComponentGetValue2(item_comp, "permanently_attached")
        if is_always_cast then
            always_casts_deck[#always_casts_deck + 1] = action_id
        else
            --is normal spell
            wand_deck[#wand_deck + 1] = action_id
        end
    end

    --Set spells on the mimic wand
    if #always_casts_deck == 0 then
        --Set spells as normal
        for i, spell in ipairs(wand_deck) do
            AddGunAction(entity_id, spell)
        end
    else
        --Set the always casts on the wand first
        for i, ac_spell in ipairs(always_casts_deck) do
            AddGunActionPermanent(entity_id, ac_spell)
        end

        --Set rest of spells
        for i, spell in ipairs(wand_deck) do
            AddGunAction(entity_id, spell)
        end

        --Reset size on wand since AC's add a hidden capacity slot
        ComponentObjectSetValue2(mimic_wand_ability_comp, "gun_config", "deck_capacity", player_gun.deck_capacity) --capacity
    end
end
