CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff31d0b4, "spawn_boss")
RegisterSpawnFunction(0xfffffe00, "spawn_center_point")
RegisterSpawnFunction(0xfffffd00, "spawn_outer_ring_point")
RegisterSpawnFunction(0xfffffc00, "spawn_activation_trigger")

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
function spawn_lamp(x, y)
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
function spawn_wands(x, y)
end
function spawn_orb(x, y)
end

function init(x, y, w, h)
	LoadPixelScene("mods/purgatory/files/biome_impl/roboroom/roboroom_mat.png", "", x - 44, y - 44, "", true)
end

function spawn_boss(x, y)
	EntityLoad( "data/entities/animals/boss_robot/boss_robot.xml", x, y )
end

function spawn_center_point(x, y)
	EntityLoad("mods/purgatory/files/entities/buildings/roboroom/center_point.xml", x-0.5, y-0.5)
end

function spawn_outer_ring_point(x, y)
	EntityLoad("mods/purgatory/files/entities/buildings/roboroom/mecha_turret.xml", x, y)
end

function spawn_activation_trigger(x, y)
	EntityLoad("mods/purgatory/files/entities/buildings/roboroom/activation_trigger.xml", x, y)
end