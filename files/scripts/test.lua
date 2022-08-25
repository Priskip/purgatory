dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--GUI
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

local ent_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(ent_id)


v = GuiSlider(gui, new_id(), 10, 70, "", v, 0, 100, 0, 1, " ", 100)
v = math.floor(v)
GuiText(gui, 10, 90, tostring(v))


-- v is a value between 0 and 100
local particle_emitter_comp = EntityGetFirstComponentIncludingDisabled( ent_id, "ParticleEmitterComponent")

ComponentSetValue2(particle_emitter_comp, "y_pos_offset_max", -v)
ComponentSetValue2(particle_emitter_comp, "count_min", v )
ComponentSetValue2(particle_emitter_comp, "count_max", v)