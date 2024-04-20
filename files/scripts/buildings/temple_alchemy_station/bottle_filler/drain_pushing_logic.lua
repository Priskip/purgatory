dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

local cauldron_sucker = {}
cauldron_sucker.id = GetUpdatedEntityID()
cauldron_sucker.x, cauldron_sucker.y = EntityGetTransform(cauldron_sucker.id)
cauldron_sucker.material_sucker_component = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialSuckerComponent")
cauldron_sucker.mode = ComponentGetValue2(cauldron_sucker.material_sucker_component, "material_type") -- 0 = liquids, 1 = sands

--Read cauldron sucker material inventory contents.
cauldron_sucker.inventory_string, cauldron_sucker.amount_filled = ReadMaterialInventory(cauldron_sucker.id)

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
end

--Get queue
cauldron_sucker.queue = {}
cauldron_sucker.queue.string = variableStorageGetValue(cauldron_sucker.id, "STRING", "queue")
cauldron_sucker.queue.materials = {}
if cauldron_sucker.queue.string ~= "" then
    local material_inventory = splitStringOnCharIntoTable(cauldron_sucker.queue.string, "-")
    for i, v in ipairs(material_inventory) do
        local mat_and_amt = splitStringOnCharIntoTable(v, ",")
        cauldron_sucker.queue.materials[i] = mat_and_amt[1]
    end
end

--Drain Push Logic
if cauldron_sucker.queue.string ~= "" then
    --There are materials to push
    local material_to_push = cauldron_sucker.queue.materials[1]
    local has_material_needed_to_push = isInTable(cauldron_sucker.materials, material_to_push)

    if has_material_needed_to_push then
        --Material that is trying to be pushed is present - push said material.

        local drain_ent = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/bottle_filler/drain.xml", cauldron_sucker.x - 7, cauldron_sucker.y + 20)
        local particle_emitter_comps = EntityGetComponent(drain_ent, "ParticleEmitterComponent")

        for i, comp in ipairs(particle_emitter_comps) do
            ComponentSetValue2(comp, "emitted_material_name", material_to_push)
        end

        variableStorageSetValue(drain_ent, "STRING", "material_and_amount", material_to_push)
        variableStorageSetValue(drain_ent, "INT", "material_and_amount", tonumber(cauldron_sucker.amounts[findElementInTable(cauldron_sucker.materials, material_to_push)]))
        variableStorageSetValue(drain_ent, "INT", "material_type", cauldron_sucker.mode)
        
    else
        --Material that is trying to be pushed in NOT present - remove said material from the queue and pushing a new material from the queue.
        table.remove(cauldron_sucker.queue.materials, 1)
        local new_queue_string = ""
        for i, mat in ipairs(cauldron_sucker.queue.materials) do
            new_queue_string = new_queue_string .. mat

            if i ~= #cauldron_sucker.queue.materials then
                new_queue_string = new_queue_string .. ","
            end
        end
        variableStorageSetValue(cauldron_sucker.id, "STRING", "queue", new_queue_string)
    end
else
    --queue is empty, deactivate this script
    cauldron_sucker.lua_components = EntityGetComponentIncludingDisabled(cauldron_sucker.id, "LuaComponent")

    if cauldron_sucker.lua_components ~= nil then
        for i, lua_comp in ipairs(cauldron_sucker.lua_components) do
            local script_file = ComponentGetValue2(lua_comp, "script_source_file")

            if script_file == "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/drain_pushing_logic.lua" then
                EntitySetComponentIsEnabled(cauldron_sucker.id, lua_comp, false)
            end
        end
    end
end

