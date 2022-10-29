dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local player_id = getPlayerEntity()

local distance_max = 150

local t = ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted")
local f = math.floor(t / 4) --Note Priskip: I have the animations of the blackhole shot change every 4 frames

--Cosmetic stuff
local particle_emitter_comp = EntityGetFirstComponent(entity_id, "ParticleEmitterComponent", "blackhole_shot")
local light_comp = EntityGetFirstComponent(entity_id, "LightComponent", "blackhole_shot")
if f < 22 then
	ComponentSetValue2(particle_emitter_comp, "x_pos_offset_min", -math.max(1, f - 10))
	ComponentSetValue2(particle_emitter_comp, "x_pos_offset_max", math.max(1, f - 10))
	ComponentSetValue2(particle_emitter_comp, "y_pos_offset_min", -math.max(1, f - 10))
	ComponentSetValue2(particle_emitter_comp, "y_pos_offset_max", math.max(1, f - 10))

	ComponentSetValue2(light_comp, "radius", f)
end

--Damage nearby entities
local damage_targets = EntityGetInRadiusWithTag(x, y, math.min(t, 22), "mortal")
local projectile_comp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local damage = ComponentGetValue2(projectile_comp, "damage")
for i, v in ipairs(damage_targets) do
	EntityInflictDamage(v, damage, "DAMAGE_PROJECTILE", "damage_projectile", "DISINTEGRATED", 0, 0, player_id)
end

--physics stuff
function calculate_force_at(body_x, body_y)
	local distance = math.sqrt((x - body_x) ^ 2 + (y - body_y) ^ 2)
	local direction = 0 - math.atan2((y - body_y), (x - body_x))

	local gravity_percent = (distance_max - distance) / distance_max
	local gravity_coeff = 256 --originally 196

	local fx = math.cos(direction) * (gravity_coeff * gravity_percent)
	local fy = -math.sin(direction) * (gravity_coeff * gravity_percent)

	return fx, fy
end

-- attract projectiles (don't attract self)
local entities = EntityGetInRadiusWithTag(x, y, distance_max, "projectile")
for _, id in ipairs(entities) do
	local physicscomp = EntityGetFirstComponent(id, "PhysicsBody2Component") or EntityGetFirstComponent(id, "PhysicsBodyComponent")
	if physicscomp == nil and not EntityHasTag(id, "black_hole") and id ~= entity_id then
		local px, py = EntityGetTransform(id)

		local velocitycomp = EntityGetFirstComponent(id, "VelocityComponent")
		if (velocitycomp ~= nil) then
			local fx, fy = calculate_force_at(px, py)
			edit_component(
				id,
				"VelocityComponent",
				function(comp, vars)
					local vel_x, vel_y = ComponentGetValue2(comp, "mVelocity")

					vel_x = vel_x + fx
					vel_y = vel_y + fy

					ComponentSetValue2(comp, "mVelocity", vel_x, vel_y)
				end
			)
		end
	end
end

-- force field for physics bodies
function calculate_force_for_body(entity, body_mass, body_x, body_y, body_vel_x, body_vel_y, body_vel_angular)
	local fx, fy = calculate_force_at(body_x, body_y)

	fx = fx * 0.2 * body_mass
	fy = fy * 0.2 * body_mass

	return body_x, body_y, fx, fy, 0 -- forcePosX,forcePosY,forceX,forceY,forceAngular
end
local size = distance_max * 0.5
PhysicsApplyForceOnArea(calculate_force_for_body, entity_id, x - size, y - size, x + size, y + size)
