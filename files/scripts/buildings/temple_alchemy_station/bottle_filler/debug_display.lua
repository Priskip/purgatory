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

--bottle stand
local bottle_stand = {}
bottle_stand.id = GetUpdatedEntityID()

--child potion/sack
local child_ents = EntityGetAllChildren(bottle_stand.id)
local placed_bottle = {}

if child_ents ~= nil then
    placed_bottle.id = child_ents[1]



    GuiText(gui, 400, 150, "display_text")
end
