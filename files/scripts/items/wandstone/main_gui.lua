dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/gun_utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/gui_utilities.lua")
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

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

--[[
                         .

					   .
			 /^\     .
		__   "V"
	   /__\   I      O  o
	  //..\\  I     .
	  \].`[/  I
	  /l\/j\  (]    .  O
	 /. ~~ ,\/I          .
	 \\L__j^\/I       o
	  \/--v}  I     o   .
	  |    |  I   _________
	  |    |  I c(`       ')o
	  |    l  I   \.     ,/
	_/j  L l\_!  _//^---^\\_
]]

--The fact that Lua does not have classes really annoys me.

CONTAINERS = CONTAINERS or nil

if CONTAINERS == nil then
    CONTAINERS = {}

    CONTAINERS[#CONTAINERS + 1] =
        NewGUIContainer(
            WANDSTONE_GUI,
            "CONTAINER_1",
            99,
            99,
            "SPELL",
            "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            "data/ui_gfx/inventory/quick_inventory_box_hovered.png",
            {
                image = "data/ui_gfx/gun_actions/nuke.png",
                key_id = "SPELL",
                picked_up = false,
                function_placed_in_matching_lock = function(old_container, new_container, key)
                    GamePrint("MATCH")
                    new_container.contents = key
                    old_container.contents = nil
                end,
                function_placed_in_non_matching_lock = function(old_container, new_container, key)
                    GamePrint("NOT MATCH")
                end,
                function_just_let_go = function(old_container, new_container, key)
                    GamePrint("Just Let Go")
                    old_container.contents = nil
                    local player_x, player_y = getPlayerCoords()
                    EntityLoad("data/entities/projectiles/deck/nuke.xml", player_x, player_y)
                end,
            }
        )

    CONTAINERS[#CONTAINERS + 1] =
        NewGUIContainer(
            WANDSTONE_GUI,
            "CONTAINER_2",
            149,
            99,
            "SPELL",
            "mods/purgatory/files/ui_gfx/inventory/wandstone/inv_box_24.png",
            "data/ui_gfx/inventory/quick_inventory_box_hovered.png"
        )

    CONTAINERS[#CONTAINERS + 1] =
        NewGUIContainer(
            WANDSTONE_GUI,
            "CONTAINER_3",
            199,
            99,
            "NOT_SPELL",
            "data/ui_gfx/inventory/quick_inventory_box.png",
            "data/ui_gfx/inventory/quick_inventory_box_hovered.png"
        )
end

--For each container
for _, container in ipairs(CONTAINERS) do
    --Draw container background images
    GuiZSetForNextWidget(WANDSTONE_GUI, 0)
    GuiImage(WANDSTONE_GUI, NewGUIID(), container.gui_pos.x, container.gui_pos.y, container.background_image, 1, 1, 1, 0)

    --Calculate if we are hovering the container.
    local is_highlighted = IsHovering(cursor_gui_x, cursor_gui_y, container.gui_pos.x, container.gui_pos.y,
        container.size.x, container.size.y)

    --If we're hovering, draw hover image
    if is_highlighted then
        GuiZSetForNextWidget(WANDSTONE_GUI, 2)
        GuiImage(WANDSTONE_GUI, NewGUIID(), container.gui_pos.x - container.hovered_image_offset.x,
            container.gui_pos.y - container.hovered_image_offset.y, container.hovered_image, 1, 1, 1, 0)
    end

    --If we have contents and are not dragging them
    if container.contents ~= nil and container.contents.picked_up == false then
        --Draw contents image
        GuiZSetForNextWidget(WANDSTONE_GUI, -1)
        GuiImage(WANDSTONE_GUI, NewGUIID(), container.gui_pos.x - container.contents.offset.x,
            container.gui_pos.y - container.contents.offset.y, container.contents.image, 1, 1, 1, 0)
    end

    --If highlighted, and we have contents, and we have just clicked down,
    --then select the contents and have them move
    if is_highlighted and container.contents ~= nil and InputIsMouseButtonJustDown(1) then
        container.contents.picked_up = true
        container.contents.grab_offset = {}
        container.contents.grab_offset.x = cursor_gui_x - (container.gui_pos.x - container.contents.offset.x)
        container.contents.grab_offset.y = cursor_gui_y - (container.gui_pos.y - container.contents.offset.y)
    end

    --If we have picked_up the contents, then have them follow the mouse
    if container.contents ~= nil and container.contents.picked_up == true then
        GuiZSetForNextWidget(WANDSTONE_GUI, -1)
        GuiImage(WANDSTONE_GUI, NewGUIID(), cursor_gui_x - container.contents.grab_offset.x,
            cursor_gui_y - container.contents.grab_offset.y, container.contents.image, 1, 1, 1, 0)
    end

    --If we let go, then unselect the image and do the appropriate action
    if container.contents ~= nil and container.contents.picked_up == true and InputIsMouseButtonJustUp(1) then
        container.contents.picked_up = false
        container.contents.grab_offset = nil

        local hovering_index = nil
        for i, v in ipairs(CONTAINERS) do
            if IsHovering(cursor_gui_x, cursor_gui_y, v.gui_pos.x, v.gui_pos.y, v.size.x, v.size.y) then
                hovering_index = i
                break
            end
        end

        if hovering_index ~= nil and CONTAINERS[hovering_index].id ~= container.id then
            if container.contents.key_id == CONTAINERS[hovering_index].lock_id then
                container.contents.function_placed_in_matching_lock(container, CONTAINERS[hovering_index],
                    container.contents)
            else
                container.contents.function_placed_in_non_matching_lock(container, CONTAINERS[hovering_index],
                    container.contents)
            end
        else
            if not is_highlighted then
            container.contents.function_just_let_go(container, CONTAINERS[hovering_index], container.contents)
            end
            --else we do nothing
        end
    end
end


SIMPLE_BUTTONS = SIMPLE_BUTTONS or
    {
        {
            id = "TEST_BUTTON_1",
            gui_pos = { x = 20, y = 41 },
            image = "mods/purgatory/files/ui_gfx/debug/button_1.png",
            hovered_image = "mods/purgatory/files/ui_gfx/debug/button_2.png",
            pressed_image = "mods/purgatory/files/ui_gfx/debug/button_3.png",
            action_highlighted = function(x_pos, y_pos)
                NoitaGUIText(WANDSTONE_GUI, x_pos, y_pos, "Disable InventoryGuiComponent")
            end,
            action_pressed = function(gui_x_pos, gui_y_pos)
                -- local player = getPlayerEntity()
				-- local inv_gui_comp = EntityGetFirstComponentIncludingDisabled(player, "InventoryGuiComponent")
				-- EntitySetComponentIsEnabled(player, inv_gui_comp, false)
				-- GamePrint("InventoryGuiComponent --> enabled = false")
            end,

        },
        {
            id = "TEST_BUTTON_2",
            gui_pos = { x = 50, y = 41 },
            image = "mods/purgatory/files/ui_gfx/debug/button_4.png",
            hovered_image = "mods/purgatory/files/ui_gfx/debug/button_5.png",
            pressed_image = "mods/purgatory/files/ui_gfx/debug/button_6.png",
            action_highlighted = function(x_pos, y_pos)
                NoitaGUIText(WANDSTONE_GUI, x_pos, y_pos, "Enable InventoryGuiComponent")
            end,
            action_pressed = function(x_pos, y_pos)
                -- local player = getPlayerEntity()
				-- local inv_gui_comp = EntityGetFirstComponentIncludingDisabled(player, "InventoryGuiComponent")
				-- EntitySetComponentIsEnabled(player, inv_gui_comp, true)
				-- GamePrint("InventoryGuiComponent --> enabled = true")

                -- local held_wands = find_all_wands_held(player_id)
                -- local spells, always_casts = GetAllSpellsOnWand(held_wands[1])

                -- print("Spells")
                -- for i, v in ipairs(spells) do
                --     print(tostring(v))
                -- end

                -- print("always_casts")
                -- for i, v in ipairs(always_casts) do
                --     print(tostring(v))
                -- end

            end,

        }
    }
	
for _, button in ipairs(SIMPLE_BUTTONS) do
    --Draw Button Images
    GuiZSetForNextWidget(WANDSTONE_GUI, 0)
    GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.image, 1, 1, 1, 0)

    --Check if size has been defined
    if button.button_size == nil then
        button.button_size = {}
        local button_size_x, button_size_y = GuiGetImageDimensions(WANDSTONE_GUI, button.image, 1)
        button.button_size.x = button_size_x
        button.button_size.y = button_size_y
    end

    local is_highlighted = cursor_gui_x > button.gui_pos.x and cursor_gui_x < button.gui_pos.x + button.button_size.x
        and cursor_gui_y > button.gui_pos.y and cursor_gui_y < button.gui_pos.y + button.button_size.y

    --Check if mouse is highlighting
    if is_highlighted then
        --Display Highlighted Image
        GuiZSetForNextWidget(WANDSTONE_GUI, -1)
        GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.hovered_image, 1, 1, 1, 0)

        --Perform Highlighting Action
        button.action_highlighted(cursor_gui_x, cursor_gui_y)
    end

    --If we are hovering, then check to see if the mouse has been left clicked. 
    --If the mouse button has just been pressed down, then activate the button's function.
    if is_highlighted and InputIsMouseButtonJustDown(1) then
        button.action_pressed(cursor_gui_x, cursor_gui_y)
    end

    --If we are hovering, then check to see if the mouse has been left clicked. 
    --If the mouse button is being pressed down, then draw button.pressed_image.
    if is_highlighted and InputIsMouseButtonDown(1) then
        GuiZSetForNextWidget(WANDSTONE_GUI, -2)
        GuiImage(WANDSTONE_GUI, NewGUIID(), button.gui_pos.x, button.gui_pos.y, button.pressed_image, 1, 1, 1, 0)
    end
end



--[[
    Types of GUI objects to make:
    [X] Simple Button
    [X] 2 State Toggle Button
    [ ] Multi State Toggle Button
    [ ] Container Button -> Dragging -> Floating

]]
