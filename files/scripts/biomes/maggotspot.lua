-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff00ffff, "spawn_tinys_player_check" )

------------ SMALL ENEMIES ----------------------------------------------------

g_small_enemies ={

}


------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

g_items = {
}

g_unique_enemy = {

}

g_ghostlamp = {

}

g_stash = {

}


g_candles = {

}

g_lamp = {

}

g_pumpkins = {
}

------------ MISC --------------------------------------

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	parallel_check( x, y )
	LoadPixelScene( "mods/purgatory/files/biome_impl/skull.png", "mods/purgatory/files/biome_impl/skull_visual.png", x, y, "mods/purgatory/files/biome_impl/skull_background.png", true )
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

function spawn_tinys_player_check(x,y)
    EntityLoad( "data/entities/buildings/maggotspot.xml", x, y ) --Spawn Entity Check for Player in Range of Tiny
end