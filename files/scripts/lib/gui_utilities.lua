--Gui Utility Functions for Purgatory
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

--Gets a new GUI ID to use
function NewGUIID()
    local id = tonumber(GlobalsGetValue("PURGATORY_GUI_ID", "0"))
    id = id + 1
    GlobalsSetValue("PURGATORY_GUI_ID", tostring(id))
    --print("Called NewGUIID() - PURGATORY_GUI_ID updated to " .. tostring(id))
    return id
end



--Reset GUI ID back to 0.
--Should only be done once per frame once everything has been processed.
function ResetGUIID()
    local id = 0
    GlobalsSetValue("PURGATORY_GUI_ID", tostring(id))
    --print("Called ResetGUIID() - PURGATORY_GUI_ID updated to " .. tostring(id))
end



--Prints the PURGATORY_GUI_ID to the console.
function PrintGUIID()
    local id = tonumber(GlobalsGetValue("PURGATORY_GUI_ID", "0"))
    print("PURGATORY_GUI_ID = " .. tostring(id))
end



--Function to draw a rectangle outline like that of the vanilla inventory gui.
function DrawWandBox(GUI, x1, y1, x2, y2, sprite_path)
    --Round the inputs to the nearest int
    round_to_int(x1)
    round_to_int(y1)
    round_to_int(x2)
    round_to_int(y2)

    --Check if x2 > x1 and y2 > y1.
    if x1 > x2 then
        x1, x2 = x2, x1 --swap if x1 is bigger than x2
    end
    if y1 > y2 then
        y1, y2 = y2, y1 --swap if x1 is bigger than x2
    end

    --Check to see if coordinates are in scope of the gui size.
    --If not, make them be.
    local gui_size_x, gui_size_y = GuiGetScreenDimensions(GUI)
    x1 = clamp(x1, 0, gui_size_x)
    y1 = clamp(y1, 0, gui_size_y)
    x2 = clamp(x2, 0, gui_size_x)
    y2 = clamp(y2, 0, gui_size_y)

    --Calculate side lengths of the wand box to draw.
    local box_size_x = x2 - x1
    local box_size_y = y2 - y1

    --Get image file paths
    local image_corner = "mods/purgatory/files/ui_gfx/inventory/selection_boxes/" .. sprite_path .. "/corner.png"
    local image_outline = "mods/purgatory/files/ui_gfx/inventory/selection_boxes/" .. sprite_path .. "/outline.png"
    local image_background = "mods/purgatory/files/ui_gfx/inventory/selection_boxes/" .. sprite_path .. "/background.png"

    --The way the pixel art is done for a selection box means that if a side length is >= 4,
    --    then we can fully draw the 2 corner pixels, 1 or more fill pixels, and the one 1 missing pixel
    --    at the top right / bottom left of the box
    --If the side lengths are shorter than that, then we have special cases.
    --The size lengths in the if statements below are 0-indexed.

    local has_full_side_x = (box_size_x >= 3)
    local has_full_side_y = (box_size_y >= 3)
    local has_fill_box = (box_size_x >= 2 and box_size_y >= 2)

    --Main Box
    if has_fill_box then
        GuiImage(GUI, NewGUIID(), x1 + 1, y1 + 1, image_background, 1, x2 - x1 - 1, y2 - y1 - 1)
    end

    --Horizontal outlines
    if has_full_side_x then
        --Corners
        GuiImage(GUI, NewGUIID(), x1, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x2, y2, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x2 - 1, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 1, y2, image_corner, 1, 1)
        --Outline
        GuiImage(GUI, NewGUIID(), x1 + 1, y1, image_outline, 1, x2 - x1 - 2, 1) --top
        GuiImage(GUI, NewGUIID(), x1 + 2, y2, image_outline, 1, x2 - x1 - 2, 1) --bottom
    elseif box_size_x == 2 then
        GuiImage(GUI, NewGUIID(), x1, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 1, y1, image_outline, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 2, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 1, y2, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 2, y2, image_outline, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 3, y2, image_corner, 1, 1)
    elseif box_size_x == 1 then
        GuiImage(GUI, NewGUIID(), x1, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 1, y1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 1, y2, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1 + 2, y2, image_corner, 1, 1)
    elseif box_size_x == 0 then
        GuiImage(GUI, NewGUIID(), x1, y1, image_corner, 1, 1)
    end

    --Vertical outlines
    if has_full_side_y then
        --Corners
        GuiImage(GUI, NewGUIID(), x2, y1 + 1, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x1, y2 - 1, image_corner, 1, 1)
        --Outline
        GuiImage(GUI, NewGUIID(), x1, y1 + 1, image_outline, 1, 1, y2 - y1 - 2) --left
        GuiImage(GUI, NewGUIID(), x2, y1 + 2, image_outline, 1, 1, y2 - y1 - 2) --right
    elseif box_size_y == 2 then
        GuiImage(GUI, NewGUIID(), x1, y1 + 1, image_outline, 1, 1)
        GuiImage(GUI, NewGUIID(), x1, y1 + 2, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x2, y2 - 2, image_corner, 1, 1)
        GuiImage(GUI, NewGUIID(), x2, y2 - 1, image_outline, 1, 1)
    elseif box_size_y == 1 then
        GuiImage(GUI, NewGUIID(), x2, y2, image_corner, 1, 1)
    elseif box_size_y == 0 then
    end

end
