dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

RegisterSpawnFunction(0xffffeedd, "init")



function init(x, y, w, h)
    print("Purgatory: loading static wang test")

    --LoadPixelScene("mods/purgatory/files/biome_impl/debug/empty_material.png", "mods/purgatory/files/biome_impl/debug/static_test_visual.png", x, y, "", true)
end


-- LoadPixelScene("mods/purgatory/files/biome_impl/debug/empty_material.png", "mods/purgatory/files/biome_impl/debug/static_test_visual.png", -1536, 8192, "")

-- LoadPixelScene( 
--     materials_filename:string, 
--     colors_filename:string, 
--     x:number, 
--     y:number, 
--     background_file:string, 
--     skip_biome_checks:bool = false, 
--     skip_edge_textures:bool = false, 
--     color_to_material_table:{string-string} = {}, 
--     background_z_index:int = 50, 
--     load_even_if_duplicate:bool = false 
-- )
