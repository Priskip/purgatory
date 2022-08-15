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
	Wand of Swiftness
	Shuffle				No
	Spells/Cast			1
	Cast Delay			-1.0 +/- 5/60
	Recharge Time		-.75 +/- 5/60
	Mana Max			1250 +/- 250
	Mana Charge Speed	1750 +/- 250
	Capicity			20 +/- 2
	Spread				0
	Speed				1.25
]]
local ability_comp = EntityGetFirstComponent(entity_id, "AbilityComponent")

local gun = {}
gun.name = {"Fast wand"} --Name
gun.shuffle_deck_when_empty = 0 --Shuffle
gun.actions_per_round = 1 --Spells/Cast
gun.fire_rate_wait = {-65, -55} --Cast Delay
gun.reload_time = {-50, -40} --Recharge Time
gun.mana_max = {1000, 1500} --Mana Max
gun.mana_charge_speed = {1500, 2000} --Mana Charge Speed
gun.deck_capacity = {18, 22} --Capacity
gun.spread_degrees = 0 --Spread
gun.speed_multiplier = 1.75 --Speed
gun.actions = {"LASER", "HEAVY_BULLET", "SLOW_BULLET", "ROCKET", "LANCE"}

local mana_max = get_random_between_range(gun.mana_max) --mana and mana max have to have the same value

ComponentSetValue(ability_comp, "ui_name", get_random_from(gun.name))
ComponentObjectSetValue(ability_comp, "gun_config", "shuffle_deck_when_empty", gun.shuffle_deck_when_empty)
ComponentObjectSetValue(ability_comp, "gun_config", "actions_per_round", gun.actions_per_round)
ComponentObjectSetValue(ability_comp, "gunaction_config", "fire_rate_wait", get_random_between_range(gun.fire_rate_wait))
ComponentObjectSetValue(ability_comp, "gun_config", "reload_time", get_random_between_range(gun.reload_time))
ComponentSetValue(ability_comp, "mana_max", mana_max)
ComponentSetValue(ability_comp, "mana", mana_max)
ComponentSetValue(ability_comp, "mana_charge_speed", get_random_between_range(gun.mana_charge_speed))
ComponentObjectSetValue(ability_comp, "gun_config", "deck_capacity", get_random_between_range(gun.deck_capacity))
ComponentObjectSetValue(ability_comp, "gunaction_config", "spread_degrees", gun.spread_degrees)
ComponentObjectSetValue(ability_comp, "gunaction_config", "speed_multiplier", gun.speed_multiplier)

local action_count = 1
local gun_action = get_random_from(gun.actions)

for i = 1, action_count do
	--AddGunActionPermanent( entity_id, gun_action )
	AddGunAction(entity_id, gun_action)
end

local item_comp = EntityGetFirstComponent(entity_id, "ItemComponent")
ComponentSetValue2(item_comp, "item_name", "$item_wand_good_1")
ComponentSetValue2(item_comp, "always_use_item_name_in_ui", true)
