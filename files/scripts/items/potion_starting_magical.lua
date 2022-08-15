dofile_once("data/scripts/lib/utilities.lua")

function get_random_between_range(target)
    local minval = target[1]
    local maxval = target[2]

    return Random(minval, maxval)
end

function in_range(num, lower_bound, upper_bound)
    if lower_bound <= num and num <= upper_bound then
        return true
    else
        return false
    end
end

function init_potion_with_amount(entity_id, potion_material, amount_in_potion)
    local x, y = EntityGetTransform(entity_id)
    SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed

    -- load the material from VariableStorageComponent
    local components = EntityGetComponent(entity_id, "VariableStorageComponent")

    if (components ~= nil) then
        for key, comp_id in pairs(components) do
            local var_name = ComponentGetValue(comp_id, "name")
            if (var_name == "potion_material") then
                potion_material = ComponentGetValue(comp_id, "value_string")
            end
        end
    end

    local total_capacity = tonumber(GlobalsGetValue("EXTRA_POTION_CAPACITY_LEVEL", "1000")) or 1000
    if (total_capacity > 1000) then
        local comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")

        if (comp ~= nil) then
            ComponentSetValue(comp, "barrel_size", total_capacity)
        end

        EntityAddTag(entity_id, "extra_potion_capacity")
    end

    AddMaterialInventoryMaterial(entity_id, potion_material, amount_in_potion)
end

function get_potion_material()
    SetRandomSeed(x, y)
    local num = Random(1, 51)
    local potion_mat = "water"

    if in_range(num, 1, 5) then
        potion_mat = "magic_liquid_polymorph"
    elseif in_range(num, 6, 10) then
        potion_mat = "magic_liquid_random_polymorph"
    elseif in_range(num, 11, 15) then
        potion_mat = "magic_liquid_berserk"
    elseif in_range(num, 16, 20) then
        potion_mat = "magic_liquid_charm"
    elseif in_range(num, 21, 25) then
        potion_mat = "magic_liquid_movement_faster"
    elseif in_range(num, 26, 30) then
        potion_mat = "magic_liquid_faster_levitation"
    elseif in_range(num, 31, 35) then
        potion_mat = "magic_liquid_protection_all"
    elseif in_range(num, 36, 40) then
        potion_mat = "magic_liquid_mana_regeneration"
    elseif in_range(num, 41, 45) then
        potion_mat = "magic_liquid_invisibility"
    elseif in_range(num, 46, 50) then
        potion_mat = "magic_liquid_faster_levitation_and_movement"
    elseif in_range(num, 51, 51) then
        potion_mat = "magic_liquid_hp_regeneration"
    end

    return potion_mat
end

function init(entity_id)
    local x, y = EntityGetTransform(entity_id)
    SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed
    local potion_material = get_potion_material()

    --Holiday starting potion
    local year, month, day = GameGetDateAndTimeLocal()
    if (((month == 5) and (day == 1)) or ((month == 4) and (day == 30))) and (Random(0, 100) <= 20) then
        potion_material = "sima"
    end

    local starting_amount = {250, 500}
    init_potion_with_amount(entity_id, potion_material, get_random_between_range(starting_amount))
end
