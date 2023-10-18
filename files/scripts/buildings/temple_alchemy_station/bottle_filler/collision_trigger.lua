dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

function collision_trigger(colliding_entity)
    local storage_ent = {}
    storage_ent.id = GetUpdatedEntityID()
    storage_ent.x, storage_ent.y = EntityGetTransform(storage_ent.id)
    storage_ent.interact_comp = EntityGetFirstComponentIncludingDisabled(storage_ent.id, "InteractableComponent")

    local player = {}
    player.id = getPlayerEntity()
    player.i2c_id = EntityGetFirstComponentIncludingDisabled(player.id, "Inventory2Component")
    player.active_item_id = ComponentGetValue2(player.i2c_id, "mActiveItem")

    local holding_potion = (EntityHasTag(player.active_item_id, "potion"))
    local holding_powder_stash = (EntityHasTag(player.active_item_id, "powder_stash"))

    local inv_full = false
    if #get_held_items() == 4 then
        inv_full = true
    end

    --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")
    storage_ent.mode = variable_storage_get_value(storage_ent.id, "STRING", "mode")

    if storage_ent.mode == "place" then
        if holding_potion then
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", "$storage_interact_placing_potion")
        elseif holding_powder_stash then
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", "$storage_interact_placing_powder_stash")
        else
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", "$bottle_filler_placing_invalid_item")
        end
    end

    if storage_ent.mode == "pick_up" then
        local stored_potion = {}
        stored_potion.id = EntityGetAllChildren(storage_ent.id)[1] --should only have 1 child ent - if not, this is bad
        stored_potion.inventory_string, stored_potion.amount_filled, stored_potion.barrel_size, stored_potion.potion_or_sack = ReadPotionInventory(stored_potion.id)
        
        if #get_held_items() < 4 then
            local potion_display_name = GetDisplayTextFromMaterialString(stored_potion.inventory_string)
            local percent_filled = string.gsub(string.format("%2.0f", 100 * (stored_potion.amount_filled / stored_potion.barrel_size)), "%s+", "")
            local display_text =
                GameTextGetTranslatedOrNot("$bottle_filler_pickup_part_1") ..
                potion_display_name .. GameTextGetTranslatedOrNot("$bottle_filler_pickup_part_2_" .. stored_potion.potion_or_sack) .. percent_filled .. GameTextGetTranslatedOrNot("$bottle_filler_pickup_part_3")

            --Set UI Text
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", display_text)
        else
            --Inventory is full, display a message saying you can't pick up
            ComponentSetValue2(storage_ent.interact_comp, "ui_text", "$bottle_filler_trigger_inventory_full_" .. stored_potion.potion_or_sack)
        end
    end
end
