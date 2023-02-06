dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
    local storage_ent = {}
    storage_ent.id = GetUpdatedEntityID()
    storage_ent.x, storage_ent.y = EntityGetTransform(storage_ent.id)

    local player = {}
    player.id = getPlayerEntity()
    player.x, player.y = EntityGetTransform(player.id)

    --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")
    storage_ent.mode = variable_storage_get_value(storage_ent.id, "STRING", "mode")

    if storage_ent.mode == "place" then
        --Find the item the player is holding
        player.i2c_id = EntityGetFirstComponentIncludingDisabled(player.id, "Inventory2Component")
        player.active_item_id = ComponentGetValue2(player.i2c_id, "mActiveItem")

        local is_holding_potion = EntityHasTag(player.active_item_id, "potion")
        local is_holding_sack = EntityHasTag(player.active_item_id, "powder_stash")

        --If player is holding a potion or sack
        if is_holding_potion or is_holding_sack then
            --Read contents
            local stored_potion = {}
            stored_potion.inventory_string, stored_potion.amount_filled, stored_potion.barrel_size, stored_potion.potion_or_sack = read_potion_inventory(player.active_item_id)

            --Make new potion
            stored_potion.id = create_stored_potion_entity(stored_potion.inventory_string, stored_potion.barrel_size, stored_potion.potion_or_sack, storage_ent.x, storage_ent.y)

            --Add as child for easy finding later
            EntityAddChild(storage_ent.id, stored_potion.id)

            --Kill Player's held potion
            EntityKill(player.active_item_id)

            --Update mode to "pick_up"
            variable_storage_set_value(storage_ent.id, "STRING", "mode", "pick_up")

            --Set Ent Name
            local potion_display_name = get_display_text_from_material_string(stored_potion.inventory_string)
            local percent_filled = string.gsub(string.format("%2.0f", 100 * (stored_potion.amount_filled / stored_potion.barrel_size)), "%s+", "")
            local display_text =
                GameTextGetTranslatedOrNot("$storage_display_part_1") ..
                potion_display_name .. GameTextGetTranslatedOrNot("$storage_display_part_2_" .. stored_potion.potion_or_sack) .. percent_filled .. GameTextGetTranslatedOrNot("$storage_display_part_3")
            storage_ent.ui_comp = EntityGetFirstComponentIncludingDisabled(storage_ent.id, "UIInfoComponent")
            ComponentSetValue2(storage_ent.ui_comp, "name", display_text)

            --Write potion contents to global storage
            storage_ent.slot_number = variable_storage_get_value(storage_ent.id, "INT", "slot_number")
            GlobalsSetValue(
                "TEMPLE_ALCHEMY_STORAGE_SLOT_" .. tostring(storage_ent.slot_number),
                stored_potion.potion_or_sack .. "," .. stored_potion.barrel_size .. ";" .. stored_potion.inventory_string
            )
        else
            --GamePrint("Please be holding a potion or sack.")
        end
    end

    if storage_ent.mode == "pick_up" then
        if #get_held_items() < 4 then
            --Read contents
            local stored_potion = {}
            stored_potion.id = EntityGetAllChildren(storage_ent.id)[1] --should only have 1 child ent - if not, this is bad
            stored_potion.inventory_string, stored_potion.amount_filled, stored_potion.barrel_size, stored_potion.potion_or_sack = read_potion_inventory(stored_potion.id)

            --Make new potion and have player pick it up
            local new_potion = create_pickup_potion_entity(stored_potion.inventory_string, stored_potion.barrel_size, stored_potion.potion_or_sack, storage_ent.x, storage_ent.y)

            --Kill old Potion
            EntityKill(stored_potion.id)

            --Change Bottle Stand mode
            storage_ent.interact_comp = EntityGetFirstComponentIncludingDisabled(storage_ent.id, "InteractableComponent")
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", "$bottle_filler_interact_placing")
            variable_storage_set_value(storage_ent.id, "STRING", "mode", "place")

            --Update Name
            storage_ent.ui_comp = EntityGetFirstComponentIncludingDisabled(storage_ent.id, "UIInfoComponent")
            ComponentSetValue2(storage_ent.ui_comp, "name", "$storage_empty")

            --Clear potion contents in global storage
            storage_ent.slot_number = variable_storage_get_value(storage_ent.id, "INT", "slot_number")
            GlobalsSetValue("TEMPLE_ALCHEMY_STORAGE_SLOT_" .. tostring(storage_ent.slot_number), "empty")
        else
            --GamePrint("Please make an empty spot in your inventory.")
        end
    end
end
