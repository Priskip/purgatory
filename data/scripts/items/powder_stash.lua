dofile_once("data/scripts/lib/utilities.lua")

materials_standard = {
	{
		material = "sand",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "soil",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "snow",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "salt",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "coal",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "gunpowder",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "fungisoil",
		min_percent = 60,
		max_percent = 80
	}
}

materials_magic = {
	{
		material = "copper",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "silver",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "gold",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "brass",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "bone",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "purifying_powder",
		min_percent = 60,
		max_percent = 80
	},
	{
		material = "fungi",
		min_percent = 60,
		max_percent = 80
	}
}

function normal_powder_stash_generation(entity_id, barrel_size)
	local powder_stash_info = {}

	if Random(0, 100) <= 50 then
		--50% chance of magical liquids	(nerf from vanilla where it was 75% chance of magical)
		powder_stash_info = random_from_array(materials_magic)
	else
		--50 chance of standard liquids
		powder_stash_info = random_from_array(materials_standard)
	end

	if powder_stash_info.min_percent ~= nil and powder_stash_info.max_percent ~= nil then
		--Random range for amount of material has been specified, use it
		AddMaterialInventoryMaterial(entity_id, powder_stash_info.material, barrel_size * 0.01 * Random(powder_stash_info.min_percent, powder_stash_info.max_percent))
	else
		--Random range for amount of material has not been specified. User must have a mod that doesn't add these values.
		AddMaterialInventoryMaterial(entity_id, powder_stash_info.material, barrel_size)
	end
end

function holiday_specials()
	local powder_stash_info = nil
	local year, month, day, temp1, temp2, temp3, jussi = GameGetDateAndTimeLocal() --Note Priskip: "dafuq is a Jussi?"

	--No Holiday info for pouches in vanilla - may add my own

	return powder_stash_info
end

function init(entity_id)
	local x, y = EntityGetTransform(entity_id)
	SetRandomSeed(x, y) -- so that all the powder_stashs will be the same in every position with the same seed

	--Find variable storage components on this powder_stash that will tell the generation to behave differently
	local powder_stash_material = nil
	local material_list_type = nil
	local material_string = nil
	local ignore_holidays = nil
	local var_storage_comps = EntityGetComponent(entity_id, "VariableStorageComponent")

	if var_storage_comps ~= nil then
		for i, var_comp in ipairs(var_storage_comps) do
			local name = ComponentGetValue2(var_comp, "name")

			if name == "powder_stash_material" then
				powder_stash_material = ComponentGetValue2(var_comp, "value_string")
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

	--For Extra powder_stash and Sack Capacity Perk
	local capacity_multiplier = tonumber(GlobalsGetValue("EXTRA_POTION_AND_SACK_CAPACITY_MULTIPLIER", "1"))
	local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")
	local barrel_size = capacity_multiplier * 1500
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

	if powder_stash_material ~= nil then
		--Case "powder_stash_material" (Vanilla's way of Setting powder_stash Contents)
		AddMaterialInventoryMaterial(entity_id, powder_stash_material, barrel_size)
	elseif material_list_type ~= nil and (material_list_type == "standard" or material_list_type == "magical") then
		--Case "material_list_type" (Generate a random powder_stash from specified list)
		local powder_stash_info = {}

		if material_list_type == "standard" then
			powder_stash_info = random_from_array(materials_standard)
		elseif material_list_type == "magical" then
			powder_stash_info = random_from_array(materials_magic)
		end

		if powder_stash_info.min_percent ~= nil and powder_stash_info.max_percent ~= nil then
			--Random range for amount of material has been specified, use it
			AddMaterialInventoryMaterial(entity_id, powder_stash_info.material, barrel_size * 0.01 * Random(powder_stash_info.min_percent, powder_stash_info.max_percent))
		else
			--Random range for amount of material has not been specified. User must have a mod that doesn't add these values.
			AddMaterialInventoryMaterial(entity_id, powder_stash_info.material, barrel_size)
		end
	elseif material_string ~= nil then
		--Case "material_string" (Generate a powder_stash with exact contents specified)
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
		--Else Generate a powder_stash as normal

		--For generating holiday specific powder_stashs
		local holdiday_override = nil
		if ignore_holidays ~= true then
			holdiday_override = holiday_specials()
		end

		if holdiday_override ~= nil then
			--Generate Holiday Specific powder_stash
			AddMaterialInventoryMaterial(entity_id, holdiday_override.material, barrel_size * 0.01 * Random(holdiday_override.min_percent, holdiday_override.max_percent))
		else
			--Generate normal powder_stash
			normal_powder_stash_generation(entity_id, barrel_size)
		end
	end
end
