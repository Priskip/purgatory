dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local laser_comps = EntityGetComponent(entity_id, "LaserEmitterComponent")
local state = variable_storage_get_value(entity_id, "INT", "state")

if state == 1 then
    if (laser_comps ~= nil) then
        for a, lcomp in ipairs(laser_comps) do
            local p = getPlayerEntity()

            if (p ~= nil) then
                local px, py = EntityGetTransform(p)

                local a = math.atan2(py - y, px - x)
                ComponentSetValue2(lcomp, "laser_angle_add_rad", a)
            end
        end
    end
end
