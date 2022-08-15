dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local initializer = {}
initializer.id = GetUpdatedEntityID()
initializer.x, initializer.y = EntityGetTransform(initializer.id)

local storage_slots = EntityGetInRadiusWithTag(initializer.x, initializer.y, 240, "temple_alchemy_potion_storage")

if #storage_slots ~= 0 then
    for i, slot_id in ipairs(storage_slots) do
        --Kill any previously stored potion
        local previously_stored_potions = EntityGetAllChildren(slot_id)
        if previously_stored_potions ~= nil then
            for i, v in ipairs(previously_stored_potions) do
                EntityKill(v)
            end
        end

        --Change mode back to "place"
        local interact_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "InteractableComponent")
        ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_placing")
        variable_storage_set_value(slot_id, "STRING", "mode", "place")

        --Change name back to empty
        local ui_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "UIInfoComponent")
        ComponentSetValue2(ui_comp, "name", "$potion_storage_empty")

        --Get Slot Number
        local slot_number = variable_storage_get_value(slot_id, "INT", "slot_number")
        local inventory = GlobalsGetValue("TEMPLE_ALCHEMY_STORAGE_SLOT" .. tostring(slot_number), "empty")

        --Fill slot with stored potion if there is one in global storage
        if inventory ~= "empty" then
            --Assign the potion entity
            local slot_x, slot_y = EntityGetTransform(slot_id)
            local new_bottle_ent_id = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/potion_storage_stored_potion.xml", slot_x, slot_y)
            EntityAddChild(slot_id, new_bottle_ent_id)
        
            inventory = split_string_on_char_into_table(inventory, "-")
        
            for i, material_and_amount in ipairs(inventory) do
                material_and_amount = split_string_on_char_into_table(material_and_amount, ",")
        
                AddMaterialInventoryMaterial(new_bottle_ent_id, material_and_amount[1], material_and_amount[2])
            end
        
            --BEGIN Set Name of Potion Storage Entity to reflect what type of potion it is
            local mat_inv_names = {}
            local mat_inv_amounts = {}
            local max_capacity = 1000 --TODO: This can change if I make the comically large potions compatable with this
            local total_volume = 0
        
            --Counts all the materials in the stored potion and organizes them from most to least
            --Read held potion contents and write them to new potion
            local mat_inv_comp_new_bottle = EntityGetFirstComponentIncludingDisabled(new_bottle_ent_id, "MaterialInventoryComponent")
            local count_per_material_type = ComponentGetValue2(mat_inv_comp_new_bottle, "count_per_material_type")
        
            local c = 0
            for i, v in ipairs(count_per_material_type) do
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
        
            local display_text = "Stored " .. potion_name .. " Potion (" .. percent_filled .. "% Full)"
        
            --Set Ent Name
            local ui_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "UIInfoComponent")
            ComponentSetValue2(ui_comp, "name", display_text)
            --END Set Name of Potion Storage Entity to reflect what type of potion it is
        
            --Change Bottle Stand mode
            local interact_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "InteractableComponent")
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_pick_up")
            variable_storage_set_value(slot_id, "STRING", "mode", "pick_up")
        end

    end
else
    print("Error! Purgatory: potion_storage_initalizer.lua - Could not find potion storage slot entities!")
end

--[[



--if something in global storage, fill this storage slot


]]
