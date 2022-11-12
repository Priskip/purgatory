dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local boss_id = EntityGetRootEntity(entity_id)
local x, y = EntityGetTransform(boss_id)
local distance_full = 52
local ax, ay = 0

--Set Size based on number of alive turrets in area
local particle_comps = EntityGetComponent(entity_id, "ParticleEmitterComponent")
local alive_turrets = EntityGetInRadiusWithTag(x, y, 1000, "roboroom_mecha_turret_alive")
local number_of_alive_turrets = math.min(#alive_turrets, 8)

for i, comp in ipairs(particle_comps) do
	ComponentSetValue2(comp, "area_circle_sector_degrees", 45 * number_of_alive_turrets)

	if number_of_alive_turrets == 0 then
		ComponentSetValue2(comp, "is_emitting", false)
	elseif number_of_alive_turrets ~= 0 and ComponentGetValue2(comp, "is_emitting") == false then
		ComponentSetValue2(comp, "is_emitting", true)
	end
end

local inner_particles = EntityGetFirstComponentIncludingDisabled(entity_id, "ParticleEmitterComponent", "inner_particles")
ComponentSetValue2(inner_particles, "count_min", 4 * number_of_alive_turrets)
ComponentSetValue2(inner_particles, "count_max", 5 * number_of_alive_turrets)

local outer_wall = EntityGetFirstComponentIncludingDisabled(entity_id, "ParticleEmitterComponent", "outer_wall")
ComponentSetValue2(outer_wall, "count_min", 40 * number_of_alive_turrets)
ComponentSetValue2(outer_wall, "count_max", 60 * number_of_alive_turrets)

--Eater Part
if number_of_alive_turrets > 0 then
	local projectiles = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")

	local varcomps = EntityGetComponent(boss_id, "VariableStorageComponent")
	local players = EntityGetWithTag("player_unit")
	local player_id = players[1] or nil

	EntitySetComponentsWithTagEnabled(entity_id, "boss_robot_spell_eater", true)
	if (player_id ~= nil) then
		local plx, ply = EntityGetTransform(player_id)
		ax, ay = x - plx, y - ply
		local a = math.pi - math.atan2(ay, ax)

		EntitySetTransform(entity_id, x, y, 0 - a)

		if (#projectiles > 0) then
			for i, projectile_id in ipairs(projectiles) do
				local px, py = EntityGetTransform(projectile_id)

				local distance = get_distance(px, py, x, y)
				local direction = get_direction(px, py, x, y)

				local dirdelta = get_direction_difference(direction, a)
				local dirdelta_deg = math.abs(math.deg(dirdelta))

				if (distance < distance_full) and (dirdelta_deg < (number_of_alive_turrets * 45 - 4)) then
					local pcomp = EntityGetFirstComponent(projectile_id, "ProjectileComponent")
					local valid = true

					if (pcomp ~= nil) then
						local whoshot = ComponentGetValue2(pcomp, "mWhoShot")

						if (whoshot == boss_id) then
							valid = false
						else
							ComponentSetValue2(pcomp, "on_death_explode", false)
							ComponentSetValue2(pcomp, "on_lifetime_out_explode", false)
						end
					end

					if valid then
						EntityKill(projectile_id)
					end
				end
			end
		end
	end
end
