dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local player_id = getPlayerEntity()
    local player_x, player_y = EntityGetTransform(player_id)

    --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")
    local mode = variable_storage_get_value(entity_id, "STRING", "mode")

    if mode == "place" then
        --Find the potion the player is holding
        local i2c_id = EntityGetFirstComponentIncludingDisabled(player_id, "Inventory2Component")
        local active_item_id = ComponentGetValue2(i2c_id, "mActiveItem")

        if (EntityHasTag(active_item_id, "potion")) then
            --Summon new potion on the stand
            local new_bottle_ent_id = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/potion_storage_stored_potion.xml", x, y)
            local old_bottle_inv_contents = {}
            EntityAddChild(entity_id, new_bottle_ent_id) --Assigns the new bottle as a child entity so it's easier to find it in the global storage

            --Read held potion contents and write them to new potion
            local mat_inv_comp_old_bottle = EntityGetFirstComponentIncludingDisabled(active_item_id, "MaterialInventoryComponent")
            local count_per_material_type = ComponentGetValue2(mat_inv_comp_old_bottle, "count_per_material_type")
            local count = 0
            for i, v in ipairs(count_per_material_type) do
                if v ~= 0 then
                    --GamePrint(CellFactory_GetName(i - 1) .. ": " .. v)
                    AddMaterialInventoryMaterial(new_bottle_ent_id, CellFactory_GetName(i - 1), v)
                    count = count + 1
                    old_bottle_inv_contents[count] = {
                        material = CellFactory_GetName(i - 1),
                        amount = v
                    }
                end
            end

            --Change Bottle Stand mode
            local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_pick_up")
            variable_storage_set_value(entity_id, "STRING", "mode", "pick_up")

            --BEGIN Set Name of Potion Storage Entity to reflect what type of potion it is
            local mat_inv_names = {}
            local mat_inv_amounts = {}
            local max_capacity = 1000 --TODO: This can change if I make the comically large potions compatable with this
            local total_volume = 0

            --Counts all the materials in the stored potion and organizes them from most to least
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
            local ui_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "UIInfoComponent")
            ComponentSetValue2(ui_comp, "name", display_text)
            --END Set Name of Potion Storage Entity to reflect what type of potion it is

            --Kill the player held potion
            EntityKill(active_item_id)

            --Write potion contents to global storage
            local slot_number = variable_storage_get_value(entity_id, "INT", "slot_number")
            for i, v in ipairs(old_bottle_inv_contents) do
                old_bottle_inv_contents[i] = v.material .. "," .. tostring(v.amount)
            end
            old_bottle_inv_contents = table_to_char_separated_string(old_bottle_inv_contents, "-")
            GlobalsSetValue("TEMPLE_ALCHEMY_STORAGE_SLOT" .. tostring(slot_number), old_bottle_inv_contents)
        else
            --GamePrint("Please be holding a potion bottle.")
        end
    end

    if mode == "pick_up" then
        if #get_held_items() < 4 then
            -- spawn your potion and add it to the inventory
            local placed_potion = EntityGetAllChildren(entity_id)[1] --only assign one child entity is assigned here, so I can get away with this
            local placed_potion_x, placed_potion_y = EntityGetTransform(placed_potion)
            local new_potion = EntityLoad("data/entities/items/pickup/potion.xml", placed_potion_x + 4, placed_potion_y + 8)
            local mat_inv_comp_new_potion = EntityGetFirstComponentIncludingDisabled(new_potion, "MaterialInventoryComponent")
            local count_per_material_type_new_potion = ComponentGetValue2(mat_inv_comp_new_potion, "count_per_material_type")

            --Empties new potion
            for i, v in ipairs(count_per_material_type_new_potion) do
                if v ~= 0 then
                    AddMaterialInventoryMaterial(new_potion, CellFactory_GetName(i - 1), 0)
                end
            end

            local mat_inv_comp_placed_potion = EntityGetFirstComponentIncludingDisabled(placed_potion, "MaterialInventoryComponent")
            local count_per_material_type_placed_potion = ComponentGetValue2(mat_inv_comp_placed_potion, "count_per_material_type")

            --Fills new potion with contents of stored potion
            for i, v in ipairs(count_per_material_type_placed_potion) do
                if v ~= 0 then
                    AddMaterialInventoryMaterial(new_potion, CellFactory_GetName(i - 1), v)
                end
            end

            --Make new potion auto pickup
            local item_comp = EntityGetFirstComponentIncludingDisabled(new_potion, "ItemComponent")
            ComponentSetValue2(item_comp, "auto_pickup", true)

            --Make invisible on pickup
            EntitySetComponentIsEnabled(new_potion, EntityGetFirstComponentIncludingDisabled(new_potion, "PhysicsBodyComponent"), false)
            EntitySetComponentIsEnabled(new_potion, EntityGetFirstComponentIncludingDisabled(new_potion, "PhysicsImageShapeComponent"), false)
            EntitySetComponentIsEnabled(new_potion, EntityGetFirstComponentIncludingDisabled(new_potion, "ProjectileComponent"), false)

            --Make Pickup really fast
            local frame = GameGetFrameNum()
            ComponentSetValue2(item_comp, "next_frame_pickable", frame)

            --Turn off auto pickup after picked up
            EntityAddComponent2(
                new_potion,
                "LuaComponent",
                {
                    remove_after_executed = true,
                    script_item_picked_up = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/pickup_new_bottle.lua"
                }
            )

            --Kill stored potion
            EntityKill(placed_potion)

            --Change Bottle Stand mode
            local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_placing")
            variable_storage_set_value(entity_id, "STRING", "mode", "place")

            --Update Name
            local ui_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "UIInfoComponent")
            ComponentSetValue2(ui_comp, "name", "$potion_storage_empty")

            --Clear potion contents in global storage
            local slot_number = variable_storage_get_value(entity_id, "INT", "slot_number")
            GlobalsSetValue("TEMPLE_ALCHEMY_STORAGE_SLOT" .. tostring(slot_number), "empty")
        else
            --GamePrint("Please make an empty spot in your inventory.")
        end
    end
end
