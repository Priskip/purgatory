dofile_once("data/scripts/lib/utilities.lua")

function item_pickup(entity_item, entity_who_picked, name)
    local entity_id = GetUpdatedEntityID()

    local item_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ItemComponent")
    ComponentSetValue2(item_comp, "auto_pickup", false)
end
