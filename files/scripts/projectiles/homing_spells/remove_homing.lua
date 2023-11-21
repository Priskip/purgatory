dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local homing_components = EntityGetComponent(entity_id, "HomingComponent")

if homing_components ~= nil then
    for _, comp in ipairs(homing_components) do
        EntitySetComponentIsEnabled(entity_id, comp, false)
    end
end