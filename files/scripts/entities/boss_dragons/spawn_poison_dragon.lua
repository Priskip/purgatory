dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

--Spawn Ice Dragon
EntityLoad( "mods/purgatory/files/entities/animals/boss_dragons/poison_dragon.xml", pos_x, pos_y)
EntityLoad( "mods/purgatory/files/entities/particles/boss_dragons/poison_dragon_spawn.xml", pos_x, pos_y)

EntityKill(entity_id)