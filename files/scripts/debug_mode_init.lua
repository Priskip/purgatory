dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function debug_mod_init(player_entity)
    local x, y = EntityGetTransform(player_entity)

    --[[
    LoadPixelScene(
        "mods/purgatory/files/biome_impl/debug/spawn_platform.png",
        "mods/purgatory/files/biome_impl/debug/spawn_platform_visual.png",
        x - 200,
        y - 200,
        "mods/purgatory/files/biome_impl/debug/spawn_platform_background.png",
        true
    )
    ]]
end
