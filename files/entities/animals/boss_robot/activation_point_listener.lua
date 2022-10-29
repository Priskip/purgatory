dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local proj = {}
proj.id = GetUpdatedEntityID()
proj.x, proj.y = EntityGetTransform(proj.id)

local laser_hotspots = EntityGetInRadiusWithTag(proj.x, proj.y, 5, "mecha_turret_laser_spot")

if #laser_hotspots > 0 then
    local x, y = EntityGetTransform(laser_hotspots[1])
    EntityLoad("mods/purgatory/files/entities/animals/boss_robot/tesla_turret_fire.xml", x, y)
    EntityKill(proj.id)
end
