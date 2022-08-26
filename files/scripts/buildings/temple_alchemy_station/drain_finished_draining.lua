dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")

function summon_new_drain_ent(x, y, material, amount)
    --Summon a new drain entity
    local new_drain_id = EntityLoad("mods/purgatory/files/entities/buildings/temple_alchemy_station/drain.xml", x, y)

    if x % 1 ~= 0.5 then
        --Sets the half pixel offset because EntityLoad won't do it
        EntitySetTransform(new_drain_id, x + 0.5, y)
    end

    EntityAddComponent2(
        new_drain_id,
        "VariableStorageComponent",
        {
            name = "material_to_emit",
            value_string = material
        }
    )

    EntityAddComponent2(
        new_drain_id,
        "VariableStorageComponent",
        {
            name = "amount_of_material",
            value_int = amount
        }
    )
end

--Get IDs and Positions
local drain = {}
local bottle_stand_placed_potion = {}
local cauldron_sucker = {}

drain.id = GetUpdatedEntityID()
drain.x, drain.y = EntityGetTransform(drain.id)

cauldron_sucker.id = EntityGetClosestWithTag(drain.x, drain.y, "temple_alchemy_cauldron_sucker") --Returns 0 if no ent is found
bottle_stand_placed_potion.id = EntityGetClosestWithTag(drain.x, drain.y, "temple_alchemy_bottle_stand_placed_potion") --Returns 0 if no ent is found

--Get Amounts
local material_to_emit = variable_storage_get_value(drain.id, "STRING", "material_to_emit")
local amount_of_material = variable_storage_get_value(drain.id, "INT", "amount_of_material")

local fill_attempt_exceeds_capacity = false
local remaining_material_amount = 0

if bottle_stand_placed_potion.id ~= 0 then
    bottle_stand_placed_potion.x, bottle_stand_placed_potion.y = EntityGetTransform(bottle_stand_placed_potion.id)

    --Get Comps Needed
    bottle_stand_placed_potion.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(bottle_stand_placed_potion.id, "MaterialInventoryComponent")
    bottle_stand_placed_potion.count_per_material_type = ComponentGetValue2(bottle_stand_placed_potion.mat_inv_comp, "count_per_material_type")

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

    --If Amount of Material to add exceeds potion capacity, set a limit
    if amount_of_material > max_bottle_capacity - bottle_stand_placed_potion.total_volume then
        fill_attempt_exceeds_capacity = true
        remaining_material_amount = amount_of_material - (max_bottle_capacity - bottle_stand_placed_potion.total_volume)

        amount_of_material = max_bottle_capacity - bottle_stand_placed_potion.total_volume
    end

    --Add Material to Inventory

    if bottle_stand_placed_potion.count_per_material_type ~= nil then
        --Counts how much of each material is inside the bottle stand's placed potion and adds the material from the drain to it
        local placed_potion_had_some_material_already = false
        for i, v in ipairs(bottle_stand_placed_potion.count_per_material_type) do
            if v ~= 0 then
                local material = CellFactory_GetName(i - 1)
                if material == material_to_emit then
                    AddMaterialInventoryMaterial(bottle_stand_placed_potion.id, material, v + amount_of_material) --v == amount of material inside the placed potion
                    placed_potion_had_some_material_already = true
                end
            end
        end
        if placed_potion_had_some_material_already == false then
            AddMaterialInventoryMaterial(bottle_stand_placed_potion.id, material_to_emit, amount_of_material)
        end
    end

    --Remove this material from the cauldron sucker's material inventory
    cauldron_sucker.mat_inv_comp = EntityGetFirstComponentIncludingDisabled(cauldron_sucker.id, "MaterialInventoryComponent")
    cauldron_sucker.count_per_material_type = ComponentGetValue2(cauldron_sucker.mat_inv_comp, "count_per_material_type")
    if cauldron_sucker.count_per_material_type ~= nil then
        for i, v in ipairs(cauldron_sucker.count_per_material_type) do
            if v ~= 0 then
                if CellFactory_GetName(i - 1) == material_to_emit then
                    AddMaterialInventoryMaterial(cauldron_sucker.id, CellFactory_GetName(i - 1), v - amount_of_material) --This removes the material from the cauldron sucker's inventory
                    break
                end
            end
        end
    end
else
    --Summon new drain ent
    --summon_new_drain_ent(drain.x, drain.y, material_to_emit, amount_of_material)
    --Moving this to the cauldron sucker so as long as it exists it attempts to push instead of having this potentially double up on stuff
end

--Kill Drain Ent
EntityKill(drain.id)

--Debug info
local debug = false
if debug then
    print("drain.id: " .. drain.id)
    print("material_to_emit: " .. material_to_emit)
    print("amount_of_material: " .. tostring(amount_of_material))
    print("remaining_material_amount: " .. tostring(remaining_material_amount))
end
