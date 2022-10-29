function in_range(num, lower, upper)
	if num >= lower and num <= upper then
		return true
	else
		return false
	end
end

spawnlists = {
	potion_spawnlist = {
		spawns = {
			{
				weight = 390,
				load_entity = "data/entities/items/pickup/potion.xml",
				offset_y = -2
			},
			{
				weight = 60,
				load_entity = "data/entities/items/pickup/powder_stash.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0

					if GameHasFlagRun("greed_curse") and (GameHasFlagRun("greed_curse_gone") == false) then
						EntityLoad("data/entities/items/pickup/physics_greed_die.xml", x + ox, y + oy)
					else
						EntityLoad("data/entities/items/pickup/physics_die.xml", x + ox, y + oy)
					end
				end,
				offset_y = -12,
				spawn_requires_flag = "card_unlocked_duplicate"
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_laser.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_laser.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_fireball.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_fireball.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_lava.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_lava.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_slow.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_slow.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_null.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_null.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_disc.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_disc.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "data/entities/items/pickup/runestones/runestone_metal.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("data/entities/items/pickup/runestones/runestone_metal.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "mods/purgatory/files/entities/items/pickup/runestones/runestone_crosses.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("mods/purgatory/files/entities/items/pickup/runestones/runestone_crosses.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 5,
				load_entity = "mods/purgatory/files/entities/items/pickup/runestones/runestone_polymorph.xml",
				offset_y = -10
			},
			{
				weight = 1,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0
					local entity_id = EntityLoad("mods/purgatory/files/entities/items/pickup/runestones/runestone_polymorph.xml", x + ox, y + oy)
					runestone_activate(entity_id)
				end,
				offset_y = -10
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/egg_monster.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/egg_slime.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/egg_purple.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/brimstone.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/thunderstone.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/waterstone.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/stonestone.xml",
				offset_y = -2
			},
			{
				weight = 6,
				load_entity = "data/entities/items/pickup/poopstone.xml",
				offset_y = -2
			},
			{
				weight = 21,
				load_entity = "data/entities/items/pickup/broken_wand.xml",
				offset_y = -2
			},
			{
				weight = 9,
				load_entity_func = function(data, x, y)
					local ox = data.offset_x or 0
					local oy = data.offset_y or 0

					if GameHasFlagRun("greed_curse") and (GameHasFlagRun("greed_curse_gone") == false) then
						EntityLoad("data/entities/items/pickup/physics_gold_orb_greed.xml", x + ox, y + oy)
					else
						EntityLoad("data/entities/items/pickup/physics_gold_orb.xml", x + ox, y + oy)
					end
				end,
				offset_y = -2
			},
			{
				weight = 2,
				load_entity = "mods/purgatory/files/entities/items/books/overstock_scroll.xml",
				offset_y = -10
			}
		}
	},
	potion_spawnlist_liquidcave = potion_spawnlist
}

--[[
	How this gets called
	spawn_from_list( "potion_spawnlist", x, y )
]]
function spawn_from_list(listname, x, y)
	SetRandomSeed(x + 425, y - 243)
	local spawnlist

	if (type(listname) == "string") then
		spawnlist = spawnlists[listname]
	elseif (type(listname) == "table") then
		spawnlist = listname
	end

	if (spawnlist == nil) then
		print("Couldn't find a spawn list with name: " .. tostring(listname))
		return
	end

	local rndmax = 0
	for i, v in ipairs(spawnlist.spawns) do
		rndmax = rndmax + v.weight
	end

	local rnd = Random(1, rndmax)
	local count = 0

	if (spawnlist.spawns ~= nil) then
		for i, data in ipairs(spawnlist.spawns) do
			if in_range(rnd, count, count + data.weight) then
				if (data.spawn_requires_flag ~= nil) and (HasFlagPersistent(data.spawn_requires_flag) == false) then
					return
				end

				local ox = data.offset_x or 0
				local oy = data.offset_y or 0

				if (data.load_entity_func ~= nil) then
					data.load_entity_func(data, x, y)
					return
				elseif (data.load_entity_from_list ~= nil) then
					spawn_from_list(data.load_entity_from_list, x, y)
					return
				elseif (data.load_entity ~= nil) then
					EntityLoad(data.load_entity, x + ox, y + oy)
					return
				end
			else
				count = count + data.weight
			end
		end
	end
end
