dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/perks/perk.lua")
dofile_once("data/scripts/perks/perk_list.lua")

--Needed for purgatory_spawn_temple_perks
--It was a local function inside perk.lua
local get_perk_flag_name = function(perk_id)
    return "PERK_" .. perk_id
end

function round_up_to_even_num(num)
    if num % 2 == 0 then
        return num
    else
        return num + 1
    end
end

--Spawns the perks inside holy mountains
--This will make it so perks organize themselves into nice rows
--Called from mods/purgatory/data/scripts/biomes/temple_altar.lua
function purgatory_spawn_temple_perks(x, y, dont_remove_others_, ignore_these_)
    local perk_count = tonumber(GlobalsGetValue("TEMPLE_PERK_COUNT", "3"))

    local perks_per_row = 7
    local rows = math.floor(perk_count / perks_per_row) + 1
    local count = perk_count % perks_per_row
    local width = 60
    local item_width = 16
    local amount_of_perks_to_spawn_in_row = count

    local ignore_these = ignore_these_ or {}
    local dont_remove_others = dont_remove_others_ or false
    local perks = perk_get_spawn_order(ignore_these)

    for row = 1, rows do
        if row ~= rows then
            amount_of_perks_to_spawn_in_row = perks_per_row
        else
            amount_of_perks_to_spawn_in_row = count
        end

        for i = 1, amount_of_perks_to_spawn_in_row do
            --stuff that Nolla does to keep the perks in order
            local next_perk_index = tonumber(GlobalsGetValue("TEMPLE_NEXT_PERK_INDEX", "1"))
            local perk_id = perks[next_perk_index]

            while (perk_id == nil or perk_id == "") do
                -- if we over flow
                perks[next_perk_index] = "LEGGY_FEET"
                next_perk_index = next_perk_index + 1
                if next_perk_index > #perks then
                    next_perk_index = 1
                end
                perk_id = perks[next_perk_index]
            end

            next_perk_index = next_perk_index + 1
            if next_perk_index > #perks then
                next_perk_index = 1
            end
            GlobalsSetValue("TEMPLE_NEXT_PERK_INDEX", tostring(next_perk_index))
            GameAddFlagRun(get_perk_flag_name(perk_id))

            --me spawning the perks in pretty positions
            local x_offset = item_width * (round_up_to_even_num(amount_of_perks_to_spawn_in_row) / 2)

            if amount_of_perks_to_spawn_in_row % 2 == 0 then
                x_offset = x_offset + (round_up_to_even_num(item_width) / 2)
            end

            local perk_spawn_x = x + i * item_width - x_offset
            local perk_spawn_y = y - 15 * (row - 1)

            perk_spawn(perk_spawn_x, perk_spawn_y, perk_id, dont_remove_others)

            --original from perk_spawn_many()
            --perk_spawn( x + (i-0.5)*item_width, y, perk_id, dont_remove_others )
        end
    end
end
