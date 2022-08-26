dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--Get IDs and Positions
local gauge = {}
gauge.id = GetUpdatedEntityID()
gauge.x, gauge.y = EntityGetTransform(gauge.id)

local bottle_stand_placed_potion = {}
bottle_stand_placed_potion.id = EntityGetClosestWithTag(gauge.x, gauge.y, "temple_alchemy_bottle_stand_placed_potion") --Returns 0 if no ent is found
if bottle_stand_placed_potion.id ~= 0 then
    bottle_stand_placed_potion.x, bottle_stand_placed_potion.y = EntityGetTransform(bottle_stand_placed_potion.id)
end

--Count how much material is in the potion and update the ui text accordingly
local placed_potion = {}
local mat_inv_names = {}
local mat_inv_amounts = {}
placed_potion.id = EntityGetClosestWithTag(x, y, "temple_alchemy_bottle_stand_placed_potion")
if placed_potion.id == 0 then
    placed_potion.id = EntityGetClosestWithTag(x, y, "placed_bottle_storage") --TODO: Fix this jank
end

placed_potion.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(placed_potion.id, "MaterialInventoryComponent")
placed_potion.count_per_material = ComponentGetValue2(placed_potion.mat_inv_comp, "count_per_material_type")

local max_capacity = 1000 --TODO: This can change if I make the comically large potions compatable with this
local total_volume = 0

--Counts all the materials in the stored potion and organizes them from most to least
local c = 0
for i, v in ipairs(placed_potion.count_per_material) do
    if v ~= 0 then
        c = c + 1
        mat_inv_names[c] = CellFactory_GetName(i - 1)
        mat_inv_amounts[c] = v
        total_volume = total_volume + v

        if c > 1 then
            for j = c, 2, -1 do
                if mat_inv_amounts[j] > mat_inv_amounts[j - 1] then
                    --swap
                    local temp = mat_inv_amounts[j - 1]
                    mat_inv_amounts[j - 1] = mat_inv_amounts[j]
                    mat_inv_amounts[j] = temp

                    temp = mat_inv_names[j - 1]
                    mat_inv_names[j - 1] = mat_inv_names[j]
                    mat_inv_names[j] = temp
                end
            end
        end
    end
end

--Update Particle Emitters
local particle_emitter_comps = EntityGetComponent(gauge.id, "ParticleEmitterComponent")

if particle_emitter_comps ~= nil then
    for i, comp in ipairs(particle_emitter_comps) do
        EntityRemoveComponent(gauge.id, comp)
    end
end

local pos = 0
if #mat_inv_names > 0 then
    for i, mat_name in ipairs(mat_inv_names) do
        local amount = math.ceil(mat_inv_amounts[i] / 10)
        local particle_emitter_component =
            EntityAddComponent2(
            gauge.id,
            "ParticleEmitterComponent",
            {
                emitted_material_name = mat_name,
                x_vel_min = 0,
                x_vel_max = 0,
                y_vel_min = 0,
                y_vel_max = 0,
                lifetime_min = 1.25,
                lifetime_max = 1.25,
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
        ComponentSetValue2(particle_emitter_component, "y_pos_offset_max", -(amount+pos))
        ComponentSetValue2(particle_emitter_component, "count_min", amount)
        ComponentSetValue2(particle_emitter_component, "count_max", amount)

        pos = pos + amount
    end
end
