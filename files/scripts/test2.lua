dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

slider = slider or {}
slider.a = GuiSlider(gui, new_id(), 10, 70, "count", slider.a, 0, 100, 25, 1, "", 100)
slider.b = GuiSlider(gui, new_id(), 10, 80, "count", slider.b, 0, 100, 25, 1, "", 100)
slider.c = GuiSlider(gui, new_id(), 10, 90, "count", slider.c, 0, 100, 25, 1, "", 100)
slider.d = GuiSlider(gui, new_id(), 10, 100, "count", slider.d, 0, 100, 25, 1, "", 100)

slider.e = GuiSlider(gui, new_id(), 150, 70, "lifetime", slider.e, 0, 200, 25, 1, "", 100)
slider.f = GuiSlider(gui, new_id(), 150, 80, "lifetime", slider.f, 0, 200, 25, 1, "", 100)
slider.g = GuiSlider(gui, new_id(), 150, 90, "lifetime", slider.g, 0, 200, 25, 1, "", 100)
slider.h = GuiSlider(gui, new_id(), 150, 100, "lifetime", slider.h, 0, 200, 25, 1, "", 100)

local ent_id = GetUpdatedEntityID()
local particle_emitter_components = EntityGetComponent(ent_id, "ParticleEmitterComponent")

for i, comp in ipairs(particle_emitter_components) do
    local emitted_material_name = ComponentGetValue2(comp, "emitted_material_name")

    if emitted_material_name == "water" then
        ComponentSetValue2(comp, "count_min", slider.a)
        ComponentSetValue2(comp, "count_max", slider.a)

        ComponentSetValue2(comp, "lifetime_min", slider.e/100)
        ComponentSetValue2(comp, "lifetime_max", slider.e/100)
    end
    if emitted_material_name == "magic_liquid_protection_all" then
        ComponentSetValue2(comp, "count_min", slider.b)
        ComponentSetValue2(comp, "count_max", slider.b)

        ComponentSetValue2(comp, "lifetime_min", slider.f/100)
        ComponentSetValue2(comp, "lifetime_max", slider.g/100)
    end
    if emitted_material_name == "spark_electric" then
        ComponentSetValue2(comp, "count_min", slider.c)
        ComponentSetValue2(comp, "count_max", slider.c)

        ComponentSetValue2(comp, "lifetime_min", slider.g/100)
        ComponentSetValue2(comp, "lifetime_max", slider.g/100)
    end
    if emitted_material_name == "glowstone_altar_hdr" then
        ComponentSetValue2(comp, "count_min", slider.d)
        ComponentSetValue2(comp, "count_max", slider.d)

        ComponentSetValue2(comp, "lifetime_min", slider.h/100)
        ComponentSetValue2(comp, "lifetime_max", slider.h/100)
    end
end
