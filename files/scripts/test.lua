dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local id = GetUpdatedEntityID()

GUI = GUI or GuiCreate()
GuiStartFrame(GUI)

--Calculate where the cursor is in the gui coordinate space
local screen_size_x, screen_size_y = GuiGetScreenDimensions(GUI)
local cursor_world_x, cursor_world_y = DEBUG_GetMouseWorld()
local cam_x, cam_y = GameGetCameraPos()
local v_res_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
local v_res_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
local v_res_offset_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_OFFSET_X")
local v_res_offset_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_OFFSET_Y")

local cursor_gui_x = roundToInt(screen_size_x * (((cursor_world_x - cam_x) + (v_res_x / 2 - v_res_offset_x)) / v_res_x))
local cursor_gui_y = roundToInt(screen_size_y * (((cursor_world_y - cam_y) + (v_res_y / 2 + v_res_offset_y)) / v_res_y))

GuiText(GUI, cursor_gui_x, cursor_gui_y,
    "World Pos: " .. string.format("%.2f", cursor_world_x) .. " " .. string.format("%.2f", cursor_world_y))
GuiText(GUI, cursor_gui_x, cursor_gui_y + 10,
    "Gui Pos: " .. string.format("%.2f", cursor_gui_x) .. " " .. string.format("%.2f", cursor_gui_y))

local fog = nil
local bilinear_fog = nil
--if DoesWorldExistAt(cursor_world_x - 1, cursor_world_y - 1, cursor_world_x + 1, cursor_world_y + 1) then

if GameGetFrameNum() > 500 then --terrible but works
    fog = GameGetFogOfWar(cursor_world_x, cursor_world_y)
    GuiText(GUI, cursor_gui_x, cursor_gui_y + 20, "GameGetFogOfWar(x, y): " .. tostring(fog))

    bilinear_fog = GameGetFogOfWarBilinear(cursor_world_x, cursor_world_y)
    GuiText(GUI, cursor_gui_x, cursor_gui_y + 30, "GameGetFogOfWarBilinear(x, y): " .. tostring(bilinear_fog))
end
