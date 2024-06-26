dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("mods/purgatory/files/scripts/gun/gun_types.lua")

--[[
    generate_gun_stats(level, mana_type, force_unshuffle)
    Inputs:
    level: 1, 2, 3, 4, 5, 6, or 10
    mana_type = "NORMAL", "FLIPPED", or "HIGH-LOW"
    force_unshuffle = false, or true
    Outputs:
    gun object
]]
--[[
    Gun Stats Generated by this algorithm:
    Shuffle:        0, 1
    Spells/Cast:    1 unless otherwise changed by spell_generation_custom.lua
    Cast Delay:     10 + so many to max of 30
    Recharge Time:  50 - so many to min of 30
    Mana Max:       varies on tier - see gun_types.lua
    Mana Recharge:  varies on tier - see gun_types.lua
    Capacity:       varies on tier - see gun_types.lua
    Spread:         0 +/- 5
    Speed:          1 +/- 0.14

    IF WAND IS SHUFFLE
    Cast Delay: - Random(10,20)
    Recharge Time: - Random(15,25)
    Mana Max: + Random(25,50)
    Mana Recharge: + Random(25, 50)
    Capacity: + Random(1,3)
]]
function generate_gun_stats(level, mana_type, force_unshuffle, x, y)
    local gun = {}
    gun.shuffle_deck_when_empty = 0 --shuffle
    gun.actions_per_round = 1 --spells/cast
    gun.fire_rate_wait = 10 --cast delay
    gun.reload_time = 50 --recharge time
    gun.mana_max = {} --mana max
    gun.mana_charge_speed = {} --mana charge speed
    gun.deck_capacity = 0 --capacity
    gun.spread_degrees = 0 --spread
    gun.speed_multiplier = 1 --speed

    local capacity_varience = 0
    local mana_options = {}
    local shuffle_chance = 0.00
    local num = 0

    --Set Randomness Values
    SetRandomSeed(x, y)

    --Get gun values from table in gun_types.lua
    for i, v in ipairs(tiers) do
        if v.tier == level then
            mana_options = v.mana_options
            gun.deck_capacity = v.capacity
            capacity_varience = v.cap_var
            shuffle_chance = v.shuffle
            break
        end
    end

    for i, v in ipairs(mana_options) do
        if v.mana_type == mana_type then
            gun.mana_max = v.mana_max
            gun.mana_charge_speed = v.mana_recharge
        end
    end

    --Set Shuffle
    if not force_unshuffle then
        num = Random(1, 100)
        if in_range(num, 0, shuffle_chance) then
            gun.shuffle_deck_when_empty = 1 --shuffle
        end
    end

    --Set Spells/Cast
    --Spells/Cast is always 1

    --Set Cast Delay
    gun.fire_rate_wait = 10 + Random(0, 20)

    --Set Recharge Time
    gun.reload_time = 50 - Random(0, 20)

    --Set Mana Max and Recharge values from within ranges given
    gun.mana_max = getRandomWithinRange(gun.mana_max)
    gun.mana_charge_speed = getRandomWithinRange(gun.mana_charge_speed)

    --Set Capacity from ranges given
    num = Random(1, 10000)
    local min_check_value = 0
    local max_check_value = 0

    for i = gun.deck_capacity - capacity_varience, gun.deck_capacity + capacity_varience, 1 do
        min_check_value = max_check_value --increase the min check value to max of previous iteration
        max_check_value = 10000 * ((-2 * i + 2 * capacity_varience + 2 * gun.deck_capacity + 1) / (2 * capacity_varience + 1) ^ 2) --Probability Density Function for if P(x=c) = 1/(2v+1) and P(x=c+v) = 1/(2v+1)^2

        if in_range(num, min_check_value, max_check_value) then
            gun.deck_capacity = i
            break
        end
        --Note Priskip: This probability density function decreases linearly so chances are this for loop will not have to recur too many times
    end

    --Set Spread
    gun.spread_degrees = 0 + Random(-5, 5)

    --Set Speed
    gun.speed_multiplier = 1 + Random(-15, 15) / 100

    --Add bonuses for shuffle wands
    if gun.shuffle_deck_when_empty == 1 then
        gun.fire_rate_wait = gun.fire_rate_wait - Random(10, 20)
        gun.reload_time = gun.reload_time - Random(15, 25)
        gun.mana_max = gun.mana_max + Random(25, 50)
        gun.mana_charge_speed = gun.mana_charge_speed + Random(25, 50)
        gun.deck_capacity = gun.deck_capacity + Random(1, 3)
    end

    return gun
end
