-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")

function spawn_small_enemies(x, y)
end
function spawn_big_enemies(x, y)
end
function spawn_items(x, y)
end
function spawn_props(x, y)
end
function spawn_props2(x, y)
end
function spawn_props3(x, y)
end
function load_pixel_scene(x, y)
end
function load_pixel_scene2(x, y)
end
function spawn_unique_enemy(x, y)
end
function spawn_unique_enemy2(x, y)
end
function spawn_unique_enemy3(x, y)
end
function spawn_ghostlamp(x, y)
end
function spawn_candles(x, y)
end
function spawn_potions(x, y)
end

function init(x, y, w, h)
	LoadPixelScene(
		"mods/purgatory/files/biome_impl/debug/spawn_platform.png",
		"mods/purgatory/files/biome_impl/debug/spawn_platform_visual.png",
		x,
		y,
		"mods/purgatory/files/biome_impl/debug/spawn_platform_background.png",
		true
	)
end
