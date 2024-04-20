dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity = {}
entity.id = GetUpdatedEntityID()
entity.x, entity.y = EntityGetTransform(entity.id)

local parent = {}
parent.id = EntityGetParent(entity.id)
parent.x, parent.y = EntityGetTransform(parent.id)

local delta_x = variableStorageGetValue(entity.id, "FLOAT", "delta_x")
local delta_y = variableStorageGetValue(entity.id, "FLOAT", "delta_y")
local scale = variableStorageGetValue(entity.id, "FLOAT", "scale")

--GUI
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

if GuiButton(gui, new_id(), 40, 40, "-U-") then
    variableStorageSetValue(entity.id, "FLOAT", "delta_y", delta_y - scale)
    EntitySetTransform( parent.id, parent.x, parent.y - scale)
end

if GuiButton(gui, new_id(), 30, 50, "-L-") then
    variableStorageSetValue(entity.id, "FLOAT", "delta_x", delta_x - scale)
    EntitySetTransform( parent.id, parent.x - scale, parent.y)
end

if GuiButton(gui, new_id(), 50, 50, "-R-") then
    variableStorageSetValue(entity.id, "FLOAT", "delta_x", delta_x + scale)
    EntitySetTransform( parent.id, parent.x + scale, parent.y)
end

if GuiButton(gui, new_id(), 40, 60, "-D-") then
    variableStorageSetValue(entity.id, "FLOAT", "delta_y", delta_y + scale)
    EntitySetTransform( parent.id, parent.x, parent.y + scale)
end

--Draw outputs
GuiText(gui, 75, 45, "Delta X: " .. tostring(delta_x))
GuiText(gui, 75, 55, "Delta Y: " .. tostring(delta_y))

--Draw Scale Selecter
GuiText(gui, 30, 80, "Scale: " .. tostring(scale))

if GuiButton(gui, new_id(), 30, 90, "-0.1-") then
    variableStorageSetValue(entity.id, "FLOAT", "scale", 0.1)
end
if GuiButton(gui, new_id(), 30, 100, "-1-") then
    variableStorageSetValue(entity.id, "FLOAT", "scale", 1)
end
if GuiButton(gui, new_id(), 30, 110, "-10-") then
    variableStorageSetValue(entity.id, "FLOAT", "scale", 10)
end