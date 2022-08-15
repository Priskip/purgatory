dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")
dofile_once("mods/purgatory/files/scripts/perks/starting_perk_pools.lua")
dofile_once("mods/purgatory/files/scripts/perks/spawn_purgatory_starting_perk.lua")

--Get Entity Location
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

function get_random_from(target)
    local rnd = Random(1, #target)

    return tostring(target[rnd])
end

function get_random_from_with_num(target)
    local rnd = Random(1, #target)

    return tostring(target[rnd]), rnd
end

function spawn_immunity_perks()
    local reroll_count = 0
    local are_same = true
    local immunity_perk_1
    local immunity_perk_2
    local num_1
    local num_2

    while are_same == true do
        SetRandomSeed(x, y + reroll_count)
        immunity_perk_1, num_1 = get_random_from_with_num(immunity_perks_with_side_effects)
        immunity_perk_2, num_2 = get_random_from_with_num(immunity_perks)

        if num_1 ~= num_2 then
            are_same = false
        else
            are_same = true
            reroll_count = reroll_count + 1
        end
    end

    --GamePrint("Immunity Perks reroll count: "..tostring(reroll_count))

    spawn_purgatory_starting_perk(x, y, immunity_perk_1, true, "START_PERK_IMMUNITY")
    spawn_purgatory_starting_perk(x + 16, y, immunity_perk_2, true, "START_PERK_IMMUNITY")
end

function spawn_good_perks()
    local reroll_count = 0
    local are_same = true
    local good_perk_1
    local good_perk_2

    while are_same == true do
        SetRandomSeed(x, y + reroll_count)
        good_perk_1 = get_random_from(good_perks)
        good_perk_2 = get_random_from(good_perks)
        good_perk_3 = get_random_from(good_perks)

        if good_perk_1 ~= good_perk_2 and good_perk_2 ~= good_perk_3 and good_perk_1 ~= good_perk_3 then
            are_same = false
        else
            are_same = true
            reroll_count = reroll_count + 1
        end
    end

    --GamePrint("Good Perks reroll count: "..tostring(reroll_count))

    spawn_purgatory_starting_perk(x + 58, y, good_perk_1, true, "START_PERK_GOOD")
    spawn_purgatory_starting_perk(x + 74, y, good_perk_2, true, "START_PERK_GOOD")
    spawn_purgatory_starting_perk(x + 90, y, good_perk_3, true, "START_PERK_GOOD")
end

function spawn_meh_perks()
    local reroll_count = 0
    local are_same = true
    local meh_perk_1
    local meh_perk_2
    local meh_perk_3

    while are_same == true do
        SetRandomSeed(x, y + reroll_count)
        meh_perk_1 = get_random_from(meh_perks)
        meh_perk_2 = get_random_from(meh_perks)
        meh_perk_3 = get_random_from(meh_perks)
        meh_perk_4 = get_random_from(meh_perks)

        if meh_perk_1 ~= meh_perk_2 and meh_perk_1 ~= meh_perk_3 and meh_perk_1 ~= meh_perk_4 and meh_perk_2 ~= meh_perk_3 and meh_perk_2 ~= meh_perk_4 and meh_perk_3 ~= meh_perk_4 then
            are_same = false
        else
            are_same = true
            reroll_count = reroll_count + 1
        end
    end

    --GamePrint("Meh Perks reroll count: "..tostring(reroll_count))

    spawn_purgatory_starting_perk(x + 132, y, meh_perk_1, true, "START_PERK_MEH")
    spawn_purgatory_starting_perk(x + 148, y, meh_perk_2, true, "START_PERK_MEH")
    spawn_purgatory_starting_perk(x + 164, y, meh_perk_3, true, "START_PERK_MEH")
    spawn_purgatory_starting_perk(x + 180, y, meh_perk_4, true, "START_PERK_MEH")
end

--Spawn the perks!
spawn_immunity_perks()
spawn_good_perks()
spawn_meh_perks()

--Kill this entity
EntityKill(entity_id)
