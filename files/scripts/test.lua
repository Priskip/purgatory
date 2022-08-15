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
local players = EntityGetInRadiusWithTag(x, y, 20, "player_unit")

GuiText(gui, 40, 40, "#players: " .. tostring(#players))

local output = "player ids: "
if players ~= nil then
    for i, v in ipairs(players) do
        output = output .. "#" .. tostring(i) .. "-id:" .. tostring(v) .. " "
    end
end

GuiText(gui, 40, 50, output)

GuiText(gui, 40, 60, tostring(type(players)))
