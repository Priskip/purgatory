dofile_once("data/scripts/lib/utilities.lua")

function damage_received(damage)
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	local nearby_ents = EntityGetInRadius(x, y, 50)

	local num_of_shield_ents = 0

	for i, ent_id in ipairs(nearby_ents) do
		if EntityGetFilename(ent_id) == "data/entities/animals/boss_alchemist/projectile_counter.xml" then
			num_of_shield_ents = num_of_shield_ents + 1
		end
	end

	if num_of_shield_ents < 10 then
		--Creates a cap on the number of shields to avoid piercing wands on this dude lagging out the game
		local cumulative = 0.0
		local dcomp = 0

		local s = EntityGetComponent(entity_id, "VariableStorageComponent")
		if (s ~= nil) then
			for i, v in ipairs(s) do
				local name = ComponentGetValue2(v, "name")

				if (name == "damage_received") then
					cumulative = ComponentGetValue2(v, "value_float")

					cumulative = cumulative + damage

					ComponentSetValue2(v, "value_float", cumulative)
					dcomp = v
				end
			end
		end

		if (damage >= 2.0) or (cumulative >= 3.0) then
			local x, y = EntityGetTransform(entity_id)

			local eid = EntityLoad("data/entities/animals/boss_alchemist/projectile_counter.xml", x, y)
			EntityAddChild(entity_id, eid)

			if (dcomp ~= NULL_ENTITY) then
				cumulative = cumulative - 3.0
				ComponentSetValue2(dcomp, "value_float", cumulative)
			end
		end
	end
end
