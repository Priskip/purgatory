dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local ent_id = GetUpdatedEntityID()
local game_effect_comp = EntityGetFirstComponentIncludingDisabled(ent_id, "GameEffectComponent")
local mCounter_value = ComponentGetValue2(game_effect_comp, "mCounter")
if mCounter_value == 1 then
    --extra life has been spent, kill this entity and one ui icon entity

    local player_id = getPlayerEntity()
    local children = EntityGetAllChildren(player_id)
    for i, child in ipairs(children) do
        local child_ui_icon_component = EntityGetFirstComponentIncludingDisabled(child, "UIIconComponent")
        local name_value = ComponentGetValue2(child_ui_icon_component, "name")

        if name_value == "$perk_respawn" then
            EntityKill(child)
            break
        end
    end

    EntityKill(ent_id)
end
