dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

local filler_gauge = {}
filler_gauge.id = GetUpdatedEntityID()
filler_gauge.x, filler_gauge.y = EntityGetTransform(filler_gauge.id)

--If bottle is empty, no need to process the contents

local materials = {"glowstone_altar_hdr", "spark_electric", "magic_liquid_protection_all", "water"}
local amounts = {250, 250, 250, 250}
local pos = 0
local ratio = 0.1

--Add particle effects
for i, mat_name in ipairs(materials) do
    local bar_size = math.ceil(amounts[i] * ratio)
    local particle_emitter_component =
        EntityAddComponent2(
        filler_gauge.id,
        "ParticleEmitterComponent",
        {
            emitted_material_name = mat_name,
            x_vel_min = 0,
            x_vel_max = 0,
            y_vel_min = 0,
            y_vel_max = 0,
            lifetime_min = 0.25,
            lifetime_max = 0.25,
            x_pos_offset_min = -2,
            x_pos_offset_max = 2,
            render_on_grid = false,
            fade_based_on_lifetime = true,
            cosmetic_force_create = false,
            airflow_force = 0.0,
            airflow_time = 0.0,
            airflow_scale = 0.0,
            emission_interval_min_frames = 0,
            emission_interval_max_frames = 0,
            emit_cosmetic_particles = true,
            is_emitting = true,
            collide_with_grid = false
        }
    )

    ComponentSetValue2(particle_emitter_component, "gravity", 0.0, 0.0)
    ComponentSetValue2(particle_emitter_component, "area_circle_radius", 0, 0)
    ComponentSetValue2(particle_emitter_component, "y_pos_offset_min", -pos)
    ComponentSetValue2(particle_emitter_component, "y_pos_offset_max", -(bar_size + pos))
    ComponentSetValue2(particle_emitter_component, "count_min", bar_size)
    ComponentSetValue2(particle_emitter_component, "count_max", bar_size)

    pos = pos + bar_size
end
