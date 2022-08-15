dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(GetUpdatedEntityID())

local comps_to_remove = {
    "PhysicsBodyComponent",
    "PhysicsBodyComponent",
    "PhysicsThrowableComponent",
    "DamageModelComponent"
}

for i, comp_name in ipairs(comps_to_remove) do
    GamePrint("hi "..comp_name)
    local comps = EntityGetComponent(entity_id, comp_name)
    if comps ~= nil then
        for i, comp in ipairs(comps) do
            EntityRemoveComponent(entity_id, comp)
        end
    end
end

