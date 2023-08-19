dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/misc/glimmered_spell_list.lua")

--Declare Vars needed.
local proj_ent_id = GetUpdatedEntityID()
local colour, particle = nil, nil

--Get colour name from var storage component that gets attached to the projectile entity.
local var_storage_comps = EntityGetComponent(proj_ent_id, "VariableStorageComponent")
if (var_storage_comps ~= nil) then
	for i, v in ipairs(var_storage_comps) do
		local name = ComponentGetValue2(v, "name")

		if (name == "colour_name") then
			colour = ComponentGetValue2(v, "value_string")
		end
	end
end

--Data of particle types.
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
		particles = {"spark_red", "spark", "spark_yellow", "spark_green", "plasma_fading", "spark_purple_bright"},
		colour_names = {"red", "orange", "yellow", "green", "blue", "purple"} --used for setting custom colour sprite components
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

--If colour was found, set colour.
if colour ~= nil then
	--Get Particle Type
	if (data[colour].particles ~= nil) then
		--If there are multiple particle types present, then select one at random.
		SetRandomSeed(proj_ent_id, proj_ent_id)
		local rnd_num = Random(1, #data[colour].particles)
		particle = data[colour].particles[rnd_num]

		if data[colour].colour_names ~= nil then
			--Get the colour associated with the randomly selected particle type if such table exists.
			--This will be used for custom colored sprite components later.
			colour = data[colour].colour_names[rnd_num]
		end
	else
		--Else there is only one particle type, so just use it.
		particle = data[colour].particle
	end

	--Set Particle Emitter Components
	local particle_emitter_comps = EntityGetComponent(proj_ent_id, "ParticleEmitterComponent")
	if (particle_emitter_comps ~= nil) then
		for i, v in ipairs(particle_emitter_comps) do
			local cosmetic = ComponentGetValue2(v, "emit_cosmetic_particles")

			if cosmetic then
				if (particle ~= nil) then
					--Colour particle exists
					ComponentSetValue2(v, "emitted_material_name", particle)
				else
					--Is Invis
					ComponentSetValue2(v, "is_emitting", false)
				end
			end
		end
	end

	--Set Sprite Particle Emitter Components
	local sprite_particle_emitter_comps = EntityGetComponent(proj_ent_id, "SpriteParticleEmitterComponent")
	if (sprite_particle_emitter_comps ~= nil) then
		for i, v in ipairs(sprite_particle_emitter_comps) do
			ComponentSetValue2(v, "is_emitting", false)
		end
	end

	--Set Sprite Components
	local sprite_comps = EntityGetComponent(proj_ent_id, "SpriteComponent")
	if (sprite_comps ~= nil) then
		for i, sprite_comp in ipairs(sprite_comps) do
			local image_file = ComponentGetValue2(sprite_comp, "image_file")
			local sprite_component_information = nil

			--Check to see if custom glimmered spells exist
			for j, w in ipairs(glimmered_spells) do
				if (image_file == w.image_file_path) or (image_file == w.sprite_component_information.image_file) then --2nd value in this if statement is needed in case the player puts multiple glimmers on the same wand
					--Get default glimmer sprite info
					sprite_component_information = w.sprite_component_information.default

					--If a special overwrite for a particular colour exists, use it instead
					if w.sprite_component_information[colour] ~= nil then
						sprite_component_information = w.sprite_component_information[colour]
					end

					break
				end
			end

			if sprite_component_information ~= nil and colour ~= "invis" then
				--Custom coloured sprites exists, remove old sprite component and add a new one to it
				EntityRemoveComponent(proj_ent_id, sprite_comp)

				local new_sprite_comp = EntityAddComponent2(proj_ent_id, "SpriteComponent", sprite_component_information)
				ComponentSetValue2(new_sprite_comp, "rect_animation", colour)
			else
				--Custom coloured sprites do not exist, use vanilla behaviour
				ComponentSetValue2(sprite_comp, "visible", false)
			end
		end
	end

	--Set Config Explosion in Projectile Components
	local projectile_comps = EntityGetComponent(proj_ent_id, "ProjectileComponent")
	if (projectile_comps ~= nil) then
		for i, v in ipairs(projectile_comps) do
			ComponentObjectSetValue2(v, "config_explosion", "explosion_sprite", "")

			if (particle ~= nil) then
				--Colour particle exists
				ComponentObjectSetValue2(v, "config_explosion", "spark_material", particle)
			else
				--Is Invis
				ComponentObjectSetValue2(v, "config_explosion", "material_sparks_enabled", false)
				ComponentObjectSetValue2(v, "config_explosion", "sparks_enabled", false)
			end
		end
	end

	--Set Laser Emitter Components
	local laser_emitter_comps = EntityGetComponent(proj_ent_id, "LaserEmitterComponent")
	if (laser_emitter_comps ~= nil) then
		for i, v in ipairs(laser_emitter_comps) do
			local beam_particle_type = CellFactory_GetType("spark_invis") --default to invis plasma, colour otherwise

			if particle ~= nil then
				--Colour particle exists
				beam_particle_type = CellFactory_GetType(particle)
			end

			ComponentObjectSetValue2(v, "laser", "beam_particle_type", beam_particle_type)
		end
	end
end
