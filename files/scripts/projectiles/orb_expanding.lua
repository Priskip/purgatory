dofile_once("data/scripts/lib/utilities.lua")

local execute_times = 115
local radius_min = 0
local radius_max = 8
local base_damage = nil

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)
local projectile_comp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local storage_comp = get_variable_storage_component(entity_id, "base_damage")

local t = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local damage = ComponentGetValue2(projectile_comp, "damage")

--NOTE PRISKIP: if you want the damage from modifiers to saved, you have to take the damage from t = 1.
-- That's because modifiers take a frame to take affect
if t == 1 then
	base_damage = damage
	ComponentSetValue2(storage_comp, "value_float", base_damage)
else
	base_damage = ComponentGetValue2(storage_comp, "value_float")
end

if t > 0 then
	-- maths
	local time = t / execute_times -- 0...1
	local current_damage = lerp(5 * base_damage, (1/5) * base_damage, time)
	local current_radius = lerp(radius_max, radius_min, time)

	-- update damage & enable projectile collision
	component_write(projectile_comp, {damage = current_damage, collide_with_entities = true})

	-- update visuals
	local comp = EntityGetFirstComponent(entity_id, "ParticleEmitterComponent")
	ComponentSetValue2(comp, "area_circle_radius", current_radius, current_radius)
end
