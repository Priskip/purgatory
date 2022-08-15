-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

------------ SMALL ENEMIES ----------------------------------------------------

------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

------------ MISC --------------------------------------

-- actual functions that get called from the wang generator


-- actual functions that get called from the wang generator

function init(x, y, w, h)
	parallel_check( x, y )
	LoadPixelScene( "mods/purgatory/files/biome_impl/pitboss_arena/1.png", "mods/purgatory/files/biome_impl/pitboss_arena/1_visual.png", x, y, "mods/purgatory/files/biome_impl/pitboss_arena/1_background.png", true )
end

function spawn_small_enemies(x, y)
end

function spawn_big_enemies(x, y)
end

function spawn_items(x, y)
	return
end

function spawn_unique_enemy(x, y)
end

function spawn_lamp(x, y)
end

function spawn_props(x, y)
	return
end

function spawn_potions( x, y ) end

function spawn_shopitem( x, y )
end

function spawn_specialshop( x, y )
end

function spawn_treasure( x, y )
end

function spawn_music_machine( x, y )
end
