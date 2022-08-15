CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xffd0d0b4, "spawn_avarice_check" )

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

--[[
	<PixelScene 
	DEBUG_RELOAD_ME="0" 
	background_filename="data/biome_impl/greed_treasure_background.png" 
	clean_area_before="0" 
	colors_filename="" 
	material_filename="data/biome_impl/greed_treasure.png" 
	pos_x="9216" 
	pos_y="4096" 
	skip_biome_checks="1" 
	skip_edge_textures="0" >
	</PixelScene>

]]

function init( x, y, w, h )
	LoadPixelScene( "data/biome_impl/greed_treasure.png", "", x, y, "data/biome_impl/greed_treasure_background.png", true )
end

function spawn_orb(x, y)
end

function spawn_avarice_check(x, y)
	EntityLoad( "mods/purgatory/files/entities/buildings/avarice_checker.xml", x, y )
end