dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local player_id = getPlayerEntity()
    local player_x, player_y = EntityGetTransform(player_id)
    local cauldron_sucker = {}
    
    --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")
    local mode = variable_storage_get_value(entity_id, "STRING", "mode")

    if mode == "place" then
        --Find the potion the player is holding
        local i2c_id = EntityGetFirstComponentIncludingDisabled(player_id, "Inventory2Component")
        local active_item_id = ComponentGetValue2(i2c_id, "mActiveItem")

        if (EntityHasTag(active_item_id, "potion")) then
            --Summon new potion on the stand
            local new_bottle_ent_id = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/bottle_stand_placed_potion.xml", x, y)

            --Read held potion contents and write them to new potion
            local mat_inv_comp_old_bottle = EntityGetFirstComponentIncludingDisabled(active_item_id, "MaterialInventoryComponent")
            local count_per_material_type = ComponentGetValue2(mat_inv_comp_old_bottle, "count_per_material_type")
            for i, v in ipairs(count_per_material_type) do
                if v ~= 0 then
                    --GamePrint(CellFactory_GetName(i - 1) .. ": " .. v)
                    AddMaterialInventoryMaterial(new_bottle_ent_id, CellFactory_GetName(i - 1), v)
                end
            end

            --Kill the player held potion
            EntityKill(active_item_id)

            --Change Bottle Stand mode
            local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_pick_up")
            variable_storage_set_value(entity_id, "STRING", "mode", "pick_up")

            --Summon the cauldron sucking entity
            cauldron_sucker.id = EntityGetClosestWithTag(x, y, "temple_alchemy_cauldron_sucker")
            if cauldron_sucker.id == 0 then
                --Summon a new cauldron sucker
                EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/cauldron_sucker.xml", x + 16, y - 40)
            end
        else
            --GamePrint("Please be holding a potion bottle.")
        end
    end

    if mode == "pick_up" then
        if #get_held_items() < 4 then
            -- spawn your potion and add it to the inventory
            local placed_potion = EntityGetClosestWithTag(x, y, "temple_alchemy_bottle_stand_placed_potion")
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

            --Get Cauldron Sucker and Kill it if it doesn't have any material in it
            cauldron_sucker.id = EntityGetClosestWithTag(x, y, "temple_alchemy_cauldron_sucker")
            cauldron_sucker.total_volume = 0
            if cauldron_sucker.id ~= 0 then
                cauldron_sucker.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialInventoryComponent")
                cauldron_sucker.count_per_material_type = ComponentGetValue2(cauldron_sucker.mat_inv_comp, "count_per_material_type")

                if cauldron_sucker.count_per_material_type ~= nil then
                    for i, v in ipairs(cauldron_sucker.count_per_material_type) do
                        if v ~= 0 then
                            cauldron_sucker.total_volume = cauldron_sucker.total_volume + v
                        end
                    end
                end

                if cauldron_sucker.total_volume == 0 then
                    EntityKill(cauldron_sucker.id)
                end
            end

            --Change Bottle Stand mode
            local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")
            ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_interact_placing")
            variable_storage_set_value(entity_id, "STRING", "mode", "place")
        else
            --GamePrint("Please make an empty spot in your inventory.")
        end
    end
end
