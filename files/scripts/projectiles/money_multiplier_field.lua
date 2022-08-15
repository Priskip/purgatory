dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

entity_id = EntityGetRootEntity(entity_id)

if (entity_id ~= NULL_ENTITY) then
    local projectile_name = tostring(EntityGetFilename(entity_id))

    if projectile_name == "mods/purgatory/files/entities/projectiles/deck/gold_vacuum.xml" then
        local var_storage_comp = EntityGetComponent(entity_id, "VariableStorageComponent")
        if (var_storage_comp ~= nil) then
            for i, v in ipairs(var_storage_comp) do
                local n = ComponentGetValue2(v, "name")
                if (n == "greed_multiplier_golden_field") then
                    local multiplier_value = ComponentGetValue2(v, "value_int")
                    ComponentSetValue2(v, "value_int", multiplier_value * 2) --each modifier doubles value of powder gold sucked by the field
                end
            end
        end
    end
end

