dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

--NOTE PRISKIP: These guys are now friendly towards the player because I created a new genome relations category for them 

--makes them no longer homing targets
EntityRemoveTag(entity_id, "homing_target")
