dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local player_id = getPlayerEntity()

local proj_comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter_id = ComponentGetValue2( proj_comp, "mWhoShot" )

if shooter_id ~= player_id then
	--target_tag = player_unit
    local homing_comps = EntityGetComponent(entity_id, "HomingComponent", "homing_rotate")

    if homing_comps ~= nil then
        for i, comp in ipairs(homing_comps) do
            ComponentSetValue2(comp, "target_tag", "player_unit")
        end
    end
end