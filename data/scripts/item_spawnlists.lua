spawnlists =
{
	potion_spawnlist =
	{
		rnd_min = 1,
		rnd_max = 101,
		spawns = 
		{
			{
				value_min = 100,
				value_max = 101,
				load_entity = "data/entities/items/pickup/waterstone.xml",
				offset_y = -2,
			},
			{
				value_min = 98,
				value_max = 99,
				load_entity = "data/entities/items/pickup/stonestone.xml",
				offset_y = -2,
			},
			{
				value_min = 96,
				value_max = 97,
				load_entity = "data/entities/items/pickup/poopstone.xml",
				offset_y = -2,
			},
			{
				value_min = 94,
				value_max = 95,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0
						
						if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
							EntityLoad( "data/entities/items/pickup/physics_gold_orb_greed.xml", x + ox, y + oy )
						else
							EntityLoad( "data/entities/items/pickup/physics_gold_orb.xml", x + ox, y + oy )
						end
					end,
				offset_y = -2,
			},
			{
				value_min = 92,
				value_max = 93,
				load_entity = "data/entities/items/pickup/broken_wand.xml",
				offset_y = -2,
			},
			{
				value_min = 90,
				value_max = 91,
				load_entity = "data/entities/items/pickup/thunderstone.xml",
				offset_y = -2,
			},
			{
				value_min = 88,
				value_max = 89,
				load_entity = "data/entities/items/pickup/brimstone.xml",
				offset_y = -2,
			},
			{
				value_min = 86,
				value_max = 87,
				load_entity = "data/entities/items/pickup/egg_monster.xml",
				offset_y = -2,
			},
			{
				value_min = 82,
				value_max = 85,
				load_entity = "data/entities/items/pickup/egg_slime.xml",
				offset_y = -2,
			},
			{
				value_min = 81,
				value_max = 81,
				load_entity = "data/entities/items/pickup/egg_purple.xml",
				offset_y = -2,
			},
			{
				value_min = 72,
				value_max = 80,
				load_entity_func =
					function(data, x, y)
						-- NOTE( Petri ): 6.3.2023 - Changed the SetRandomSeed to be different, so that we might get other runestones than edges
						-- NOTE( Priskip ): 3/6/23 - Reverted what I had done with seperating these into seperate entries becuase Petri fixed the SetRandomSeed
						SetRandomSeed(x + 2617.941, y - 1229.3581)
						local opts = { "laser", "fireball", "lava", "slow", "null", "disc", "metal" }
						local modded_opts = { "crosses", "polymorph" }

						local rnd = Random(1, #opts + #modded_opts)
						local vanilla_or_modded = ""
						if (rnd <= #opts) then
							vanilla_or_modded = "vanilla"
						else
							vanilla_or_modded = "modded"
						end

						if vanilla_or_modded == "vanilla" then
							rnd = Random(1, #opts)
							local opt = opts[rnd]
							local ox = data.offset_x or 0
							local oy = data.offset_y or 0
							local entity_id = EntityLoad(
								"data/entities/items/pickup/runestones/runestone_" .. opt .. ".xml", x + ox, y + oy)

							rnd = Random(1, 10)
							if (rnd == 2) then
								runestone_activate(entity_id)
							end
						end

						if vanilla_or_modded == "modded" then
							rnd = Random(1, #modded_opts)
							local opt = modded_opts[rnd]
							local ox = data.offset_x or 0
							local oy = data.offset_y or 0
							local entity_id = EntityLoad(
								"mods/purgatory/files/entities/items/pickup/runestones/runestone_" .. opt .. ".xml",
								x + ox, y + oy)

							rnd = Random(1, 10)
							if (rnd == 2) then
								runestone_activate(entity_id)
							end
						end
					end,
				offset_y = -10,
			},
			{
				value_min = 71,
				value_max = 71,
				load_entity_func = 
					function( data, x, y )
						local ox = data.offset_x or 0
						local oy = data.offset_y or 0
						
						if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
							EntityLoad( "data/entities/items/pickup/physics_greed_die.xml", x + ox, y + oy )
						else
							EntityLoad( "data/entities/items/pickup/physics_die.xml", x + ox, y + oy )
						end
					end,
				offset_y = -12,
				spawn_requires_flag = "card_unlocked_duplicate",
			},
			{
				value_min = 66,
				value_max = 70,
				load_entity = "data/entities/items/pickup/powder_stash.xml",
				offset_y = -2,
			},
			{
				value_min = 1,
				value_max = 65,
				load_entity = "data/entities/items/pickup/potion.xml",
				offset_y = -2,
			},
		},
	},
	potion_spawnlist_liquidcave =
	{
		rnd_min = 1,
		rnd_max = 92,
		spawns = 
		{
			{
				value_min = 91,
				value_max = 92,
				load_entity = "data/entities/items/pickup/waterstone.xml",
				offset_y = -2,
			},
			{
				value_min = 89,
				value_max = 90,
				load_entity = "data/entities/items/pickup/stonestone.xml",
				offset_y = -2,
			},
			{
				value_min = 87,
				value_max = 88,
				load_entity = "data/entities/items/pickup/poopstone.xml",
				offset_y = -2,
			},
			{
				value_min = 83,
				value_max = 86,
				load_entity = "data/entities/items/pickup/broken_wand.xml",
				offset_y = -2,
			},
			{
				value_min = 77,
				value_max = 82,
				load_entity = "data/entities/items/pickup/moon.xml",
				offset_y = -2,
			},
			{
				value_min = 71,
				value_max = 76,
				load_entity = "data/entities/items/pickup/thunderstone.xml",
				offset_y = -2,
			},
			{
				value_min = 65,
				value_max = 70,
				load_entity = "data/entities/items/pickup/brimstone.xml",
				offset_y = -2,
			},
			{
				value_min = 59,
				value_max = 64,
				load_entity = "data/entities/items/pickup/egg_monster.xml",
				offset_y = -2,
			},
			{
				value_min = 56,
				value_max = 58,
				load_entity = "data/entities/items/pickup/egg_slime.xml",
				offset_y = -2,
			},
			{
				value_min = 53,
				value_max = 55,
				load_entity = "data/entities/items/pickup/egg_fire.xml",
				offset_y = -2,
			},
			{
				value_min = 50,
				value_max = 52,
				load_entity = "data/entities/items/pickup/egg_purple.xml",
				offset_y = -2,
			},
			{
				value_min = 1,
				value_max = 49,
				load_entity = "data/entities/items/pickup/potion.xml",
				offset_y = -2,
			},
		},
	},
}

function spawn_from_list( listname, x, y )
	SetRandomSeed( x+425, y-243 )
	local spawnlist
	
	if ( type( listname ) == "string" ) then
		spawnlist = spawnlists[listname]
	elseif ( type( listname ) == "table" ) then
		spawnlist = listname
	end
	
	if ( spawnlist == nil ) then
		print( "Couldn't find a spawn list with name: " .. tostring( listname ) )
		return
	end
	
	local rndmin = spawnlist.rnd_min or 0
	local rndmax = spawnlist.rnd_max or 100
	
	local rnd = Random( rndmin, rndmax )
	
	if ( spawnlist.spawns ~= nil ) then
		for i,data in ipairs( spawnlist.spawns ) do
			local vmin = data.value_min or rndmin
			local vmax = data.value_max or rndmax
			
			if ( rnd >= vmin ) and ( rnd <= vmax ) then
				if ( data.spawn_requires_flag ~= nil ) and ( HasFlagPersistent( data.spawn_requires_flag ) == false ) then
					return
				end
				
				local ox = data.offset_x or 0
				local oy = data.offset_y or 0
				
				if ( data.load_entity_func ~= nil ) then
					data.load_entity_func( data, x, y )
					return
				elseif ( data.load_entity_from_list ~= nil ) then
					spawn_from_list( data.load_entity_from_list, x, y )
					return
				elseif ( data.load_entity ~= nil ) then
					EntityLoad( data.load_entity, x + ox, y + oy )
					return
				end
			end
		end
	end
end