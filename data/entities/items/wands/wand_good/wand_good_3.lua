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

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(x, y + GameGetFrameNum())

--[[
	Wand of Multitudes
	Shuffle				No
	Spells/Cast			30
	Cast Delay			0.25 +/- 5/60
	Recharge Time		0.75 +/-5/60
	Mana Max			2750 +/- 250
	Mana Charge Speed	1000 +/- 250
	Capicity			30
	Spread				0
	Speed				1
]]
local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

local gun = {}
gun.name = {"Scattershot wand"}
gun.shuffle_deck_when_empty = 0
gun.actions_per_round = 30
gun.fire_rate_wait = {5, 20}
gun.reload_time = {40, 50}
gun.mana_max = {2500, 3000}
gun.mana_charge_speed = {750, 1250}
gun.deck_capacity = 30
gun.spread_degrees = 0
gun.speed_multiplier = 1.0
gun.actions = {"GRENADE_TIER_3", "ROCKET_TIER_3", "METEOR", "HEAVY_BULLET", "DISC_BULLET"}

local mana_max = get_random_between_range(gun.mana_max)

ComponentSetValue(ability_comp, "ui_name", get_random_from(gun.name))

ComponentObjectSetValue(ability_comp, "gun_config", "shuffle_deck_when_empty", gun.shuffle_deck_when_empty)
ComponentObjectSetValue(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round)
ComponentObjectSetValue(ability_comp, "gunaction_config", "fire_rate_wait", get_random_between_range(gun.fire_rate_wait))
ComponentObjectSetValue(ability_comp, "gun_config", "reload_time", get_random_between_range(gun.reload_time))
ComponentSetValue(ability_comp, "mana_max", mana_max)
ComponentSetValue(ability_comp, "mana", mana_max)
ComponentSetValue(ability_comp, "mana_charge_speed", get_random_between_range(gun.mana_charge_speed))
ComponentObjectSetValue(ability_comp, "gun_config", "deck_capacity", gun.deck_capacity)
ComponentObjectSetValue(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees)
ComponentObjectSetValue(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier)

local action_count = 10
local gun_action = get_random_from(gun.actions)

for i = 1, action_count do
	--AddGunActionPermanent( entity_id, gun_action )
	AddGunAction(entity_id, gun_action)
end

local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
ComponentSetValue2(item_comp, "item_name", "$item_wand_good_3")
ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)
