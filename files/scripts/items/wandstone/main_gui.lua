dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/gui_utilities.lua")

local wandstone_id = GetUpdatedEntityID()
local player_id = getPlayerEntity()
local id_to_seed_location = player_id or wandstone_id --just to get lua to stop bitching that player_id may be nil
local x, y = EntityGetTransform(id_to_seed_location)
SetRandomSeed(x, y)

WANDSTONE_GUI = WANDSTONE_GUI or GuiCreate()
GuiStartFrame(WANDSTONE_GUI)

--Calculate where the cursor is in the gui coordinate space
local screen_size_x, screen_size_y = GuiGetScreenDimensions(WANDSTONE_GUI)
local cursor_world_x, cursor_world_y = DEBUG_GetMouseWorld()
local cam_x, cam_y = GameGetCameraPos()
local v_res_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_X")
local v_res_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_Y")
local v_res_offset_x = MagicNumbersGetValue("VIRTUAL_RESOLUTION_OFFSET_X")
local v_res_offset_y = MagicNumbersGetValue("VIRTUAL_RESOLUTION_OFFSET_Y")

local cursor_gui_x = round_to_int(screen_size_x * (((cursor_world_x - cam_x) + (v_res_x / 2 - v_res_offset_x)) / v_res_x))
local cursor_gui_y = round_to_int(screen_size_y * (((cursor_world_y - cam_y) + (v_res_y / 2 + v_res_offset_y)) / v_res_y))

GuiText(WANDSTONE_GUI, 10, 10,
    "GUI = " .. string.format("%.2f", cursor_gui_x) .. " " .. string.format("%.2f", cursor_gui_y))

--MAIN MENU BUTTONS TO DRAW
MAIN_MENU_BUTTONS = MAIN_MENU_BUTTONS or
    {
        {
            id = "STORE_SPELLS",
            gui_pos = { x = 20, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/store_spells.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "STORE_SPELLS")
            end,
            action_selected = function()
                GamePrint("STORE_SPELLS")
            end
        },
        {
            id = "WITHDRAW_SPELLS",
            gui_pos = { x = 48, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/withdraw_spells.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "WITHDRAW_SPELLS")
            end,
            action_selected = function()
                GamePrint("WITHDRAW_SPELLS")
            end
        },
        {
            id = "SAVE_WAND",
            gui_pos = { x = 76, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/save_wand.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "SAVE_WAND")
            end,
            action_selected = function()
                GamePrint("SAVE_WAND")
            end
        },
        {
            id = "LOAD_WAND",
            gui_pos = { x = 104, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/load_wand.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "LOAD_WAND")
            end,
            action_selected = function()
                GamePrint("LOAD_WAND")
            end
        },


        {
            id = "SAC_SPELLS",
            gui_pos = { x = 160, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/sac_spells.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "SAC_SPELLS")
            end,
            action_selected = function()
                GamePrint("SAC_SPELLS")
            end
        },
        {
            id = "SAC_WAND",
            gui_pos = { x = 132, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/sac_wands.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "SAC_WAND")
            end,
            action_selected = function()
                GamePrint("SAC_WAND")
            end
        },
        {
            id = "TOGGLE_SACRIFICE",
            gui_pos = { x = 188, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/toggle_sacrifice.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "TOGGLE_SACRIFICE")
            end,
            action_selected = function()
                GamePrint("TOGGLE_SACRIFICE")
            end
        },
        {
            id = "UPGRADE_MENU",
            gui_pos = { x = 216, y = 41 },
            background_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            foreground_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/upgrade_menu.png",
            foreground_offset = { x = 1, y = 1 },
            hovered_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_hovered.png",
            selected_image = "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24_selected.png",
            selected = false,
            action_highlighted = function(x, y)
                GuiZSetForNextWidget(WANDSTONE_GUI, -4)
                GuiText(WANDSTONE_GUI, x, y, "UPGRADE_MENU")
            end,
            action_selected = function()
                GamePrint("UPGRADE_MENU")
            end
        },

    }

--For each Button
for i, button in ipairs(MAIN_MENU_BUTTONS) do
    --Draw Background
    GuiZSetForNextWidget(WANDSTONE_GUI, 0)
    GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.background_image, 1, 1, 1, 0)

    --Draw Foreground
    GuiZSetForNextWidget(WANDSTONE_GUI, -1)
    GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x + button.foreground_offset.x,
        button.gui_pos.y + button.foreground_offset.y, button.foreground_image, 1, 1, 1, 0)

    --Check to see if the button is selected. If it is, then draw the selected_image and perform its action_selected.
    if button.selected then
        GuiZSetForNextWidget(WANDSTONE_GUI, -2)
        GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.selected_image, 1, 1, 1, 0)
        button.action_selected()
    end

    --Check if mouse is hovering on the button. If so, draw the hovering image.
    local button_size_x, button_size_y = GuiGetImageDimensions(WANDSTONE_GUI, button.background_image, 1)
    if in_range_2d(cursor_gui_x, cursor_gui_y, button.gui_pos.x, button.gui_pos.y, button.gui_pos.x + button_size_x, button.gui_pos.y + button_size_y) then
        --Display Highlighting Image
        GuiZSetForNextWidget(WANDSTONE_GUI, -3)
        GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.hovered_image, 1, 1, 1, 0)

        --Perform Highlighting Action
        button.action_highlighted(cursor_gui_x, cursor_gui_y)

        --If we are hovering, then check to see if the mouse has been left clicked. If so, toggle button.selected
        if InputIsMouseButtonJustDown(1) then
            button.selected = not button.selected
        end
    end
end


--Test selection drawing
SELECTION = SELECTION or
    {
        start_x = 0,
        start_y = 0,
        held = false
    }

if InputIsKeyJustDown(29) then
    SELECTION.held = true
    SELECTION.start_x = cursor_gui_x
    SELECTION.start_y = cursor_gui_y
end

if InputIsKeyJustUp(29) then
    SELECTION.held = false
    SELECTION.start_x = 0
    SELECTION.start_y = 0
end

if SELECTION.held then
    DrawWandBox(WANDSTONE_GUI, SELECTION.start_x, SELECTION.start_y, cursor_gui_x, cursor_gui_y, "wand_selected")
    GuiText(WANDSTONE_GUI, cursor_gui_x, cursor_gui_y, "Start = " .. string.format("%.2f", SELECTION.start_x) .. " " .. string.format("%.2f", SELECTION.start_y))
    GuiText(WANDSTONE_GUI, cursor_gui_x, cursor_gui_y + 10, "End = " .. string.format("%.2f", cursor_gui_x) .. " " .. string.format("%.2f", cursor_gui_y))
end
