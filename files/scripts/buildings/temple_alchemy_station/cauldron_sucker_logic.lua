dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

--Get IDs and Positions
local cauldron_sucker = {}
local bottle_stand_placed_potion = {}

cauldron_sucker.id = GetUpdatedEntityID()
cauldron_sucker.x, cauldron_sucker.y = EntityGetTransform(cauldron_sucker.id)

bottle_stand_placed_potion.id = EntityGetClosestWithTag(cauldron_sucker.x, cauldron_sucker.y, "temple_alchemy_bottle_stand_placed_potion") --Returns 0 if no ent is found

--If we find the potion in the bottle stand, then we push material from the cauldron sucker to it through the drain
if bottle_stand_placed_potion.id ~= 0 then
    --Get Material Inventory Components
    bottle_stand_placed_potion.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(bottle_stand_placed_potion.id, "MaterialInventoryComponent")
    bottle_stand_placed_potion.count_per_material_type = ComponentGetValue2(bottle_stand_placed_potion.mat_inv_comp, "count_per_material_type")
    cauldron_sucker.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialInventoryComponent")
    cauldron_sucker.count_per_material_type = ComponentGetValue2(cauldron_sucker.mat_inv_comp, "count_per_material_type")

    --Count how much stuff is in the placed bottle
    local max_bottle_capacity = 1000
    bottle_stand_placed_potion.total_volume = 0

    if bottle_stand_placed_potion.count_per_material_type ~= nil then
        for i, v in ipairs(bottle_stand_placed_potion.count_per_material_type) do
            if v ~= 0 then
                bottle_stand_placed_potion.total_volume = bottle_stand_placed_potion.total_volume + v
            end
        end
    end

    --Set barrel size of cauldorn sucker to amount of empty space inside placed bottle and enable sucker
    cauldron_sucker.mat_suck_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialSuckerComponent")
    --ComponentSetValue2(cauldron_sucker.mat_suck_comp, "barrel_size", max_bottle_capacity - bottle_stand_placed_potion.total_volume) Disabled because with the changes to the drain this is no longer needed
    EntitySetComponentIsEnabled(cauldron_sucker.id, cauldron_sucker.mat_suck_comp, true)

    --Count Materials from cauldron sucker's inventory and add them to the queue to push
    local count = 0
    local queue = variable_storage_get_value(cauldron_sucker.id, "STRING", "queue")
    cauldron_sucker.mat_inv_contents = {}

    if queue == "" then
        queue = {}
    else
        queue = split_string_on_char_into_table(queue, ",")
    end
    
    if cauldron_sucker.count_per_material_type ~= nil then
        --Counts how much of each material is inside the cauldron sucker and empties the cauldron sucker's inventory
        for i, v in ipairs(cauldron_sucker.count_per_material_type) do
            if v ~= 0 then
                count = count + 1
                cauldron_sucker.mat_inv_contents[count] = {
                    material = CellFactory_GetName(i - 1),
                    amount = v
                }

                if not is_in_table(queue, cauldron_sucker.mat_inv_contents[count].material) then
                    --Add this material to the queue
                    queue[#queue + 1] = cauldron_sucker.mat_inv_contents[count].material
                end
            end
        end
    end

    --Store queue data
    variable_storage_set_value(cauldron_sucker.id, "STRING", "queue", table_to_char_separated_string(queue, ","))

    --Add Lua Component to trigger pushing materials to drain every second if the cauldorn sucker does not have one
    local push_components = EntityGetComponent(cauldron_sucker.id, "LuaComponent", "push_to_drain_script")
    local push_comp = 0
    if push_components == nil then
        --Add Component
        push_comp =
            EntityAddComponent2(
            cauldron_sucker.id,
            "LuaComponent",
            {
                execute_on_added = false,
                script_source_file = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/cauldron_sucker_push_to_drain.lua.",
                execute_every_n_frame = 60,
                remove_after_executed = true
            }
        )
        ComponentAddTag(push_comp, "push_to_drain_script")
    else
        push_comp = push_components[1] --should only get component here. If not, whoops... ¯\_(ツ)_/¯
    end

    --Debug Display
    local debug_display = false

    if debug_display then
        local text_to_print = "Queue: "

        if #queue ~= 0 then
            for i, v in ipairs(queue) do
                text_to_print = text_to_print .. v

                if i ~= #queue then
                    text_to_print = text_to_print .. ", "
                end
            end
        else
            text_to_print = text_to_print .. "empty"
        end

        gui = gui or GuiCreate()
        GuiStartFrame(gui)

        GuiText(gui, 300, 20, text_to_print)
    end
end
