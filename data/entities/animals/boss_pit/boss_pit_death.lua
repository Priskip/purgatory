dofile_once("data/scripts/lib/utilities.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	local flag_status = HasFlagPersistent("card_unlocked_duplicate")

	local pw = check_parallel_pos(x)
	SetRandomSeed(pw, 120)

	local opts = {"ALPHA", "OMEGA", "GAMMA", "MU", "RESET", "ZETA", "PHI", "TAU", "SIGMA"}
	local rnd = Random(1, #opts)

	if flag_status then
		for i = 1, 4 do
			rnd = Random(1, #opts)
			CreateItemActionEntity(opts[rnd], x - 8 * 4 + (i - 1) * 16, y)
			table.remove(opts, rnd)
		end
	else
		for i = 1, 4 do
			rnd = Random(1, #opts)
			CreateItemActionEntity(opts[rnd], x - 8 * 4 + (i - 1) * 16, y)
			table.remove(opts, rnd)
		end
		EntityLoad("data/entities/items/pickup/heart_fullhp.xml", x, y)
	end

	AddFlagPersistent("card_unlocked_duplicate")
	AddFlagPersistent("miniboss_pit")

	--Kill all wand mimics in area
	local mimic_wands_in_area = EntityGetInRadiusWithTag(x, y, 240, "wand_ghost_mimic")

	for i, ghost_id in ipairs(mimic_wands_in_area) do
		EntityKill(ghost_id)
	end
end
