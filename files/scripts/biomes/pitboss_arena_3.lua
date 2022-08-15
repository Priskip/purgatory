-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffffe15e, "spawn_wand" )

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	parallel_check( x, y )
	LoadPixelScene( "mods/purgatory/files/biome_impl/pitboss_arena/3.png", "mods/purgatory/files/biome_impl/pitboss_arena/3_visual.png", x, y, "mods/purgatory/files/biome_impl/pitboss_arena/3_background.png", true )
end

function spawn_wand(x, y)
	EntityLoad("mods/purgatory/files/entities/animals/boss_pit/trapped_wand.xml", x, y)
end