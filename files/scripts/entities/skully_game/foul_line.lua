dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    --Kill all goals
    local goals = EntityGetInRadiusWithTag(x, y, 250, "goal")
    for i, goal in ipairs(goals) do
        local goal_x, goal_y = EntityGetTransform(goal)
        EntityLoad("data/entities/misc/loose_chunks_small.xml", goal_x, goal_y)
        EntityKill(goal)
    end

    --Kill Foul Line
    local foul_lines = EntityGetInRadiusWithTag(x, y, 250, "foul_line")
    for i, foul_line in ipairs(foul_lines) do
        EntityKill(foul_line)
    end
end
