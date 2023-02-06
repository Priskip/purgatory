dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

local initializer = {}
initializer.id = GetUpdatedEntityID()
initializer.x, initializer.y = EntityGetTransform(initializer.id)

local storage_slots = get_entity_in_radius_with_name(initializer.x, initializer.y, 240, "temple_alchemy_potion_storage", "temple_alchemy_station")

if #storage_slots ~= 0 then
    --Fill the slot
    for i, slot_id in ipairs(storage_slots) do
        --Kill any previously stored potion
        local previously_stored_potions = EntityGetAllChildren(slot_id)
        if previously_stored_potions ~= nil then
            for i, v in ipairs(previously_stored_potions) do
                EntityKill(v)
            end
        end

        --Change Mode back to "place"
        variable_storage_set_value(slot_id, "STRING", "mode", "place")

        --Change name back to empty
        local ui_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "UIInfoComponent")
        ComponentSetValue2(ui_comp, "name", "$storage_empty")

        --Get the Slot Number
        local slot_number = variable_storage_get_value(slot_id, "INT", "slot_number")

        --Get the inventory from Global value
        local slot_contents = GlobalsGetValue("TEMPLE_ALCHEMY_STORAGE_SLOT_" .. tostring(slot_number), "empty")
        --Example value: potion,1000;blood,855-magic_liquid_mana_regeneration,82

        if slot_contents ~= "empty" then
            --Read Cotents of Global
            local slot_contents = split_string_on_char_into_table(slot_contents, ";")
            local header = slot_contents[1] --Example value: potion,1000
            local inventory_string = slot_contents[2] --Example value: blood,855-magic_liquid_mana_regeneration,82

            header = split_string_on_char_into_table(header, ",")
            --Now header[1] = "potion", header[2] = "1000"

            --Make potion to store
            local slot_x, slot_y = EntityGetTransform(slot_id)
            stored_potion_id = create_stored_potion_entity(inventory_string, tonumber(header[2]), header[1], slot_x, slot_y)
            local _inv_string, amount_filled, _barrel_size, _potion_or_sack = read_potion_inventory(stored_potion_id) --not the cleanest way of getting the amount filled

            --Add as child for easy finding later
            EntityAddChild(slot_id, stored_potion_id)

            --Update mode to "pick_up"
            variable_storage_set_value(slot_id, "STRING", "mode", "pick_up")

            --Set Ent Name
            local potion_display_name = get_display_text_from_material_string(inventory_string)
            local percent_filled = string.gsub(string.format("%2.0f", 100 * (amount_filled / tonumber(header[2]))), "%s+", "")
            local display_text =
                GameTextGetTranslatedOrNot("$storage_display_part_1") ..
                potion_display_name .. GameTextGetTranslatedOrNot("$storage_display_part_2_" .. header[1]) .. percent_filled .. GameTextGetTranslatedOrNot("$storage_display_part_3")
            local slot_ui_comp = EntityGetFirstComponentIncludingDisabled(slot_id, "UIInfoComponent")
            ComponentSetValue2(slot_ui_comp, "name", display_text)
        end
    end
else
    print("Error! Purgatory: potion_storage_initalizer.lua - Could not find potion storage slot entities!")
end
