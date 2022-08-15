dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

--BEGIN
local entity_id = GetUpdatedEntityID()
local player_id = EntityGetRootEntity(entity_id)

local wand_id = find_the_wand_held(player_id)

--If holding a wand
if (wand_id ~= nil) and (wand_id ~= NULL_ENTITY) then
    local wx, wy, wdir = EntityGetTransform(wand_id)

    local stuff = EntityGetFirstComponent(player_id, "VelocityComponent")
    if (stuff ~= nil) then
        vx, vy = ComponentGetValue2(stuff, "mVelocity")
    end

    local plasma_ent = EntityLoad("mods/purgatory/files/entities/projectiles/deck/personal_laser.xml", wx, wy)
    EntityAddChild( player_id, plasma_ent )

    local ox = wx + math.cos(0 - wdir) * 6 + vx * 1.5
    local oy = wy - math.sin(0 - wdir) * 6 + vy * 1.5

    EntitySetTransform(plasma_ent, ox, oy + 0.5, wdir)
end

