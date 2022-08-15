dofile_once("data/scripts/lib/utilities.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	local flag_status = HasFlagPersistent("purgatory_alchemist_spells")

	local pw = check_parallel_pos(x)
	SetRandomSeed(pw, 60)

	local opts_materials = {"MATERIAL_ACID", "MATERIAL_CEMENT", "MATERIAL_BLOOD", "MATERIAL_OIL", "MATERIAL_WATER", "MATERIAL_LAVA", "MATERIAL_GUNPOWDER_EXPLOSIVE", "MATERIAL_DIRT", "MATERIAL_URINE"}
	local opts_touchies = {"TOUCH_GOLD", "TOUCH_WATER", "TOUCH_OIL", "TOUCH_ALCOHOL", "TOUCH_BLOOD", "TOUCH_SMOKE"}
	local opts_circles = {"CIRCLE_FIRE", "CIRCLE_ACID", "CIRCLE_OIL", "CIRCLE_WATER"}
	local opts_seas = {"SEA_LAVA", "SEA_ALCOHOL", "SEA_OIL", "SEA_WATER", "SEA_ACID", "SEA_ACID_GAS"}
	local opts_chaos = {"TRANSMUTATION", "CHAOTIC_TRAIL"}
	local opts_summons = {"SUMMON_POTION_FLASK", "SUMMON_POWDER_SACK"}

	--Create list of spells to drop
	local spells_to_drop = {}

	if Random(0, 1) == 0 then
		spells_to_drop[1] = random_from_array(opts_materials)
	else
		spells_to_drop[1] = random_from_array(opts_touchies)
	end

	if Random(0, 1) == 0 then
		spells_to_drop[2] = random_from_array(opts_circles)
	else
		spells_to_drop[2] = random_from_array(opts_seas)
	end

	spells_to_drop[3] = random_from_array(opts_chaos)
	spells_to_drop[4] = random_from_array(opts_summons)

	for i, spell in ipairs(spells_to_drop) do
		CreateItemActionEntity(spell, x - 8 * 4 + (i - 1) * 16, y)
	end

	EntityLoad("data/entities/items/pickup/heart_fullhp.xml", x - 10, y)
	EntityLoad("mods/purgatory/files/entities/items/pickup/haste_stone.xml", x + 10, y)

	AddFlagPersistent("purgatory_alchemist_spells")
	AddFlagPersistent("miniboss_alchemist")
end
