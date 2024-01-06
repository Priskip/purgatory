dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID() --pit boss
local ent_x, ent_y = EntityGetTransform(entity_id)

local wand_id = EntityLoad("mods/purgatory/files/entities/animals/boss_pit/wand_of_healing/wand_of_healing.xml", ent_x, ent_y)
EntityAddChild( entity_id, wand_id )

--GamePrint("Summon Wand of Healing")