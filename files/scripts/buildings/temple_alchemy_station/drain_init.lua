dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local material_to_emit = variable_storage_get_value(entity_id, "STRING", "material_to_emit")

if material_to_emit ~= "" then
    local particle_comps = EntityGetComponent(entity_id, "ParticleEmitterComponent")

    for i, comp in ipairs(particle_comps) do
        ComponentSetValue2(comp, "emitted_material_name", material_to_emit)
    end
end
