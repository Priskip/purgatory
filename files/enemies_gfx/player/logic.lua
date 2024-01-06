dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local id = GetUpdatedEntityID()
local belt_id = EntityGetWithName("purgatory_belt_tracker")
local belt_x, belt_y = EntityGetTransform(belt_id)

local player = EntityGetParent(id)
local character_data_comp = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent")
local vel_x, vel_y = 0, 0
if (character_data_comp ~= nil) then
    vel_x, vel_y = ComponentGetValue2(character_data_comp, "mVelocity")
end

local phi = math.atan2(200, -vel_x)
EntitySetTransform(id, belt_x, belt_y, phi - math.pi / 2, 1, 1)
