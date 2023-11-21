dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    --Kill all goals and foul lines
    local all_entities_in_range = EntityGetInRadius(x, y, 500)
    local ent_names_to_kill = {
        "skully_kicking_goal",
        "skully_kicking_foul_line",
        "skully_kicking_foul_line_black",
        "skully_kicking_skull",
        "skully_kicking_bone_small",
        "skully_kicking_bone_large",
        "skully_kicking_respawn_point",
        "skully_kicking_lantern"
    }

    for _, ent in ipairs(all_entities_in_range) do
        local name = EntityGetName(ent)

        --Collapse Goals
        --collapse goals
        if name == "skully_kicking_goal" then
            local goal_x, goal_y = EntityGetTransform(ent)
            EntityLoad("data/entities/misc/loose_chunks_small.xml", goal_x, goal_y)
        end

        --Kill ents
        for _, ent_name_to_kill in ipairs(ent_names_to_kill) do
            if name == ent_name_to_kill then
                EntityKill(ent)
            end
        end
    end
end
