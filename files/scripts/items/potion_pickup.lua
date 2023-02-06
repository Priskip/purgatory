dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/game_helpers.lua")

function item_pickup(entity_item, entity_who_picked, name)
    local x, y = EntityGetTransform(entity_item)
    local color = GameGetPotionColorUint(entity_item)

    local do_fx = true

    local item_comp = EntityGetFirstComponentIncludingDisabled(entity_item, "ItemComponent")
    if (item_comp ~= nil and ComponentGetValueBool(item_comp, "has_been_picked_by_player")) then
        do_fx = false
    end

    local var_stor_comps = EntityGetComponent(entity_item, "VariableStorageComponent")
    local fx_override = nil
    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local n = ComponentGetValue2(v, "name")
            if (n == "disable_pickup_fx") then
                fx_override = ComponentGetValue2(v, "BOOL")
            end
        end
    end

    if fx_override == true then
        do_fx = false
    end

    if (do_fx) then
        local entity = EntityLoad("data/entities/particles/image_emitters/potion_effect.xml", x, y - 8)

        edit_component(
            entity,
            "ParticleEmitterComponent",
            function(comp, vars)
                vars.color = color
            end
        )
    end

    local mat_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_item, "MaterialSuckerComponent")
    EntitySetComponentIsEnabled(entity_item, mat_sucker_comp, true)
    ComponentAddTag(mat_sucker_comp, "enabled_in_world")
    ComponentAddTag(mat_sucker_comp, "enabled_in_hand")
end
