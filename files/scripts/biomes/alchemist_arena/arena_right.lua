CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff4cff03, "spawn_regular_potions" )
RegisterSpawnFunction( 0xff4cff02, "spawn_magical_potions" )
RegisterSpawnFunction( 0xff4cff01, "spawn_sack" )
RegisterSpawnFunction( 0xff4cff00, "spawn_cauldron_liquid" )

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
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_right.png",
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_right_visual.png",
        x, y,
        "mods/purgatory/files/biome_impl/alchemist_arena/arena_right_background.png",
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

function spawn_cauldron_liquid(x, y)
    local liquid_ent = EntityCreateNew()
    EntitySetTransform(liquid_ent, x, y)
    local AP_recipe, LC_recipe = get_AP_LC_RECIPE()
    
    SetRandomSeed(x, y)
    local rand_num = Random(1,3)
    local cauldron_material = AP_recipe[rand_num]

    --print("cauldron_material = "  .. tostring(cauldron_material))

    EntityAddComponent2(liquid_ent, "ParticleEmitterComponent", {
        emitted_material_name=cauldron_material,
        create_real_particles=true,
        lifetime_min=1,
        lifetime_max=1,
        count_min=1,
        count_max=1,
        render_on_grid=true,
        fade_based_on_lifetime=true,
        cosmetic_force_create=false,
        airflow_force=0.251,
        airflow_time=1.01,
        airflow_scale=0.05,
        emission_interval_min_frames=1,
        emission_interval_max_frames=1,
        emit_cosmetic_particles=false,
        image_animation_file="mods/purgatory/files/biome_impl/alchemist_arena/cauldron_liquid.png",
        image_animation_speed=1,
        image_animation_loop=false,
        image_animation_raytrace_from_center=true,
        collide_with_gas_and_fire=false,
        set_magic_creation=true,
        is_emitting=true
    })

    EntityKill(liquid_ent)

end