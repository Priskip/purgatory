dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform(entity_id)
local detection_distance = 300 --homing range
local detection_angle = 90 --angle of cone to find homing target
local storage_comp = get_variable_storage_component(entity_id, "base_speed") --get the var storage for projectile's speed
local t = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") --for tracking base speed similar to how expanding sphere tracks base damage

--convert from "nolla radians" to regular radians
local theta = -1 * r
if theta < 0 then
    theta = theta + 2 * math.pi
end

--get entities in area
local entities = EntityGetInRadius(x, y, detection_distance)
local found_entities = {}
local count = 1

if #entities > 0 then
    --find entities within detection_angle
    for i, ent in ipairs(entities) do
        local ent_x, ent_y = EntityGetTransform(ent)

        local distance = get_distance(ent_x, ent_y, x, y)
        local direction = get_direction(ent_x, ent_y, x, y)

        local dirdelta = get_direction_difference(direction, theta)
        local dirdelta_deg = math.abs(math.deg(dirdelta))

        if (distance < detection_distance) and (dirdelta_deg < detection_angle) then
            found_entities[count] = ent
            count = count + 1
        end
    end

    if #found_entities > 0 then
        --finds closest target with valid homing target
        local min_distance = 42069
        local closest_ent = nil
        for i, target in ipairs(found_entities) do
            local target_x, target_y = EntityGetTransform(target)
            local distance_to_target = get_distance(target_x, target_y, x, y)

            if distance_to_target < min_distance and EntityHasTag(target, "homing_target") and not RaytraceSurfaces(x, y, target_x, target_y) then
                min_distance = distance_to_target
                closest_ent = target
            end
        end

        --if finds a valid target, set to home on them
        if closest_ent ~= nil then
            local closest_ent_x, closest_ent_y = EntityGetTransform(closest_ent)
            local set_target_ent = EntityLoad("mods/purgatory/files/entities/misc/homing_spells/homing_player_rocket_target.xml", closest_ent_x, closest_ent_y)
            EntityAddChild(closest_ent, set_target_ent)
        end
    end
end

--[[
    --Really borked

    --Set speed to keep constant
local velocity_comp = EntityGetComponent(entity_id, "VelocityComponent")
velocity_comp = velocity_comp[1] --only ever one velocity component (at least so I hope)

local vel_x, vel_y = 0, 0
local angular_vel = 0
local angular_vel_angle = 0
vel_x, vel_y = ComponentGetValueVector2(velocity_comp, "mVelocity", vel_x, vel_y)

--NOTE PRISKIP: if you want the damage from modifiers to saved, you have to take the damage from t = 1.
-- That's because modifiers take a frame to take affect
if t == 1 then
    angular_vel = get_magnitude(vel_x, vel_y)
    ComponentSetValue2(storage_comp, "value_float", angular_vel) --store magnitude of velocity for later
end

if t > 1 then
    local angular_vel_new = get_magnitude(vel_x, vel_y)

    angular_vel = ComponentGetValue2(storage_comp, "value_float")
    angular_vel_angle = get_direction(0, 0, vel_x, vel_y) --get_direction( x1, y1, x2, y2 )

    if angular_vel_new < angular_vel then
        local vx_new, vy_new = rad_to_vec(angular_vel_angle)
        ComponentSetValueVector2(velocity_comp, "mVelocity", angular_vel * vx_new, angular_vel * vy_new)
    end
end

]]