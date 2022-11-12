dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local laser_comps = EntityGetComponent(entity_id, "LaserEmitterComponent")
local state = variable_storage_get_value(entity_id, "INT", "state")
state = state + 1

if state == 1 then
    --Start the Laser Beam Tracking
    if (laser_comps ~= nil) then
        for a, lcomp in ipairs(laser_comps) do
            local p = getPlayerEntity()

            if (p ~= nil) then
                local px, py = EntityGetTransform(p)

                local a = math.atan2(py - y, px - x)
                ComponentSetValue2(lcomp, "laser_angle_add_rad", a)
                ComponentObjectSetValue2(lcomp, "laser", "beam_radius", 1.5)
                ComponentObjectSetValue2(lcomp, "laser", "damage_to_entities", 0)
                ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", false)
                ComponentSetValue2(lcomp, "is_emitting", true)
                ComponentObjectSetValue2(lcomp, "laser", "beam_particle_type", CellFactory_GetType("spark_blue"))
            end
        end
    end
end

if state == 2 then
    --Fire Death Laser
    if (laser_comps ~= nil) then
        for a, lcomp in ipairs(laser_comps) do
            ComponentObjectSetValue2(lcomp, "laser", "beam_radius", 4)
            ComponentObjectSetValue2(lcomp, "laser", "damage_to_entities", 0.6)
            ComponentObjectSetValue2(lcomp, "laser", "beam_particle_type", CellFactory_GetType("spark_red"))
            if (a == 1) then
                ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", true)
            end
        end
    end

    local particle_comps = EntityGetComponent(entity_id, "ParticleEmitterComponent")
    for i, comp in ipairs(particle_comps) do
        ComponentSetValue2(comp, "emitted_material_name", "spark_red")
    end

    --Change Tesla Turret to red sprite
    local turret_id = EntityGetParent(entity_id)
    local sprite_comps_parent = EntityGetComponent(turret_id, "SpriteComponent")
    for i, comp in ipairs(sprite_comps_parent) do
        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret.xml" then
            --if == blue sprite
            ComponentSetValue2(comp, "alpha", 0)
        end

        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret_firing.xml" then
            --if == red sprite
            ComponentSetValue2(comp, "alpha", 1)
        end
    end

    --Change light aura to red
    local sprite_comps = EntityGetComponent(entity_id, "SpriteComponent")
    for i, comp in ipairs(sprite_comps) do
        ComponentSetValue2(comp, "image_file", "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret_light_red.xml")
    end
end

if state == 3 then
    --Stop Firing Death Laser
    if (laser_comps ~= nil) then
        for a, lcomp in ipairs(laser_comps) do
            ComponentSetValue2(lcomp, "is_emitting", false)
            if (a == 1) then
                ComponentObjectSetValue2(lcomp, "laser", "audio_enabled", false)
            end
        end
    end

    local particle_comps = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
    for i, comp in ipairs(particle_comps) do
        ComponentSetValue2(comp, "emitted_material_name", "spark_blue")
    end

    --Change Tesla Turret back to blue sprite
    local turret_id = EntityGetParent(entity_id)
    local sprite_comps = EntityGetComponentIncludingDisabled(turret_id, "SpriteComponent")
    for i, comp in ipairs(sprite_comps) do
        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret.xml" then
            --if == blue sprite
            ComponentSetValue2(comp, "alpha", 1)
        end

        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret_firing.xml" then
            --if == red sprite
            ComponentSetValue2(comp, "alpha", 0)
        end
    end

    --Change light aura to red
    local sprite_comps = EntityGetComponent(entity_id, "SpriteComponent")
    for i, comp in ipairs(sprite_comps) do
        ComponentSetValue2(comp, "image_file", "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret_light_blue.xml")
    end

    --Stop rendering blue shieldy type thing
    local particle_emitter_comps = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
    for i, particle_emitter_comp in ipairs(particle_emitter_comps) do
        EntitySetComponentIsEnabled(entity_id, particle_emitter_comp, false)
    end

    --Disable turret in wait for next activation
    state = 0
    local lua_comps = EntityGetComponentIncludingDisabled(entity_id, "LuaComponent")
    for i, lua_comp in ipairs(lua_comps) do
        EntitySetComponentIsEnabled(entity_id, lua_comp, false)
    end
end

--Write new state value to storage
variable_storage_set_value(entity_id, "INT", "state", state)
