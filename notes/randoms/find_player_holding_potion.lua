dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local i2c_id = EntityGetFirstComponentIncludingDisabled(getPlayerEntity(), "Inventory2Component")
local active_item_id = ComponentGetValue2(i2c_id, "mActiveItem")
local interact_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "InteractableComponent")

local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")


if (EntityHasTag(active_item_id, "potion")) then
    --Holding a potion
    ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_can_place_bottle")

    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "ready_to_recieve_bottle") then
                 ComponentSetValue2(v, "value_bool", true)
            end
        end
    end
else
    --Is not holding a potion
    ComponentSetValue2(interact_comp, "ui_text", "$bottle_filler_cannot_place_bottle")

    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "ready_to_recieve_bottle") then
                 ComponentSetValue2(v, "value_bool", false)
            end
        end
    end
end
