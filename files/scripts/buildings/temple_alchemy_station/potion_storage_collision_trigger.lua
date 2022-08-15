dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local player_id = getPlayerEntity()
    local i2c_id = EntityGetFirstComponentIncludingDisabled(player_id, "Inventory2Component")
    local active_item_id = ComponentGetValue2(i2c_id, "mActiveItem")
    local holding_potion = (EntityHasTag(active_item_id, "potion"))
    local inv_full = false
    local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")

    if #get_held_items() == 4 then
        inv_full = true
    end

    --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")
    local mode = variable_storage_get_value(entity_id, "STRING", "mode")

    if mode == "place" then
        if holding_potion then
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_placing")
        else
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_not_holding_potion")
        end
    end

    if mode == "pick_up" then
        if not inv_full then
            --Count how much material is in the potion and update the ui text accordingly
            local placed_potion = {}
            local mat_inv_names = {}
            local mat_inv_amounts = {}
            placed_potion.id = EntityGetClosestWithTag(x, y, "temple_alchemy_potion_storage_stored_potion")
            placed_potion.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(placed_potion.id, "MaterialInventoryComponent")
            placed_potion.count_per_material = ComponentGetValue2(placed_potion.mat_inv_comp, "count_per_material_type")

            local max_capacity = 1000 --TODO: This can change if I make the comically large potions compatable with this
            local total_volume = 0

            --Counts all the materials in the stored potion and organizes them from most to least
            local c = 0
            for i, v in ipairs(placed_potion.count_per_material) do
                if v ~= 0 then
                    c = c + 1
                    mat_inv_names[c] = CellFactory_GetUIName(i - 1)
                    mat_inv_amounts[c] = v
                    total_volume = total_volume + v

                    if c > 1 then
                        for j = c, 2, -1 do
                            if mat_inv_amounts[j] > mat_inv_amounts[j - 1] then
                                --swap
                                local temp = mat_inv_amounts[j - 1]
                                mat_inv_amounts[j - 1] = mat_inv_amounts[j]
                                mat_inv_amounts[j] = temp

                                temp = mat_inv_names[j - 1]
                                mat_inv_names[j - 1] = mat_inv_names[j]
                                mat_inv_names[j] = temp
                            end
                        end
                    end
                end
            end

            --Build display text
            local percent_filled = string.format("%2.0f", 100 * (total_volume / max_capacity))
            local potion_name = ""
            if #mat_inv_names > 0 then
                for i, v in ipairs(mat_inv_names) do
                    if i > 1 then
                        potion_name = potion_name .. "+"
                    end

                    potion_name = potion_name .. first_letter_to_upper(GameTextGetTranslatedOrNot(v))
                end
            else
                potion_name = "Empty"
            end

            local display_text = "Press $0 to pickup stored " .. potion_name .. " Potion (" .. percent_filled .. "% Full)"

            --Set UI Text
            ComponentSetValue2(interact_comp, "ui_text", display_text)
        else
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_inv_full")
        end
    end
end