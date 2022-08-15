-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile("data/scripts/items/generate_shop_item.lua")
dofile("data/scripts/biomes/temple_shared.lua")
dofile_once("data/scripts/biomes/temple_altar_top_shared.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff6d934c, "spawn_hp")
RegisterSpawnFunction(0xff33934c, "spawn_shopitem")
RegisterSpawnFunction(0xff33935F, "spawn_cheap_shopitem")
RegisterSpawnFunction(0xff10822d, "spawn_workshop")
RegisterSpawnFunction(0xff5a822d, "spawn_workshop_extra")
RegisterSpawnFunction(0xffFAABBA, "spawn_motordoor")
RegisterSpawnFunction(0xffFAABBB, "spawn_pressureplate")
RegisterSpawnFunction(0xffFF5A0A, "spawn_music_trigger")
RegisterSpawnFunction(0xff667e0a, "spawn_duplicator")
RegisterSpawnFunction(0xff03DEAD, "spawn_areachecks")
RegisterSpawnFunction(0xffc128ff, "spawn_rubble")
RegisterSpawnFunction(0xffa7a707, "spawn_lamp_long")
RegisterSpawnFunction(0xff80FF5A, "spawn_vines")
RegisterSpawnFunction(0xff9f2a00, "spawn_statue")
RegisterSpawnFunction(0xff42ff00, "load_bottle_stand_ent")
RegisterSpawnFunction(0xff42ff01, "load_potion_storare")
RegisterSpawnFunction(0xff42ff02, "load_potion_storare_initializer")

g_lamp = {
	total_prob = 0,
	{
		prob = 1.0,
		min_count = 1,
		max_count = 1,
		entity = ""
	},
	{
		prob = 1.0,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics/temple_lantern.xml"
	}
}

g_fish = {
	total_prob = 0,
	-- add skullflys after this step
	{
		prob = 1.0,
		min_count = 1,
		max_count = 4,
		entity = "data/entities/animals/fish.xml"
	},
	{
		prob = 1.0,
		min_count = 1,
		max_count = 1,
		entity = ""
	}
}

g_rubble = {
	total_prob = 0,
	-- add skullflys after this step
	{
		prob = 2.0,
		min_count = 1,
		max_count = 1,
		entity = ""
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_01.xml"
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_02.xml"
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_03.xml"
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_04.xml"
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_05.xml"
	},
	{
		prob = 0.1,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/props/physics_temple_rubble_06.xml"
	}
}

g_vines = {
	total_prob = 0,
	{
		prob = 0.5,
		min_count = 1,
		max_count = 1,
		entity = ""
	},
	{
		prob = 0.4,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine.xml"
	},
	{
		prob = 0.3,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_long.xml"
	},
	{
		prob = 0.2,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob = 0.2,
		min_count = 1,
		max_count = 1,
		entity = "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
	}
}

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
	spawn_altar_top(x, y, false)
	LoadPixelScene(
		"mods/purgatory/files/biome_impl/temple/altar_left.png",
		"mods/purgatory/files/biome_impl/temple/altar_left_visual.png",
		x,
		y - 40 + 300,
		"mods/purgatory/files/biome_impl/temple/altar_left_background.png",
		true
	)
end

function spawn_hp(x, y)
	EntityLoad("data/entities/items/pickup/heart_fullhp_temple.xml", x - 16, y)
	EntityLoad("data/entities/items/pickup/heart_refresh.xml", x + 16, y)
end

function spawn_shopitem(x, y)
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item(x, y, false)
end

function spawn_cheap_shopitem(x, y)
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	generate_shop_item(x, y, true)
end

function spawn_workshop(x, y)
	EntityLoad("data/entities/buildings/workshop.xml", x, y)
end

function spawn_workshop_extra(x, y)
	EntityLoad("data/entities/buildings/workshop_allow_mods.xml", x, y)
end

function spawn_motordoor(x, y)
	EntityLoad("data/entities/props/physics_templedoor2.xml", x, y)
end

function spawn_pressureplate(x, y)
	EntityLoad("data/entities/props/temple_pressure_plate.xml", x, y)
end

function spawn_lamp(x, y)
	spawn(g_lamp, x, y, 0, 10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp, x, y, 0, 15)
end

function spawn_music_trigger(x, y)
	--EntityLoad( "data/entities/buildings/music_trigger_temple_left.xml", x, y )
end

function spawn_duplicator(x, y)
	EntityLoad("data/entities/buildings/temple_duplicator.xml", x, y)
end

function spawn_areachecks(x, y)
	if (temple_should_we_spawn_checkers(x, y)) then
		EntityLoad("data/entities/buildings/temple_areacheck_horizontal.xml", x - 5, y - 101)
		EntityLoad("data/entities/buildings/temple_areacheck_horizontal.xml", x - 10, y + 140)
		EntityLoad("data/entities/buildings/temple_areacheck_vertical.xml", x - 310, y)
		EntityLoad("data/entities/buildings/temple_areacheck_vertical_stub.xml", x - 310, y - 100)
		EntityLoad("mods/purgatory/files/entities/buildings/temple_areacheck_horizontal_stub.xml", x - 310, y - 101)
		EntityLoad("mods/purgatory/files/entities/buildings/temple_areacheck_horizontal_stub.xml", x - 310, y + 140)
	end
end

function spawn_rubble(x, y)
	spawn(g_rubble, x, y, 5, 0)
end

function spawn_vines(x, y)
	spawn(g_vines, x + 5, y + 5)
end

function spawn_statue(x, y)
	local curse = GameHasFlagRun("greed_curse")

	if curse then
		EntityLoad("data/entities/misc/greed_curse/greed_crystal.xml", x, y - 48)
		EntityLoad("data/entities/props/temple_statue_01_green.xml", x, y)
	else
		EntityLoad("data/entities/props/temple_statue_01.xml", x, y)
	end
end

function spawn_fish(x, y)
	local f = GameGetOrbCountAllTime()

	for i = 1, f do
		EntityLoad("data/entities/animals/fish.xml", x, y)
	end
end

function load_bottle_stand_ent(x, y)
	EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/bottle_stand.xml", x, y)
end

function load_potion_storare(x, y)
	local offsets = {
		{0, 0},
		{11, 0},
		{22, 0},
		{33, 0},
		{44, 0},
		{0, 85},
		{11, 85},
		{22, 85},
		{33, 85},
		{44, 85}
	}

	for i, v in ipairs(offsets) do
		local ent_path = "mods/purgatory/files/entities/buildings/temple_alchemy_station/potion_storage/slot_" .. tostring(i - 1) .. ".xml"
		local storage_ent = EntityLoad(ent_path, x + v[1], y + v[2])

		--local particle_ent_path = "mods/purgatory/files/debug_utilities/number_particles/small/" .. tostring(i-1) .. "_small.xml"
		--EntityLoad(particle_ent_path, x + v[1], y - 8 + v[2])
	end
end

function load_potion_storare_initializer(x, y)
	EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/potion_storage_initalizer.xml", x, y)
end
