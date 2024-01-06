dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = getPlayerEntity()

local proj_comp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local shooter_id = ComponentGetValue2(proj_comp, "mWhoShot")

if shooter_id ~= player_id then
    --set homing type
    local var_stor_comps = EntityGetComponent(entity_id, "VariableStorageComponent")
    if (var_stor_comps ~= nil) then
        for i, v in ipairs(var_stor_comps) do
            local name = ComponentGetValue2(v, "name")

            if (name == "target_type") then
                ComponentSetValue2(v, "value_string", "player")
            end
        end
    end
end
