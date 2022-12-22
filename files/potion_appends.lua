--Standard potion materials
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

function init(entity_id)
	local x, y = EntityGetTransform(entity_id)
	SetRandomSeed(x, y) -- so that all the potions will be the same in every position with the same seed

	--for if something specifically tells the entity what potion to be
	local components = EntityGetComponent(entity_id, "VariableStorageComponent")
	if (components ~= nil) then
		for key, comp_id in pairs(components) do
			local var_name = ComponentGetValue(comp_id, "name")
			if (var_name == "potion_material") then
				local potion_material = ComponentGetValue(comp_id, "value_string")
				AddMaterialInventoryMaterial(entity_id, potion_material, 1000)
				break
			end
		end
	else
		--if not, then is a random potion
		local potion = {}
		local max_amount_of_material = 1000 --in case I bring back more potion capacity perk, which I doubt I will -priskip

		if (Random(0, 100) <= 50) then
			-- 50% chance of magic_liquid_
			potion = random_from_array(materials_magic)
		else
			potion = random_from_array(materials_standard)
		end

		AddMaterialInventoryMaterial(entity_id, potion.material, max_amount_of_material * 0.01 * Random(potion.min_percent, potion.max_percent))
	end
end
