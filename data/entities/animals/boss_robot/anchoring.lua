dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local center_point_id = EntityGetInRadiusWithTag(x, y, 325, "roboroom_center")[1]

if center_point_id ~= nil then
    local center_x, center_y = EntityGetTransform(center_point_id)

    local distance = get_distance(x, y, center_x, center_y)
    local allowed_travel_radius = 225

    if distance <= allowed_travel_radius then
        --Set Var Storage for last known position inside radius
        variable_storage_set_value(entity_id, "FLOAT", "last_pos_x", x)
        variable_storage_set_value(entity_id, "FLOAT", "last_pos_y", y)
    else
        --Set Mecha's Location to old location
        local new_x, new_y = variable_storage_get_value(entity_id, "FLOAT", "last_pos_x"), variable_storage_get_value(entity_id, "FLOAT", "last_pos_y")
        EntitySetTransform(entity_id, new_x, new_y)
    end
end
--Note Priskip: IF Mecha Kolmi is forcibly removed from the center by the player, then this can get really, really weird


