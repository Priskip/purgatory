dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success(pos_x, pos_y)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    --GamePrint("MATERIAL CHECKER SUCCESS")

    --Clear Diamond from Avarice
    EntityLoad("mods/purgatory/files/entities/buildings/avarice_clear_diamond.xml", x, y)

    --Load a hint particle effect
    SetRandomSeed(x, y + GameGetFrameNum())

    local hints = {
        "mods/purgatory/files/entities/particles/avarice_hints/hint_flash.xml",
        "mods/purgatory/files/entities/particles/avarice_hints/hint_greed.xml",
        "mods/purgatory/files/entities/particles/avarice_hints/hint_suns.xml"
    }

    EntityLoad(hints[Random(1, #hints)], x, y - 150)
end
