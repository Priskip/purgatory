dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()

local rest_x = variable_storage_get_value(entity_id, "FLOAT", "rest_position_x")
local rest_y = variable_storage_get_value(entity_id, "FLOAT", "rest_position_y")

EntitySetTransform(entity_id, rest_x, rest_y)
