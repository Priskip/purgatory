dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )


EntityLoad("mods/purgatory/files/entities/animals/boss_pit/wand_ghost_mimic/mimic_wand.xml", pos_x, pos_y)