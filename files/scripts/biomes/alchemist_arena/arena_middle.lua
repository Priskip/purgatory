CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff4cff03, "spawn_regular_potions" )
RegisterSpawnFunction( 0xff4cff02, "spawn_magical_potions" )
RegisterSpawnFunction( 0xff4cff01, "spawn_sack" )
RegisterSpawnFunction( 0xff4cff00, "spawn_boss" )


function spawn_small_enemies( x, y ) end
function spawn_big_enemies( x, y ) end
function spawn_items( x, y ) end
function spawn_props( x, y ) end
function spawn_props2( x, y ) end
function spawn_props3( x, y ) end
function spawn_lamp( x, y ) end
function load_pixel_scene( x, y ) end
function load_pixel_scene2( x, y ) end
function spawn_unique_enemy( x, y ) end
function spawn_unique_enemy2( x, y ) end
function spawn_unique_enemy3( x, y ) end
function spawn_ghostlamp( x, y ) end
function spawn_candles( x, y ) end
function spawn_potions( x, y ) end
function spawn_wands( x, y ) end

function init( x, y, w, h )
	LoadPixelScene(
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_middle.png",
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_middle_visual.png",
        x, y,
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_middle_background.png",
        true
    )
end

function spawn_regular_potions(x, y)
    EntityLoad("mods/purgatory/files/entities/items/pickup/potion_regular_material.xml", x, y)
end

function spawn_magical_potions(x, y)
    EntityLoad("mods/purgatory/files/entities/items/pickup/potion_magical_material.xml", x, y)
end

function spawn_sack(x, y)
    EntityLoad("data/entities/items/pickup/powder_stash.xml", x, y)
end

function spawn_boss(x, y)
	EntityLoad( "data/entities/animals/boss_alchemist/boss_alchemist.xml", x + 20, y - 20 )
	--EntityLoad( "data/entities/items/books/book_00.xml", x - 30, y + 40 )
	--EntityLoad( "data/entities/misc/music_energy_000.xml", x, y - 10 )
end