dofile_once("data/scripts/lib/utilities.lua")

function clear_projectiles_in_radius(x, y, radius)
    local projectiles = EntityGetInRadiusWithTag(x, y, radius, "projectile")

    if (#projectiles > 0) then
        for i, projectile_id in ipairs(projectiles) do
            local proj_x, proj_y = EntityGetTransform(projectile_id)

            local liquid_ent = EntityCreateNew()
            EntitySetTransform(liquid_ent, proj_x, proj_y)

            EntityAddComponent2(
                liquid_ent,
                "ParticleEmitterComponent",
                {
                    emitted_material_name = "plasma_fading", --old value: "void_liquid"
                    create_real_particles = true,
                    lifetime_min = 1,
                    lifetime_max = 1,
                    count_min = 1,
                    count_max = 1,
                    render_on_grid = true,
                    fade_based_on_lifetime = true,
                    cosmetic_force_create = false,
                    airflow_force = 0.251,
                    airflow_time = 1.01,
                    airflow_scale = 0.05,
                    emission_interval_min_frames = 1,
                    emission_interval_max_frames = 1,
                    emit_cosmetic_particles = false,
                    image_animation_file = "mods/purgatory/files/entities/animals/boss_pit/spell_fizzle_emitter.png",
                    image_animation_speed = 1,
                    image_animation_loop = false,
                    image_animation_raytrace_from_center = true,
                    collide_with_gas_and_fire = false,
                    set_magic_creation = true,
                    is_emitting = true
                }
            )

            EntityKill(liquid_ent)
            EntityKill(projectile_id)
        end
    end
end
