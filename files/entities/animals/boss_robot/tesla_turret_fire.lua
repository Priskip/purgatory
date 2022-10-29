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
            end
        end
    end
end

if state == 2 then
    --Disable the hitbox of the turret it's in as to not destroy it
    local turret_id = EntityGetInRadiusWithTag(x, y, 10, "roboroom_mecha_turret_alive")[1]
    local hitbox_comp = EntityGetFirstComponentIncludingDisabled(turret_id, "HitboxComponent")
    EntitySetComponentIsEnabled(turret_id, hitbox_comp, false)

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
    local sprite_comps = EntityGetComponent(turret_id, "SpriteComponent")
    for i, comp in ipairs(sprite_comps) do
        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret.xml" then
            --if == blue sprite
            ComponentSetValue2(comp, "alpha", 0)
        end

        if ComponentGetValue2(comp, "image_file") == "mods/purgatory/files/buildings_gfx/roboroom/mecha_turret_firing.xml" then
            --if == red sprite
            ComponentSetValue2(comp, "alpha", 1)
        end
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

    --Re-enable the hitbox of the turret
    local turret_id = EntityGetInRadiusWithTag(x, y, 10, "roboroom_mecha_turret_alive")[1]
    local hitbox_comp = EntityGetFirstComponentIncludingDisabled(turret_id, "HitboxComponent")
    EntitySetComponentIsEnabled(turret_id, hitbox_comp, false)

    --Change Tesla Turret back to blue sprite
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
end

--Write new state value to storage
variable_storage_set_value(entity_id, "INT", "state", state)
