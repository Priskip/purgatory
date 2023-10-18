dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/purgatory/files/scripts/utils.lua")
dofile_once("mods/purgatory/files/scripts/buildings/temple_alchemy_station/temple_alchemy_utilities.lua")

--Drain Entity
local drain = {}
drain.id = GetUpdatedEntityID()
drain.x, drain.y = EntityGetTransform(drain.id)
drain.material = variable_storage_get_value(drain.id, "STRING", "material_and_amount")
drain.amount = variable_storage_get_value(drain.id, "INT", "material_and_amount")
drain.mode = variable_storage_get_value(drain.id, "INT", "material_type")

--Look to see if there is a placed potion on the bottle stand.
local bottle_stand = {}
bottle_stand.id = get_entity_in_radius_with_name(drain.x, drain.y, 500, "temple_alchemy_bottle_stand", "temple_alchemy_station")[1] --Should only ever be 1 bottle stand in area. If not, there's problems
local placed_bottle = {}
placed_bottle.id = EntityGetAllChildren(bottle_stand.id)
if placed_bottle.id ~= nil then
    placed_bottle.id = placed_bottle.id[1] --should only have 1 child ent - if not, this is bad
end

--If there's a bottle/sack on the stand
if placed_bottle.id ~= nil then
    --Get amount of space left in the bottle
    placed_bottle.inventory_string, placed_bottle.amount_filled, placed_bottle.barrel_size, placed_bottle.potion_or_sack = ReadPotionInventory(placed_bottle.id)
    placed_bottle.room_available = placed_bottle.barrel_size - placed_bottle.amount_filled

    if placed_bottle.room_available > 0 then
        --Look to see if the Cauldron Sucker has the material needed in its inventory
        local cauldron_sucker = {}
        cauldron_sucker.id = get_entity_in_radius_with_name(drain.x, drain.y, 500, "temple_alchemy_cauldron_sucker", "temple_alchemy_station")[1]
        cauldron_sucker.amount_of_requested_material = GetAmountOfMaterialInInventory(cauldron_sucker.id, drain.material)

        if cauldron_sucker.amount_of_requested_material >= drain.amount then
            --Cauldron Sucker has the material needed to fullfill the drain.
            local amount_to_drain = drain.amount

            if placed_bottle.room_available < drain.amount then
                amount_to_drain = placed_bottle.room_available --Prevent over-filling
            end

            if (placed_bottle.potion_or_sack == "potion" and drain.mode == 0) or (placed_bottle.potion_or_sack == "powder_stash" and drain.mode == 1) then
                --Remove contents from Cauldron Sucker
                ActuallyAddMaterialInventoryMaterial(cauldron_sucker.id, drain.material, -amount_to_drain)

                --Add contents to placed potion/sack
                ActuallyAddMaterialInventoryMaterial(placed_bottle.id, drain.material, amount_to_drain)
            end
        end
    end
end

--Update filler gauge
local filler_gauge_id = get_entity_in_radius_with_name(drain.x, drain.y, 500, "temple_alchemy_fill_gauge", "temple_alchemy_station")[1] --Should only ever be 1 filler gauge in area. If not, there's problems

EntityAddComponent2(
    filler_gauge_id,
    "LuaComponent",
    {
        execute_on_added = false,
        execute_every_n_frame = 5, --Five frame delay to allow for potion/sack components to update
        remove_after_executed = true,
        script_source_file = "mods/purgatory/files/scripts/buildings/temple_alchemy_station/bottle_filler/fill_gauge_update.lua"
    }
)

--Kill Drain Ent
EntityKill(drain.id)
