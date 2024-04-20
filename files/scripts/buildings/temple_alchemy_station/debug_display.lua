dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

--Gui Header
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

--Function for automatically incrementing y values
local y_val = 0
local x_val = 0
local function new_y_value()
    y_val = y_val + 10
    return y_val
end
local function set_y_value(num)
    y_val = num
    return y_val
end
local width, height = 0, 0

--Get Entities
local debug_display = {}
debug_display.id = GetUpdatedEntityID()
debug_display.x, debug_display.y = EntityGetTransform(debug_display.id)

local cauldron_sucker = {}
cauldron_sucker.id = getEntityInRadiusWithName(debug_display.x, debug_display.y, 200, "temple_alchemy_cauldron_sucker", "temple_alchemy_station")[1] --Should only ever be 1 cauldron sucker in area. If not, there's problems

local bottle_stand = {}
bottle_stand.id = getEntityInRadiusWithName(debug_display.x, debug_display.y, 200, "temple_alchemy_bottle_stand", "temple_alchemy_station")[1] --Should only ever be 1 cauldron sucker in area. If not, there's problems

local placed_bottle = {}
placed_bottle.id = EntityGetAllChildren(bottle_stand.id)
if placed_bottle.id ~= nil then
    placed_bottle.id = placed_bottle.id[1] --should only ever have 1 child ent on this
end

if not GameIsInventoryOpen() then
    --Begin Ui
    if GuiImageButton(gui, new_id(), 100, 0, "Kill Debug Desplay", "mods/purgatory/files/ui_gfx/debug/button_death.png") then
        EntityKill(debug_display.id)
    end

    --Cauldron Sucker Info
    x_val = 10
    GuiText(gui, x_val, set_y_value(40), "Cauldron Sucker")
    if cauldron_sucker.id ~= nil then
        --Lua Components' States
        cauldron_sucker.lua_components = EntityGetComponentIncludingDisabled(cauldron_sucker.id, "LuaComponent")
        cauldron_sucker.cauldron_sucker_logic_enabled = nil
        cauldron_sucker.drain_pushing_logic_enabled = nil

        if cauldron_sucker.lua_components ~= nil then
            for i, lua_comp in ipairs(cauldron_sucker.lua_components) do
                local script_file = ComponentGetValue2(lua_comp, "script_source_file")

                if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/cauldron_sucker_logic.lua" then
                    cauldron_sucker.cauldron_sucker_logic_enabled = ComponentGetIsEnabled(lua_comp)
                end

                if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/drain_pushing_logic.lua" then
                    cauldron_sucker.drain_pushing_logic_enabled = ComponentGetIsEnabled(lua_comp)
                end
            end
        end

        width, height = GuiGetTextDimensions(gui, "cauldron_sucker_logic.lua: ", 1, 2)
        GuiText(gui, x_val, new_y_value(), "cauldron_sucker_logic.lua: ")
        if cauldron_sucker.cauldron_sucker_logic_enabled then
            GuiColorSetForNextWidget(gui, 0, 1, 0, 1) --r, g, b, a (this is green)
            GuiText(gui, x_val + width, y_val, "enabled")
        else
            GuiColorSetForNextWidget(gui, 1, 0, 0, 1) --r, g, b, a (this is red)
            GuiText(gui, x_val + width, y_val, "disabled")
        end

        width, height = GuiGetTextDimensions(gui, "drain_pushing_logic.lua: ", 1, 2)
        GuiText(gui, x_val, new_y_value(), "drain_pushing_logic.lua: ")
        if cauldron_sucker.drain_pushing_logic_enabled then
            GuiColorSetForNextWidget(gui, 0, 1, 0, 1) --r, g, b, a (this is green)
            GuiText(gui, x_val + width, y_val, "enabled")
        else
            GuiColorSetForNextWidget(gui, 1, 0, 0, 1) --r, g, b, a (this is red)
            GuiText(gui, x_val + width, y_val, "disabled")
        end

        --Queue
        new_y_value() --update a y value to have a blank space
        GuiText(gui, x_val, new_y_value(), "Queue: ")
        cauldron_sucker.queue = {}
        cauldron_sucker.queue.string = variableStorageGetValue(cauldron_sucker.id, "STRING", "queue")
        cauldron_sucker.queue.materials = {}
        if cauldron_sucker.queue.string ~= "" then
            --queue has stuff in it
            local material_inventory = splitStringOnCharIntoTable(cauldron_sucker.queue.string, "-")
            for i, v in ipairs(material_inventory) do
                local mat_and_amt = splitStringOnCharIntoTable(v, ",")
                cauldron_sucker.queue.materials[i] = mat_and_amt[1]
            end

            for i, v in ipairs(cauldron_sucker.queue.materials) do
                GuiText(gui, x_val, new_y_value(), tostring(i) .. ": " .. v)
            end
        else
            --queue is Empty
            width, height = GuiGetTextDimensions(gui, "Queue: ", 1, 2)
            GuiColorSetForNextWidget(gui, 0, 0.25, 0.25, 0.25)
            GuiText(gui, x_val + width, y_val, "Empty")
        end

        --Mat Sucker
        new_y_value() --update a y value to have a blank space
        cauldron_sucker.material_sucker_component = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialSuckerComponent")
        cauldron_sucker.material_sucker_component_is_enabled = ComponentGetIsEnabled(cauldron_sucker.material_sucker_component)
        cauldron_sucker.material_sucker_component_sucker_type = ComponentGetValue2(cauldron_sucker.material_sucker_component, "material_type")
        GuiText(gui, x_val, new_y_value(), "Material Sucker Component: ")

        width, height = GuiGetTextDimensions(gui, "Is Enabled: ", 1, 2)
        GuiText(gui, x_val, new_y_value(), "Is Enabled: ")
        if cauldron_sucker.material_sucker_component_is_enabled then
            GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
            GuiText(gui, x_val + width, y_val, "true")
        else
            GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
            GuiText(gui, x_val + width, y_val, "false")
        end

        width, height = GuiGetTextDimensions(gui, "Sucker Type: ", 1, 2)
        GuiText(gui, x_val, new_y_value(), "Sucker Type: ")
        if cauldron_sucker.material_sucker_component_sucker_type == 0 then
            GuiColorSetForNextWidget(gui, 0, 0.2, 0.2, 1)
            GuiText(gui, x_val + width, y_val, "Liquids")
        elseif cauldron_sucker.material_sucker_component_sucker_type == 1 then
            GuiColorSetForNextWidget(gui, 1, 1, 0.2, 1)
            GuiText(gui, x_val + width, y_val, "Sands")
        else
            GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
            GuiText(gui, x_val + width, y_val, "error?!")
        end

        --Material Inventory
        cauldron_sucker.inventory_string, cauldron_sucker.amount_filled = ReadMaterialInventory(cauldron_sucker.id)
        new_y_value() --update a y value to have a blank space
        GuiText(gui, x_val, new_y_value(), "Material Inventory: ")

        --If cauldron material contents is not empty, process material string into list of materials for adding to the queue
        cauldron_sucker.materials = {}
        cauldron_sucker.amounts = {}
        if cauldron_sucker.inventory_string ~= "" then
            local material_inventory = splitStringOnCharIntoTable(cauldron_sucker.inventory_string, "-")
            for i, v in ipairs(material_inventory) do
                local mat_and_amt = splitStringOnCharIntoTable(v, ",")
                cauldron_sucker.materials[i] = mat_and_amt[1]
                cauldron_sucker.amounts[i] = mat_and_amt[2]
            end

            for i, v in ipairs(cauldron_sucker.materials) do
                GuiText(gui, x_val, new_y_value(), v .. " - " .. tostring(cauldron_sucker.amounts[i]))
            end

        else
            --inv is empty
            width, height = GuiGetTextDimensions(gui, "Material Inventory: ", 1, 2)
            GuiColorSetForNextWidget(gui, 0, 0.25, 0.25, 0.25)
            GuiText(gui, x_val + width, y_val, "Empty")
        end



    else
        GuiText(gui, x_val, new_y_value(), "Could not find cauldron sucker id")
    end

    --Placed Bottle Info
    x_val = 210
    GuiText(gui, x_val, set_y_value(40), "Placed Bottle")
    if placed_bottle.id ~= nil then
        --Read cauldron sucker material inventory contents.
        placed_bottle.inventory_string, placed_bottle.amount_filled, placed_bottle.barrel_size, placed_bottle.potion_or_sack = ReadPotionInventory(placed_bottle.id)

        GuiText(gui, x_val, new_y_value(), "Amount Filled: " .. tostring(placed_bottle.amount_filled))
        GuiText(gui, x_val, new_y_value(), "Barrel Size: " .. tostring(placed_bottle.barrel_size))
        GuiText(gui, x_val, new_y_value(), "Potion or Sack: " .. tostring(placed_bottle.potion_or_sack))

        --If cauldron material contents is not empty, process material string into list of materials for adding to the queue
        placed_bottle.materials = {}
        placed_bottle.amounts = {}
        if placed_bottle.inventory_string ~= "" then
            local material_inventory = splitStringOnCharIntoTable(placed_bottle.inventory_string, "-")
            for i, v in ipairs(material_inventory) do
                local mat_and_amt = splitStringOnCharIntoTable(v, ",")
                placed_bottle.materials[i] = mat_and_amt[1]
                placed_bottle.amounts[i] = mat_and_amt[2]
            end

            new_y_value() --update a y value to have a blank space

            GuiText(gui, x_val, new_y_value(), "Inventory: ")

            for i, v in ipairs(placed_bottle.materials) do
                GuiText(gui, x_val, new_y_value(), v .. " - " .. tostring(placed_bottle.amounts[i]))
            end
        end
    else
        GuiText(gui, 210, new_y_value(), "Could not find placed bottle id")
    end
end
