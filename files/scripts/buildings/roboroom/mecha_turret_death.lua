dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
    local turret = GetUpdatedEntityID()
    local x, y = EntityGetTransform(turret)

    EntityLoad("mods/purgatory/files/entities/buildings/roboroom/mecha_turret_broken.xml", x, y)
end
