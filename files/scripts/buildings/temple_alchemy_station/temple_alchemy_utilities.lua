dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function read_potion_inventory(potion_entity_id)
    --[[
    Description:
    Reads the materials stored in the MaterialInventoryComponent of the provided entity.
    Returns those materials and amounts in a string sorted from most numerous material to least numerous material. See Return Type for inventory_string below

    Usage:
    inventory_string, amount_filled, barrel_size, potion_or_sack = read_potion_inventory(potion_entity_id)
    
    Input Types:
    potion_entity_id = [num] Numeric entity id of the potion entity you want to read the contents of

    Return Types:
    inventory_string = "magic_liquid_movement_faster,477-oil,17" [string]
    amount_filled = [num]
    barrel_size = [num]
    potion_or_sack = "potion" or "powder_stash" [string]

    All values will return nil upon error
]]
    local inventory_string = ""
    local amount_filled = 0
    local barrel_size = 0
    local potion_or_sack = ""

    --Check entity type
    local is_potion = EntityHasTag(potion_entity_id, "potion")
    local is_sack = EntityHasTag(potion_entity_id, "powder_stash")

    --Potion or sack?
    if is_potion then
        potion_or_sack = "potion"
    end
    if is_sack then
        potion_or_sack = "powder_stash"
    end

    --Read inventory if potion or sack was provided
    if not (is_potion or is_sack) then
        --Error case
        print("Error! [temple_alchemy_utilities.lua] read_potion_inventory(potion_entity_id) - Entity given is not a potion nor powder stash.")
        inventory_string = nil
        amount_filled = nil
        barrel_size = nil
        potion_or_sack = nil
    else
        --Given entity id is that of a potion or powder stash - can proceed to read its contents.

        --Get Barrel Size
        local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(potion_entity_id, "MaterialSuckerComponent")
        barrel_size = ComponentGetValue2(material_sucker_comp, "barrel_size")

        --Read material inventory
        local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(potion_entity_id, "MaterialInventoryComponent")
        local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")
        local count = 0
        local inventory_contents = {}
        for i, v in ipairs(count_per_material_type) do
            if v ~= 0 then
                --print(CellFactory_GetName(i - 1) .. ": " .. v)
                count = count + 1
                inventory_contents[count] = {
                    material = CellFactory_GetName(i - 1),
                    amount = v
                }
                amount_filled = amount_filled + v
            end
        end

        if count > 1 then
            --Sort material inventory contents from material with most volume present to least volume present
            local sorted = false
            while not sorted do
                sorted = true
                for i = 1, #inventory_contents - 1 do
                    if inventory_contents[i].amount < inventory_contents[i + 1].amount then
                        inventory_contents[i], inventory_contents[i + 1] = inventory_contents[i + 1], inventory_contents[i]
                        sorted = false
                    end
                end
            end
        end

        --Format into string
        if count > 0 then
            for i, v in ipairs(inventory_contents) do
                if i > 1 then
                    inventory_string = inventory_string .. "-"
                end

                inventory_string = inventory_string .. v.material .. "," .. tostring(v.amount)
            end
        end
    end --else not error

    return inventory_string, amount_filled, barrel_size, potion_or_sack
end

function create_stored_potion_entity(material_inventory_string, barrel_size, potion_or_sack, x, y)
    --[[
    Description:
    Creates a storage potion/powder sack at x, y.
    Stored potions/powder sacks are only sprites and cannot physically interact with the world. 

    Usage:
    stored_potion_entity = create_stored_potion_entity(material_inventory_string, potion_or_sack)
    
    Input Types:
    material_inventory_string = [string]
        examples:   ""
                    "water,550"
                    "magic_liquid_movement_faster,477-oil,17"
    potion_or_sack = "potion" or "powder_stash"
    barrel_size = [num] Barrel size for newly created potion/sack
    x = [num] X coordinate for the newly summoned entity
    y = [num] Y coordinate for the newly summoned entity

    Return Types:
    stored_potion_entity = [num] Numeric ID of the newly created stored potion entity
    
    Value returned will be nil upon error
]]
    local new_potion_ent = nil
    local is_error = false

    if potion_or_sack ~= "potion" and potion_or_sack ~= "powder_stash" then
        print('Error! [temple_alchemy_utilities.lua] create_stored_potion_entity(material_inventory_string, potion_or_sack) - Incorrect "potion_or_sack" value given.')
        is_error = true
    end

    if not is_error then
        --Summon new potion entity.
        new_potion_ent = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/stored_ents/" .. potion_or_sack .. ".xml", x, y)

        --Add materials to potion
        if material_inventory_string ~= "" then
            --Potion is not empty, must add materials to it
            local material_inventory = split_string_on_char_into_table(material_inventory_string, "-")

            for i, v in ipairs(material_inventory) do
                local mat_and_amt = split_string_on_char_into_table(v, ",")
                AddMaterialInventoryMaterial(new_potion_ent, mat_and_amt[1], mat_and_amt[2])
            end
        end

        --Set Barrel Size
        local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(new_potion_ent, "MaterialSuckerComponent")
        ComponentSetValue2(material_sucker_comp, "barrel_size", barrel_size)
    end

    return new_potion_ent
end

function create_pickup_potion_entity(material_inventory_string, barrel_size, potion_or_sack, x, y)
    --[[
    Description:
    Creates a potion/powder sack at x, y that the player forcfully picks up

    Usage:
    pickup_potion_entity = create_pickup_potion_entity(material_inventory_string, barrel_size, potion_or_sack, x, y)
    
    Input Types:
    material_inventory_string = [string]
        examples:   ""
                    "water,550"
                    "magic_liquid_movement_faster,477-oil,17"
    potion_or_sack = "potion" or "powder_stash"
    barrel_size = [num] Barrel size for newly created potion/sack
    x = [num] X coordinate for the newly summoned entity
    y = [num] Y coordinate for the newly summoned entity

    Return Types:
    pickup_potion_entity = [num] Numeric ID of the newly created pick up potion entity
    
    Value returned will be nil upon error
]]
    local new_potion_ent = nil
    local is_error = false

    if potion_or_sack ~= "potion" and potion_or_sack ~= "powder_stash" then
        print('Error! [temple_alchemy_utilities.lua] create_stored_potion_entity(material_inventory_string, potion_or_sack) - Incorrect "potion_or_sack" value given.')
        is_error = true
    end

    if not is_error then
        --Summon new potion entity.
        new_potion_ent = EntityLoad("data/entities/items/pickup/" .. potion_or_sack .. ".xml", x + 4, y + 8)

        local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(new_potion_ent, "MaterialInventoryComponent")
        local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

        --Empties new potion
        for i, v in ipairs(count_per_material_type) do
            if v ~= 0 then
                AddMaterialInventoryMaterial(new_potion_ent, CellFactory_GetName(i - 1), 0)
            end
        end

        --Add materials to potion
        if material_inventory_string ~= "" then
            --Potion is not empty, must add materials to it
            local material_inventory = split_string_on_char_into_table(material_inventory_string, "-")

            for i, v in ipairs(material_inventory) do
                local mat_and_amt = split_string_on_char_into_table(v, ",")
                AddMaterialInventoryMaterial(new_potion_ent, mat_and_amt[1], mat_and_amt[2])
            end
        end

        --Set Barrel Size
        local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(new_potion_ent, "MaterialSuckerComponent")
        ComponentSetValue2(material_sucker_comp, "barrel_size", barrel_size)

        --Make new potion auto pickup
        local item_comp = EntityGetFirstComponentIncludingDisabled(new_potion_ent, "ItemComponent")
        ComponentSetValue2(item_comp, "auto_pickup", true)

        --Make invisible on pickup
        EntitySetComponentIsEnabled(new_potion_ent, EntityGetFirstComponentIncludingDisabled(new_potion_ent, "PhysicsBodyComponent"), false)
        EntitySetComponentIsEnabled(new_potion_ent, EntityGetFirstComponentIncludingDisabled(new_potion_ent, "PhysicsImageShapeComponent"), false)
        EntitySetComponentIsEnabled(new_potion_ent, EntityGetFirstComponentIncludingDisabled(new_potion_ent, "ProjectileComponent"), false)

        --Make Pickup really fast
        local frame = GameGetFrameNum()
        ComponentSetValue2(item_comp, "next_frame_pickable", frame)

        --Turn off auto pickup after picked up
        EntityAddComponent2(
            new_potion_ent,
            "LuaComponent",
            {
                remove_after_executed = true,
                script_item_picked_up = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/storage/pickup_new_bottle.lua"
            }
        )
    end --if not is_error

    return new_potion_ent
end

function get_display_text_from_material_string(material_inventory_string)
    --[[
    Description:
    Generates the nice looking display information from a material inventory string

    Usage:
    display_string = get_display_text_from_material_string(material_inventory_string)
    
    Input and Return Examples
    
    Inputs
    ""
    "water,550"
    "magic_liquid_movement_faster,477-oil,17"
    "blood,500-magic_liquid_movement_faster,477-oil,12"

    Outputs
    "Empty"
    "Water"
    "Acceleratium + Oil"
    "Blood + Acceleratium + Oil"
]]
    local display_string = "Empty"

    if material_inventory_string ~= "" then
        --Calculate name
        display_string = ""

        --Potion is not empty, must add materials to it
        local material_inventory = split_string_on_char_into_table(material_inventory_string, "-")

        for i, v in ipairs(material_inventory) do
            if i > 1 then
                display_string = display_string .. "+"
            end

            local mat_and_amt = split_string_on_char_into_table(v, ",")

            display_string = display_string .. first_letter_to_upper(GameTextGetTranslatedOrNot(CellFactory_GetUIName(CellFactory_GetType(mat_and_amt[1]))))
        end
    end

    return display_string
end

function get_gfx_glows_of_materials(material_list)
    --[[
    Description:
    Returns a list of gfx_glow values for the materials specified in the input list

    Usage:
    gfx_glow_list = get_gfx_glows_of_materials(material_list)
    
    Input Types:
    material_list = [table] of material id strings
    Example: {"water", "blood", "magic_liquid_polymorph", "gold"}

    Return Types:
    gfx_glow_list = [table] of ints
    Example: {0, 0 150, 127}

    Note: In vanilla noita, the range of values for gfx_glow is 0 to 1000
]]
    local gfx_glow_list = {}

    local nxml = dofile_once("mods/purgatory/libraries/nxml.lua")
    local materials_xml = ModTextFileGetContent("data/materials.xml")
    local xml = nxml.parse(materials_xml)

    local count = 0

    for element in xml:each_child() do
        local index = find_element_in_table(material_list, element.attr.name)

        if index ~= nil then
            gfx_glow_list[index] = element.attr.gfx_glow or 0
            count = count + 1
        end

        if count == #material_list then
            --all elements have had their glow found, stop search.
            break
        end
    end

    return gfx_glow_list
end

function read_material_inventory(entity_id)
    --[[
    Description:
    Reads the materials stored in the MaterialInventoryComponent of the provided entity.
    Returns those materials and amounts in a string sorted from most numerous material to least numerous material. See Return Type for inventory_string below.
    This function is different than "read_potion_inventory(potion_entity_id)" in the fact that it does not care if the entity provided is a potion or sack.
    This function is primarilly used in "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/cauldron_sucker_logic.lua"

    Usage:
    inventory_string, amount_filled = read_material_inventory(entity_id)
    
    Input Types:
    entity_id = [num] Numeric entity id of the potion entity you want to read the contents of

    Return Types:
    inventory_string = "magic_liquid_movement_faster,477-oil,17" [string]
    amount_filled = [num]

]]
    local inventory_string = ""
    local amount_filled = 0

    --Get Barrel Size
    local material_sucker_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialSuckerComponent")

    --Read material inventory
    local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")
    local count = 0
    local inventory_contents = {}
    for i, v in ipairs(count_per_material_type) do
        if v ~= 0 then
            --print(CellFactory_GetName(i - 1) .. ": " .. v)
            count = count + 1
            inventory_contents[count] = {
                material = CellFactory_GetName(i - 1),
                amount = v
            }
            amount_filled = amount_filled + v
        end
    end

    if count > 1 then
        --Sort material inventory contents from material with most volume present to least volume present
        local sorted = false
        while not sorted do
            sorted = true
            for i = 1, #inventory_contents - 1 do
                if inventory_contents[i].amount < inventory_contents[i + 1].amount then
                    inventory_contents[i], inventory_contents[i + 1] = inventory_contents[i + 1], inventory_contents[i]
                    sorted = false
                end
            end
        end
    end

    --Format into string
    if count > 0 then
        for i, v in ipairs(inventory_contents) do
            if i > 1 then
                inventory_string = inventory_string .. "-"
            end

            inventory_string = inventory_string .. v.material .. "," .. tostring(v.amount)
        end
    end

    return inventory_string, amount_filled
end

function potion_or_sack(entity_id)
    --[[
    Description:
    Light weight function (compared to read_potion_inventory(potion_entity_id)) that just returns whether or not the provided entity is a potion or a sack

    Usage:
    potion_or_sack = potion_or_sack(entity_id)
    
    Input Types:
    entity_id = [num] Numeric entity id

    Return Types:
    potion_or_sack = "potion" or "powder_stash" [string] or [nil]

    Will return nil if a neither a potion nor sack is provided
]]
    local potion_or_sack = nil

    --Check entity type
    local is_potion = EntityHasTag(entity_id, "potion")
    local is_sack = EntityHasTag(entity_id, "powder_stash")

    --Potion or sack?
    if is_potion then
        potion_or_sack = "potion"
    end
    if is_sack then
        potion_or_sack = "powder_stash"
    end

    return potion_or_sack
end

function get_amount_of_material_in_inventory(entity_id, material_name)
    --[[
    Description: Returns the amount of material in the material inventory component of the specified entity

    Usage:
    count = get_amount_of_material_in_inventory(entity_id, material_name)

    Input Types:
    entity_id = [num] id of the entity that has the material inventory component that you wish to add material to
    material_name = [string] material id string of the material you wish to add. See function CellFactory_GetName( material_id:int ) in "lua_api_documentation.txt" for more info
        
    Return Types:
    amount = [num]
    ]]
    local amount = 0
    local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

    for i, v in ipairs(count_per_material_type) do
        if v ~= 0 then
            if CellFactory_GetName(i - 1) == material_name then
                amount = v
            end
        end
    end

    return amount
end

function actually_add_material_inventory_material(entity_id, material_name, count)
    --[[
    Description: This function actually add/subtracts materials from a material inventory component because
                    the api function AddMaterialInventoryMaterial( entity_id:int, material_name:string, count:int )
                    will just set the amount of material rather than adding to the amount of material.
                    Nolla really should update the name of this function. ¯\_(ツ)_/¯

    Input Types:
    entity_id = [num] id of the entity that has the material inventory component that you wish to add material to
    material_name = [string] material id string of the material you wish to add. See function CellFactory_GetName( material_id:int ) in "lua_api_documentation.txt" for more info
    count = [num] amount of material you wish to add (use a negative value to remove material)
    ]]
    local mat_inv_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")
    local count_per_material_type = ComponentGetValue2(mat_inv_comp, "count_per_material_type")

    for i, v in ipairs(count_per_material_type) do
        if CellFactory_GetName(i - 1) == material_name then
            AddMaterialInventoryMaterial(entity_id, material_name, math.max(v + count, 0))

            if v + count < 0 then
                print("Warning: [temple_alchemy_utilities.lua] - Tried to remove more material than was in the material inventory. Simply removed all available material.")
            end

            break
        end
    end
end
