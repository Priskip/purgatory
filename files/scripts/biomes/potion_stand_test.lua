CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile_once("data/scripts/lib/utilities.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )


function init( x, y, w, h )
    for i = 0, 480, 20 do
        for j = 0, 480, 30 do
            LoadPixelScene( "data/biome_impl/potion_altar.png", "data/biome_impl/potion_altar_visual.png", x + i, y + j, "", true )
        end
    end
end

