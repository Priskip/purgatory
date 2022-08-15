dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/gun/initialize_starting_wands.lua")

local player_id = getPlayerEntity()

--Initialize Starting Wands
initialize_starting_wands(player_id)