dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local ent = {}
ent.id = GetUpdatedEntityID()
ent.x, ent.y, ent.phi = EntityGetTransform(ent.id)

--Gui Starters
local gui_id = 1
local function new_gui_id()
    gui_id = gui_id + 1
    return gui_id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

--GuiText(gui, 20, 50, "ent.phi: " .. string.format("%.2f", tostring(ent.phi)))
phi = phi or 0
phi = GuiSlider(gui, new_gui_id(), 25, 50, "phi", phi, -3.14, 3.14, 0, 100, "", 100)

--Wedge
EntitySetTransform(ent.id, ent.x, ent.y, phi)

local particle_comps = EntityGetComponent(ent.id, "ParticleEmitterComponent")
local alive_turrets = EntityGetInRadiusWithTag(ent.x, ent.y, 300, "roboroom_mecha_turret_alive")
local number_of_alive_turrets = math.min(#alive_turrets, 8)

for i, comp in ipairs(particle_comps) do
    ComponentSetValue2(comp, "area_circle_sector_degrees", 45 * number_of_alive_turrets)

    if number_of_alive_turrets == 0 then
        ComponentSetValue2(comp, "is_emitting", false)
    elseif number_of_alive_turrets ~= 0 and ComponentGetValue2(comp, "is_emitting") == false then
        ComponentSetValue2(comp, "is_emitting", true)
    end
end

local inner_particles = EntityGetFirstComponentIncludingDisabled(ent.id, "ParticleEmitterComponent", "inner_particles")
ComponentSetValue2(inner_particles, "count_min", 4 * number_of_alive_turrets)
ComponentSetValue2(inner_particles, "count_max", 5 * number_of_alive_turrets)

local outer_wall = EntityGetFirstComponentIncludingDisabled(ent.id, "ParticleEmitterComponent", "outer_wall")
ComponentSetValue2(outer_wall, "count_min", 40 * number_of_alive_turrets)
ComponentSetValue2(outer_wall, "count_max", 60 * number_of_alive_turrets)