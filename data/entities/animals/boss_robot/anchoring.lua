dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local center_point_id = EntityGetInRadiusWithTag(x, y, 500, "roboroom_center")[1]

if center_point_id ~= nil then
    local center_x, center_y = EntityGetTransform(center_point_id)

    local distance = get_distance(x, y, center_x, center_y)
    local direction = get_direction(x, y, center_x, center_y)
    local allowed_travel_radius = 200
    local force_multiplier = 100

    local force_x = -1 * force_multiplier * (distance - allowed_travel_radius) * math.cos(direction)
    local force_y = force_multiplier * (distance - allowed_travel_radius) * math.sin(direction)

    if distance >= allowed_travel_radius then
        PhysicsApplyForce(entity_id, force_x, force_y) --boop him back to center
    end
end
--Note Priskip: IF Mecha Kolmi is forcibly removed from the center by the player, then this can be comical
