dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function physics_body_modified(is_destroyed)
    --Kill lantern entity
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local reset_x, reset_y = 0, 0

    --First find out if the game is still alive
    local all_entities_in_range = EntityGetInRadius(x, y, 500)
    local all_entities_in_range_names = {}
    local still_alive = false
    for _, ent in ipairs(all_entities_in_range) do
        local name = EntityGetName(ent)
        all_entities_in_range_names[#all_entities_in_range_names + 1] = name
        if name == "skully_kicking_respawn_point" then
            still_alive = true
            reset_x, reset_y = EntityGetTransform(ent)
            break
        end
    end


    --If game is still alive, reset it
    if still_alive then
        --Print that we reset the game
        GamePrint("$skully_game_reset")

        --Find and kill all the pieces
        local ents_to_find_and_reset = {
            "skully_kicking_skull",
            "skully_kicking_bone_small",
            "skully_kicking_bone_large",
            "skully_kicking_book"
        }

        for i, name in ipairs(ents_to_find_and_reset) do
            --Is the entity to find alive?
            local index = find_element_in_table(all_entities_in_range_names, name)
            local ent_to_kill = all_entities_in_range[index]
            --If we find the ent, kill it
            if index ~= nil then
                -- if name ~= "skully_kicking_book" then
                --     EntityApplyTransform(all_entities_in_range[index], 310, 37762) --Hax: since killing the physics objects leaves the body behind, I just yeet them to the dark sun here.
                -- end
                EntityConvertToMaterial(ent_to_kill, "spark_purple") --Instead of trying to teleport it, lets convert it to a sparky material
                EntityKill(ent_to_kill)
            end
        end

        --Resets the pieces
        EntityLoad("mods/purgatory/files/entities/buildings/skully_game/skully.xml", reset_x, reset_y - 6)
        EntityLoad("mods/purgatory/files/entities/buildings/skully_game/physics_bone_small.xml", reset_x + 8, reset_y - 4)
        EntityLoad("mods/purgatory/files/entities/buildings/skully_game/physics_bone_large.xml", reset_x - 12,
            reset_y - 4)
        EntityLoad("mods/purgatory/files/entities/items/books/skully_book.xml", reset_x, reset_y)
    end

    EntityConvertToMaterial(entity_id, "spark_purple")
    EntityKill(entity_id)
end
