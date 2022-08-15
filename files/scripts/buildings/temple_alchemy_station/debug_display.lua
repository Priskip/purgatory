dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

local bottle_stand_placed_potion = {}
local cauldron_sucker = {}
local drain = {}

--GUI
local id = 1
local function new_id()
    id = id + 1
    return id
end
gui = gui or GuiCreate()
GuiStartFrame(gui)

--Placed Bottle Display
--The placed bottle is calling the cauldron sucker logic
bottle_stand_placed_potion.id = GetUpdatedEntityID()

--Get Material Inventory Components
bottle_stand_placed_potion.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(bottle_stand_placed_potion.id, "MaterialInventoryComponent")
bottle_stand_placed_potion.count_per_material_type = ComponentGetValue2(bottle_stand_placed_potion.mat_inv_comp, "count_per_material_type")
bottle_stand_placed_potion.total_volume = 0
local count = 0

if bottle_stand_placed_potion.count_per_material_type ~= nil then
    for i, v in ipairs(bottle_stand_placed_potion.count_per_material_type) do
        if v ~= 0 then
            count = count + 1
            bottle_stand_placed_potion.total_volume = bottle_stand_placed_potion.total_volume + v
            GuiText(gui, 20, 50 + 10 * count, CellFactory_GetName(i - 1) .. ": " .. tostring(v))
        end
    end
end

GuiText(gui, 20, 40, "Placed Bottle")
GuiText(gui, 20, 50, "Total Volume: " .. tostring(bottle_stand_placed_potion.total_volume))

--Cauldron Sucker Display
cauldron_sucker.id = EntityGetClosestWithTag(x, y, "temple_alchemy_cauldron_sucker")

if cauldron_sucker.id ~= 0 then
    --Get Material Inventory Components
    cauldron_sucker.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialInventoryComponent")
    cauldron_sucker.count_per_material_type = ComponentGetValue2(cauldron_sucker.mat_inv_comp, "count_per_material_type")
    cauldron_sucker.total_volume = 0
    local count = 0

    if cauldron_sucker.count_per_material_type ~= nil then
        for i, v in ipairs(cauldron_sucker.count_per_material_type) do
            if v ~= 0 then
                count = count + 1
                cauldron_sucker.total_volume = cauldron_sucker.total_volume + v
                GuiText(gui, 300, 60 + 10 * count, CellFactory_GetName(i - 1) .. ": " .. tostring(v))
            end
        end
    end

    GuiText(gui, 300, 40, "Cauldron Sucker")
    GuiText(gui, 300, 50, "Total Volume: " .. tostring(cauldron_sucker.total_volume))

    cauldron_sucker.mat_suck_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialSuckerComponent")
    GuiText(gui, 300, 60, "Barrel Size: " .. tostring(ComponentGetValue2(cauldron_sucker.mat_suck_comp, "barrel_size")))
end

--Cauldron Sucker Display
drain.id = EntityGetClosestWithTag(x, y, "temple_alchemy_drain")

if drain.id ~= 0 then
    --Get Amounts
    local material_to_emit = variable_storage_get_value(drain.id, "STRING", "material_to_emit")
    local amount_of_material = variable_storage_get_value(drain.id, "INT", "amount_of_material")

    GuiText(gui, 500, 40, "Drain")
    GuiText(gui, 500, 50, "Material: " .. material_to_emit)
    GuiText(gui, 500, 60, "Amount: " .. amount_of_material)
end
