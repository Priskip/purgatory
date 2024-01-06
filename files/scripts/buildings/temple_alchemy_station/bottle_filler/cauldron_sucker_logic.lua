dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

local cauldron_sucker = {}
cauldron_sucker.id = GetUpdatedEntityID()
cauldron_sucker.x, cauldron_sucker.y = EntityGetTransform(cauldron_sucker.id)
cauldron_sucker.material_sucker_component = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialSuckerComponent")

--Look to see if there is a placed potion on the bottle stand.
local bottle_stand = {}
bottle_stand.id = get_entity_in_radius_with_name(cauldron_sucker.x, cauldron_sucker.y, 50, "temple_alchemy_bottle_stand", "temple_alchemy_station")[1] --Should only ever be 1 filler gauge in area. If not, there's problems
local placed_bottle = {}
placed_bottle.id = EntityGetAllChildren(bottle_stand.id)
if placed_bottle.id ~= nil then
    placed_bottle.id = placed_bottle.id[1] --should only have 1 child ent - if not, this is bad
end

--Read material inventory contents.
cauldron_sucker.inventory_string, cauldron_sucker.amount_filled = ReadMaterialInventory(cauldron_sucker.id)

--Enables/Disables the material sucker component on the cauldron sucker depending on whether a flask/sack is present on the filling stand.
--Also sets the type of material the sucker component will suck.
if placed_bottle.id == nil then
    --No bottle in stand, deactivate sucker
    local is_enabled = ComponentGetIsEnabled(cauldron_sucker.material_sucker_component)
    --Checking to see if the component is enabled first that way we're not constantly updating the component.
    if is_enabled and cauldron_sucker.inventory_string == "" then
        EntitySetComponentIsEnabled(cauldron_sucker.id, cauldron_sucker.material_sucker_component, false)
    end
else
    --Bottle in stand, activate sucker
    local is_enabled = ComponentGetIsEnabled(cauldron_sucker.material_sucker_component)

    --Checking to see if the component is disabled first that way we're not constantly updating the component.
    if not is_enabled then
        EntitySetComponentIsEnabled(cauldron_sucker.id, cauldron_sucker.material_sucker_component, true)

        local potion_or_sack = IsPotionOrSack(placed_bottle.id)
        if potion_or_sack == "potion" and cauldron_sucker.inventory_string == "" then
            ComponentSetValue2(cauldron_sucker.material_sucker_component, "material_type", 0) --Sets the type of materials to suck to liquids
        elseif potion_or_sack == "powder_stash" and cauldron_sucker.inventory_string == "" then
            ComponentSetValue2(cauldron_sucker.material_sucker_component, "material_type", 1) --Sets the type of materials to suck to sands
        elseif potion_or_sack == nil then
            print("Error: [cauldron_sucker_logic.lua] potion_or_sack == nil")
        end
    end
end

--If cauldron material contents is not empty, process material string into list of materials for adding to the queue
cauldron_sucker.materials = {}
cauldron_sucker.amounts = {}
if cauldron_sucker.inventory_string ~= "" then
    local material_inventory = split_string_on_char_into_table(cauldron_sucker.inventory_string, "-")
    for i, v in ipairs(material_inventory) do
        local mat_and_amt = split_string_on_char_into_table(v, ",")
        cauldron_sucker.materials[i] = mat_and_amt[1]
        cauldron_sucker.amounts[i] = mat_and_amt[2]
    end
end

--Get queue
cauldron_sucker.queue = {}
cauldron_sucker.queue.string = variable_storage_get_value(cauldron_sucker.id, "STRING", "queue")
cauldron_sucker.queue.materials = {}
if cauldron_sucker.queue.string ~= "" then
    local material_inventory = split_string_on_char_into_table(cauldron_sucker.queue.string, "-")
    for i, v in ipairs(material_inventory) do
        local mat_and_amt = split_string_on_char_into_table(v, ",")
        cauldron_sucker.queue.materials[i] = mat_and_amt[1]
    end
end

--Check materials of sucker and materials of queue and add any new materials in sucker to the queue
for i, mat in ipairs(cauldron_sucker.materials) do
    local is_in_queue = is_in_table(cauldron_sucker.queue.materials, mat)
    if not is_in_queue then
        --Add to the queue
        cauldron_sucker.queue.materials[#cauldron_sucker.queue.materials + 1] = mat
    end
end

--Generate new queue string and save it to var storage
local new_queue_string = ""
for i, mat in ipairs(cauldron_sucker.queue.materials) do
    new_queue_string = new_queue_string .. mat

    if i ~= #cauldron_sucker.queue.materials then
        new_queue_string = new_queue_string .. ","
    end
end
variable_storage_set_value(cauldron_sucker.id, "STRING", "queue", new_queue_string)

--Activate drain pushing logic if queue is not empty
if cauldron_sucker.queue.string ~= "" then
    cauldron_sucker.lua_components = EntityGetComponentIncludingDisabled(cauldron_sucker.id, "LuaComponent")

    if cauldron_sucker.lua_components ~= nil then
        for i, lua_comp in ipairs(cauldron_sucker.lua_components) do
            local script_file = ComponentGetValue2(lua_comp, "script_source_file")

            if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/drain_pushing_logic.lua" then
                local is_enabled = ComponentGetIsEnabled(lua_comp)
                if not is_enabled then
                    EntitySetComponentIsEnabled(cauldron_sucker.id, lua_comp, true)
                end
            end
        end
    end
end

--if no placed bottle and no material in inventory, disable this script
if placed_bottle.id == nil and cauldron_sucker.inventory_string == "" then
    cauldron_sucker.lua_components = EntityGetComponentIncludingDisabled(cauldron_sucker.id, "LuaComponent")

    if cauldron_sucker.lua_components ~= nil then
        for i, lua_comp in ipairs(cauldron_sucker.lua_components) do
            local script_file = ComponentGetValue2(lua_comp, "script_source_file")

            if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/cauldron_sucker_logic.lua" then
                EntitySetComponentIsEnabled(cauldron_sucker.id, lua_comp, false)
            end
        end
    end
end
