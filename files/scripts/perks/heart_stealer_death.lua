dofile_once("data/scripts/lib/utilities.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
    local entity_id = GetUpdatedEntityID()
    local pos_x, pos_y = EntityGetTransform(entity_id)
    local hearts_dropped = tonumber(GlobalsGetValue("MINI_HEARTS_DROPPED_TOTAL", "1"))

    SetRandomSeed(GameGetFrameNum(), pos_x + pos_y + entity_id)

    local num = Random(1, hearts_dropped + 1)

    if num == 1 then
        EntityLoad("mods/purgatory/files/entities/items/pickup/heart_mini.xml", pos_x, pos_y - 2)
        GlobalsSetValue("MINI_HEARTS_DROPPED_TOTAL", tostring(hearts_dropped + 1))
    end
end
