dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local velocity_comp = EntityGetFirstComponent(entity_id, "VelocityComponent")
if velocity_comp == nil then
    return
else
    ComponentSetValue2(velocity_comp, "gravity_x", 0)
    ComponentSetValue2(velocity_comp, "gravity_y", 0)
end
