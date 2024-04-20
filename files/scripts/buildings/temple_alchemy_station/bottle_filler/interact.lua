dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
    local bottle_stand = {}
    bottle_stand.id = GetUpdatedEntityID()
    bottle_stand.x, bottle_stand.y = EntityGetTransform(bottle_stand.id)
    bottle_stand.mode = variableStorageGetValue(bottle_stand.id, "STRING", "mode") --Variable storage for what mode the bottle stand is in (either "place" or "pick_up")

    local player = {}
    player.id = getPlayerEntity()
    player.x, player.y = EntityGetTransform(player.id)

    if bottle_stand.mode == "place" then
        --What still needs done here:
        --Activate Cauldron Sucker
        --Activate Filler Gauge
        --Set Ent Name with potion/sack name

        --Find the item the player is holding
        player.i2c_id = EntityGetFirstComponentIncludingDisabled(player.id, "Inventory2Component")
        player.active_item_id = ComponentGetValue2(player.i2c_id, "mActiveItem")

        local is_holding_potion = EntityHasTag(player.active_item_id, "potion")
        local is_holding_sack = EntityHasTag(player.active_item_id, "powder_stash")

        --If player is holding a potion or sack
        if is_holding_potion or is_holding_sack then
            --Read contents
            local placed_bottle = {}
            placed_bottle.inventory_string, placed_bottle.amount_filled, placed_bottle.barrel_size, placed_bottle.potion_or_sack = ReadPotionInventory(player.active_item_id)

            --Make new potion
            --placed_bottle.id = CreateStoredPotionEntityFromItemID(player.active_item_id)
            placed_bottle.id = CreateStoredPotionEntity(placed_bottle.inventory_string, placed_bottle.barrel_size, placed_bottle.potion_or_sack, bottle_stand.x, bottle_stand.y)

            --Add as child for easy finding later
            EntityAddChild(bottle_stand.id, placed_bottle.id)

            --Kill Player's held potion
            EntityKill(player.active_item_id)

            --Update mode to "pick_up"
            variableStorageSetValue(bottle_stand.id, "STRING", "mode", "pick_up")

            --Activate Fill Gauge
            local filler_gauge_id = getEntityInRadiusWithName(bottle_stand.x, bottle_stand.y, 50, "temple_alchemy_fill_gauge", "temple_alchemy_station")[1] --Should only ever be 1 filler gauge in area. If not, there's problems
            EntityAddComponent2(
                filler_gauge_id,
                "LuaComponent",
                {
                    execute_on_added = false,
                    execute_every_n_frame = 5, --Five frame delay to allow for potion/sack components to update
                    remove_after_executed = true,
                    script_source_file = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/fill_gauge_update.lua"
                }
            )

            --Activate Cauldron Sucker
            local cauldron_sucker = {}
            cauldron_sucker.id = getEntityInRadiusWithName(bottle_stand.x, bottle_stand.y, 50, "temple_alchemy_cauldron_sucker", "temple_alchemy_station")[1] --Should only ever be 1 cauldron sucker in area. If not, there's problems
            cauldron_sucker.lua_components = EntityGetComponentIncludingDisabled(cauldron_sucker.id, "LuaComponent")

            if cauldron_sucker.lua_components ~= nil then
                for i, lua_comp in ipairs(cauldron_sucker.lua_components) do
                    local script_file = ComponentGetValue2(lua_comp, "script_source_file")

                    if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/cauldron_sucker_logic.lua" then
                        EntitySetComponentIsEnabled(cauldron_sucker.id, lua_comp, true)
                    end
                end
            end
        else
            GamePrint("Please be holding a potion or powder sack.")
        end
    end

    if bottle_stand.mode == "pick_up" then
        --Deactivate Cauldron Sucker
        --Deactivate Filler Gauge
        --Create new potion/sack and force player to pick it up
        --Kill potion/sack on the bottle stand

        if #getHeldItems() < 4 then
            --Read contents
            local placed_bottle = {}
            placed_bottle.id = EntityGetAllChildren(bottle_stand.id)[1] --should only have 1 child ent - if not, this is bad
            placed_bottle.inventory_string, placed_bottle.amount_filled, placed_bottle.barrel_size, placed_bottle.potion_or_sack = ReadPotionInventory(placed_bottle.id)

            --Make new potion and have player pick it up
            local new_potion = CreatePickupPotionEntity(placed_bottle.inventory_string, placed_bottle.barrel_size, placed_bottle.potion_or_sack, bottle_stand.x, bottle_stand.y)

            --Kill old Potion
            EntityKill(placed_bottle.id)

            --Update mode to "place"
            variableStorageSetValue(bottle_stand.id, "STRING", "mode", "place")

            --Clear Particle Emitters from fill gauge
            local filler_gauge = {}
            filler_gauge.id = getEntityInRadiusWithName(bottle_stand.x, bottle_stand.y, 50, "temple_alchemy_fill_gauge", "temple_alchemy_station")[1] --Should only ever be 1 filler gauge in area. If not, there's problems
            filler_gauge.particle_emitter_comps = EntityGetComponent(filler_gauge.id, "ParticleEmitterComponent")

            if filler_gauge.particle_emitter_comps ~= nil then
                for i, comp in ipairs(filler_gauge.particle_emitter_comps) do
                    EntityRemoveComponent(filler_gauge.id, comp) --Remove particle emitter components and adding new ones is easier to program than having to sort old ones
                end
            end

        else
            GamePrint("Plese make room in your inventory to pick this up.")
        end
    end
end
