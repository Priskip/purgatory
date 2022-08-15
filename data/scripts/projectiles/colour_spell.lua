dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local colour, particle

local comps = EntityGetComponent(entity_id, "VariableStorageComponent")
if (comps ~= nil) then
	for i, v in ipairs(comps) do
		local name = ComponentGetValue2(v, "name")

		if (name == "colour_name") then
			colour = ComponentGetValue2(v, "value_string")
		end
	end
end

local data = {
	red = {
		particle = "spark_red"
	},
	orange = {
		particle = "spark"
	},
	yellow = {
		particle = "spark_yellow"
	},
	green = {
		particle = "spark_green"
	},
	blue = {
		particle = "plasma_fading"
	},
	purple = {
		particle = "spark_purple_bright"
	},
	random = {
		particles = {"spark_red", "spark", "spark_yellow", "spark_green", "plasma_fading", "spark_purple_bright"}
	},
	rainbow = {
		particle = "material_rainbow"
	},
	white = {
		particle = "spark_white"
	},
	black = {
		particle = "spark_black"
	},
	invis = {}
}

if (colour ~= nil) then
	local d = data[colour] or {}
	particle = d.particle

	if (d.particles ~= nil) then
		SetRandomSeed(entity_id, entity_id)
		local rnd = Random(1, #d.particles)
		particle = d.particles[rnd]
	end

	comps = EntityGetComponent(entity_id, "ParticleEmitterComponent")
	if (comps ~= nil) then
		for i, v in ipairs(comps) do
			local cosmetic = ComponentGetValue2(v, "emit_cosmetic_particles")

			if cosmetic then
				if (particle ~= nil) then
					ComponentSetValue2(v, "emitted_material_name", particle)
				else
					ComponentSetValue2(v, "is_emitting", false)
				end
			end
		end
	end

	comps = EntityGetComponent(entity_id, "SpriteParticleEmitterComponent")
	if (comps ~= nil) then
		for i, v in ipairs(comps) do
			ComponentSetValue2(v, "is_emitting", false)
		end
	end

	comps = EntityGetComponent(entity_id, "SpriteComponent")
	if (comps ~= nil) then
		for i, v in ipairs(comps) do
			ComponentSetValue2(v, "visible", false)
		end
	end

	comps = EntityGetComponent(entity_id, "ProjectileComponent")
	if (comps ~= nil) then
		for i, v in ipairs(comps) do
			ComponentObjectSetValue2(v, "config_explosion", "explosion_sprite", "")

			if (particle ~= nil) then
				ComponentObjectSetValue2(v, "config_explosion", "spark_material", particle)
			else
				ComponentObjectSetValue2(v, "config_explosion", "material_sparks_enabled", false)
				ComponentObjectSetValue2(v, "config_explosion", "sparks_enabled", false)
			end
		end
	end

	--New! Laser Colours
	comps = EntityGetComponent(entity_id, "LaserEmitterComponent")
	if (comps ~= nil) then
		for i, comp in ipairs(comps) do
			local beam_particle_type = CellFactory_GetType("spark_invis")

			if particle ~= nil then
				beam_particle_type = CellFactory_GetType(particle)
			end

			ComponentObjectSetValue2(comp, "laser", "beam_particle_type", beam_particle_type)
		end
	end
end
