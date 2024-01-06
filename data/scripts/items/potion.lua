dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

materials_standard = {
	{
		material = "lava",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "water",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "blood",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "alcohol",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "oil",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "slime",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "acid",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "radioactive_liquid",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "gunpowder_unstable",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "liquid_fire",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "poison",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "glue",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "urine",
		min_percent = 80,
		max_percent = 100
	}
}

materials_magic = {
	{
		material = "magic_liquid_unstable_teleportation",
		min_percent = 50,
		max_percent = 70
	},
	{
		material = "magic_liquid_teleportation",
		min_percent = 20,
		max_percent = 40
	},
	{
		material = "magic_liquid_polymorph",
		min_percent = 20,
		max_percent = 60
	},
	{
		material = "magic_liquid_random_polymorph",
		min_percent = 20,
		max_percent = 60
	},
	{
		material = "magic_liquid_berserk",
		min_percent = 50,
		max_percent = 100
	},
	{
		material = "magic_liquid_charm",
		min_percent = 15,
		max_percent = 35
	},
	{
		material = "magic_liquid_invisibility",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "material_confusion",
		min_percent = 70,
		max_percent = 90
	},
	{
		material = "magic_liquid_movement_faster",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "magic_liquid_faster_levitation",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "magic_liquid_worm_attractor",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "magic_liquid_protection_all",
		min_percent = 15,
		max_percent = 45
	},
	{
		material = "magic_liquid_mana_regeneration",
		min_percent = 90,
		max_percent = 100
	},
	{
		material = "material_rainbow",
		min_percent = 95,
		max_percent = 100
	},
	{
		material = "magic_liquid_hp_regeneration",
		min_percent = 10,
		max_percent = 25
	},
	{
		material = "material_darkness",
		min_percent = 80,
		max_percent = 100
	},
	{
		material = "blood_worm",
		min_percent = 80,
		max_percent = 100
	}
}

function normal_potion_generation(entity_id, barrel_size)
	local potion_info = {}

	if Random(0, 100) <= 50 then
		--50% chance of magical liquids	(nerf from vanilla where it was 75% chance of magical)
		potion_info = random_from_array(materials_magic)
	else
		--50 chance of standard liquids
		potion_info = random_from_array(materials_standard)
	end

	if potion_info.min_percent ~= nil and potion_info.max_percent ~= nil then
		--Random range for amount of material has been specified, use it
		AddMaterialInventoryMaterial(entity_id, potion_info.material, barrel_size * 0.01 * Random(potion_info.min_percent, potion_info.max_percent))
	else
		--Random range for amount of material has not been specified. User must have a mod that doesn't add these values.
		AddMaterialInventoryMaterial(entity_id, potion_info.material, barrel_size)
	end
end

function holiday_specials()
	local potion_info = nil
	local year, month, day, temp1, temp2, temp3, jussi = GameGetDateAndTimeLocal() --Note Priskip: "dafuq is a Jussi?"

	--Vappu
	if (((month == 5) and (day == 1)) or ((month == 4) and (day == 30))) and (Random(0, 100) <= 20) then
		potion_info = {}
		potion_info.material = "sima"
		potion_info.min_percent = 95
		potion_info.max_percent = 100
	end

	--Jussi?
	if (jussi and Random(0, 100) <= 9) then
		potion_info = {}
		potion_info.material = "juhannussima"
		potion_info.min_percent = 95
		potion_info.max_percent = 100
	end

	--Valentine's Day
	if (month == 2 and day == 14 and Random(0, 100) <= 8) then
		potion_info = {}
		potion_info.material = "magic_liquid_charm"
		potion_info.min_percent = 95
		potion_info.max_percent = 100
	end

	return potion_info
end

function init(entity_id)
	local x, y = EntityGetTransform(entity_id)
	SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed

	--Find variable storage components on this potion that will tell the generation to behave differently
	local potion_material = nil
	local material_list_type = nil
	local material_string = nil
	local ignore_holidays = nil
	local var_storage_comps = EntityGetComponent(entity_id, "VariableStorageComponent")

	if var_storage_comps ~= nil then
		for i, var_comp in ipairs(var_storage_comps) do
			local name = ComponentGetValue2(var_comp, "name")

			if name == "potion_material" then
				potion_material = ComponentGetValue2(var_comp, "value_string")
			end

			if name == "material_list_type" then
				material_list_type = ComponentGetValue2(var_comp, "value_string")
			end

			if name == "material_string" then
				material_string = {}
				material_string.string = ComponentGetValue2(var_comp, "value_string")
				material_string.int = ComponentGetValue2(var_comp, "value_int")
			end

			if name == "ignore_holidays" then
				ignore_holidays = ComponentGetValue2(var_comp, "value_bool")
			end
		end
	end

	--For Extra Potion and Sack Capacity Perk
	local capacity_multiplier = tonumber(GlobalsGetValue("EXTRA_POTION_AND_SACK_CAPACITY_MULTIPLIER", "1"))
	local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")
	local barrel_size = capacity_multiplier * 1000
	ComponentSetValue2(material_sucker_comp, "barrel_size", barrel_size)

	--Make ui description show barrel size.
	EntityAddComponent2(
		entity_id,
		"LuaComponent",
		{
			_tags = "enabled_in_hand,enabled_in_world,enabled_in_inventory",
			execute_on_added = false,
			execute_every_n_frame = 5,
			remove_after_executed = true,
			script_source_file = "mods/purgatory/files/scripts/items/barrel_size_displayer.lua"
		}
	)

	if potion_material ~= nil then
		--Case "potion_material" (Vanilla's way of Setting Potion Contents)
		AddMaterialInventoryMaterial(entity_id, potion_material, barrel_size)
	elseif material_list_type ~= nil and (material_list_type == "standard" or material_list_type == "magical") then
		--Case "material_list_type" (Generate a random potion from specified list)
		local potion_info = {}

		if material_list_type == "standard" then
			potion_info = random_from_array(materials_standard)
		elseif material_list_type == "magical" then
			potion_info = random_from_array(materials_magic)
		end

		if potion_info.min_percent ~= nil and potion_info.max_percent ~= nil then
			--Random range for amount of material has been specified, use it
			AddMaterialInventoryMaterial(entity_id, potion_info.material, barrel_size * 0.01 * Random(potion_info.min_percent, potion_info.max_percent))
		else
			--Random range for amount of material has not been specified. User must have a mod that doesn't add these values.
			AddMaterialInventoryMaterial(entity_id, potion_info.material, barrel_size)
		end
	elseif material_string ~= nil then
		--Case "material_string" (Generate a potion with exact contents specified)
		local mat_string = material_string.string
		local mode = material_string.int

		local materials = {}
		local amounts = {}

		for i, v in ipairs(split_string_on_char_into_table(material_string.string, "-")) do
			local mat_and_amounts = split_string_on_char_into_table(v, ",")
			materials[i] = mat_and_amounts[1]
			amounts[i] = mat_and_amounts[2]
		end

		for i, mat in ipairs(materials) do
			if material_string.int == 0 then
				--Add flat values
				AddMaterialInventoryMaterial(entity_id, mat, amounts[i])
			elseif material_string.int == 1 then
				--Add percentages
				AddMaterialInventoryMaterial(entity_id, mat, amounts[i] * 0.01 * barrel_size)
			end
		end
	else
		--Else Generate a potion as normal

		--For generating holiday specific potions
		local holdiday_override = nil
		if ignore_holidays ~= true then
			holdiday_override = holiday_specials()
		end

		if holdiday_override ~= nil then
			--Generate Holiday Specific Potion
			AddMaterialInventoryMaterial(entity_id, holdiday_override.material, barrel_size * 0.01 * Random(holdiday_override.min_percent, holdiday_override.max_percent))
		else
			--Generate normal potion
			normal_potion_generation(entity_id, barrel_size)
		end
	end
end
