dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

local filler_gauge = {}
filler_gauge.id = GetUpdatedEntityID()
filler_gauge.x, filler_gauge.y = EntityGetTransform(filler_gauge.id)

local bottle_stand = {}
bottle_stand.id = get_entity_in_radius_with_name(filler_gauge.x, filler_gauge.y, 50, "temple_alchemy_bottle_stand", "temple_alchemy_station")[1] --Should only ever be 1 filler gauge in area. If not, there's problems

local placed_bottle = {}
placed_bottle.id = EntityGetAllChildren(bottle_stand.id)[1] --should only have 1 child ent - if not, this is bad

if placed_bottle.id ~= nil then
    --Read contents of the potion
    placed_bottle.inventory_string, placed_bottle.amount_filled, placed_bottle.barrel_size, placed_bottle.potion_or_sack = ReadPotionInventory(placed_bottle.id)

    --Clear Particle Emitters
    filler_gauge.particle_emitter_comps = EntityGetComponent(filler_gauge.id, "ParticleEmitterComponent")

    if filler_gauge.particle_emitter_comps ~= nil then
        for i, comp in ipairs(filler_gauge.particle_emitter_comps) do
            EntityRemoveComponent(filler_gauge.id, comp) --Remove particle emitter components and adding new ones is easier to program than having to sort old ones
        end
    end

    --If bottle is empty, no need to process the contents
    if placed_bottle.inventory_string ~= "" then
        local materials = {}
        local amounts = {}
        local material_inventory = split_string_on_char_into_table(placed_bottle.inventory_string, "-")
        for i, v in ipairs(material_inventory) do
            local mat_and_amt = split_string_on_char_into_table(v, ",")
            materials[i] = mat_and_amt[1]
            amounts[i] = mat_and_amt[2]
        end

        --For normalizing brightness. 
        --WARNING: GetGFXGlowsOfMaterials(materials) is a performance intensive function that calls the entire material.xml table. Call this function sparingly.
        local gfx_glows = GetGFXGlowsOfMaterials(materials)

        --This makes it so the particles don't go outside the bar if the player inserts an over-filled potion from the hiisi alchemist
        local pos = 0
        local ratio = 0
        if placed_bottle.amount_filled <= placed_bottle.barrel_size then
            ratio = 100 / placed_bottle.barrel_size
        else
            ratio = 100 / placed_bottle.amount_filled
        end

        --Add particle effects
        for i, mat_name in ipairs(materials) do
            local count = math.ceil(50.978685 * 0.998362 ^ gfx_glows[i]) --regression from datapoints: 0 --> 50, 150 --> 45, 255 --> 30, 1000 --> 10
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
                    lifetime_min = 0.5,
                    lifetime_max = 0.5,
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
                    collide_with_grid = false,
                    count_min = count,
                    count_max = count
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
    end
end
