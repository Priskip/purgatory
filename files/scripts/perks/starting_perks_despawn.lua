dofile("data/scripts/game_helpers.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/perks/perk.lua")

function item_pickup(entity_item, entity_who_picked, item_name)
    local x, y = EntityGetTransform(entity_item)

    local vsc = EntityGetComponentIncludingDisabled(entity_item, "VariableStorageComponent")
    local perk_type = ""
    
    for i, comp in ipairs(vsc) do
        local comp_name = ComponentGetValue2(comp, "name")

        if comp_name == "perk_type" then
            perk_type = ComponentGetValue2(comp, "value_string")
        end
    end

    local entity_with_same_tag = EntityGetClosestWithTag(x, y, perk_type)
    local count = 0

    while entity_with_same_tag ~= 0 and count < 10 do
        EntityKill(entity_with_same_tag)
        entity_with_same_tag = EntityGetClosestWithTag(x, y, perk_type)
        --GamePrint("Found perk to kill: "..tostring(entity_with_same_tag))
        count = count + 1
    end

    --TODO: Make this cleaner

end
