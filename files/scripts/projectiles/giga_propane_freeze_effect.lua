dofile("data/scripts/lib/utilities.lua")

--Start
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

EntityLoad("mods/purgatory/files/entities/projectiles/short_freeze.xml", x, y)