dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

--GUI
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

local entity_id = GetUpdatedEntityID()
local slot_number = variable_storage_get_value(entity_id, "INT", "slot_number")
local display_text = "Slot " .. slot_number .. ": \"" .. GlobalsGetValue( "TEMPLE_ALCHEMY_STORAGE_SLOT_" .. tostring(slot_number), "empty") .. "\""

GuiText(gui, 40, 200 + 10 * slot_number, display_text)

