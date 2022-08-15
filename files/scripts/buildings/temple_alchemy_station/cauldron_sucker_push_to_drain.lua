dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--Get IDs and Positions
local cauldron_sucker = {}
local bottle_stand_placed_potion = {}

cauldron_sucker.id = GetUpdatedEntityID()
cauldron_sucker.x, cauldron_sucker.y = EntityGetTransform(cauldron_sucker.id)

--Read Material Inventory
cauldron_sucker.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialInventoryComponent")
cauldron_sucker.count_per_material_type = ComponentGetValue2(cauldron_sucker.mat_inv_comp, "count_per_material_type")
local count = 0
cauldron_sucker.mat_inv_contents = {}

if cauldron_sucker.count_per_material_type ~= nil then
    --Counts how much of each material is inside the cauldron sucker and empties the cauldron sucker's inventory
    for i, v in ipairs(cauldron_sucker.count_per_material_type) do
        if v ~= 0 then
            count = count + 1
            cauldron_sucker.mat_inv_contents[count] = {
                material = CellFactory_GetName(i - 1),
                amount = v
            }
        end
    end
end

--Read Queue
local queue = variable_storage_get_value(cauldron_sucker.id, "STRING", "queue")
if queue == "" then
    queue = {}
else
    queue = split_string_on_char_into_table(queue, ",")
end

if #queue ~= 0 then
    local has_mat_to_push = false
    local mat_to_push = queue[1]
    local amount_to_push = 0

    for i, v in ipairs(cauldron_sucker.mat_inv_contents) do
        if v.material == mat_to_push then
            has_mat_to_push = true
            amount_to_push = v.amount
            break
        end
    end

    if has_mat_to_push then
        --Push Material to Drain
        local drain_id = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/drain.xml", cauldron_sucker.x, cauldron_sucker.y)
        EntitySetTransform(drain_id, cauldron_sucker.x - 7.5, cauldron_sucker.y + 21)

        EntityAddComponent2(
            drain_id,
            "VariableStorageComponent",
            {
                name = "material_to_emit",
                value_string = mat_to_push
            }
        )

        EntityAddComponent2(
            drain_id,
            "VariableStorageComponent",
            {
                name = "amount_of_material",
                value_int = amount_to_push
            }
        )

        --[[
            DO NOT DO THIS HERE - IT CREATES RACE CONDITIONS
            THIS WILL INSTEAD WORK AT THE END OF THE DRAIN
        --Remove this material from the cauldron sucker's material inventory
        if cauldron_sucker.count_per_material_type ~= nil then
            for i, v in ipairs(cauldron_sucker.count_per_material_type) do
                if v ~= 0 then
                    if CellFactory_GetName(i - 1) == mat_to_push then
                        AddMaterialInventoryMaterial(cauldron_sucker.id, CellFactory_GetName(i - 1), 0) --This removes the material from the cauldron sucker's inventory
                        break
                    end
                end
            end
        end
        ]]
    else
        --Remove Material from Queue
        table.remove(queue, 1)
        variable_storage_set_value(cauldron_sucker.id, "STRING", "queue", table_to_char_separated_string(queue, ","))
    end
end
