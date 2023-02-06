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
    local num = Random(1, 1000000)
    local potion_mat = "water"

    if in_range(num, 1, 1) then
    elseif in_range(num, 600000, 899999) then
        potion_mat = "blood"
    elseif in_range(num, 900000, 999899) then
        potion_mat = "acid"
    elseif in_range(num, 999900, 999989) then
        potion_mat = "slime"
    elseif in_range(num, 999900, 999999) then
        potion_mat = "urine"
    elseif in_range(num, 1000000, 1000000) then
        potion_mat = "gold"
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

    local starting_amount = {750, 1000}
    init_potion_with_amount(entity_id, potion_material, get_random_between_range(starting_amount))

    --Make description reflect barrel size.
	EntityAddComponent2(
		entity_id,
		"LuaComponent",
		{
			_tags="enabled_in_hand,enabled_in_world,enabled_in_inventory",
			execute_on_added = false,
			execute_every_n_frame = 5,
			remove_after_executed = true,
			script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
		}
	)

    local mat_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")
    EntitySetComponentIsEnabled(entity_id, mat_sucker_comp, true)
    ComponentAddTag(mat_sucker_comp, "enabled_in_world")
    ComponentAddTag(mat_sucker_comp, "enabled_in_hand")
end

--TODO: clean up this mess with my new logic