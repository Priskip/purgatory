dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local ent_x, ent_y = EntityGetTransform(entity_id)

local player_ent = EntityGetInRadiusWithTag(ent_x, ent_y, 500, "player_unit")
local player_in_radius = false
if #player_ent ~= 0 then
    player_in_radius = true
end

if player_in_radius then
    -- Gui Starters
    local gui_id = 1
    local function new_gui_id()
        gui_id = gui_id + 1
        return gui_id
    end
    gui = gui or GuiCreate()
    GuiStartFrame(gui)

    --OLD DEBUG CODE for sliding between orb counts 
    -- --Slider for Orb Count to adjust HP
    -- ORB_COUNT =
    --     ORB_COUNT or
    --     {
    --         current = 0,
    --         prev = 0,
    --         rounded = 0
    --     }
    -- ORB_COUNT.current = GuiSlider(gui, new_gui_id(), 10, 70, "Orb Count", ORB_COUNT.current, 0, 75, 0, 1, "", 200)
    -- ORB_COUNT.rounded = roundToInt(ORB_COUNT.current)
    -- GuiText(gui, 10, 80, tostring(ORB_COUNT.rounded))

    -- if ORB_COUNT.prev ~= ORB_COUNT.current then
    --     ORB_COUNT.prev = ORB_COUNT.current

    --     -- Set boss HP based on orbs
    --     local boss_hp = 46.0 + (2.0 ^ (ORB_COUNT.rounded + 1.3)) + (ORB_COUNT.rounded * 15.5)
    --     local comp = EntityGetFirstComponent(entity_id, "DamageModelComponent")
    --     if (comp ~= nil) then
    --         ComponentSetValue(comp, "max_hp", tostring(boss_hp))
    --         ComponentSetValue(comp, "hp", tostring(boss_hp))
    --     end

    --     --Update HP bar with appropriate orb count if one exists.
    --     local hp_string = string.format("%.0f", tostring(25 * boss_hp))
    --     local str_length = string.len(hp_string)

    --     local outline_file =
    --         "mods/purgatory/files/ui_gfx/boss_bars/boss_centipede/outline_" .. tostring(str_length) .. ".png"
    --     if ModDoesFileExist(outline_file) then
    --         variableStorageSetValue(entity_id, "STRING", "boss_bar_outline", outline_file)
    --     end

    --     --Purgatory: Set custom HP bar size based on length of health bar.
	-- 	local hp_string = string.format("%.0f", tostring(25 * boss_hp))
    --     local str_length = string.len(hp_string)
	-- 	local outline_file = "mods/purgatory/files/ui_gfx/boss_bars/boss_centipede/outline_" .. tostring(str_length) .. ".png"
    --     if ModDoesFileExist(outline_file) then
    --         variableStorageSetValue(entity_id, "STRING", "boss_bar_outline", outline_file)
	-- 		GamePrint(outline_file)
    --     end
	-- 	local fill_file = "mods/purgatory/files/ui_gfx/boss_bars/boss_centipede/fill_" .. tostring(str_length) .. ".png"
    --     if ModDoesFileExist(outline_file) then
    --         variableStorageSetValue(entity_id, "STRING", "boss_bar_fill", fill_file)
	-- 		GamePrint(fill_file)
    --     end

    -- --75 orb kolmi's hp is 25 digits long
    -- --0 orb hp is 4 digits long. (not that this will happen in purgatory since his hp starts at 11 orbs)
    -- --11 orb hp is 6 digits
    -- end

    -- Declare Vars
    local bar_outline = {}
    local bar_filling = {}

    -- Get Variable Storage Component Values
    local damage_model_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
    local max_hp = 25 * ComponentGetValue2(damage_model_comp, "max_hp")
    local current_hp = 25 * ComponentGetValue2(damage_model_comp, "hp") -- Note Priskip: multiply hp numbers by 25 here because Nolla stores hp numbers at 1/25 size internally for some reason
    if current_hp < 0 then
        current_hp = 0
    end -- Don't display negative numbers

    local boss_bar_position = variableStorageGetValue(entity_id, "STRING", "boss_bar_position")
    local boss_name = variableStorageGetValue(entity_id, "STRING", "boss_name")
    bar_outline.image = variableStorageGetValue(entity_id, "STRING", "boss_bar_outline")
    bar_filling.image = variableStorageGetValue(entity_id, "STRING", "boss_bar_fill")

    local boss_name_vertical_offset = variableStorageGetValue(entity_id, "FLOAT", "boss_name_vertical_offset")

    -- Screen Size Dimensions
    local screen_size = {}
    screen_size.x, screen_size.y = GuiGetScreenDimensions(gui)

    local bar_offset = 0
    if boss_bar_position == "LEFT" then
        bar_offset = -screen_size.x / 4
    end
    if boss_bar_position == "RIGHT" then
        bar_offset = screen_size.x / 4
    end

    -- Image Dimensions
    bar_outline.size_x, bar_outline.size_y = GuiGetImageDimensions(gui, bar_outline.image)
    bar_filling.size_x, bar_filling.size_y = GuiGetImageDimensions(gui, bar_filling.image)

    -- Calculate Positions
    bar_outline.pos_x = screen_size.x / 2 - bar_outline.size_x / 2
    bar_outline.pos_y = screen_size.y - bar_outline.size_y / 2 - screen_size.y / 16
    bar_outline.alpha = 1
    bar_outline.scale = 1
    bar_outline.scale_y = 1
    bar_outline.rot = 0

    bar_filling.pos_x = screen_size.x / 2 - bar_filling.size_x / 2 - 1 --custom -1 for kolmi
    bar_filling.pos_y = screen_size.y - bar_filling.size_y / 2 - screen_size.y / 16
    bar_filling.alpha = 1
    bar_filling.scale = current_hp / max_hp
    bar_filling.scale_y = 1
    bar_filling.rot = 0

    -- Draw Bar Outline
    GuiZSet(gui, 1) -- Bigger Z = Renders Deeper
    GuiImage(
        gui,
        new_gui_id(),
        bar_outline.pos_x + bar_offset,
        bar_outline.pos_y,
        bar_outline.image,
        bar_outline.alpha,
        bar_outline.scale,
        bar_outline.scale_y,
        bar_outline.rot
    )

    -- Draw Bar Filling
    GuiZSet(gui, 2)
    GuiImage(
        gui,
        new_gui_id(),
        bar_filling.pos_x + bar_offset,
        bar_filling.pos_y,
        bar_filling.image,
        bar_filling.alpha,
        bar_filling.scale,
        bar_filling.scale_y,
        bar_filling.rot
    )

    -- Draw Boss Name
    local boss_name_text = {}
    boss_name_text.size_x, boss_name_text.size_y = GuiGetTextDimensions(gui, boss_name, 1, 2)
    boss_name_text.pos_x = screen_size.x / 2 - boss_name_text.size_x / 2
    boss_name_text.pos_y = screen_size.y - bar_outline.size_y - screen_size.y / 20 --change /16 to /20 for kolmi

    if boss_name_vertical_offset ~= nil then
        boss_name_text.pos_y = boss_name_text.pos_y + boss_name_vertical_offset * screen_size.y -- not exactly sure how to scale this, will go with trial and error
    end

    GuiZSet(gui, 0)
    GuiText(gui, boss_name_text.pos_x + bar_offset, boss_name_text.pos_y, boss_name)

    -- Draw Boss Name
    local boss_health_text = {}
    boss_health_text.text =
        string.format("%.0f", tostring(current_hp)) .. " / " .. string.format("%.0f", tostring(max_hp))
    boss_health_text.size_x, boss_health_text.size_y = GuiGetTextDimensions(gui, boss_health_text.text, 1, 2)
    boss_health_text.pos_x = screen_size.x / 2 - boss_health_text.size_x / 2
    boss_health_text.pos_y = bar_outline.pos_y + bar_outline.size_y / 2 - boss_health_text.size_y / 2

    GuiText(gui, boss_health_text.pos_x + bar_offset, boss_health_text.pos_y, boss_health_text.text)
end
--[[

--GuiSlider( gui:obj, id:int, x:number, y:number, text:string, value:number, value_min:number, value_max:number, value_default:number, value_display_multiplier:number, value_formatting:string, width:number ) -> new_value:number

--GuiImage( gui:obj, id:int, x:number, y:number, sprite_filename:string, alpha:number = 1, scale:number = 1, scale_y:number = 0, rotation:number = 0, rect_animation_playback_type:int = GUI_RECT_ANIMATION_PLAYBACK.PlayToEndAndHide, rect_animation_name:string = "" )
--['scale' will be used for 'scale_y' if 'scale_y' equals 0.]

]]
