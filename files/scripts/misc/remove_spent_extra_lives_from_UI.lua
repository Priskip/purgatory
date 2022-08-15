dofile_once("mods/purgatory/files/scripts/utils.lua")

local player_id = getPlayerEntity()
local children = EntityGetAllChildren(player_id)

for i, child in ipairs(children) do
    local child_game_effect_component = EntityGetFirstComponentIncludingDisabled(child, "GameEffectComponent")
    local effect_value = ComponentGetValue2(child_game_effect_component, "effect")

    if effect_value == "RESPAWN" then
        local mCounter_value = ComponentGetValue2(child_game_effect_component, "mCounter")

        if mCounter_value == 1 then
            --Remove extra life child
            EntityKill(child)

            --Remove UI component
            for i, child2 in ipairs(children) do
                local child_ui_icon_component = EntityGetFirstComponentIncludingDisabled(child2, "UIIconComponent")
                local name_value = ComponentGetValue2(child_ui_icon_component, "name")

                if name_value == "$perk_respawn" then
                    EntityKill(child2)
                    break
                end
            end
        end
    end
end