dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local ent_x, ent_y = EntityGetTransform(entity_id)

local player_id = getPlayerEntity()


-- Gui Starters
local gui_id = 1
local function new_gui_id()
    gui_id = gui_id + 1
    return gui_id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)


local player_ingestion_comp = EntityGetFirstComponentIncludingDisabled(player_id, "IngestionComponent")
local blood_healing_speed = ComponentGetValue2(player_ingestion_comp, "blood_healing_speed")



GuiText(gui, 10, 50, "blood_healing_speed = " .. tostring(blood_healing_speed))



local differentials = {
    -1000,
    -100,
    -10,
    -1,
    1,
    10,
    100,
    1000
}
AMOUNT = AMOUNT or 0

local x_pos = 10
for i, v in ipairs(differentials) do
    

    if(GuiButton(gui, new_gui_id(), x_pos, 60, tostring(v))) then 
        AMOUNT = AMOUNT + v
    end

    local w, h = GuiGetTextDimensions(gui, tostring(v))
    x_pos = x_pos + w + 5
end

GuiText(gui, 10, 70, "AMOUNT = " .. tostring (AMOUNT))






local player_damage_model_comp = EntityGetFirstComponentIncludingDisabled(player_id, "DamageModelComponent")
local current_hp = ComponentGetValue2(player_damage_model_comp, "hp")
local max_hp = ComponentGetValue2(player_damage_model_comp, "max_hp")

GuiText(gui, 10, 90, "current_hp = " .. tostring(current_hp))
GuiText(gui, 10, 100, "max_hp = " .. tostring(max_hp))

local blood_amount_to_heal = (max_hp - current_hp) / blood_healing_speed

GuiText(gui, 10, 120, "blood_amount_to_heal = " .. tostring(blood_amount_to_heal))



if(GuiButton(gui, new_gui_id(), 10, 140, "[Feed]")) then 
    EntityIngestMaterial(player_id, CellFactory_GetType("blood"), AMOUNT) --makes player eat the blood
end




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
