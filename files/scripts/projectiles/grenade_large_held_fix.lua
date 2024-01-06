dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y, r, sx, sy = EntityGetTransform(entity_id)
EntitySetTransform(entity_id, x, y + 10)

local comp = EntityGetComponent(entity_id, "VelocityComponent")

local comp = comp[1]
local vel_x, vel_y = 0, 0
vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)

ComponentSetValueVector2( comp, "mVelocity", vel_x, 130 )
--scuffed but works