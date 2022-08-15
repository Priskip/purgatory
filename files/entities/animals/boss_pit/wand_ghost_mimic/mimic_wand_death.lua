dofile_once("data/scripts/lib/utilities.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)

    local mimic_wands_in_area = EntityGetInRadiusWithTag(x, y, 240, "mimic_wand")

    for i, wand_id in ipairs(mimic_wands_in_area) do
        local root_ent_id = EntityGetRootEntity(wand_id)

        if root_ent_id == wand_id then
            EntityKill(wand_id)
        end
    end
end
