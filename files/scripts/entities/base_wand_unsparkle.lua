dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

function collision_trigger(colliding_entity)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    local comps = EntityGetAllComponents(entity_id)
    for i, comp in ipairs(comps) do
        local shiny = ComponentHasTag(comp, "shiny_particles")

        if shiny then
            EntityRemoveComponent(entity_id, comp)
        end
    end

    local sprite_comps = EntityGetComponent(entity_id, "SpriteParticleEmitterComponent")

    if sprite_comps ~= nil then
        for i, sprite_comp in ipairs(sprite_comps) do
            EntityRemoveComponent(entity_id, sprite_comp)
        end
    end
end
