-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff00ffff, "spawn_maggot_spot")
RegisterSpawnFunction(0xff639bff, "spawn_edr_fill")
RegisterSpawnFunction(0xffd77bba, "spawn_edr_fill_big")
RegisterSpawnFunction(0xff99e550, "spawn_chunk_loader")

------------ SMALL ENEMIES ----------------------------------------------------
g_small_enemies = {}
------------ BIG ENEMIES ------------------------------------------------------
------------ ITEMS ------------------------------------------------------------
g_items = {}
g_unique_enemy = {}
g_ghostlamp = {}
g_stash = {}
g_candles = {}
g_lamp = {}
g_pumpkins = {}
------------ MISC --------------------------------------

-- actual functions that get called from the wang generator
function init(x, y, w, h)
	parallel_check(x, y)
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

function spawn_potions(x, y) end

function spawn_shopitem(x, y)
end

function spawn_specialshop(x, y)
end

function spawn_treasure(x, y)
end

function spawn_music_machine(x, y)
end

function spawn_maggot_spot(x, y)
	LoadPixelScene(
		"mods/purgatory/files/biome_impl/static_tile/maggot_spot/skull.png",
		"mods/purgatory/files/biome_impl/static_tile/maggot_spot/skull_visual.png",
		x - 193, y - 259,
		"mods/purgatory/files/biome_impl/static_tile/maggot_spot/skull_background.png",
		true
	)
	EntityLoad("data/entities/buildings/maggotspot.xml", x, y) --Spawn Entity Check for Player in Range of Tiny
end

function spawn_edr_fill(x, y)
	EntityLoad("mods/purgatory/files/entities/misc/edr_fill.xml", x, y)
end

function spawn_edr_fill_big(x, y)
	EntityLoad("mods/purgatory/files/entities/misc/edr_fill_big.xml", x, y)
end

function spawn_chunk_loader(x, y)
	EntityLoad("mods/purgatory/files/entities/misc/chunk_loader.xml", x, y)
end
